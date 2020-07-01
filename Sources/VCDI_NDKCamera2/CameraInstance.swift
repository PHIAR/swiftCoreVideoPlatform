import CVideoCaptureDriverInterface
import Dispatch
import Foundation

#if os(Android)

import CNDKCamera2

internal final class CameraInstance {
    private typealias MappedBuffer = (pointer: UnsafeMutableRawPointer,
                                      size: Int)

    public typealias ACameraDevice = OpaquePointer
    public typealias PixelbufferCallback = (_ context: UnsafeMutableRawPointer,
                                            _ pointer: UnsafeMutableRawPointer,
                                            _ length: Int) -> Void

    private let executionQueue = DispatchQueue(label: "CameraInstance.executionQueue")
    private let receiveQueue = DispatchQueue(label: "CameraInstance.receiveQueue")
    private var stopped = false
    private var stopSynchronizer = DispatchGroup()
    private let buffers: [MappedBuffer]
    private var callbacks: [(context: UnsafeMutableRawPointer,
                             callback: PixelbufferCallback)] = []
    private let cameraDevice: ACameraDevice

    internal init() {
        let buffers: [MappedBuffer] = []
        let cameraManager = ACameraManager_create()
        var _cameraIdList: UnsafeMutablePointer <ACameraIdList>? = nil

        guard ACameraManager_getCameraIdList(cameraManager, &_cameraIdList) == ACAMERA_OK,
              let cameraIdList = _cameraIdList,
              cameraIdList.pointee.numCameras > 1 else {
            preconditionFailure()
        }

        var _cameraDevice: ACameraDevice? = nil
        let cameraId = cameraIdList.pointee.cameraIds[0]
        var deviceStateCallbacks = ACameraDevice_StateCallbacks()

        guard ACameraManager_openCamera(cameraManager, cameraId,
                                        &deviceStateCallbacks, &_cameraDevice) == ACAMERA_OK,
              let cameraDevice = _cameraDevice else {
            preconditionFailure()
        }

        ACameraManager_delete(cameraManager)

        self.buffers = buffers
        self.cameraDevice = cameraDevice
    }

    deinit {
        ACameraDevice_close(self.cameraDevice)
    }

    internal func registerPixelbufferCallback(context: UnsafeMutableRawPointer,
                                              callback: @escaping PixelbufferCallback) {
        self.executionQueue.sync {
            self.callbacks.append((context: context,
                                   callback: callback))
        }
    }

    internal func requestAuthorization() -> Bool {
        return true
    }

    internal func startCapture() -> Bool {
        return false
    }

    internal func stopCapture() -> Bool {
        return false
    }
}

#endif
