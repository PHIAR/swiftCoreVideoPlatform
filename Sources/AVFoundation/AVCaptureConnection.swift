import Foundation

public final class AVCaptureConnection {
    private var captureInput: AVCaptureInput
    private var captureOutput: AVCaptureOutput

    internal init(captureInput: AVCaptureInput,
                  captureOutput: AVCaptureOutput) {
        self.captureInput = captureInput
        self.captureOutput = captureOutput

        if let captureDeviceInput = captureInput as? AVCaptureDeviceInput,
           let captureVideoDataOutput = captureOutput as? AVCaptureVideoDataOutput {
            let device = captureDeviceInput.device

            device.register { [weak self] pointer, size in
                guard let strongSelf = self else {
                    return
                }

                let imageBuffer = CVPixelBuffer(width: 1280,
                                                height: 720,
                                                baseAddress: pointer,
                                                dataSize: size)
                let sampleBuffer = CMSampleBuffer(imageBuffer: imageBuffer)

                captureVideoDataOutput.post(sampleBuffer: sampleBuffer,
                                            captureConnection: strongSelf)
            }
        }
    }
}
