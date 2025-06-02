//
//  SwiftPackage.m
//  SwiftPackage
//
//  Created by Resit Berkay Bozkurt on 02.06.25.
//

#import "SwiftPackage.h"

@implementation SwiftPackage

- (instancetype)init {
    self = [super init];
    if (self) {
        _desc = @"This is SPM package code";
    }
    return self;
}

- (NSString *)describe {
    return self.desc;
}

@end



