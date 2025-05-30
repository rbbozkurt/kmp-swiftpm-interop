#import "RandomNumberGenerator.h"

@implementation RandomNumberGenerator

- (NSInteger)generateWithMin:(NSInteger)min max:(NSInteger)max {
    return arc4random_uniform((uint32_t)(max - min + 1)) + min;
}

@end
