// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftPackage",
    platforms: [
            .macOS(.v10_14), .iOS(.v13), .tvOS(.v13)
        ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftPackage",
            type : .dynamic,
            targets: ["SwiftPackage"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftPackage",
            path : "Sources/SwiftPackage",
            publicHeadersPath: "include"
        ),

    ]
)
