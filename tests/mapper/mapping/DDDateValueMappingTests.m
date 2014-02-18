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
#import "DDHasManyMapping.h"
#import "DDObjectMapping.h"
#import "DDDateValueMapping.h"


@interface DDDateValueMappingTests : XCTestCase
@end

@implementation DDDateValueMappingTests
{
    NSDictionary* _testDictionary;
    Comment* _testComment;

    DDDateValueMapping* _dateValueMapping;
}

- (void)setUp
{
    [super setUp];

    _testDictionary = @
    {
        @"create_date": @"2014-01-22T17:33:19Z"
    };

    _testComment = [[Comment alloc] init];
    _testComment.createDate = [NSDate dateWithTimeIntervalSince1970:1390411999];

    _dateValueMapping = [[DDDateValueMapping alloc] initWithKey:@"create_date"
                                                          field:@"createDate"
                                                       required:YES
                                                     dateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
                                                       timeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMap
{
    Comment* resultComment = [[Comment alloc] init];
    NSError* error = nil;

    [_dateValueMapping mapFromDictionary:_testDictionary
                                toObject:resultComment
                                   error:&error];

    [resultComment.createDate timeIntervalSince1970];
    [_testComment.createDate timeIntervalSince1970];

    XCTAssertNil(error);
    XCTAssertEqual(resultComment, _testComment);
}
/*
- (void)testMapNull
{
    User* resultUser = [[User alloc] init];
    NSError* error = nil;

    NSDictionary* nullDictionary = @
    {
        @"comments": [NSNull null]
    };

    DDHasManyMapping* hasManyMapping = [[DDHasManyMapping alloc] initWithKey:@"comments"
                                                                       field:@"comments"
                                                                     mapping:_commentMapping
                                                                    required:NO];

    [hasManyMapping mapFromDictionary:nullDictionary
                             toObject:resultUser
                                error:&error];

    XCTAssertNil(error);
    XCTAssertNil(resultUser.comments);
}

- (void)testMapRequiredError
{
    NSDictionary* invalidDictionary = @{};
    User* resultUser = [[User alloc] init];

    NSError* error = nil;

    [_hasManyMapping mapFromDictionary:invalidDictionary
                              toObject:resultUser
                                 error:&error];

    XCTAssertNil(resultUser.comments);
    XCTAssertEqualObjects(error.domain, DDHasManyMappingErrorDomain);
    XCTAssertEqual(error.code, DDHasManyMappingErrorCodeValueIsRequired);
}

- (void)testMapNotAnArrayError
{
    NSDictionary* invalidDictionary = @
    {
        @"comments": @"totallyNotAnArray"
    };

    User* resultUser = [[User alloc] init];
    NSError* error = nil;

    [_hasManyMapping mapFromDictionary:invalidDictionary
                              toObject:resultUser
                                 error:&error];

    XCTAssertNil(resultUser.comments);
    XCTAssertEqualObjects(error.domain, DDHasManyMappingErrorDomain);
    XCTAssertEqual(error.code, DDHasManyMappingErrorCodeNotAnArray);
}
*/
/*
- (void)testMapReverse
{
    NSMutableDictionary* resultDictionary = [[NSMutableDictionary alloc] init];
    NSError* error = nil;

    [_dateValueMapping mapFromObject:_testUser
                        toDictionary:resultDictionary
                               error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultDictionary, _testDictionary);
}
*/
/*
- (void)testMapReverseNull
{
    User* nullUser = [[User alloc] init];
    NSMutableDictionary* resultDictionary = [[NSMutableDictionary alloc] init];
    NSError* error = nil;

    DDHasManyMapping* hasManyMapping = [[DDHasManyMapping alloc] initWithKey:@"comments"
                                                                       field:@"comments"
                                                                     mapping:_commentMapping
                                                                    required:NO];

    [hasManyMapping mapFromObject:nullUser
                     toDictionary:resultDictionary
                            error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultDictionary[@"comments"], [NSNull null]);
}

- (void)testMapReverseRequiredError
{
    User* invalidUser = [[User alloc] init];
    NSMutableDictionary* resultDictionary = [[NSMutableDictionary alloc] init];
    NSError* error = nil;

    [_hasManyMapping mapFromObject:invalidUser
                      toDictionary:resultDictionary
                             error:&error];

    XCTAssertNil(invalidUser.comments);
    XCTAssertEqualObjects(error.domain, DDHasManyMappingErrorDomain);
    XCTAssertEqual(error.code, DDHasManyMappingErrorCodeValueIsRequired);
}*/

@end
