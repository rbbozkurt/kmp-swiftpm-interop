//
//  SwiftPackageObjC.m
//  SwiftPackage
//
//  Created by Resit Berkay Bozkurt on 02.06.25.
//

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
