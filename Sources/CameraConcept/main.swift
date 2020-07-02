import swiftSDL2
import AVFoundation
import CoreMedia
import CoreVideo
import Foundation

internal final class CaptureDelegate: NSObject,
                                      AVCaptureVideoDataOutputSampleBufferDelegate {
    public typealias PixelbufferCallback = (CVPixelBuffer) -> Void

    private let callback: PixelbufferCallback

    public init(callback: @escaping PixelbufferCallback) {
        self.callback = callback
    }

    public func captureOutput(_ output: AVCaptureOutput,
                              didOutput sampleBuffer: CMSampleBuffer,
                              from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }

        self.callback(pixelBuffer)
    }
}

SDL2.initialize(flags: .everything)

let windowWidth = 1280
let windowHeight = 720
var flags = Window.Flags.shown

#if os(iOS) || os(macOS) || os(tvOS)
flags.insert(.metal)
#else
flags.insert(.opengl)
#endif

let window = Window(title: "Camera Concept",
                    x: 0,
                    y: 0,
                    width: windowWidth,
                    height: windowHeight,
                    flags: flags)
let renderer = window.createRenderer(index: 0)

#if os(iOS) || os(macOS) || os(tvOS)
let pixelformat: Texture.Pixelformat = .nv12
#elseif os(Android) || os(Linux)
let pixelformat: Texture.Pixelformat = .yuy2
#endif

let texture = renderer.createTexture(pixelformat: pixelformat,
                                     textureAccess: .streaming,
                                     width: windowWidth,
                                     height: windowHeight)

var granted = false
let group = DispatchGroup()

group.enter()
AVCaptureDevice.requestAccess(for: .video) { _granted in
    granted = _granted
    group.leave()
}

group.wait()

guard granted else {
    exit(1)
}

let captureDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [
                                                          .builtInWideAngleCamera,
                                                      ],
                                                      mediaType: .video,
                                                      position: .back).devices

guard let captureDevice = captureDevices.first else {
    exit(1)
}

let captureSession = AVCaptureSession()

captureSession.beginConfiguration()

let captureInput = try! AVCaptureDeviceInput(device: captureDevice)
let outputData = AVCaptureVideoDataOutput()

outputData.videoSettings = [
    String(kCVPixelBufferPixelFormatTypeKey): kCVPixelFormatType_420YpCbCr8BiPlanarFullRange,
]

let executionQueue = DispatchQueue(label: "CaptureDelegate.executionQueue")
let captureDelegate = CaptureDelegate() { pixelBuffer in
    let _ = CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
    let pointer = CVPixelBufferGetBaseAddress(pixelBuffer)!

#if os(iOS) || os(macOS) || os(tvOS)
    let pitch = 1280
#elseif os(Android) || os(Linux)
    let pitch = 1280 * 2
#endif

    texture.update(pixels: pointer,
                   pitch: pitch)
    renderer.copy(texture: texture)
    renderer.present()

    let _ = CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
}

outputData.setSampleBufferDelegate(captureDelegate,
                                   queue: executionQueue)

guard captureSession.canAddInput(captureInput),
      captureSession.canAddOutput(outputData) else {
    captureSession.commitConfiguration()
    exit(1)
}

captureSession.addInput(captureInput)
captureSession.addOutput(outputData)
captureSession.commitConfiguration()
        captureSession.startRunning()

SDL2.eventLoop { event in
    switch event.type {
    case SDL_KEYDOWN.rawValue:
        return false

    default:
        break
    }

    return true
}

captureSession.stopRunning()
