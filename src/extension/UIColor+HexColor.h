// DDCollectable.h
//
// Created by Till Hagger on 20/12/13.
// Copyright (c) 2013 DU DA. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DDDebugModuleController <NSObject>

@property (nonatomic, readonly) CGFloat preferredModuleHeight;

@end

@interface DDDebugOverlay : NSObject

+ (void)enableOverlay;
+ (void)addDebugModuleController:(UIViewController<DDDebugModuleController>*)debugModuleController;

@end