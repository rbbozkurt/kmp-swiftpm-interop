//
// Created by Resit Berkay Bozkurt on 02.06.25.
//

import Foundation
import ComposeApp

@objc public class DummyPackageIOS: NSObject {
    private let dummyKmpPackage = DummyIosPackage()
    private let desc = "This is iOS App code"

    @objc public func describe() -> String {
        let innerDescription = dummyKmpPackage.describe()
        .split(separator: "\n")
        .map { "  \($0)" }
        .joined(separator: "\n")

        return "\(desc) calling:\n{\n\(innerDescription)\n}"
    }
}

