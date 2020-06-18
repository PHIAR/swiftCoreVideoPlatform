// swift-tools-version:5.2

import PackageDescription

// MARK: - Platform configuration

let platforms: [SupportedPlatform] = [
   .iOS("13.2"),
   .macOS("10.15"),
   .tvOS("13.2"),
]

let package = Package(name: "CoreVideo",
                      platforms: platforms,
                      products: [
                          .executable(name: "CameraConcept",
                                      targets: [
                                          "CameraConcept",
                                      ]),
                          .library(name: "AVFoundation",
                                   type: .dynamic,
                                   targets: [
                                       "AVFoundation",
                                   ]),
                          .library(name: "CoreMedia",
                                   type: .dynamic,
                                   targets: [
                                       "CoreMedia",
                                   ]),
                          .library(name: "CoreVideo",
                                   type: .dynamic,
                                   targets: [
                                       "CoreVideo",
                                   ]),
                          .library(name: "VCDI_NDKCamera2",
                                   type: .dynamic,
                                   targets: [
                                       "VCDI_NDKCamera2",
                                   ]),
                          .library(name: "VCDI_V4L2",
                                   type: .dynamic,
                                   targets: [
                                       "VCDI_V4L2",
                                   ]),
                          .library(name: "VideoToolbox",
                                   type: .dynamic,
                                   targets: [
                                       "VideoToolbox",
                                   ]),
                      ],
                      dependencies: [
                          .package(url: "https://github.com/PHIAR/swiftMetalPlatform.git",
                          .branch("master")),
                      ],
                      targets: [
                          .target(name: "AVFoundation",
                                  dependencies: [
                                      "CoreMedia",
                                      "CoreVideo",
                                  ]),
                          .target(name: "CameraConcept",
                                  dependencies: [
                                      "AVFoundation",
                                  ]),
                          .target(name: "CoreMedia",
                                  dependencies: [
                                      "CoreVideo",
                                  ]),
                          .target(name: "CoreVideo",
                                  dependencies: [
                                      .product(name: "Metal",
                                              package: "swiftMetalPlatform"),
                                  ]),
                          .target(name: "CVideoCaptureDriverInterface"),
                          .target(name: "VCDI_NDKCamera2",
                                  dependencies: [
                                      "CVideoCaptureDriverInterface",
                                  ]),
                          .target(name: "VCDI_V4L2",
                                  dependencies: [
                                      "CVideoCaptureDriverInterface",
                                  ]),
                          .target(name: "VideoToolbox",
                                  dependencies: [
                                  ]),
                          .testTarget(name: "CoreVideoTests",
                                      dependencies: [
                                          "CoreVideo",
                                      ]),
                      ])
