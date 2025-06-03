//
//  DummyPackageIOS.swift
//  iOSApp
//
//  Created by Resit Berkay Bozkurt on 02.06.25.
//

import Foundation
import ComposeApp  // Kotlin/Native XCFramework containing getDummyPackage()

/// Objective-C compatible wrapper class for Kotlin Multiplatform shared logic.
///
/// This class demonstrates how an iOS-native layer (Swift/ObjC)
/// can call into Kotlin code compiled as an XCFramework.
///
/// It acts as an adapter between Swift/ObjC and Kotlin Multiplatform,
/// and is callable from SwiftUI.
///
/// In the context of this project:
/// - This class is used in SwiftUI (e.g., in `ContentView`)
/// - It calls the Kotlin function `getDummyPackage()`, which returns a platform-specific implementation
/// - That implementation (on iOS) wraps an Objective-C wrapper to a SwiftPM package
///
@objc public class DummyPackageIOS: NSObject {

    /// A reference to the Kotlin-implemented DummyPackage via `expect/actual`
    private let dummyKmpPackage = DummyPackage_iosKt.getDummyPackage()

    /// A description string specific to the iOS app layer
    private let desc = "This is iOS App code"

    /// A formatted string that:
    /// - Calls Kotlin's implementation of `DummyPackage.describe()`
    /// - Indents each line of that output for readability
    /// - Adds its own prefix to indicate the iOS App layer
    ///
    /// This method can be called directly from SwiftUI via `@objc` compatibility.
    @objc public func describe() -> String {
        let innerDescription = dummyKmpPackage.describe()
        .split(separator: "\n")
        .map { "  \($0)" }
        .joined(separator: "\n")

        return "\(desc) calling:\n{\n\(innerDescription)\n}"
    }
}
