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
#import "DDMapper.h"


@interface DDMapperTests : XCTestCase
@end

@implementation DDMapperTests
{
    NSDictionary* _testDictionary;
    User* _testUser;

    DDObjectMapping* _userMapping;
    DDObjectMapping* _commentMapping;
}

- (void)setUp
{
    [super setUp];

    NSDate* date = [[NSDate alloc] init];

    _testUser = [[User alloc] initWithId:64
                               firstName:@"Tom"
                                lastName:@"Test"
                                  gender:GenderMale
                                comments:@
    [
        [[Comment alloc] initWithId:1234
                         createDate:date
                               user:nil],

        [[Comment alloc] initWithId:2345
                         createDate:date
                               user:nil],

        [[Comment alloc] initWithId:3456
                         createDate:date
                               user:nil],

        [[Comment alloc] initWithId:4567
                         createDate:date
                               user:nil],
    ]];

    _testDictionary = @
    {
        @"id": @64,
        @"first_name": @"Tom",
        @"last_name": @"Test",
        @"gender": @2,
        @"comments": @
        [
            @{
                @"id": @1234,
                @"create_date": date
            },

            @{
                @"id": @2345,
                @"create_date": date
            },

            @{
                @"id": @3456,
                @"create_date": date
            },

            @{
                @"id": @4567,
                @"create_date": date
            }
        ]
    };

    _commentMapping = [DDObjectMapping mappingWithClass:[Comment class]
                                  withConstructionBlock:^(DDObjectMapping* mapping)
    {
        [mapping mapKey:@"id"
                toField:@"id"
                  class:[NSNumber class]
               required:YES
                 strict:YES];

        [mapping mapKey:@"create_date"
                toField:@"createDate"
                  class:[NSDate class]
               required:YES
                 strict:YES];
    }];

    _userMapping = [DDObjectMapping mappingWithClass:[User class]
                           withConstructionBlock:^(DDObjectMapping* mapping)
    {
        [mapping mapKey:@"id"
                toField:@"id"
                  class:[NSNumber class]
               required:YES
                 strict:YES];

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

        [mapping mapKey:@"gender"
                toField:@"gender"
                  class:[NSNumber class]
               required:YES
                 strict:YES];

        [mapping hasManyMapping:_commentMapping
                         forKey:@"comments"
                          field:@"comments"
                       required:YES];
    }];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testMapper
{
    NSError* error = nil;

    User* resultUser = [DDMapper objectFromDictionary:_testDictionary
                                          withMapping:_userMapping
                                                error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultUser, _testUser);
}

- (void)testMapperReverse
{
    NSError* error = nil;

    NSDictionary* resultDictionary = [DDMapper dictionaryFromObject:_testUser
                                                        withMapping:_userMapping
                                                              error:&error];

    XCTAssertNil(error);
    XCTAssertEqualObjects(resultDictionary, _testDictionary);
}

@end
