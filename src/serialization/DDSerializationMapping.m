// DDSerializationMapping.m
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

#import "DDSerializationMapping.h"
#import "DDValueSerializer.h"
#import "DDMapping.h"
#import "DDKeyFieldMapping.h"
#import "DDHasOneMapping.h"


@implementation DDSerializationMapping
{
    NSMutableArray* _mappings;
}

@synthesize mappings = _mappings;

+ (instancetype)mappingWithClass:(Class)class
           withConstructionBlock:(DDSerializationMappingConstructionBlock)constructionBlock
{
    NSParameterAssert(class);
    NSParameterAssert(constructionBlock);

    DDSerializationMapping* mapping = [[DDSerializationMapping alloc] initWithClass:class];
    constructionBlock(mapping);

    return mapping;
}

- (instancetype)init
{
    NSAssert(false, @"Use 'initWithClass:'!");
    return nil;
}

- (instancetype)initWithClass:(Class)class
{
    NSParameterAssert(class);

    self = [super init];

    if (self)
    {
        _objectClass = class;
        _mappings = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)mapKey:(NSString*)key toField:(NSString*)field class:(Class)class required:(BOOL)required strict:(BOOL)strict
{
    DDKeyFieldMapping* keyFieldMapping =
        [[DDKeyFieldMapping alloc] initWithKey:key
                                         field:field
                                         class:class
                                      required:required
                                        strict:strict];

    [self addMapping:keyFieldMapping];
}

- (void)mapKey:(NSString*)key toField:(NSString*)field class:(Class)class withSerializer:(id <DDValueSerializer>)serializer
{

}

- (void)hasOneMapping:(DDSerializationMapping*)mapping forKey:(NSString*)key field:(NSString*)field required:(BOOL)required
{
    DDHasOneMapping* hasOneMapping =
        [[DDHasOneMapping alloc] initWithKey:key
                                       field:field
                        serializationMapping:mapping
                                    required:required];

    [self addMapping:hasOneMapping];
}

- (void)hasManyMapping:(DDSerializationMapping*)mapping
                forKey:(NSString*)key
                 field:(NSString*)field
              required:(BOOL)required
{

}

- (void)addMapping:(id<DDMapping>)mapping
{
    [_mappings addObject:mapping];
}

@end