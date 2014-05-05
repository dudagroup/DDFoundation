// UIImage+DDGAdditions.m
//
// Created by Till Hagger on 05/05/14.

#import "UIImage+DDGAdditions.h"


@implementation UIImage (DDGAdditions)

- (UIImage*)imageWithNormalizedRotation
{

}

- (UIImage*)imageWithRotation:(DDGImageRotation)rotation
{

}

- (UIImage*)imageWithSize:(CGSize)size resizeMode:(DDGImageResizeMode)resizeMode
{
    NSAssert(size.width > 0.0, @"Size width must be greater than zero.");
    NSAssert(size.height > 0.0, @"Size height must be greater than zero.");

    CGSize finalSize;

    float imageAspectRatio = (float)self.size.width / (float)self.size.height;
    float sizeAspectRatio = size.width / size.height;

    switch (resizeMode)
    {
        default:
        case DDGImageResizeModeAspectFit:
            if (imageAspectRatio > sizeAspectRatio)
            {
                finalSize = CGSizeMake(size.width, size.width / imageAspectRatio);
            }
            else
            {
                finalSize = CGSizeMake(size.height * imageAspectRatio, size.height);
            }
        break;
    }

    UIGraphicsBeginImageContextWithOptions(finalSize, NO, 1.0f);

    [self drawInRect:CGRectMake(0, 0, finalSize.width, finalSize.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return resizedImage;
}

/*- (void)imageWithNormalizedRotation:(DDGImageResizeCompletionHandler)completionHandler
{
}

- (void)imageWithRotation:(DDGImageRotation)rotation
               completion:(DDGImageResizeCompletionHandler)completionHandler
{

}

- (void)imageWithSize:(CGSize)size
           resizeMode:(DDGImageResizeMode)resizeMode
           completion:(DDGImageResizeCompletionHandler)completionHandler
{

}*/

@end