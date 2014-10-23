// UIColor+DDGAdditions.m
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

#import "UIColor+DDGAdditions.h"
#import "DDGMathUtils.h"


@implementation UIColor (DDGAdditions)

+ (UIColor*)colorFromRgb:(NSUInteger)colorValue
{
    unsigned char red = (unsigned char)((colorValue & 0xFF0000) >> 16);
    unsigned char blue = (unsigned char)((colorValue & 0x00FF00) >> 8);
    unsigned char green = (unsigned char)(colorValue & 0x0000FF);

    return [UIColor colorWithRed:red / 255.0f
                           green:blue / 255.0f
                            blue:green / 255.0f
                           alpha:1.0f];
}

+ (UIColor*)colorFromRgba:(NSUInteger)colorValue
{
    unsigned char red = (unsigned char)((colorValue & 0xFF000000) >> 24);
    unsigned char blue = (unsigned char)((colorValue & 0x00FF0000) >> 16);
    unsigned char green = (unsigned char)((colorValue & 0x0000FF00) >> 8);
    unsigned char alpha = (unsigned char)(colorValue & 0x000000FF);

    return [UIColor colorWithRed:red / 255.0f
                           green:blue / 255.0f
                            blue:green / 255.0f
                           alpha:alpha / 255.0f];
}

+ (UIColor*)randomColor
{
    NSUInteger randomRgb = DDGRandomUnsignedIntegerWithUpperBound(0xFFFFFF);
    return [UIColor colorFromRgb:randomRgb];
}

+ (UIColor*)randomColorWithRandomAlpha
{
    NSUInteger randomRgba = DDGRandomUnsignedIntegerWithUpperBound(0xFFFFFFFF);
    return [UIColor colorFromRgba:randomRgba];
}

+ (UIColor*)randomColorWithAlpha:(CGFloat)alpha
{
    return [[UIColor randomColor] colorWithAlphaComponent:alpha];
}


@end