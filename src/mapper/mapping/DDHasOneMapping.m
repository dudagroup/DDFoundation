// DDHasOneMapping.m
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

#import "DDHasOneMapping.h"
#import "DDObjectMapping.h"
#import "DDMapper.h"


@implementation DDHasOneMapping
{

}

NSString* const DDHasOneMappingErrorDomain = @"com.dudagroup.mapper.hasone";

- (instancetype)init
{
    NSAssert(false, @"Use 'initWithKey:field:mapping:required:'!");
    return nil;
}

- (instancetype)initWithKey:(NSString*)key
                      field:(NSString*)field
                    mapping:(DDObjectMapping*)mapping
                   required:(BOOL)required
{
    NSParameterAssert(key);
    NSParameterAssert(field);
    NSParameterAssert(mapping);

    self = [super init];

    if (self)
    {
        _key = key;
        _field = field;

        _required = required;

        _objectMapping = mapping;
    }

    return self;
}

- (void)mapFromDictionary:(NSDictionary*)dictionary toObject:(id)object error:(NSError**)error
{
    NSParameterAssert(dictionary);
    NSParameterAssert(object);
    NSParameterAssert(error);

    NSError* underlyingError = nil;
    NSDictionary* dataDictionary = dictionary[_key];

    if ([dataDictionary isKindOfClass:[NSNull class]])
    {
        dataDictionary = nil;
    }

    if (!dataDictionary)
    {
        if (_required)
        {
            NSString* description =
                [NSString stringWithFormat:@"Value for key '%@' is nil but was set as required!", _key];

            NSDictionary* userInfo = @
            {
                NSLocalizedDescriptionKey: description
            };

            *error = [NSError errorWithDomain:DDHasOneMappingErrorDomain
                                         code:DDHasOneMappingErrorCodeValueIsRequired
                                     userInfo:userInfo];
        }
        else
        {
            [object setValue:nil forKey:_field];
        }

        return;
    }

    id deserializedObject = [DDMapper objectFromDictionary:dataDictionary
                                               withMapping:_objectMapping
                                                     error:&underlyingError];

    if (underlyingError)
    {
        NSString* description =
            [NSString stringWithFormat:@"Failed to map object of type '%@' for key '%@'! "
                                        "Look at the underlying error (NSUnderlyingErrorKey) for more information.",
                                        _objectMapping.objectClass, _key];

        NSDictionary* userInfo = @
        {
            NSLocalizedDescriptionKey: description,
            NSUnderlyingErrorKey: underlyingError
        };

        *error = [NSError errorWithDomain:DDHasOneMappingErrorDomain
                                     code:DDDHasOneMappingErrorCodeUnderlyingMappingError
                                 userInfo:userInfo];

        return;
    }

    [object setValue:deserializedObject forKey:_field];
}

- (void)mapFromObject:(id)object toDictionary:(NSMutableDictionary*)dictionary error:(NSError**)error
{
    NSParameterAssert(object);
    NSParameterAssert(dictionary);
    NSParameterAssert(error);

    NSError* underlyingError = nil;
    id value = [object valueForKey:_field];

    if (!value)
    {
        if (_required)
        {
            NSString* description =
                [NSString stringWithFormat:@"Value for property '%@' is nil but was set as required!", _key];

            NSDictionary* userInfo = @
            {
                NSLocalizedDescriptionKey: description
            };

            *error = [NSError errorWithDomain:DDHasOneMappingErrorDomain
                                         code:DDHasOneMappingErrorCodeValueIsRequired
                                     userInfo:userInfo];
        }
        else
        {
            [dictionary setObject:[NSNull null] forKey:_key];
        }
    }
    else
    {
        NSDictionary* objectDictionary = [DDMapper dictionaryFromObject:value
                                                      withMapping:_objectMapping
                                                            error:&underlyingError];

        if (underlyingError)
        {
            NSString* description =
                [NSString stringWithFormat:@"Failed to map object of type '%@' for property '%@'! "
                                            "Look at the underlying error (NSUnderlyingErrorKey) for more information.",
                                           _objectMapping.objectClass, _field];

            NSDictionary* userInfo = @
            {
                NSLocalizedDescriptionKey: description,
                NSUnderlyingErrorKey: underlyingError
            };

            *error = [NSError errorWithDomain:DDHasOneMappingErrorDomain
                                         code:DDDHasOneMappingErrorCodeUnderlyingMappingError
                                     userInfo:userInfo];

            return;
        }

        [dictionary setObject:objectDictionary forKey:_key];
    }
}


@end