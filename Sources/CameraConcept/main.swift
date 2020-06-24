import swiftNuklear
import swiftSDL2
import AVFoundation
import Foundation

import CVideoCaptureDriverInterface

private extension UnsafeMutableRawPointer {
    func toRuntimeInstance(retained: Bool = false) -> RuntimeInstance {
        guard retained else {
            return Unmanaged <RuntimeInstance>.fromOpaque(UnsafeRawPointer(self)!).takeUnretainedValue()
        }

        return Unmanaged <RuntimeInstance>.fromOpaque(UnsafeRawPointer(self)!).takeRetainedValue()
    }
}

internal extension RuntimeInstance {
    func toUnsafeMutableRawPointer(retained: Bool = false) -> UnsafeMutableRawPointer {
        guard retained else {
            return UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
        }

        return UnsafeMutableRawPointer(Unmanaged.passRetained(self).toOpaque())
    }
}

internal final class RuntimeInstance {
    internal init() {
    }

    internal func run() {
    }
}

print("Camera Concept Test Application")

private let runtimeInstance = RuntimeInstance()

#if os(iOS) || os(tvOS) || os(macOS)
private let libraryName = "libVCDI_Darwin.dylib"
#elseif os(Android) || os(Linux)
private let libraryName = "libVCDI_V4L2.so"
#endif

guard let library = dlopen(libraryName, RTLD_NOW) else {
    print("Driver \(libraryName) not found.")
    exit(1)
}

private let entrypointPointer = dlsym(library, "vcdi_main")
private let entrypoint = unsafeBitCast(entrypointPointer,
                                       to: (@convention (c) (UnsafeMutableRawPointer) -> Bool).self)
private var runtimeRegistrationData = vcdi_instance_registration_data_t()

private let registerInstance: @convention(c) (UnsafeMutableRawPointer,
                                              UnsafeMutablePointer <vcdi_instance_registration_data_t>) -> Bool = { runtimeInstance, registrationData in
    let _ = runtimeInstance.toRuntimeInstance()

    runtimeRegistrationData = registrationData.pointee
    return true
}

private var instance = vcdi_instance_t(instance_handle: runtimeInstance.toUnsafeMutableRawPointer(),
                                       register_instance: registerInstance)

var result = entrypoint(&instance)

result = runtimeRegistrationData.request_authorization(runtimeRegistrationData.context)
precondition(result)

print(String(format: "Device name: %s", runtimeRegistrationData.vendor_name))

var instanceSession = vcdi_instance_session_t()

result = runtimeRegistrationData.open_session(runtimeRegistrationData.context, &instanceSession)
precondition(result)

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
let texture = renderer.createTexture(pixelformat: .bgra32,
                                     textureAccess: .streaming,
                                     width: windowWidth,
                                     height: windowHeight)
let cameraCallback: @convention(c) (_ context: UnsafeMutableRawPointer,
                                    _ pointer: UnsafeMutableRawPointer,
                                    _ size: Int) -> Void = { context, pointer, size in
    DispatchQueue.main.sync {
        let cameraCaptureBufferHeight = 720

        texture.update(pixels: pointer,
                       pitch: size / cameraCaptureBufferHeight)
        renderer.copy(texture: texture)
        renderer.present()
    }
}

instanceSession.register_camera_callback(&instanceSession,
                                         UnsafeMutableRawPointer(bitPattern: 1)!,
                                         cameraCallback)

let _ = instanceSession.start_capture(&instanceSession)

SDL2.eventLoop { event in
    switch event.type {
    case SDL_KEYDOWN.rawValue:
        return false

    default:
        break
    }

    return true
}

let _ = instanceSession.stop_capture(&instanceSession)

instanceSession.close_session(&instanceSession)
