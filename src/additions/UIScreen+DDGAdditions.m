// UIScreen+DDGAdditions.m
//
// Created by Till Hagger on 28/04/14.

#import "UIScreen+DDGAdditions.h"


@implementation UIScreen (DDGAdditions)

static const CGFloat WidescreenRatio = 1.7;

+ (BOOL)isMainScreenWidescreen
{
    return [[UIScreen mainScreen] isWidescreen];
}

- (BOOL)isWidescreen
{
    return (self.bounds.size.height / self.bounds.size.width) >= WidescreenRatio;
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