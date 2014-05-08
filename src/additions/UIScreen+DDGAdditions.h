// UIScreen+DDGAdditions.h
//
// Created by Till Hagger on 28/04/14.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIScreen (DDGAdditions)

+ (BOOL)isMainScreenWidescreen;
- (BOOL)isWidescreen;

+ (BOOL)isMainScreenRetina;
- (BOOL)isRetina;

@end