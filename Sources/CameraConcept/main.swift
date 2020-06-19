import AVFoundation
import Foundation
import CVideoCaptureDriverInterface

print("Camera Concept Test Application")

private let library = dlopen("libVCDI_V4L2.so", RTLD_NOW)
private let entrypointPointer = dlsym(library, "vcdi_main")
private let entrypoint = unsafeBitCast(entrypointPointer,
                                       to: (@convention (c) (UnsafeMutableRawPointer) -> Bool).self)

private let registerInstance: @convention(c) (UnsafeMutableRawPointer,
                                              UnsafeMutablePointer <vcdi_instance_registration_data_t>) -> Bool = { instance, registrationData in
    return false
}

private var instance = vcdi_instance_t(instance_handle: malloc(8),
                                       register_instance: registerInstance)

let _ = entrypoint(&instance)