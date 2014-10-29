// DDGImageLoadingQueueItem.m
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

#import <AFNetworking/AFHTTPRequestOperation.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

#import "DDGImageLoadingQueueItem.h"
#import "DDGImageLoadingQueue.h"


@implementation DDGImageLoadingQueueItem
{
    BOOL _didComplete;

    AFHTTPRequestOperation* _requestOperation;
    UIImage* _image;
}

- (instancetype)init
{
    NSAssert(NO, @"Don't use this class directly.");
    return nil;
}

- (instancetype)initWithQueue:(DDGImageLoadingQueue*)queue url:(NSURL*)url
{
    NSParameterAssert(queue);
    NSParameterAssert(url);

    self = [super init];

    if (self)
    {
        _queue = queue;
        _url = url;
    }

    return self;
}

- (void)start
{
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:_url];
    UIImage* cachedImage = [[UIImageView sharedImageCache] cachedImageForRequest:urlRequest];

    if (cachedImage)
    {
        _image = cachedImage;

        [_queue queueItemCompleted:self];
        if (_successBlock) _successBlock(cachedImage);
    }
    else
    {
        _requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
        _requestOperation.responseSerializer = [[AFImageResponseSerializer alloc] init];

        __weak DDGImageLoadingQueueItem* weakSelf = self;
        __strong DDGImageLoadingQueueItem* strongSelf = weakSelf;

        [_requestOperation setCompletionBlockWithSuccess:^(
            AFHTTPRequestOperation* operation,
            id responseObject)
        {
            strongSelf->_image = responseObject;

            [[UIImageView sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
            [strongSelf.queue queueItemCompleted:strongSelf];

            if (strongSelf.successBlock)
            {
                strongSelf.successBlock(responseObject);
            }
        }
                                                 failure:^(
            AFHTTPRequestOperation* operation,
            NSError* error)
        {
            [strongSelf.queue queueItemCompleted:strongSelf];

            if (strongSelf.failureBlock)
            {
                strongSelf.failureBlock(error);
            }
        }];

        _requestOperation.downloadProgressBlock = ^(
            NSUInteger bytesRead,
            long long int totalBytesRead,
            long long int totalBytesExpectedToRead)
        {
            if (weakSelf.progressBlock && totalBytesExpectedToRead != -1)
            {
                weakSelf.progressBlock(totalBytesRead, totalBytesExpectedToRead);
            }
        };

        [_queue.queue addOperation:_requestOperation];
    }
}

- (void)cancel
{
    [_requestOperation cancel];
}

- (void)resume
{
    [_requestOperation resume];
}

- (void)pause
{
    [_requestOperation pause];
}

@end