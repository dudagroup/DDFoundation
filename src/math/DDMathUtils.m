// DDMathUtils.m
//
// Created by Till Hagger on 13/03/14.

#import "DDMathUtils.h"


NSUInteger DDRandomUnsignedInteger()
{
    return arc4random();
}

NSUInteger DDRandomUnsignedIntegerWithUpperBound(NSUInteger upperBound)
{
    return arc4random_uniform((u_int32_t)upperBound);
}

double DDRandomDouble()
{
    static dispatch_once_t Once;

    dispatch_once(&Once, ^
    {
        srand48(time(0));
    });

    return drand48();
}