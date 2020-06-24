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

var frameIndex = 0
let cameraCallback: @convention(c) (_ context: UnsafeMutableRawPointer,
                                    _ pointer: UnsafeMutableRawPointer,
                                    _ size: Int) -> Void = { context, pointer, size in
    guard frameIndex < 10 else {
        return
    }

    let data = Data(bytes: pointer,
                    count: size)
    let url = URL(fileURLWithPath: "frame\(frameIndex).yuv")

    try! data.write(to: url)
    frameIndex += 1
}

instanceSession.register_camera_callback(&instanceSession,
                                         UnsafeMutableRawPointer(bitPattern: 1)!,
                                         cameraCallback)

let _ = instanceSession.start_capture(&instanceSession)
let window = Window(title: "Camera Concept",
                    x: 0,
                    y: 0,
                    width: 640,
                    height: 360,
                    flags: .shown)

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
