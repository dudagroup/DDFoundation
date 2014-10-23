// NSArray+DDGAdditions.m
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

#import "NSArray+DDGAdditions.h"
#import "DDGMathUtils.h"


@implementation NSArray (DDGAdditions)

- (NSArray*)shuffledArray
{
    NSMutableArray* mutableArray = [self mutableCopy];
    [mutableArray shuffle];

    return [mutableArray copy];
}

@end

@implementation NSMutableArray (DDGShufflingAdditions)

- (void)shuffle
{
    NSUInteger count = self.count;

    if (count > 1)
    {
        for (NSUInteger i = count - 1; i > 0; --i)
        {
            [self exchangeObjectAtIndex:i
                      withObjectAtIndex:DDGRandomUnsignedIntegerWithUpperBound(i + 1)];
        }
    }
}

@end