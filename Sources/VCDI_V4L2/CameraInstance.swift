import CVideoCaptureDriverInterface
import CV4L2
import Foundation

internal final class CameraInstance {
    private let fd: Int32
    private let capability: v4l2_capability
    private let cropCapability: v4l2_cropcap
    private let format: v4l2_format

    private static func v4l2_ioctl(fd: Int32,
                                   request: video_ioctl_request_e,
                                   arg: UnsafeMutableRawPointer) -> Int32 {
        var result = Int32(-1)

        while result == -1 {
            result = ioctl_1_arg(fd, Int32(request.rawValue), arg)

            guard errno != EINTR else {
                break
            }
        }

        return result
    }

    internal init(fd: Int32) {
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

        self.fd = fd
        self.capability = capability
        self.cropCapability = cropCapability
        self.format = format
    }

    deinit {
        close(self.fd)
    }
}