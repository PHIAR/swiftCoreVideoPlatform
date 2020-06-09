@_exported import CoreMedia
@_exported import CoreVideo
import Foundation

public enum AVMediaType {
    case video
}

public final class AVCaptureDevice {
    public final class DiscoverySession {
    }

    public var activeVideoMaxFrameDuration: Double {
        preconditionFailure()
    }

    public var activeVideoMinFrameDuration: Double {
        preconditionFailure()
    }

    public class func requestAccess(for: AVMediaType,
                                    completionHandler: (Bool) -> Void) {
        completionHandler(true)
    }

    public func lockForConfiguration() throws {
    }

    public func unlockForConfiguration() {
    }
}
