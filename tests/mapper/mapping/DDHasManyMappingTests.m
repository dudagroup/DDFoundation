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


@interface DDHasManyMappingTests : XCTestCase
@end

@implementation DDHasManyMappingTests
{
    NSDictionary* _testDictionary;
    User* _testUser;

    DDObjectMapping* _commentMapping;
    DDHasManyMapping* _hasManyMapping;
}

- (void)setUp
{
    [super setUp];

    _testDictionary = @
    {
        @"comments": @
        [
            @{
                @"id": @24134
            },

            @{
                @"id": @23411
            }
        ]
    };

    _testUser = [[User alloc] init];

    _testUser.comments = @
    [
        [[Comment alloc] initWithId:24134
                         createDate:nil
                               user:nil],

        [[Comment alloc] initWithId:23411
                         createDate:nil
                               user:nil]
    ];

    _commentMapping = [DDObjectMapping mappingWithClass:[Comment class]
                                  withConstructionBlock:^(DDObjectMapping* mapping)
    {
        [mapping mapKey:@"id"
                toField:@"id"
                  class:[NSNumber class]
               required:YES
                 strict:YES];
    }];

    _hasManyMapping = [[DDHasManyMapping alloc] initWithKey:@"comments"
                                                      field:@"comments"
                                                    mapping:_commentMapping
                                                   required:YES];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMap
{
    User* resultUser = [[User alloc] init];
    NSError* error = nil;

    [_hasManyMapping mapFromDictionary:_testDictionary
                              toObject:resultUser
                                 error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultUser, _testUser);
}

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

- (void)testMapUnderlyingMappingError
{
    DDObjectMapping* invalidObjectMapping = [DDObjectMapping mappingWithClass:[Comment class]
                                                        withConstructionBlock:^(DDObjectMapping* mapping)
    {
        [mapping mapKey:@"notExistingKey"
                toField:@"notExistingProperty"
                  class:[NSString class]
               required:YES
                 strict:YES];
    }];

    DDHasManyMapping* hasManyMapping = [[DDHasManyMapping alloc] initWithKey:@"comments"
                                                                       field:@"comments"
                                                                     mapping:invalidObjectMapping
                                                                    required:YES];

    User* resultUser = [[User alloc] init];
    NSError* error = nil;

    [hasManyMapping mapFromDictionary:_testDictionary
                             toObject:resultUser
                                error:&error];

    XCTAssertNil(resultUser.comments);
    XCTAssertEqualObjects(error.domain, DDHasManyMappingErrorDomain);
    XCTAssertEqual(error.code, DDDHasManyMappingErrorCodeUnderlyingMappingError);
    XCTAssertNotNil(error.userInfo[NSUnderlyingErrorKey]);
}

- (void)testMapReverse
{
    NSMutableDictionary* resultDictionary = [[NSMutableDictionary alloc] init];
    NSError* error = nil;

    [_hasManyMapping mapFromObject:_testUser
                      toDictionary:resultDictionary
                             error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultDictionary, _testDictionary);
}

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
}

@end
