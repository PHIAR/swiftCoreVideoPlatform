import Foundation

public final class AVCaptureDeviceInput: AVCaptureInput {
    private let _device: AVCaptureDevice

    public var device: AVCaptureDevice {
        return self._device
    }

    public init(device: AVCaptureDevice) throws {
        self._device = device
    }

    internal override func startCapture() {
        super.startCapture()
        self.device.startCapture()
    }

    internal override func stopCapture() {
        super.stopCapture()
        self.device.stopCapture()
    }
}
