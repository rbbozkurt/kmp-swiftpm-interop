//
//  SwiftPackageObjC.m
//  SwiftPackage
//
//  Created by Resit Berkay Bozkurt on 02.06.25.
//

/**
 Objective-C bridge class implementation for exposing Swift logic to C-family consumers.

 ## Purpose
 `SwiftPackageObjC` wraps the `SwiftPackage` class written in Swift and provides an Objective-C-compatible
 interface for external tools or runtimes such as Kotlin Multiplatform (KMP), where Swift cannot be
 directly accessed from Kotlin/Native.

 This allows Swift logic to be used in environments that support Objective-C interoperability
 via C interop bindings.

 ## Internal Behavior
 - Initializes a Swift `SwiftPackage` instance.
 - Exposes a `desc` property and a `describe` method which returns a formatted string combining Objective-C
   and Swift values.

 ## Properties
 - `swiftPack`: The wrapped Swift object.
 - `_desc`: Local description string representing the Objective-C layer.

 ## Methods
 - `init`: Initializes both the Objective-C wrapper and its internal Swift object.
 - `desc`: Getter for the Objective-C description.
 - `describe`: Returns a formatted multiline string combining `_desc` and `swiftPack.describe()` with indentation.

 ## Usage
 This class is consumed via Kotlin/Native CInterop, allowing Kotlin code to invoke the `describe()` method
 and receive combined output from both layers (Swift and Objective-C).

 */

#import "SwiftPackageObjC.h"
@import SwiftPackageSwift; // Imports the Swift module

@implementation SwiftPackageObjC {
    SwiftPackage *swiftPack;
    NSString *_desc;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        swiftPack = [[SwiftPackage alloc] init];
        _desc = @"This is SPM package ObjC code calling:";
    }
    return self;
}

- (NSString *)desc {
    return _desc;
}

- (NSString *)describe {
    NSString *inner = [swiftPack describe];
    NSArray<NSString *> *lines = [inner componentsSeparatedByString:@"\n"];

    NSMutableString *indented = [NSMutableString string];
    for (NSString *line in lines) {
        [indented appendFormat:@"  %@\n", line];
    }

    return [NSString stringWithFormat:@"%@\n{\n%@}", _desc, indented];
}

@end
