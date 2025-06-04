# Kotlin Multiplatform — SwiftPM Integration Prototype

## Overview
This project demonstrates how to integrate a Swift Package Manager (SwiftPM) dependency—exposing an Objective-C compatible API—into the `iosMain` source set of a Kotlin Multiplatform (KMP) project. The SwiftPM logic is then consumed by Kotlin/Native code and ultimately used within a native iOS application.

The primary goal is to establish seamless interoperation across three layers:

1. SwiftPM — Swift logic packaged and distributed using Swift Package Manager
2. Kotlin/Native (KMP) — Kotlin code accessing Swift functionality via Objective-C wrappers using CInterop
3. iOS App — A native iOS application consuming Kotlin logic that internally calls SwiftPM logic

This prototype provides a complete, working example of:
- Integrating a SwiftPM dependency in a Kotlin/Native iOS target
- Exposing SwiftPM logic to Kotlin via Objective-C and CInterop
- Packaging the Kotlin code as an `XCFramework`
- Using the `XCFramework` in an iOS Swift app to access the full Kotlin → Objective-C → Swift call chain

## Nested Architecture
The following diagram outlines the call chain and structural dependencies across the iOS application, Kotlin Multiplatform (KMP) module, and SwiftPM package:

```text
iOS App
  └── DummyPackageIOS.swift (Swift wrapper)
        └── Kotlin XCFramework (ComposeApp)
              └── DummyIosPackage.kt (iosMain implementation)
                    └── SwiftPackageObjC (Objective-C wrapper)
                          └── SwiftPackage.swift (Core Swift logic)

```

## 1. SwiftPM Package

The Swift Package Manager (SwiftPM) dependency used in this prototype is located at:
```text
/SwiftPMPackages/SwiftPackage/
```
It consists of two modules:
- `SwiftPackageSwift`: Contains the core logic written in pure Swift.
- `SwiftPackageObjC`: Provides an Objective-C wrapper that exposes Swift APIs in a way that Kotlin/Native can access via CInterop.


### Module Structure
```text
SwiftPackage/
├── Package.swift
└── Sources/
    ├── SwiftPackageSwift/
    │   └── SwiftPackage.swift
    └── SwiftPackageObjC/
        ├── SwiftPackageObjC.m
        ├── SwiftPackageObjC.h
        └── include/module.modulemap
```
### Functionality
- The `SwiftPackage` Swift class defines a basic function returning a static string or message.
- The Objective-C wrapper (`SwiftPackageObjC`) exposes that logic through an `@interface`, making it accessible to Kotlin/Native through Objective-C headers.
- A `module.modulemap` is provided in the `include/` directory to describe the Objective-C interface for CInterop.
- The SwiftPM package is built as a dynamic library to ensure runtime symbol visibility when consumed by Kotlin/Native.

## 2. Kotlin Multiplatform Project

The Kotlin Multiplatform (KMP) module forms the core layer that bridges the SwiftPM dependency with the iOS app.

### Structure

- `commonMain` defines a platform-agnostic interface, `DummyPackage`.
- `iosMain` provides the actual implementation, `DummyIosPackage`, which internally calls the Objective-C wrapper (`SwiftPackageObjC`) exposed by the SwiftPM module.
```kotlin
//commonMain
interface DummyPackage {
    fun describe(): String
}

expect fun getDummyPackage(): DummyPackage

// iosMain
import SwiftPackage.SwiftPackageObjC

class DummyIosPackage : DummyPackage {
    private val spm = SwiftPackageObjC()

    override fun describe(): String {
        return spm.describe()
    }
}

actual fun getDummyPackage(): DummyPackage = DummyIosPackage()

```

### CInterop Configuration in Gradle

The SwiftPM Objective-C wrapper is integrated into the Kotlin/Native build using CInterop. This is defined in `composeApp/build.gradle.kts`:
```kotlin
// composeApp/build.gradle.kts
val SwiftPackage by cinterops.creating {
    definitionFile.set(project.file("src/nativeInterop/cinterop/SwiftPackage.def"))
    includeDirs(project.file("path/to/SwiftPackageObjC/include"))
}
```
This configuration tells Kotlin/Native to generate interop bindings for the Objective-C headers defined in the `.def` file and located in the specified `includeDirs`.

### XCFramework Generation
The Kotlin codebase is compiled into a multiplatform `XCFramework`, which is then consumed by the iOS application.

## 3. iOS Application

The native iOS application integrates the Kotlin XCFramework (`ComposeApp`) and serves as the top layer of the interop stack.

