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
private let library = dlopen("libVCDI_V4L2.so", RTLD_NOW)
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

let window = Window(title: "Hello World!",
                            x: 0,
                            y: 0,
                            width: 640,
                            height: 480,
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

instanceSession.close_session(&instanceSession)
