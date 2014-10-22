// DDGFoundation.h
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
#import "DDGImageLoadingQueue.h"
#import "DDGImageLoadingQueueItem.h"


float DDGImageBufferDefaultLow = 0.0f;
float DDGImageBufferDefaultHigh = 0.0f;

@implementation DDGImageLoadingQueue
{
    NSOperationQueue* _queue;
}

- (instancetype)init
{
    self = [super init];

    if (self)
    {
        _queue = [[NSOperationQueue alloc] init];

    }

    return self;
}

- (DDGImageLoadingQueueItem*)addImageByUrl:(NSURL*)url
{
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];

    AFHTTPRequestOperation* requestOperation =
        [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];


    requestOperation.responseSerializer = [[AFImageResponseSerializer alloc] init];
    requestOperation.completionBlock = ^
    {
        NSLog(@"Done!");
    };

    [requestOperation setDownloadProgressBlock:^(
        NSUInteger bytesRead,
        long long int totalBytesRead,
        long long int totalBytesExpectedToRead)
    {
        NSLog(@"%qi %qi", totalBytesRead, totalBytesExpectedToRead);
    }];

    [_queue addOperation:requestOperation];

    return nil;
}

@end