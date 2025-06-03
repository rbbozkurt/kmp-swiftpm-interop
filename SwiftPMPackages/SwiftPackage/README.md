# SwiftPackage

## Overview
This Swift Package demonstrates integration of a Swift module with an Objective-C API, making it usable in cross-language environments like Kotlin Multiplatform (KMP) — through Kotlin/Native cinterop.

## Functionality

- `SwiftPackageSwift`: Contains native Swift logic encapsulated in a class with a simple `describe()` API.
- `SwiftPackageObjC`: Acts as an Objective-C bridge to expose Swift functionality through an Objective-C interface. This is essential for interop with platforms that can consume only C-compatible APIs (e.g., Kotlin Native, older Apple APIs).
- `module.modulemap`: Enables correct inclusion and export of headers for external tools like cinterop to find and consume the public API.

## Project Structure

```
SwiftPackage/
├── Package.swift                   # SwiftPM manifest defining dynamic library and targets
└── Sources/
    ├── SwiftPackageSwift/          # Pure Swift logic (e.g., SwiftPackage class)
    │   └── SwiftPackage.swift      # Defines 'desc' property and 'describe()' method
    └── SwiftPackageObjC/           # Objective-C wrapper exposing Swift logic
        ├── SwiftPackageObjC.h      # Public header for use in cinterop or C-family
        ├── SwiftPackageObjC.m      # Implements bridge logic and indentation formatting
        └── include/
            ├── SwiftPackageObjC.h  # Symlinked or copied public header for visibility
            └── module.modulemap    # Declares module exports for compiler/interoperability
```
### Why a dynamic library?
This package is explicitly configured to produce a dynamic library using:

```swift
type: .dynamic
```

This is necessary for interoperability use cases:
- Kotlin/Native cinterop requires runtime symbols to be available.
- Bridging Swift to Objective-C with runtime calls is smoother with dynamic linking.
- Enables consumption from systems that expect runtime-resolved symbols (e.g., plugin architectures, embedded platforms).

Static libraries may lead to linker errors or optimized-away symbols that Kotlin cannot access.



## Usage
- Import this package as a local or remote dependency.
- Use `SwiftPackageObjC` in Kotlin Native cinterop to call into Swift.
- Make sure the `include/` headers are correctly exposed via the module.modulemap.

### Example Usage (Kotlin Native cinterop)

```kotlin
val spmPackage = SwiftPackageObjC()
println(spmPackage.describe())
// Output:
// This is SPM package ObjC code calling:
// {
//   This SPM package Swift code
// }
```

### Supported Platforms
 - iOS 13+
 - macOS 10.14+

### Swift Compatibility
 - Swift 6.1+

### License
This project is licensed under the [MIT License](LICENSE).

### Author
Resit Berkay Bozkurt — 2025
