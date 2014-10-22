//
// Created by Till Hagger on 22/10/14.
//

#import <Foundation/Foundation.h>

@class DDGImageLoadingQueue;


@interface DDGImageLoadingQueueItem : NSObject

@property (nonatomic, weak) DDGImageLoadingQueue* imageQueue;
@property (nonatomic, readonly) NSString* identifier;

@property (nonatomic) NSObject* successBlock;
@property (nonatomic) NSObject* failureBlock;
@property (nonatomic) NSObject* progressBlock;

@end