// UIColor+DDGHexColorAdditions.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (DDGAdditions)

///=================================================================================================
/// @name Creating Colors
///=================================================================================================

/**
 Returns a UIColor with a provided RGB (Red, Green, Blue) color.

     [UIColor colorFromRgba:0xFF0000]; // Creates a red.

 @param colorValue RGB integer e.g. 0xFF0000 for a red.
 @return UIColor with the provided RGB color.
 */
+ (UIColor*)colorFromRgb:(NSUInteger)colorValue;

/**
 Returns a UIColor with a provided RGBA (Red, Green, Blue, Alpha) color.

     [UIColor colorFromRgba:0xFF0000CC]; // Creates a semi transparent red.

 @param colorValue RGBA integer e.g. 0xFF0000CC for a semi transparent red.
 @return UIColor with the provided RGBA color.
 */
+ (UIColor*)colorFromRgba:(NSUInteger)colorValue;

///=================================================================================================
/// @name Helpers
///=================================================================================================

/**
 Returns a random opaque UIColor.

 @return Random opaque UIColor.
 */
+ (UIColor*)randomColor;

/**
 Returns a random UIColor with a random alpha component.

 @return Random UIColor with a random alpha component.
 */
+ (UIColor*)randomColorWithRandomAlpha;

/**
 Returns a random UIColor with the provided alpha component.

 @return Random UIColor with the provided alpha component.
 */
+ (UIColor*)randomColorWithAlpha:(CGFloat)alpha;

@end