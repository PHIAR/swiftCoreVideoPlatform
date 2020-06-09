@_exported import CoreMedia
@_exported import CoreVideo
import Foundation

public enum AVMediaType {
    case video
}

public final class AVCaptureDevice {
    public enum Position {
        case unspecified
        case back
        case front
    }

    public struct DeviceType {
        public static let builtInDualCamera: DeviceType = DeviceType(rawValue: 1)
        public static let builtInDualWideCamera: DeviceType = DeviceType(rawValue: 2)
        public static let builtInTripleCamera: DeviceType = DeviceType(rawValue: 3)
        public static let builtInWideAngleCamera: DeviceType = DeviceType(rawValue: 4)
        public static let builtInUltraWideCamera: DeviceType = DeviceType(rawValue: 5)
        public static let builtInTelephotoCamera: DeviceType = DeviceType(rawValue: 6)
        public static let builtInTrueDepthCamera: DeviceType = DeviceType(rawValue: 6)
        public static let builtInMicrophone: DeviceType = DeviceType(rawValue: 7)
        public static let externalUnknown: DeviceType = DeviceType(rawValue: 8)
        public static let builtInDuoCamera: DeviceType = .builtInDualCamera

        private let rawValue: Int

        private init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    public final class DiscoverySession {
        private init() {
        }

        public var devices: [AVCaptureDevice] {
            preconditionFailure()
        }

        public convenience init(deviceTypes: [AVCaptureDevice.DeviceType],
                                mediaType: AVMediaType?,
                                position: AVCaptureDevice.Position) {
            self.init()
        }
    }

    public final class Format {
        public var formatDescription: CMFormatDescription {
            preconditionFailure()
        }

        public var videoSupportedFrameRateRanges: [AVFrameRateRange] {
            preconditionFailure()
        }
    }

    public var activeFormat: AVCaptureDevice.Format {
        get {
            preconditionFailure()
        }

        set {
            preconditionFailure()
        }
    }

    public var activeVideoMaxFrameDuration: CMTime {
        get {
            preconditionFailure()
        }

        set {
            preconditionFailure()
        }
    }

    public var activeVideoMinFrameDuration: CMTime {
        get {
            preconditionFailure()
        }

        set {
            preconditionFailure()
        }
    }

    public var formats: [AVCaptureDevice.Format] {
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
