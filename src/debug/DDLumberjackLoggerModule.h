// DDCollectable.h
//
// Created by Till Hagger on 20/12/13.
// Copyright (c) 2013 DU DA. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CocoaLumberjack/DDLog.h>

#import "DDDebugOverlay.h"

@interface DDLumberjackLoggerModule : UIViewController <DDDebugModuleController,
                                                        UITableViewDataSource,
                                                        UITableViewDelegate,
                                                        DDLogger>

@property (nonatomic, readonly) CGFloat preferredModuleHeight;
@property (nonatomic) NSUInteger maxLogMessages;

@end