To simplify usage of the Kotlin logic inside Swift, a lightweight Swift wrapper class is defined. This wrapper calls the Kotlin `getDummyPackage()` function, which returns an instance of `DummyIosPackage`—the platform-specific implementation from the `iosMain` source set.

While wrapping Kotlin logic in Swift is optional, doing so helps encapsulate interop boundaries and provides a cleaner API for Swift-side consumption.

### Swift Wrapper
```swift
@objc public class DummyPackageIOS: NSObject {
    private let dummyKmpPackage = DummyPackage_iosKt.getDummyPackage()

    @objc public func describe() -> String {
        return dummyKmpPackage.describe()
    }
}
```
This class acts as a bridge between the Swift-based UI and the Kotlin business logic, which itself indirectly invokes SwiftPM logic via the Objective-C wrapper.

## Demo Videos 
### iOS App
Shows SwiftUI app consuming Kotlin XCFramework that wraps SwiftPM logic.
![iOS App Demo](media/ios-demo.gif) 


### Android App
Demonstrates the same shared logic used natively on Android.
![Android App Demo](media/android-demo.gif)




## Concepts and Key Takeaways
This section summarizes the core technologies involved in the prototype and how they interoperate to enable a seamless Kotlin-to-Swift integration via Objective-C.

### Kotlin Multiplatform (KMP)
Kotlin Multiplatform (KMP) is a technology that enables code sharing across multiple platforms—such as iOS, Android, desktop, and web—while allowing you to retain native code for platform-specific functionality.

KMP organizes code into:
- `commonMain`: Shared business logic compiled for all declared targets
- Platform-specific source sets like `iosMain` or `androidMain`, where native code or interop bindings reside

