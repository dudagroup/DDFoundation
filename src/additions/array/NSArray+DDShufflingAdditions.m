// NSArray+DDShufflingAdditions.m
//
// Created by Till Hagger on 14/03/14.

#import "NSArray+DDShufflingAdditions.h"
#import "DDMathUtils.h"


@implementation NSArray (DDShufflingAdditions)

- (NSArray*)shuffledArray
{
    NSMutableArray* mutableArray = [self mutableCopy];
    [mutableArray shuffle];

    return [mutableArray copy];
}

@end

@implementation NSMutableArray (DDShufflingAdditions)

- (void)shuffle
{
    NSUInteger count = self.count;

    if (count > 1)
    {
        for (NSUInteger i = count - 1; i > 0; --i)
        {
            [self exchangeObjectAtIndex:i
                      withObjectAtIndex:DDRandomUnsignedIntegerWithUpperBound(i + 1)];
        }
    }
}

@end