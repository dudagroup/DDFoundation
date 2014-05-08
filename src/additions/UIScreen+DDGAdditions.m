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
    return self.bounds.size.height == 568.0f;
}

@end