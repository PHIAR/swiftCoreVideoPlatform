#pragma once

// VCDI - Video Capture Driver Interface
// ==========================================================================================================
//
//
// VCDI is a runtime used by swiftCoreVideoPlatform's AVFoundation module to provide camera capture services.
// The runtime exposes a driver API to make camera enablement across various platforms simpler.
//
// In particular a simple C interface is exposed so that implemnenting drivers can be built with appropriate
// bindings to a wide variety of languages and runtimes.
//
//
// ----------------------------------------------------------------------------------------------------------
// VCDI API
// ----------------------------------------------------------------------------------------------------------
//
// At a bare minimum, a simple dummy driver can be implemented as follows:
//
// <C source: vcdi_dummy_driver.c>
// #include <stdio.h>
// #include <VideoCaptureDriverInterface.h>
//
//  bool vcdi_main(vcdi_instance_t *instance) {
//      printf("Hello world from VCDI dummy driver!")
//      memset(instance, 0, sizeof(*instance));
//      return false
//  }
// </C source>
//
// and compiled as follows:
//     $ clang -o libvcdi_dummy_driver.so \
//             -I <path_to_VideoCaptureDriverInterface.h> \
//             vcdi_dummy_driver.c
//
// Although not functional, libvcdi_dummy_driver.so can now be located in the driver runtime search paths
// and on enumeration, will emit a hello world message to indicate successful driver loading.

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include "CompilerDefinitions.h"

NONNULL_BEGIN

typedef enum vcdi_instance_type_e {
    vcdi_instance_type_unknown = 0,

    // Vendor driver instance is a color camera
    vcdi_instance_type_hardware_color_camera = 1,
} vcdi_instance_type_e;

typedef void (vcdi_camera_callback_t)(void *context,
                                      void *pointer,
                                      size_t size);

typedef struct vcdi_instance_session_t {
    // Vendor driver context
    void * NULL_UNSPECIFIED context;

    // Start video capture stream
    bool (* NULL_UNSPECIFIED start_capture)(struct vcdi_instance_session_t *session);

    // Stop video capture stream
    bool (* NULL_UNSPECIFIED stop_capture)(struct vcdi_instance_session_t *session);

    // Session termination callback
    // NB: Context is cleared on completion.
    void (* NULL_UNSPECIFIED close_session)(struct vcdi_instance_session_t *session);

    // Pixel buffer capture callback
    void (* NULL_UNSPECIFIED register_camera_callback)(struct vcdi_instance_session_t *session,
                                                       void *context,
                                                       vcdi_camera_callback_t *callback);
} vcdi_instance_session_t;

typedef bool (vcdi_instance_requestion_authorization_t)(void *context);

typedef bool (vcdi_instance_open_session_t)(void *context,
                                            vcdi_instance_session_t *instance_session);

typedef struct vcdi_instance_registration_data_t {
    // Vendor driver context
    void * NULL_UNSPECIFIED context;

    // Vendor device unique name
    char const * NULL_UNSPECIFIED  vendor_name;

    // Vendor device instance type
    vcdi_instance_type_e instance_type;

    // Callbacks
    vcdi_instance_requestion_authorization_t * NULL_UNSPECIFIED request_authorization;
    vcdi_instance_open_session_t * NULL_UNSPECIFIED open_session;
} vcdi_instance_registration_data_t;

// Per instance data
typedef struct vcdi_instance_t {
    // VCDI internal context data
    void *instance_handle;

    // Register instance callback and populate vcdi_instance_registration_data_t on success.
    bool (*register_instance)(void *instance_handle,
                              vcdi_instance_registration_data_t *data);
} vcdi_instance_t;

// Main entrypoint interface definition
typedef bool (vcdi_library_entrypoint_t)(struct vcdi_instance_t *instance);

BEGIN_DECLS

// PUBLIC API: VideoCaptureDriverInterface main entrypoint
EXPORT_SYMBOL vcdi_library_entrypoint_t vcdi_main;

END_DECLS

NONNULL_END
