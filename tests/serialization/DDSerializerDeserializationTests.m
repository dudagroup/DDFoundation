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
#import "DDSerializationMapping.h"
#import "DDSerializer.h"
#import "DDKeyFieldMapping.h"

@interface TestObject : NSObject

@property (nonatomic) NSString* testString;
@property (nonatomic) NSNumber* testNumber;

@property (nonatomic) NSInteger testInteger;
@property (nonatomic) CGFloat testFloat;

@property (nonatomic) TestObject* testObject;

@end

@implementation TestObject
@end

@interface DDSerializerDeserializationTests : XCTestCase
@end

@implementation DDSerializerDeserializationTests

- (void)setUp
{
    [super setUp];


}

- (void)tearDown
{

    [super tearDown];
}

- (void)testErrorNullDictionary
{
    DDSerializationMapping* serializationMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping mapKey:@"test_number" toField:@"testString" class:[NSString class] required:YES strict:NO];
        }];

    NSError* error = nil;
    TestObject* testObject = [DDSerializer objectFromDictionary:nil
                                                    withMapping:serializationMapping
                                                          error:&error];

    NSError* underlyingError = error.userInfo[NSUnderlyingErrorKey];

    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, DDSerializerErrorCodeInvalidDictionary);
}

- (void)testErrorInvalidDictionary
{
    DDSerializationMapping* serializationMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping mapKey:@"test_number" toField:@"testString" class:[NSString class] required:YES strict:NO];
        }];

    id totallyNotADictionary = [NSArray array];

    NSError* error = nil;
    TestObject* testObject = [DDSerializer objectFromDictionary:totallyNotADictionary
                                                    withMapping:serializationMapping
                                                          error:&error];

    NSError* underlyingError = error.userInfo[NSUnderlyingErrorKey];

    XCTAssertNotNil(error);
    XCTAssertEqual(error.code, DDSerializerErrorCodeInvalidDictionary);
}

- (void)testStrictStringMapping
{
    DDSerializationMapping* serializationMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping mapKey:@"test_string" toField:@"testString" class:[NSString class] required:YES strict:YES];
        }];

    NSDictionary* testDictionary = @
    {
        @"test_string": @"Some test data"
    };

    NSError* error = nil;
    TestObject* testObject = [DDSerializer objectFromDictionary:testDictionary
                                                    withMapping:serializationMapping
                                                          error:&error];

    XCTAssertEqualObjects(testObject.testString, @"Some test data");
}

- (void)testNonStrictStringMapping
{
    DDSerializationMapping* serializationMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping mapKey:@"test_number" toField:@"testString" class:[NSString class] required:YES strict:NO];
        }];

    NSDictionary* testDictionary = @
    {
        @"test_number": @1234
    };

    NSError* error = nil;
    TestObject* testObject = [DDSerializer objectFromDictionary:testDictionary
                                                    withMapping:serializationMapping
                                                          error:&error];

    XCTAssertEqualObjects(testObject.testString, @"1234");
}

- (void)testStrictNumberMapping
{
    DDSerializationMapping* serializationMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping mapKey:@"test_number" toField:@"testNumber" class:[NSNumber class] required:YES strict:YES];
            [mapping mapKey:@"test_number" toField:@"testInteger" class:[NSNumber class] required:YES strict:YES];
            [mapping mapKey:@"test_number" toField:@"testFloat" class:[NSNumber class] required:YES strict:YES];
        }];

    NSDictionary* testDictionary = @
    {
        @"test_number": @1.513
    };

    NSError* error = nil;
    TestObject* testObject = [DDSerializer objectFromDictionary:testDictionary
                                                    withMapping:serializationMapping
                                                          error:&error];

    XCTAssertEqualObjects(testObject.testNumber, [NSNumber numberWithDouble:1.513]);
    XCTAssertEqual(testObject.testInteger, 1);
    XCTAssertEqual(testObject.testFloat, 1.513f);
}

- (void)testNonStrictNumberMapping
{
    DDSerializationMapping* serializationMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping mapKey:@"test_string" toField:@"testNumber" class:[NSNumber class] required:YES strict:NO];
            [mapping mapKey:@"test_string" toField:@"testInteger" class:[NSNumber class] required:YES strict:NO];
            [mapping mapKey:@"test_string" toField:@"testFloat" class:[NSNumber class] required:YES strict:NO];
        }];

    NSDictionary* testDictionary = @
    {
        @"test_string": @"1.513",
    };

    NSError* error = nil;
    TestObject* testObject = [DDSerializer objectFromDictionary:testDictionary
                                                    withMapping:serializationMapping
                                                          error:&error];

    XCTAssertEqualObjects(testObject.testNumber, [NSNumber numberWithDouble:1.513]);
    XCTAssertEqual(testObject.testInteger, 1);
    XCTAssertEqual(testObject.testFloat, 1.513f);
}

