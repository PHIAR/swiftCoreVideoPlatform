import CVideoCaptureDriverInterface
import CV4L2
import Dispatch
import Foundation

internal final class CameraInstance {
    private typealias MappedBuffer = (pointer: UnsafeMutableRawPointer,
                                      size: Int)

    public typealias PixelbufferCallback = (_ context: UnsafeMutableRawPointer,
                                            _ pointer: UnsafeMutableRawPointer,
                                            _ length: Int) -> Void

    private let executionQueue = DispatchQueue(label: "CameraInstance.executionQueue")
    private let receiveQueue = DispatchQueue(label: "CameraInstance.receiveQueue")
    private var stopped = false
    private var stopSynchronizer = DispatchGroup()
    private let fd: Int32
    private let capability: v4l2_capability
    private let format: v4l2_format
    private let buffers: [MappedBuffer]
    private var callbacks: [(context: UnsafeMutableRawPointer,
                             callback: PixelbufferCallback)] = []

    private static func v4l2_ioctl(fd: Int32,
                                   request: video_ioctl_request_e,
                                   arg: UnsafeMutableRawPointer) -> Int32 {
        var result = Int32(0)

        repeat {
            result = ioctl_1_arg(fd, request, arg)
        } while (result == -1) &&
                (errno == EINTR)

        return result
    }

    private func receiveOnReceiveQueue() {
        dispatchPrecondition(condition: .onQueue(self.receiveQueue))

        while !self.executionQueue.sync(execute: {
            guard self.stopped else {
                return false
            }

            self.stopSynchronizer.leave()
            return true
        }) {
            var timeVal = timeval()
            var fds = get_fd_set(fd);

            timeVal.tv_sec = 10
            timeVal.tv_usec = 0

            let result = select(fd + 1, &fds, nil, nil, &timeVal)

            precondition(result != 0, "Receive pixelbuffer timed out.")

            guard result != EINTR else {
                continue
            }

            guard result != -1 else {
                break
            }

            var buffer = v4l2_buffer()

            buffer.type = V4L2_BUF_TYPE_VIDEO_CAPTURE.rawValue
            buffer.memory = V4L2_MEMORY_MMAP.rawValue

            guard CameraInstance.v4l2_ioctl(fd: fd,
                                            request: video_ioctl_request_dequeue_buffer,
                                            arg: &buffer) != -1 else {
                preconditionFailure()
            }

            let mappedBuffer = self.buffers[Int(buffer.index)]

            for callback in self.callbacks {
                callback.callback(callback.context,
                                  mappedBuffer.pointer,
                                  mappedBuffer.size)
            }

            guard CameraInstance.v4l2_ioctl(fd: fd,
                                            request: video_ioctl_request_queue_buffer,
                                            arg: &buffer) != -1 else {
                preconditionFailure()
            }
        }
    }

    internal init(fd: Int32,
                  numberOfBuffers: Int) {
        var capability = v4l2_capability()

        guard CameraInstance.v4l2_ioctl(fd: fd,
                                        request: video_ioctl_request_query_cap,
                                        arg: &capability) != -1 else {
            preconditionFailure("Failed to query device capabilities.")
        }

        var format = v4l2_format()

        format.type = UInt32(V4L2_BUF_TYPE_VIDEO_CAPTURE.rawValue)

        guard CameraInstance.v4l2_ioctl(fd: fd,
                                        request: video_ioctl_request_get_format,
                                        arg: &format) != -1 else {
            preconditionFailure("Failed to query device format.")
        }

        print(format.fmt.pix)

        var requestBuffers = v4l2_requestbuffers()

        requestBuffers.type = UInt32(V4L2_BUF_TYPE_VIDEO_CAPTURE.rawValue)
        requestBuffers.memory = UInt32(V4L2_MEMORY_MMAP.rawValue)
        requestBuffers.count = UInt32(numberOfBuffers)

        guard CameraInstance.v4l2_ioctl(fd: fd,
                                        request: video_ioctl_request_request_buffers,
                                        arg: &requestBuffers) != -1 else {
            preconditionFailure("Failed to query device format.")
        }

        var buffers: [MappedBuffer] = []

        for i in 0..<numberOfBuffers {
            var buffer = v4l2_buffer()

            buffer.type = UInt32(V4L2_BUF_TYPE_VIDEO_CAPTURE.rawValue)
            buffer.memory = UInt32(V4L2_MEMORY_MMAP.rawValue)
            buffer.index = UInt32(i)

            guard CameraInstance.v4l2_ioctl(fd: fd,
                                            request: video_ioctl_request_query_buffer,
                                            arg: &buffer) != -1 else {
                preconditionFailure("Failed to request buffer for mmap.")
            }

            let size = Int(buffer.length)
            let pointer = mmap(nil,
                               size,
                               PROT_READ |
                               PROT_WRITE,
                               MAP_SHARED,
                               fd,
                               off_t(buffer.m.offset))!

            var queueBuffer = v4l2_buffer()

            queueBuffer.type = UInt32(V4L2_BUF_TYPE_VIDEO_CAPTURE.rawValue)
            queueBuffer.memory = UInt32(V4L2_MEMORY_MMAP.rawValue)
            queueBuffer.index = UInt32(i)

            guard CameraInstance.v4l2_ioctl(fd: fd,
                                            request: video_ioctl_request_queue_buffer,
                                            arg: &queueBuffer) != -1 else {
                preconditionFailure("Failed to queue buffer to device.")
            }

            buffers.append((pointer: pointer,
                            size: size))
        }

        self.fd = fd
        self.capability = capability
        self.format = format
        self.buffers = buffers
    }

    deinit {
        for buffer in self.buffers {
            munmap(buffer.pointer, buffer.size)
        }

        close(self.fd)
    }

    internal func registerPixelbufferCallback(context: UnsafeMutableRawPointer,
                                              callback: @escaping PixelbufferCallback) {
        self.executionQueue.sync {
            self.callbacks.append((context: context,
                                   callback: callback))
        }
    }

    internal func requestAuthorization() -> Bool {
        return true
    }

    internal func startCapture() -> Bool {
        var type = V4L2_BUF_TYPE_VIDEO_CAPTURE

        guard CameraInstance.v4l2_ioctl(fd: fd,
                                        request: video_ioctl_request_stream_on,
                                        arg: &type) != -1 else {
            return false
        }

        self.receiveQueue.async {
            self.executionQueue.sync { self.stopped = false }
            self.receiveOnReceiveQueue()
        }

        return true
    }

    internal func stopCapture() -> Bool {
        var type = V4L2_BUF_TYPE_VIDEO_CAPTURE

        self.executionQueue.sync {
            self.stopSynchronizer.enter()
            self.stopped = true
        }

        self.stopSynchronizer.wait()
        return CameraInstance.v4l2_ioctl(fd: fd,
                                         request: video_ioctl_request_stream_off,
                                         arg: &type) != -1
    }
}