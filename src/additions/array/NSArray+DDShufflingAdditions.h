// NSArray+DDShufflingAdditions.h
//
// Created by Till Hagger on 14/03/14.

#import <Foundation/Foundation.h>

@interface NSArray (DDShufflingAdditions)

/**
 Returns a randomly shuffled version of the array.
 For more information see: http://en.wikipedia.org/wiki/Fisher–Yates_shuffle

 @return Randomly shuffled version of the array
 */
- (NSArray*)shuffledArray;

@end

@interface NSMutableArray (DDShufflingAdditions)

/**
 Shuffles the array randomly.
 For more information see: http://en.wikipedia.org/wiki/Fisher–Yates_shuffle
 */
- (void)shuffle;

@end