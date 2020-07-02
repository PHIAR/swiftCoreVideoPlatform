import Dispatch
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

    private let executionQueue = DispatchQueue(label: "AVCaptureSession.executionQueue")
    private var configurationIsBeingChanged = false
    private var captureConnections: [AVCaptureConnection] = []
    private var inputs: [AVCaptureInput] = []
    private var outputs: [AVCaptureOutput] = []

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
        precondition(self.configurationIsBeingChanged)

        self.executionQueue.sync {
            self.inputs.append(input)
        }
    }

    public func addOutput(_ output: AVCaptureOutput) {
        precondition(self.configurationIsBeingChanged)

        self.executionQueue.sync {
            self.outputs.append(output)
        }
    }

    public func beginConfiguration() {
        self.configurationIsBeingChanged = true
    }

    public func canAddInput(_ input: AVCaptureInput) -> Bool {
        precondition(self.configurationIsBeingChanged)

        return true
    }

    public func canAddOutput(_ input: AVCaptureOutput) -> Bool {
        precondition(self.configurationIsBeingChanged)

        return true
    }

    public func commitConfiguration() {
        self.configurationIsBeingChanged = false

        self.inputs.forEach { input in
            self.outputs.forEach { output in
                let captureConnection = AVCaptureConnection(captureInput: input,
                                                            captureOutput: output)

                self.captureConnections.append(captureConnection)
            }
        }
    }

    public func startRunning() {
        precondition(!self.configurationIsBeingChanged)

        self.inputs.forEach { input in
            input.startCapture()
        }
    }

    public func stopRunning() {
        precondition(!self.configurationIsBeingChanged)

        self.inputs.forEach { $0.stopCapture() }
    }
}
