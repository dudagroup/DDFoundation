// DDMathUtils.h
//
// Created by Till Hagger on 13/03/14.

#import <Foundation/Foundation.h>

/**
 Returns a random NSUInteger approximately between 0 and 4294967295.

 @see UINT32_MAX
 @see arc4random

 @return A random NSUInteger approximately between 0 and 4294967295.
 */
NSUInteger DDRandomUnsignedInteger();

/**
 Returns a random NSUInteger approximately between 0 and the provided upper bound.

 @see arc4random_uniform

 @return A random NSUInteger approximately between 0 and the provided upper bound.
 */
NSUInteger DDRandomUnsignedIntegerWithUpperBound(NSUInteger upperBound);

/**
 Returns a random double between 0 and 1.

 @see drand48

 @return A random double between 0 and 1.
 */
double DDRandomDouble();