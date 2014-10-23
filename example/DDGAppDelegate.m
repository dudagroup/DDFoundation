// DDGAppDelegate.h
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

#import "DDGAppDelegate.h"
#import "UIScreen+DDGAdditions.h"

#import <DDGFoundation/DDGFoundation.h>
#import <AFNetworking/AFNetworking.h>


@implementation DDGAppDelegate
{
    UIWindow* _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] init];
    [_window makeKeyAndVisible];

    NSLog(@"%i", [UIScreen isMainScreenWidescreen]);

    
    DDGImageLoadingQueue* imageLoadingQueue = [[DDGImageLoadingQueue alloc] init];


    [imageLoadingQueue queueImageByUrl:
        [NSURL URLWithString:@"http://lorempixel.com/200/200/cats/"]];

    [imageLoadingQueue queueImageByUrl:
        [NSURL URLWithString:@"http://lorempixel.com/200/200/cats/"]];

    [imageLoadingQueue queueImageByUrl:
        [NSURL URLWithString:@"http://lorempixel.com/200/200/cats/"]];

    [imageLoadingQueue queueImageByUrl:
        [NSURL URLWithString:@"http://lorempixel.com/200/200/cats/"]];

    [imageLoadingQueue queueImageByUrl:
        [NSURL URLWithString:@"http://lorempixel.com/200/200/cats/"]];

    [imageLoadingQueue queueImageByUrl:
        [NSURL URLWithString:@"http://lorempixel.com/200/200/cats/"]];

    DDGImageLoadingQueueItem* queueItem =
        [imageLoadingQueue queueImageByUrl:
            [NSURL URLWithString:@"http://lorempixel.com/300/300/cats/"]];



    queueItem.requestOperation.queuePriority = NSOperationQueuePriorityVeryHigh;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}

@end
