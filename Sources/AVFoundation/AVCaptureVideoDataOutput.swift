import Dispatch
import Foundation

public final class AVCaptureVideoDataOutput: AVCaptureOutput {
    private var sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    private var sampleBufferCallbackQueue: DispatchQueue?
    private var _videoSettings: [String: Any] = [:]

    public var videoSettings: [String: Any]! {
        get {
            return self._videoSettings
        }

        set {
            self._videoSettings = newValue
        }
    }

    internal func post(sampleBuffer: CMSampleBuffer,
                       captureConnection: AVCaptureConnection) {
        guard let sampleBufferDelegate = self.sampleBufferDelegate else {
            return
        }

        let sampleBufferCallbackQueue = self.sampleBufferCallbackQueue ?? .global()

        sampleBufferCallbackQueue.sync {
            sampleBufferDelegate.captureOutput(self,
                                               didOutput: sampleBuffer,
                                               from: captureConnection)
        }
    }

    public override init() {
    }

    public func setSampleBufferDelegate(_ sampleBufferDelegate: AVCaptureVideoDataOutputSampleBufferDelegate?,
                                        queue sampleBufferCallbackQueue: DispatchQueue?) {
        self.sampleBufferDelegate = sampleBufferDelegate
        self.sampleBufferCallbackQueue = sampleBufferCallbackQueue
    }
}
