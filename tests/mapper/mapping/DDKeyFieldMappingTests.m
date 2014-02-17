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
#import "DDKeyFieldMapping.h"


@interface DDKeyFieldMappingTests : XCTestCase
@end

@implementation DDKeyFieldMappingTests
{
    NSDictionary* _testDictionary;
    User* _testUser;
}

- (void)setUp
{
    [super setUp];

    _testDictionary = @
    {
        @"id": @2341,
        @"id_string": @"2341",
        @"first_name": @"Tom",
        @"last_name": [NSNull null]
    };

    _testUser = [[User alloc] init];

    _testUser.id = 2341;
    _testUser.idString = @"2341";
    _testUser.firstName = @"Tom";
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMap
{
    NSError* error = nil;
    User* resultUser = [[User alloc] init];

    DDKeyFieldMapping* keyFieldMapping = [[DDKeyFieldMapping alloc] initWithKey:@"first_name"
                                                                          field:@"firstName"
                                                                          class:[NSString class]
                                                                       required:YES
                                                                         strict:YES];

    [keyFieldMapping mapFromDictionary:_testDictionary
                              toObject:resultUser
                                 error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultUser.firstName, @"Tom");
}

- (void)testMapNull
{
    NSError* error = nil;
    User* resultUser = [[User alloc] init];

    DDKeyFieldMapping* keyFieldMapping = [[DDKeyFieldMapping alloc] initWithKey:@"last_name"
                                                                          field:@"lastName"
                                                                          class:[NSString class]
                                                                       required:NO
                                                                         strict:YES];

    [keyFieldMapping mapFromDictionary:_testDictionary
                              toObject:resultUser
                                 error:&error];

    XCTAssertNil(error);
    XCTAssertNil(resultUser.lastName);
}

- (void)testMapPrimitive
{
    NSError* error = nil;
    User* resultUser = [[User alloc] init];

    DDKeyFieldMapping* keyFieldMapping = [[DDKeyFieldMapping alloc] initWithKey:@"id"
                                                                          field:@"id"
                                                                          class:[NSNumber class]
                                                                       required:YES
                                                                         strict:YES];

    [keyFieldMapping mapFromDictionary:_testDictionary
                              toObject:resultUser
                                 error:&error];

    XCTAssertNil(error);
    XCTAssert(resultUser.id == 2341);
}

- (void)testMapAutoConvertStringToNumber
{
    NSError* error = nil;
    User* resultUser = [[User alloc] init];

    DDKeyFieldMapping* keyFieldMapping = [[DDKeyFieldMapping alloc] initWithKey:@"id_string"
                                                                          field:@"id"
                                                                          class:[NSNumber class]
                                                                       required:YES
                                                                         strict:NO];

    [keyFieldMapping mapFromDictionary:_testDictionary
                              toObject:resultUser
                                 error:&error];

    XCTAssertNil(error);
    XCTAssert(resultUser.id == 2341);
}

- (void)testMapAutoConvertNumberToString
{
    NSError* error = nil;
    User* resultUser = [[User alloc] init];

    DDKeyFieldMapping* keyFieldMapping = [[DDKeyFieldMapping alloc] initWithKey:@"id"
                                                                          field:@"idString"
                                                                          class:[NSString class]
                                                                       required:YES
                                                                         strict:NO];

    [keyFieldMapping mapFromDictionary:_testDictionary
                              toObject:resultUser
                                 error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultUser.idString, @"2341");
}

- (void)testMapRequiredError
{
    NSError* error = nil;
    User* resultUser = [[User alloc] init];

    DDKeyFieldMapping* keyFieldMapping = [[DDKeyFieldMapping alloc] initWithKey:@"last_name"
                                                                          field:@"lastName"
                                                                          class:[NSString class]
                                                                       required:YES
                                                                         strict:YES];

    [keyFieldMapping mapFromDictionary:_testDictionary
                              toObject:resultUser
                                 error:&error];

    XCTAssertNil(resultUser.lastName);
    XCTAssertNotNil(error);
    XCTAssertEqualObjects(error.domain, DDKeyFieldMappingErrorDomain);
    XCTAssertEqual(error.code, DDKeyFieldMappingErrorCodeValueIsRequired);
}

- (void)testMapReverse
{
    NSError* error = nil;
    NSMutableDictionary* resultDictionary = [[NSMutableDictionary alloc] init];

    DDKeyFieldMapping* keyFieldMapping = [[DDKeyFieldMapping alloc] initWithKey:@"first_name"
                                                                          field:@"firstName"
                                                                          class:[NSString class]
                                                                       required:YES
                                                                         strict:YES];

    [keyFieldMapping mapFromObject:_testUser
                      toDictionary:resultDictionary
                             error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultDictionary[@"first_name"], @"Tom");
}

- (void)testMapReversePrimitive
{
    NSError* error = nil;
    NSMutableDictionary* resultDictionary = [[NSMutableDictionary alloc] init];

    DDKeyFieldMapping* keyFieldMapping = [[DDKeyFieldMapping alloc] initWithKey:@"id"
                                                                          field:@"id"
                                                                          class:[NSNumber class]
                                                                       required:YES
                                                                         strict:YES];

    [keyFieldMapping mapFromObject:_testUser
                      toDictionary:resultDictionary
                             error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultDictionary[@"id"], @2341);
}

- (void)testMapReverseNull
{
    NSError* error = nil;
    NSMutableDictionary* resultDictionary = [[NSMutableDictionary alloc] init];

    DDKeyFieldMapping* keyFieldMapping = [[DDKeyFieldMapping alloc] initWithKey:@"last_name"
                                                                          field:@"lastName"
                                                                          class:[NSString class]
                                                                       required:NO
                                                                         strict:YES];

    [keyFieldMapping mapFromObject:_testUser
                      toDictionary:resultDictionary
                             error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultDictionary[@"last_name"], [NSNull null]);
}

- (void)testMapReverseRequiredError
{
    NSError* error = nil;
    NSMutableDictionary* resultDictionary = [[NSMutableDictionary alloc] init];

    DDKeyFieldMapping* keyFieldMapping = [[DDKeyFieldMapping alloc] initWithKey:@"last_name"
                                                                          field:@"lastName"
                                                                          class:[NSString class]
                                                                       required:YES
                                                                         strict:YES];

    [keyFieldMapping mapFromObject:_testUser
                      toDictionary:resultDictionary
                             error:&error];

    XCTAssertNil(resultDictionary[@"last_name"]);
    XCTAssertEqualObjects(error.domain, DDKeyFieldMappingErrorDomain);
    XCTAssertEqual(error.code, DDKeyFieldMappingErrorCodeValueIsRequired);
}

@end
