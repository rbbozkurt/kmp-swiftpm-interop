// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "SwiftPackage",
    platforms: [
        .iOS(.v13), .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "SwiftPackage",
            type: .dynamic,
            targets: ["SwiftPackageObjC", "SwiftPackageSwift"]
        )
    ],
    targets: [
        .target(
            name: "SwiftPackageSwift",
            path: "Sources/SwiftPackageSwift"
        ),
        .target(
            name: "SwiftPackageObjC",
            dependencies: ["SwiftPackageSwift"],
            path: "Sources/SwiftPackageObjC",
            publicHeadersPath: "include"
        )
    ]
)

