// UIImage+DDGAdditions.m
//
// Copyright (c) 2014 DU DA GMBH (http://www.dudagroup.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIImage+DDGAdditions.h"


@implementation UIImage (DDGAdditions)

- (UIImage*)imageWithNormalizedRotation
{
    return nil;
}

- (UIImage*)imageWithRotation:(DDGImageRotation)rotation
{
    return nil;
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