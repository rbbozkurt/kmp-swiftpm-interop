//
//  SwiftPackageObjC.h
//  SwiftPackage
//
//  Created by Resit Berkay Bozkurt on 02.06.25.
//

#import <Foundation/Foundation.h>

/**
 * Objective-C Interface for SwiftPackage wrapper class.
 *
 * ## Purpose
 * This interface exposes the Objective-C wrapper around a Swift class (`SwiftPackage`)
 * to C-compatible consumers. It is designed to allow integration of Swift logic
 * into cross-language platforms like Kotlin Multiplatform (KMP) via Kotlin/Native cinterop.
 *
 * ## Description
 * `SwiftPackageObjC` is the public Objective-C API exposed via a module map and
 * included in the `include/` directory of the Swift Package. The interface includes:
 *
 * - `desc`: A read-only description string representing the Objective-C bridge layer.
 * - `describe`: A method that combines the Objective-C layer description with that of the Swift implementation.
 *
 * This interface is used by Kotlin/Native through the generated bindings from `cinterop`.
 *
 * ## Usage
 * From Kotlin (via cinterop):
 * ```kotlin
 * val obj = SwiftPackageObjC()
 * println(obj.describe())
 * ```
 */
@interface SwiftPackageObjC : NSObject

/// A human-readable description of the Objective-C wrapper layer.
@property (nonatomic, strong) NSString *desc;

/// Returns a formatted description combining both ObjC and Swift layer outputs.
- (NSString *)describe;

@end
