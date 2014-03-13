// UIColor+DDHexColorAdditions.m
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

#import "UIColor+DDHexColorAdditions.h"
#import "DDMathUtils.h"


@implementation UIColor (DDHexColorAdditions)

+ (UIColor*)colorFromRgba:(NSUInteger)colorValue
{
    NSUInteger defaultedColorValue = colorValue;

    if (colorValue <= 0xF)
    {
        defaultedColorValue = (colorValue << 28) + 0x000000FF;
    }
    else if (colorValue <= 0xFF)
    {
        defaultedColorValue = (colorValue << 24) + 0x000000FF;
    }
    else if (colorValue <= 0xFFF)
    {
        defaultedColorValue = (colorValue << 20) + 0x000000FF;
    }
    else if (colorValue <= 0xFFFF)
    {
        defaultedColorValue = (colorValue << 16) + 0x000000FF;
    }
    else if (colorValue <= 0xFFFFF)
    {
        defaultedColorValue = (colorValue << 12) + 0x000000FF;
    }
    else if (colorValue <= 0xFFFFFF)
    {
        defaultedColorValue = (colorValue << 8) + 0x000000FF;
    }
    else if (colorValue <= 0xFFFFFFF)
    {
        defaultedColorValue = (colorValue << 4);
    }

    unsigned char red = (unsigned char)((defaultedColorValue & 0xFF000000) >> 24);
    unsigned char blue = (unsigned char)((defaultedColorValue & 0x00FF0000) >> 16);
    unsigned char green = (unsigned char)((defaultedColorValue & 0x0000FF00) >> 8);
    unsigned char alpha = (unsigned char)(defaultedColorValue & 0x000000FF);

    return [UIColor colorWithRed:red / 255.0f
                           green:blue / 255.0f
                            blue:green / 255.0f
                           alpha:alpha / 255.0f];
}

+ (UIColor*)colorFromRgbaString:(NSString*)rgbaString
{
    return nil;
}

+ (UIColor*)colorFromArgb:(NSUInteger)colorValue
{
    return nil;
}

+ (UIColor*)colorFromArgbString:(NSString*)argbString
{
    return nil;
}

+ (UIColor*)randomColor
{
    NSUInteger randomRgb = DDRandomUnsignedIntegerWithUpperBound(0xFFFFFF);
    return [UIColor colorFromRgba:randomRgb];
}

+ (UIColor*)randomColorWithRandomAlpha
{
    NSUInteger randomRgba = DDRandomUnsignedIntegerWithUpperBound(0xFFFFFFFF);
    return [UIColor colorFromRgba:randomRgba];
}

+ (UIColor*)randomColorWithAlpha:(CGFloat)alpha
{
    return [[UIColor randomColor] colorWithAlphaComponent:alpha];
}


@end