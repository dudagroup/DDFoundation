// NSString+DDGAdditions.m
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

#import "NSString+DDGAdditions.h"


@implementation NSString (DDGAdditions)

static char BaseTable[] = "0123456789abcdefghijklmnopqrstuvwxyz";

+ (NSString*)stringWithBase:(NSUInteger)base fromInteger:(NSUInteger)value
{
    NSAssert(base >= 2 && base <= 36, @"Unsupported base %lu", (unsigned long)base);

    if (value == 0) return @"0";

    NSString* baseString = [NSString string];
    NSUInteger dividend = value;

    while (dividend > 0)
    {
        NSInteger modulo = dividend % base;
        baseString = [NSString stringWithFormat:@"%c%@", BaseTable[modulo], baseString];

        dividend = dividend / base;
    }

    return baseString;
}


@end