//
// Created by Resit Berkay Bozkurt on 03.06.25.
//
import Foundation

@objc public class SwiftPackage: NSObject {

    @objc public var desc: String

    @objc public override init() {
        self.desc = "This is SPM package Swift code"
        super.init()
    }

    @objc public func describe() -> String {
        return desc
    }
}
