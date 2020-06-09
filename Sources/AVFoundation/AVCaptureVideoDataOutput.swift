import Dispatch
import Foundation

public final class AVCaptureVideoDataOutput: AVCaptureOutput {
    public var videoSettings: [String : Any]! {
        get {
            preconditionFailure()
        }

        set {
            preconditionFailure()
        }
    }

    public override init() {
    }

    public func setSampleBufferDelegate(_ sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?,
                                        queue sampleBufferCallbackQueue: DispatchQueue?) {
    }
}
