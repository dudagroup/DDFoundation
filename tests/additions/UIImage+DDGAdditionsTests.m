//
//  UIImage+DDGAdditionsTests.m
//  DDGFoundation
//
//  Created by Till Hagger on 08/05/14.
//
//

#import <XCTest/XCTest.h>
#import "UIImage+DDGAdditions.h"

@interface UIImage_DDGAdditionsTests : XCTestCase

@end

@implementation UIImage_DDGAdditionsTests
{
    UIImage* _testImage;
    UIImage* _testImageRotated;
}

- (void)setUp
{
    [super setUp];

    _testImage =
        [UIImage imageWithContentsOfFile:
            [[NSBundle bundleForClass:[self class]] pathForResource:@"test_image" ofType:@"jpg"]];


    _testImageRotated =
        [UIImage imageWithContentsOfFile:
            [[NSBundle bundleForClass:[self class]] pathForResource:@"test_image_rotated" ofType:@"jpg"]];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testImageResizeAspectFit
{
    NSLog(@"ORIENTATION -> %i", _testImage.imageOrientation);
    NSLog(@"ORIENTATION 2 -> %i", _testImageRotated.imageOrientation);


    XCTAssert(_testImage, @"TEST");
}

@end