- (void)testNullValue
{
    DDSerializationMapping* serializationMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping mapKey:@"test_number" toField:@"testString" class:[NSString class] required:NO strict:NO];
        }];

    NSDictionary* testDictionary = @
    {
        @"test_number": [NSNull null]
    };

    NSError* error = nil;
    TestObject* testObject = [DDSerializer objectFromDictionary:testDictionary
                                                    withMapping:serializationMapping
                                                          error:&error];

    XCTAssertEqualObjects(testObject.testString, nil);
}

- (void)testErrorRequiredNonStrictNullValue
{
    DDSerializationMapping* serializationMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping mapKey:@"test_number" toField:@"testString" class:[NSString class] required:YES strict:NO];
        }];

    NSDictionary* testDictionary = @
    {
        @"test_number": [NSNull null]
    };

    NSError* error = nil;
    TestObject* testObject = [DDSerializer objectFromDictionary:testDictionary
                                                    withMapping:serializationMapping
                                                          error:&error];

    NSError* underlyingError = error.userInfo[NSUnderlyingErrorKey];

    XCTAssertNotNil(error);
    XCTAssertNotNil(underlyingError);
    XCTAssertEqual(error.code, DDSerializerErrorCodeDeserializationError);
    XCTAssertEqual(underlyingError.code, DDKeyFieldMappingErrorCodeValueIsRequired);
}

- (void)testErrorRequiredNonStrictMissingValue
{
    DDSerializationMapping* serializationMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping mapKey:@"test_number" toField:@"testString" class:[NSString class] required:YES strict:NO];
        }];

    NSDictionary* testDictionary = @{};

    NSError* error = nil;
    TestObject* testObject = [DDSerializer objectFromDictionary:testDictionary
                                                    withMapping:serializationMapping
                                                          error:&error];

    NSError* underlyingError = error.userInfo[NSUnderlyingErrorKey];

    XCTAssertNotNil(error);
    XCTAssertNotNil(underlyingError);
    XCTAssertEqual(error.code, DDSerializerErrorCodeDeserializationError);
    XCTAssertEqual(underlyingError.code, DDKeyFieldMappingErrorCodeValueIsRequired);
}

- (void)testErrorStrict
{
    DDSerializationMapping* serializationMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping mapKey:@"test_date" toField:@"testString" class:[NSString class] required:YES strict:YES];
        }];

    NSDictionary* testDictionary = @
    {
        @"test_date": [[NSDate alloc] init]
    };

    NSError* error = nil;
    TestObject* testObject = [DDSerializer objectFromDictionary:testDictionary
                                                    withMapping:serializationMapping
                                                          error:&error];

    NSError* underlyingError = error.userInfo[NSUnderlyingErrorKey];

    XCTAssertNotNil(error);
    XCTAssertNotNil(underlyingError);
    XCTAssertEqual(error.code, DDSerializerErrorCodeDeserializationError);
    XCTAssertEqual(underlyingError.code, DDKeyFieldMappingErrorCodeValueHasWrongType);
}

- (void)testErrorNonStrictConversion
{
    DDSerializationMapping* serializationMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping mapKey:@"test_date"
                    toField:@"testString"
                      class:[NSString class]
                   required:YES
                     strict:NO];
        }];

    NSDictionary* testDictionary = @
    {
        @"test_date": [[NSDate alloc] init]
    };

    NSError* error = nil;
    TestObject* testObject = [DDSerializer objectFromDictionary:testDictionary
                                                    withMapping:serializationMapping
                                                          error:&error];

    NSError* underlyingError = error.userInfo[NSUnderlyingErrorKey];

    XCTAssertNotNil(error);
    XCTAssertNotNil(underlyingError);
    XCTAssertEqual(error.code, DDSerializerErrorCodeDeserializationError);
    XCTAssertEqual(underlyingError.code, DDKeyFieldMappingErrorCodeValueCouldNotConvert);
}

- (void)testHasOneMapping
{
    DDSerializationMapping* testObjectMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping mapKey:@"test_string" toField:@"testString" class:[NSString class] required:YES strict:YES];
        }];

    DDSerializationMapping* serializationMapping =
        [DDSerializationMapping mappingWithClass:[TestObject class]
                           withConstructionBlock:^(DDSerializationMapping* mapping)
        {
            [mapping hasOneMapping:testObjectMapping
                            forKey:@"test_object"
                             field:@"testObject"
                          required:YES];
        }];

    NSDictionary* testDictionary = @
    {
        @"test_object": @
        {
            @"test_string": @"A Test String!"
        }
    };

    NSError* error = nil;
    TestObject* testObject = [DDSerializer objectFromDictionary:testDictionary
                                                    withMapping:serializationMapping
                                                          error:&error];

    NSError* underlyingError = error.userInfo[NSUnderlyingErrorKey];

    XCTAssertNotNil(testObject.testObject);
    XCTAssertEqualObjects(testObject.testObject.testString, @"A Test String!");
}

@end
