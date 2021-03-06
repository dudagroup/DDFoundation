// DDGMathUtils.h
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

/**
 Returns a random NSUInteger approximately between 0 and 4294967295.

 @see UINT32_MAX
 @see arc4random

 @return A random NSUInteger approximately between 0 and 4294967295.
 */
NSUInteger DDGRandomUnsignedInteger();

/**
 Returns a random NSUInteger approximately between 0 and the provided upper bound.

 @see arc4random_uniform

 @return A random NSUInteger approximately between 0 and the provided upper bound.
 */
NSUInteger DDGRandomUnsignedIntegerWithUpperBound(NSUInteger upperBound);

/**
 Returns a random double between 0 and 1.

 @see drand48

 @return A random double between 0 and 1.
 */
double DDGRandomDouble();

/**
 Returns a random float between 0 and 1.
 Calls DDGRandomDouble internally and cast its return value to a float.

 @see DDGRandomDouble

 @return A random float between 0 and 1.
 */
float DDGRandomFloat();

/**
 Converts a float value from radians to degrees.

 @return The converted value.
 */
inline float DDGFloatRadiansToDegrees(float radians);

/**
 Converts a double value from radians to degrees.

 @return The converted value.
 */
inline double DDGRadiansToDegrees(double radians);

/**
 Converts a float value from degrees to radians.

 @return The converted value.
 */
inline float DDGFloatDegreesToRadians(float angle);

/**
 Converts a double value from radians to degrees.

 @return The converted value.
 */
inline double DDGDegreesToRadians(double angle);