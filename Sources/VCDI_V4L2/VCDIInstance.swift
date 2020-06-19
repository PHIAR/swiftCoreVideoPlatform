import CVideoCaptureDriverInterface
import Foundation
import Glibc

internal final class VCDIInstance {
    private static let defaultVideoNode = 0
    private static let defaultDeviceNode = "/dev/video\(VCDIInstance.defaultVideoNode)"

    private let instanceHandle: UnsafeMutableRawPointer
    private let cameraInstance: CameraInstance

    internal let vendorName = "V4L2 Camera Driver"

    internal var openSession: @convention(c) (UnsafeMutableRawPointer) -> UnsafeMutablePointer <vcdi_instance_session_t>? = { instance in
        return nil
    }

    internal var requestAuthorization: @convention(c) (UnsafeMutableRawPointer) -> Bool = { instance in
        return false
    }

    internal init(instanceHandle: UnsafeMutableRawPointer) {
        let fd = open(VCDIInstance.defaultDeviceNode,
                      O_RDWR |
                      O_NONBLOCK,
                      0)

        precondition(fd != -1)

        self.instanceHandle = instanceHandle
        self.cameraInstance = CameraInstance(fd: fd)
    }
}
