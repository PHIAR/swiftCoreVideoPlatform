import CVideoCaptureDriverInterface
import Foundation

internal var instances: [VCDIInstance] = []

@_cdecl("vcdi_main")
public func vcdi_main(_ instance: UnsafeMutablePointer <vcdi_instance_t>) {
    let registerInstance = instance.pointee.register_instance
    let _instance = VCDIInstance(instanceHandle: instance.pointee.instance_handle)
    let result: Bool = _instance.vendorName.withCString { vendorName in
        var instanceRegistrationData = vcdi_instance_registration_data_t(context: UnsafeMutableRawPointer(bitPattern: instances.count + 1)!,
                                                                         vendor_name: vendorName,
                                                                         instance_type: vcdi_instance_type_hardware_color_camera,
                                                                         request_authorization: _instance.requestAuthorization,
                                                                         open_session: _instance.openSession)

        return registerInstance(&instanceRegistrationData)
    }

    guard result else {
        return
    }

    instances.append(_instance)
}
