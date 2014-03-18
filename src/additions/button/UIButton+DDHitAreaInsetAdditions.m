// UIButton+DDHitAreaAdditions.m
//
// Created by Till Hagger on 17/03/14.

#import "UIButton+DDHitAreaInsetAdditions.h"

#import <objc/runtime.h>


@implementation UIButton (DDHitAreaInsetAdditions)

@dynamic hitAreaInset;

static void* const HitAreaInsetKey = (void* const)&HitAreaInsetKey;

- (void)setHitAreaInset:(UIEdgeInsets)hitAreaInset
{
    NSValue* value = [NSValue valueWithUIEdgeInsets:hitAreaInset];
    objc_setAssociatedObject(self, HitAreaInsetKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)hitAreaInset
{
    NSValue* value = objc_getAssociatedObject(self, HitAreaInsetKey);
    return value.UIEdgeInsetsValue;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect hitTestArea = UIEdgeInsetsInsetRect(self.bounds, self.hitAreaInset);
    return CGRectContainsPoint(hitTestArea, point);
}

@end