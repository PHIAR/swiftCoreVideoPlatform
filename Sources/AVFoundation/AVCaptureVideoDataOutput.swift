import Dispatch
import Foundation

public final class AVCaptureVideoDataOutput: AVCaptureOutput {
    private var _videoSettings: [String: Any] = [:]

    public var videoSettings: [String: Any]! {
        get {
            return self._videoSettings
        }

        set {
            self._videoSettings = newValue
        }
    }

    public override init() {
    }

    public func setSampleBufferDelegate(_ sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?,
                                        queue sampleBufferCallbackQueue: DispatchQueue?) {
    }
}
