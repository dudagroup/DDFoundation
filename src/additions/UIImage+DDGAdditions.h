// UIImage+DDGAdditions.h
//
// Created by Till Hagger on 05/05/14.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDGImageResizeMode)
{
    DDGImageResizeModeAspectFit
};

typedef NS_ENUM(NSUInteger, DDGImageRotation)
{
    DDGImageRotation90Degrees = 0,
    DDGImageRotation180Degrees,
    DDGImageRotation270Degrees,
};

typedef void (^DDGImageResizeCompletionHandler)(UIImage* resizedImage);

@interface UIImage (DDGAdditions)

- (UIImage*)imageWithNormalizedRotation;
- (UIImage*)imageWithRotation:(DDGImageRotation)rotation;
- (UIImage*)imageWithSize:(CGSize)size resizeMode:(DDGImageResizeMode)resizeMode;

/*- (void)imageWithNormalizedRotation:(DDGImageResizeCompletionHandler)completionHandler;

- (void)imageWithRotation:(DDGImageRotation)rotation
               completion:(DDGImageResizeCompletionHandler)completionHandler;

- (void)imageWithSize:(CGSize)size
           resizeMode:(DDGImageResizeMode)resizeMode
           completion:(DDGImageResizeCompletionHandler)completionHandler;*/

@end