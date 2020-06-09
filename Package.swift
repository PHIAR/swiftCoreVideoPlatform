// swift-tools-version:5.2

import PackageDescription

let package = Package(name: "CoreVideo",
                      products: [
                          .library(name: "AVFoundation",
                                   targets: [
                                       "AVFoundation",
                                   ]),
                          .library(name: "CoreMedia",
                                   targets: [
                                       "CoreMedia",
                                   ]),
                          .library(name: "CoreVideo",
                                   targets: [
                                       "CoreVideo",
                                   ]),
                          .library(name: "VideoToolbox",
                                   targets: [
                                       "VideoToolbox",
                                   ]),
                      ],
                      dependencies: [
                      ],
                      targets: [
                          .target(name: "AVFoundation",
                                  dependencies: [
                                      "CoreMedia",
                                      "CoreVideo",
                                  ]),
                          .target(name: "CoreMedia",
                                  dependencies: [
                                  ]),
                          .target(name: "CoreVideo",
                                  dependencies: [
                                  ]),
                          .target(name: "VideoToolbox",
                                  dependencies: [
                                  ]),
                          .testTarget(name: "CoreVideoTests",
                                      dependencies: [
                                          "CoreVideo",
                                      ]),
                      ])
