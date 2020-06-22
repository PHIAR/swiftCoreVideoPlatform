@_exported import CoreMedia
@_exported import CoreVideo
import CVideoCaptureDriverInterface
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
        private let _devices: [AVCaptureDevice]

        private init(devices: [AVCaptureDevice]) {
            self._devices = devices
        }

        public var devices: [AVCaptureDevice] {
            return self._devices
        }

        public convenience init(deviceTypes: [AVCaptureDevice.DeviceType],
                                mediaType: AVMediaType?,
                                position: AVCaptureDevice.Position) {
            let library = dlopen("libVCDI_V4L2.so", RTLD_NOW)
            let entrypoint = unsafeBitCast(dlsym(library, "vcdi_main"),
                                           to: (@convention (c) (UnsafeMutableRawPointer) -> Bool).self)
            let devices = [
                AVCaptureDevice(entrypoint: entrypoint),
            ]

            self.init(devices: devices)
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

    private static let registerInstance: @convention(c) (UnsafeMutableRawPointer,
                                                         UnsafeMutablePointer <vcdi_instance_registration_data_t>) -> Bool = { runtimeInstance, registrationData in
        let captureDevice = runtimeInstance.toAVCaptureDevice()

        captureDevice.runtimeRegistrationData = registrationData.pointee
        return true
    }

    private var runtimeRegistrationData = vcdi_instance_registration_data_t()
    private var instanceSession = vcdi_instance_session_t()

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

    internal init(entrypoint: @convention (c) (UnsafeMutableRawPointer) -> Bool) {
        var instance = vcdi_instance_t(instance_handle: self.toUnsafeMutableRawPointer(),
                                       register_instance: AVCaptureDevice.registerInstance)
        var result = entrypoint(&instance)

        result = self.runtimeRegistrationData.request_authorization(runtimeRegistrationData.context)
        precondition(result)

        var instanceSession = vcdi_instance_session_t()

        result = runtimeRegistrationData.open_session(runtimeRegistrationData.context, &instanceSession)
        precondition(result)

        self.instanceSession = instanceSession
    }

    deinit {
        self.instanceSession.close_session(&instanceSession)
    }

    public func lockForConfiguration() throws {
    }

    public func unlockForConfiguration() {
    }
}

private extension AVCaptureDevice {
    func toUnsafeMutableRawPointer(retained: Bool = false) -> UnsafeMutableRawPointer {
        guard retained else {
            return UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        }

        return UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())
    }
}

private extension UnsafeMutableRawPointer {
    func toAVCaptureDevice(retained: Bool = false) -> AVCaptureDevice {
        guard retained else {
            return Unmanaged <AVCaptureDevice>.fromOpaque(UnsafeRawPointer(self)!).takeUnretainedValue()
        }

        return Unmanaged <AVCaptureDevice>.fromOpaque(UnsafeRawPointer(self)!).takeRetainedValue()
    }
}

internal extension AVCaptureDevice {
    func startCapture() {
        let _ = self.instanceSession.start_capture(&self.instanceSession)
    }

    func stopCapture() {
        let _ = self.instanceSession.stop_capture(&self.instanceSession)
    }
}
