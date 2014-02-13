// DDSerializationMapping.h
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

#import <Foundation/Foundation.h>

@protocol DDValueSerializer;


@interface DDSerializationMapping : NSObject

typedef void (^DDSerializationMappingConstructionBlock)(DDSerializationMapping* mapping);
typedef void (^DDSerializationMappingFormatBlock)(NSString* mapping);

///=================================================================================================
/// @name Create Mapping
///=================================================================================================

+ (instancetype)mappingWithClass:(Class)class
           withConstructionBlock:(DDSerializationMappingConstructionBlock)constructionBlock;

- (instancetype)initWithClass:(Class)class;

@property (nonatomic, readonly) Class objectClass;
@property (nonatomic, readonly) NSArray* mappings;

///=================================================================================================
/// @name Map Properties
///=================================================================================================

- (void)mapKey:(NSString*)key toField:(NSString*)field class:(Class)class required:(BOOL)required strict:(BOOL)strict;
- (void)mapKey:(NSString*)key toField:(NSString*)field class:(Class)class withSerializer:(id<DDValueSerializer>)serializer;

- (void)hasOneMapping:(DDSerializationMapping*)mapping forKey:(NSString*)key field:(NSString*)field required:(BOOL)required;
- (void)hasManyMapping:(DDSerializationMapping*)mapping forKey:(NSString*)key field:(NSString*)field required:(BOOL)required;

@end