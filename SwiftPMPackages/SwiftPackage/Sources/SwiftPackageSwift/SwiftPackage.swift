//
//  SwiftPackage.swift
//  SwiftPackage
//
//  Created by Resit Berkay Bozkurt on 03.06.25.
//

import Foundation

/**
 A Swift class that represents the core functionality of the Swift module within the SwiftPM package.

 ## Purpose
 This class provides a simple description property and method for testing and demonstration purposes.
 It is exposed to Objective-C using `@objc`, which makes it accessible from Objective-C and compatible
 with Kotlin Multiplatform (KMP) via Kotlin/Native cinterop.

 ## Usage
 This class is used internally by the Objective-C wrapper (`SwiftPackageObjC`) to forward method calls
 from external consumers such as Kotlin code.

 ## Properties
 - `desc`: A description string that is returned by `describe()`. This value is set during initialization.

 ## Methods
 - `describe() -> String`: Returns the value of `desc`.

 This setup enables the Swift logic to be reused and invoked in other environments that cannot call Swift code directly,
 such as Kotlin Native, by routing the call through Objective-C.

 */
@objc public class SwiftPackage: NSObject {

    /// The descriptive string returned by the `describe()` method.
    @objc public var desc: String

    /// Default initializer. Sets the default description value.
    @objc public override init() {
        self.desc = "This is SPM package Swift code"
        super.init()
    }

    /// Returns the description string.
    @objc public func describe() -> String {
        return desc
    }
}
