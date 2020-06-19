import CVideoCaptureDriverInterface
import CV4L2
import Foundation

internal final class CameraInstance {
    private typealias MappedBuffer = (pointer: UnsafeMutableRawPointer,
                                      size: Int)

    private let fd: Int32
    private let capability: v4l2_capability
    private let cropCapability: v4l2_cropcap
    private let format: v4l2_format
    private let buffers: [MappedBuffer]

    private static func v4l2_ioctl(fd: Int32,
                                   request: video_ioctl_request_e,
                                   arg: UnsafeMutableRawPointer) -> Int32 {
        var result = Int32(-1)

        while result == -1 {
            result = ioctl_1_arg(fd, request, arg)

            guard errno != EINTR else {
                break
            }
        }

        return result
    }

    internal init(fd: Int32,
                  numberOfBuffers: Int) {
        var capability = v4l2_capability()

        guard CameraInstance.v4l2_ioctl(fd: fd,
                                        request: video_ioctl_request_query_cap,
                                        arg: &capability) != -1 else {
            preconditionFailure("Failed to query device capabilities.")
        }

        var cropCapability = v4l2_cropcap()

        guard CameraInstance.v4l2_ioctl(fd: fd,
                                        request: video_ioctl_request_crop_cap,
                                        arg: &cropCapability) != -1 else {
            preconditionFailure("Failed to query device crop capability.")
        }

        var format = v4l2_format()

        guard CameraInstance.v4l2_ioctl(fd: fd,
                                        request: video_ioctl_request_get_format,
                                        arg: &format) != -1 else {
            preconditionFailure("Failed to query device format.")
        }

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
                preconditionFailure("Failed to query device format.")
            }

            let size = Int(buffer.length)
            let pointer = mmap(nil,
                               size,
                               PROT_READ |
                               PROT_WRITE,
                               MAP_SHARED,
                               fd,
                               off_t(buffer.m.offset))!

            buffers.append((pointer: pointer,
                            size: size))
        }

        self.fd = fd
        self.capability = capability
        self.cropCapability = cropCapability
        self.format = format
        self.buffers = buffers
    }

    deinit {
        for buffer in self.buffers {
            munmap(buffer.pointer, buffer.size)
        }

        close(self.fd)
    }
}