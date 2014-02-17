// DDBlockValueSerializer.m
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

#import "DDBlockValueMapping.h"


@implementation DDBlockValueMapping
{

}

- (instancetype)init
{
    NSAssert(false, @"Use 'initWithKey:field:mappingBlock:reverseMappingBlock:' instead!");
    return nil;
}

- (instancetype)initWithKey:(NSString*)key
                      field:(NSString*)field
               mappingBlock:(DDMappingBlock)mapBlock
        reverseMappingBlock:(DDMappingBlock)reverseMapBlock
{
    NSParameterAssert(key);
    NSParameterAssert(field);
    NSParameterAssert(mapBlock);
    NSParameterAssert(reverseMapBlock);

    self = [super init];

    if (self)
    {
        _key = key;
        _field = field;

        _mapBlock = mapBlock;
        _reverseMapBlock = reverseMapBlock;
    }

    return self;
}

- (void)mapFromDictionary:(NSDictionary*)dictionary
                 toObject:(id)object
                    error:(NSError**)error
{
    NSParameterAssert(object);
    NSParameterAssert(dictionary);
    NSParameterAssert(error);

    id value = dictionary[_key];
    id formattedValue = _mapBlock(value, error);

    if (error)
    {
        return;
    }

    [object setValue:formattedValue forKey:_field];
}

- (void)mapFromObject:(id)object
         toDictionary:(NSMutableDictionary*)dictionary
                error:(NSError**)error
{
    NSParameterAssert(object);
    NSParameterAssert(dictionary);
    NSParameterAssert(error);

    id value = [object valueForKey:_field];
    id formattedValue = _mapBlock(value, error);

    if (error)
    {
        return;
    }

    [dictionary setObject:formattedValue forKey:_key];
}


@end