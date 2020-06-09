import Foundation

public final class AVCaptureSession {
    public struct Preset {
        public static let hd1280x720: Preset = Preset(rawValue: 1)
        public static let hd1920x1080: Preset = Preset(rawValue: 2)
        public static let hd4K3840x2160: Preset = Preset(rawValue: 3)
        public static let low: Preset = Preset(rawValue: 4)
        public static let medium: Preset = Preset(rawValue: 5)
        public static let high: Preset = Preset(rawValue: 6)

        private let rawValue: Int

        private init(rawValue: Int) {
            self.rawValue = rawValue
        }
    }

    public var sessionPreset: AVCaptureSession.Preset {
        get {
            preconditionFailure()
        }

        set {
            preconditionFailure()
        }
    }

    public init() {
    }

    public func addInput(_ input: AVCaptureInput) {
    }

    public func addOutput(_ input: AVCaptureOutput) {
    }

    public func beginConfiguration() {
    }

    public func canAddInput(_ input: AVCaptureInput) -> Bool {
        return false
    }

    public func canAddOutput(_ input: AVCaptureOutput) -> Bool {
        return false
    }

    public func commitConfiguration() {
    }

    public func startRunning() {
    }

    public func stopRunning() {
    }
}