Learn more in [JetBrains's official documentation](https://www.jetbrains.com/kotlin-multiplatform/).

### Swift Package Manager (SwiftPM)
The Swift Package Manager (SwiftPM) is Apple’s official tool for distributing, compiling, and managing Swift libraries. It is tightly integrated with Xcode and supports modular, dependency-managed Swift projects.

It has been the default packaging tool for Swift since version 3.0.

Learn more in [SwiftPM's official documentation](https://www.swift.org/documentation/package-manager/).

### Swift/ObjC ↔ Kotlin/Native
Kotlin/Native does not directly interoperate with Swift. However, it supports interop with Objective-C. Since Swift and Objective-C are also interoperable, this allows Kotlin to access Swift code **indirectly** through Objective-C.

Key enabling mechanism:

- Swift APIs must be annotated with `@objc` to be visible to Objective-C.

- Kotlin/Native can use these Objective-C APIs via CInterop.

This creates the following valid transitive ginterop chain:
```text
(Kotlin/Native ↔ ObjC) ∧ (ObjC ↔ Swift) ⇒ (Kotlin/Native ↔ Swift)
 ```

See following documentations/resources to learn/understand more about the interop:
- [What is Kotlin/Native?](https://kotlinlang.org/docs/native-overview.html)
- [What is Objective-C (ObjC)?](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011210-CH1-SW1)
- [What is Swift?](https://www.swift.org/)
- [Objective-C ↔ Swift Interoperability](https://www.fleksy.com/blog/developing-an-ios-framework-in-unison-with-swift-objective-c/)
  - [More about @objc in Swift](https://mahigarg.github.io/blogs/objc-in-swift/)
  - [More about Bridging Headers](https://medium.com/@mail2ashislaha/swift-objective-c-interoperability-static-libraries-modulemap-etc-39caa77ce1fc)
- [Objective-C/Swift ↔ Kotlin/Native Interoperability](https://kotlinlang.org/docs/native-objc-interop.html)

### Integrating iOS Dependencies into Kotlin Multiplatform
- Apple system libraries like `Foundation` or `CoreBluetooth` are natively supported in Kotlin/Native via prebuilt bindings—no extra setup required.
- Third-party iOS frameworks can also be used if they:
  - Are written in Objective-C, **or** 
  - Are written in Swift and expose an Objective-C-compatible interface (via `@objc`)

#### Important Considerations
- Pure Swift APIs (not annotated with `@objc`) are not usable from Kotlin/Native due to Swift’s lack of stable ABI and header exposure.
- Integration must be configured manually using `.def` files and proper `includeDirs`.

**Note:** To use a SwiftPM dependency in Kotlin/Native, it must:
- Provide Objective-C headers, and
- Expose Swift APIs using `@objc` annotations or an Objective-C wrapper.

### Integration Guides
This section outlines how to:
- Integrate a local SwiftPM package with Objective-C headers into a Kotlin Multiplatform (KMP) project using CInterop.
- Build and consume a Kotlin XCFramework from a native iOS application.

#### Integrating a Local SwiftPM Package into Kotlin Multiplatform (KMP)
Follow these steps to expose a SwiftPM dependency (with Objective-C API) to Kotlin/Native:
1. Create a SwiftPM package in Xcode
   - Set up your Swift package project using `Package.swift`.
2. Configure SwiftPM for Objective-C interop

     In your SwiftPM package:
     - Create an `include/` directory inside your Objective-C target (`SwiftPackageObjC`) under Sources/.
     - Place or symlink the Objective-C header files you want to expose in this directory.
     - Add a `module.modulemap` to the `include/` folder:
        ```modulemap
        module SwiftPackageObjC {
            header "SwiftPackageObjC.h"
            export *
        }
        ```
3. Create a Kotlin CInterop definition file

   Inside your KMP module (e.g., `composeApp`), create:
    ```text
    src/nativeInterop/cinterop/SwiftPackage.def
    ```
   Example content:
    ```text
   headers = SwiftPackageObjC.h
   package = SwiftPackage
   language = Objective-C
    ```
   **NOTE : Role of `module.modulemap` and `.def` Files**

    These files are essential for making native libraries available to Kotlin/Native. The `module.modulemap` informs the compiler how to treat headers as a module, while `.def` instructs Kotlin how to link and expose them.


4. Configure `build.gradle.kts` for CInterop
   In `composeApp/build.gradle.kts`, register the interop binding:
    ```kotlin
    iosTarget.compilations.getByName("main") {
        val SwiftPackage by cinterops.creating {
            definitionFile.set(project.file("src/nativeInterop/cinterop/SwiftPackage.def"))
            includeDirs(project.file("${rootDir}/path/to/SwiftPackageObjC/include"))
        }
    }
    ```

5. Enable CInterop commonization in `gradle.properties` to share interop configuration across iOS architectures:
   ```properties
   # Enables shared CInterop configuration across iOS architectures
   kotlin.mpp.enableCInteropCommonization=true
   ```
6. Sync Gradle and rebuild 
   
    After configuration, sync the Gradle project to generate the interop bindings.


#### Packaging Kotlin Code as an XCFramework for iOS
Follow these steps to package your KMP module as a Kotlin XCFramework and use it in an iOS app:

1. Define the XCFramework in `composeApp/build.gradle.kts`:
   ```kotlin
   val xcFramework = XCFramework("ComposeApp")
   ```
2. Declare iOS targets in your Kotlin setup:
   ```kotlin
   iosX64()
   iosArm64()
   iosSimulatorArm64()
   ```
3. Configure framework binaries for each target:
   ```kotlin
   listOf(iosX64(), iosArm64(), iosSimulatorArm64()).forEach { target ->
        target.binaries.framework {
            baseName = "ComposeApp"
            isStatic = true
            xcFramework.add(this)
        }
   }
   ```
4. Build the XCFramework using Gradle:
   ```shell
   ./gradlew :composeApp:assembleXCFramework
   ```

5. Import the XCFramework into your iOS project
   - Import `ComposeApp.xcframework` into your Xcode project.
   - Make sure the framework is included in the appropriate build phase and linked correctly.

6. Call Kotlin code from Swift
   Example usage from Swift code:
   ```swift
   import ComposeApp  // Kotlin XCFramework

   let dummy = DummyPackageIOS()
   print(dummy.describe())
   ```

### References, Useful Resources and Links
- [JetBrains's official documentation](https://www.jetbrains.com/kotlin-multiplatform/)
- [SwiftPM's official documentation](https://www.swift.org/documentation/package-manager/)
- [What is Kotlin/Native?](https://kotlinlang.org/docs/native-overview.html)
- [What is Objective-C (ObjC)?](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html#//apple_ref/doc/uid/TP40011210-CH1-SW1)
- [What is Swift?](https://www.swift.org/)
- [Objective-C ↔ Swift Interoperability](https://www.fleksy.com/blog/developing-an-ios-framework-in-unison-with-swift-objective-c/)
    - [More about @objc in Swift](https://mahigarg.github.io/blogs/objc-in-swift/)
    - [More about Bridging Headers](https://medium.com/@mail2ashislaha/swift-objective-c-interoperability-static-libraries-modulemap-etc-39caa77ce1fc)
- [Objective-C/Swift ↔ Kotlin/Native Interoperability](https://kotlinlang.org/docs/native-objc-interop.html)
- [Migrating Obj-C/C++ module to SPM](https://engineering.monstar-lab.com/en/post/2023/03/29/Migrating-objc-module-to-spm/)
- [More about SwiftPM '/include' folder](https://github.com/swiftlang/swift-package-manager/blob/main/Documentation/Usage.md#creating-c-language-targets)
- [KMP iOS Integration Methods](https://www.jetbrains.com/help/kotlin-multiplatform-dev/multiplatform-ios-integration-overview.html)
- [Exporting Modules as an XCFramework](https://www.jetbrains.com/help/kotlin-multiplatform-dev/multiplatform-spm-export.html#exporting-multiple-modules-as-an-xcframework)
- [Creating a Standalone Swift Package with Xcode](https://developer.apple.com/documentation/xcode/creating-a-standalone-swift-package-with-xcode)


## Improvements with More Time

If I had more time to allocate to this prototype, I would focus on the following enhancements and extensions:

- **Remote SwiftPM Dependency Integration (Objective-C APIs)**

  Explore using a remote SwiftPM package hosted on GitHub that exposes `@objc`-compatible APIs. Specifically, I would investigate whether it’s possible to integrate such a dependency into `iosMain` without relying on manually extracted headers or a local wrapper layer.


- **Reduce Export Scope of Kotlin XCFramework**

  Modularize the Kotlin Multiplatform library to expose only the required class (`DummyIosPackage`) in the XCFramework, instead of exporting the entire `ComposeApp` module. This would result in a cleaner public API surface and reduced binary size.


- **Improved Developer Tooling**

  Add scripts to lint Objective-C headers, detect breaking changes, and verify that generated binaries expose stable, ABI-compatible symbols for Kotlin/Native interop.

## Reflections and Learnings

Throughout this prototype, I gained the following technical insights:

- **Kotlin/Native Interop Depends on Objective-C Symbols**

  Kotlin/Native cannot directly consume Swift code; interop requires Swift APIs to be exposed via Objective-C, typically through `@objc` annotations or wrapper layers.


- **Role of `module.modulemap` and `.def` Files**

  These files are essential for making native libraries available to Kotlin/Native. The `module.modulemap` informs the compiler how to treat headers as a module, while `.def` instructs Kotlin how to link and expose them.


- **XCFramework Export Workflow**

  I learned how to configure and build a Kotlin Multiplatform XCFramework, and how to import it into a native iOS app. This included coordinating Gradle multiplatform configuration, linking native targets, and wrapping Kotlin logic for Swift-side access.
- Gained practical experience with Kotlin Multiplatform Gradle setup, iOS targets, and XCFramework creation.

### Directions for Further Research

Based on the technical insights gained during this prototype, the following research directions are strong candidates for future work. 

#### 1. SwiftPM Importing Kotlin XCFrameworks

- **Goal:** Make Kotlin XCFrameworks (produced from Kotlin/Native) consumable directly from SwiftPM packages.
- **Tasks may include:**
  - Creating a sample **Package.swift** that includes a Kotlin-generated `.xcframework` as a binary target.
  - Ensuring proper module mapping and visibility (via .modulemap).
  - Investigating limitations for distributing Kotlin code via SwiftPM (e.g., target platform restrictions).

**Example:**
```swift
.binaryTarget(
  name: "ComposeApp",
  path: "./binaries/ComposeApp.xcframework"
)
```

#### 2. SwiftPM Build Tool Plugin for Kotlin Sources

- **Goal:** Prototype a SwiftPM build tool plugin that can compile Kotlin/Native `.kt` files directly during a SwiftPM build.

- **Rationale:** This would allow Swift developers to treat Kotlin codebases as source dependencies within SwiftPM.

**Example Use Case:**

A Swift package includes a `Sources/Kotlin/` directory and a plugin builds it into a `.framework` or `.xcframework` automatically during SwiftPM resolution.

#### 3. Simplified Gradle DSL for CInterop

- **Goal:** Create a Kotlin Gradle plugin or extension DSL that wraps common CInterop setup for SwiftPM use cases.

- **Motivation:** The current `.def` + manual include dir setup is error-prone and verbose.

**Example:**
```kotlin
kotlinInterop {
    register("SwiftPackage") {
        headers = "SwiftPackageObjC.h"
        includeDirs = "src/nativeInterop/include"
        moduleMap = true
    }
}

```

---

## Conclusion

This prototype demonstrates how to bridge Swift code into Kotlin Multiplatform projects by leveraging Objective-C compatibility and Kotlin/Native's CInterop tooling. It showcases a complete integration pipeline—from SwiftPM setup and Objective-C wrapping, to Kotlin interop and iOS app consumption.

With additional time, future efforts could focus on streamlining remote SwiftPM integration, modularizing exports, and automating cross-language packaging workflows via plugins and declarative metadata.


