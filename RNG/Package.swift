// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "RNG",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "RNG",
            type: .dynamic,
            targets: ["RNG"]
        )
    ],
    targets: [
        .target(
            name: "RNG",
            path: "Sources/RNG",
            publicHeadersPath: "include"
        )
    ]
)
