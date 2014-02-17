// UIColor+DDHexColorAdditions.h
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

@interface UIColor (DDHexColorAdditions)

///=================================================================================================
/// @name RGBA
///=================================================================================================

/**
 Returns a UIColor with a provided RGBA (Red, Green, Blue, Alpha) color.

     [UIColor colorFromRgba:0xFF0000CC]; // Creates a semi transparent red.

 @param colorValue RGBA integer e.g. 0xFF0000CC for a semi transparent red.
 @return UIColor with the provided RGBA color.
 */
+ (UIColor*)colorFromRgba:(NSUInteger)colorValue;

/**
 Return a UIColor with a provided RGBA (Red, Green, Blue, Alpha) color.

     [UIColor colorFromRgbaString:@"#FF0000CC"]; // Creates a semi transparent red.
     // Or
     [UIColor colorFromRgbaString:@"FF0000CC"];
     // Or
     [UIColor colorFromRgbaString:@"0xFF0000CC"];

 @param rgbaString A string representing a color in hexadecimal, prefixes like '0x' or '#' will be
                   ignored.
 @return UIColor with the provided RGBA color.
 */
+ (UIColor*)colorFromRgbaString:(NSString*)rgbaString;

///=================================================================================================
/// @name ARGB
///=================================================================================================

/**
 Returns a UIColor with a provided ARGB (Alpha, Red, Green, Blue) color.

     [UIColor colorFromRgba:0xCCFF0000]; // Creates a semi transparent red.

 @param colorValue RGBA integer e.g. 0xCCFF0000 for a semi transparent red.
 @return UIColor with the provided ARGB color.
 */
+ (UIColor*)colorFromArgb:(NSUInteger)colorValue;

/**
 Return a UIColor with a provided RGBA (Alpha, Red, Green, Blue) color.

     [UIColor colorFromRgbaString:@"#CCFF0000"]; // Creates a semi transparent red.
     // Or
     [UIColor colorFromRgbaString:@"CCFF0000"];
     // Or
     [UIColor colorFromRgbaString:@"0xCCFF0000"];

 @param rgbaString A string representing a color in hexadecimal, prefixes like '0x' or '#' will be
                   ignored.
 @return UIColor with the provided RGBA color.
 */
+ (UIColor*)colorFromArgbString:(NSString*)argbString;

@end