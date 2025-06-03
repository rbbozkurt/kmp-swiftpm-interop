// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    // Name of the Swift package
    name: "SwiftPackage",

    // Supported platforms and minimum versions
    platforms: [
        .iOS(.v13),
        .macOS(.v10_14)
    ],

    // Products define the library output of this package
    products: [
        .library(
            name: "SwiftPackage",
            type: .dynamic, // Exports as a dynamic library, to ensure runtime symbol visibility,
            targets: ["SwiftPackageObjC", "SwiftPackageSwift"] // Both targets are bundled
        )
    ],

    // Targets define the modules to be built
    targets: [
        // Pure Swift logic module
        .target(
            name: "SwiftPackageSwift",
            path: "Sources/SwiftPackageSwift"
        ),

        // Objective-C wrapper that depends on the Swift target
        .target(
            name: "SwiftPackageObjC",
            dependencies: ["SwiftPackageSwift"],
            path: "Sources/SwiftPackageObjC",
            publicHeadersPath: "include" // Makes headers accessible to external consumers
        )
    ]
)
