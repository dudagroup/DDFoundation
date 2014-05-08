// UIScreen+DDGAdditions.m
//
// Created by Till Hagger on 28/04/14.

#import "UIScreen+DDGAdditions.h"


@implementation UIScreen (DDGAdditions)

+ (BOOL)isMainScreenWidescreen
{
    return [[UIScreen mainScreen] isWidescreen];
}

- (BOOL)isWidescreen
{
    return self.bounds.size.height == 568.0;
}

+ (BOOL)isMainScreenRetina
{
    return [[UIScreen mainScreen] isRetina];
}

- (BOOL)isRetina
{
    return self.scale > 1.0;
}

@end