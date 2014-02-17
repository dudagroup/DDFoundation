// DDSerializerDeserializationTests.m
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

#import <XCTest/XCTest.h>

#import "MockObjects.h"
#import "DDObjectMapping.h"
#import "DDHasOneMapping.h"


@interface DDHasOneMappingTests : XCTestCase
@end

@implementation DDHasOneMappingTests
{
    NSDictionary* _testDictionary;
    Comment* _testComment;

    DDObjectMapping* _userMapping;
    DDHasOneMapping* _hasOneMapping;
}

- (void)setUp
{
    [super setUp];

    _testDictionary = @
    {
        @"user": @
        {
            @"first_name": @"Tom",
            @"last_name": @"Test"
        }
    };

    _testComment = [[Comment alloc] init];
    _testComment.user = [[User alloc] initWithId:0
                                       firstName:@"Tom"
                                        lastName:@"Test"
                                          gender:(Gender)0
                                        comments:nil];

    _userMapping = [DDObjectMapping mappingWithClass:[User class]
                               withConstructionBlock:^(DDObjectMapping* mapping)
    {
        [mapping mapKey:@"first_name"
                toField:@"firstName"
                  class:[NSString class]
               required:YES
                 strict:YES];

        [mapping mapKey:@"last_name"
                toField:@"lastName"
                  class:[NSString class]
               required:YES
                 strict:YES];
    }];

    _hasOneMapping = [[DDHasOneMapping alloc] initWithKey:@"user"
                                                    field:@"user"
                                                  mapping:_userMapping
                                                 required:YES];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMap
{
    Comment* resultComment = [[Comment alloc] init];
    NSError* error = nil;

    [_hasOneMapping mapFromDictionary:_testDictionary
                             toObject:resultComment
                                error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultComment, _testComment);
}

- (void)testMapNull
{
    Comment* resultComment = [[Comment alloc] init];
    NSError* error = nil;

    NSDictionary* nullDictionary = @
    {
        @"user": [NSNull null]
    };

    DDHasOneMapping* hasOneMapping = [[DDHasOneMapping alloc] initWithKey:@"user"
                                                                    field:@"user"
                                                                  mapping:_userMapping
                                                                 required:NO];

    [hasOneMapping mapFromDictionary:nullDictionary
                            toObject:resultComment
                               error:&error];

    XCTAssertNil(error);
    XCTAssertNil(resultComment.user);
}

- (void)testMapRequiredError
{
    NSDictionary* invalidDictionary = @{};
    Comment* resultComment = [[Comment alloc] init];
    NSError* error = nil;

    [_hasOneMapping mapFromDictionary:invalidDictionary
                             toObject:resultComment
                                error:&error];

    XCTAssertNil(resultComment.user);
    XCTAssertEqualObjects(error.domain, DDHasOneMappingErrorDomain);
    XCTAssertEqual(error.code, DDHasOneMappingErrorCodeValueIsRequired);
}

- (void)testMapReverse
{
    NSMutableDictionary* resultDictionary = [[NSMutableDictionary alloc] init];
    NSError* error = nil;

    [_hasOneMapping mapFromObject:_testComment
                     toDictionary:resultDictionary
                            error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultDictionary, _testDictionary);
}

- (void)testMapReverseNull
{
    Comment* nullComment = [[Comment alloc] init];
    NSMutableDictionary* resultDictionary = [[NSMutableDictionary alloc] init];
    NSError* error = nil;

    DDHasOneMapping* hasOneMapping = [[DDHasOneMapping alloc] initWithKey:@"user"
                                                                    field:@"user"
                                                                  mapping:_userMapping
                                                                 required:NO];

    [hasOneMapping mapFromObject:nullComment
                    toDictionary:resultDictionary
                           error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultDictionary[@"user"], [NSNull null]);
}

- (void)testMapReverseRequiredError
{
    Comment* invalidComment = [[Comment alloc] init];
    NSMutableDictionary* resultDictionary = [[NSMutableDictionary alloc] init];
    NSError* error = nil;

    [_hasOneMapping mapFromObject:invalidComment
                     toDictionary:resultDictionary
                            error:&error];

    XCTAssertNil(resultDictionary[@"user"]);
    XCTAssertEqualObjects(error.domain, DDHasOneMappingErrorDomain);
    XCTAssertEqual(error.code, DDHasOneMappingErrorCodeValueIsRequired);
}

@end
