// NSBundle+DDAppInformationAddition.h
//
// Created by Till Hagger on 20/03/14.

#import <Foundation/Foundation.h>

@interface NSBundle (DDAppInformationAddition)

/**
 Returns the name of the application.

 @return The name of the application.
 */
@property (nonatomic, readonly) NSString* appName;

/**
 Returns the version of the application.

 @return The version of the application.
 */
@property (nonatomic, readonly) NSString* appVersion;

@end