// DDKeyFieldMapping.m
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

#import "DDKeyFieldMapping.h"


@implementation DDKeyFieldMapping
{

}

NSString* const DDKeyFieldMappingErrorDomain = @"com.dudagroup.mapper.keyfield";

- (instancetype)init
{
    NSAssert(false, @"Use 'initWithKey:field:required:strict:'!");
    return nil;
}

- (instancetype)initWithKey:(NSString*)key
                      field:(NSString*)field
                      class:(Class)class
                   required:(BOOL)required
                     strict:(BOOL)strict
{
    NSParameterAssert(key);
    NSParameterAssert(field);
    NSParameterAssert(class);

    self = [super init];

    if (self)
    {
        _key = key;
        _field = field;
        _class = class;
        _required = required;
        _strict = strict;
    }

    return self;
}

- (void)mapFromDictionary:(NSDictionary*)dictionary toObject:(id)object error:(NSError**)error
{
    NSParameterAssert(dictionary);
    NSParameterAssert(object);
    NSParameterAssert(error);

    id value = dictionary[_key];

    if ([value isKindOfClass:[NSNull class]])
    {
        value = nil;
    }

    if (!value)
    {
        if (_required)
        {
            NSString* description =
            [NSString stringWithFormat:@"Value for key '%@' is nil but was set as required!", _key];

            NSDictionary* userInfo = @
            {
                NSLocalizedDescriptionKey: description
            };

            *error = [NSError errorWithDomain:DDKeyFieldMappingErrorDomain
                                         code:DDKeyFieldMappingErrorCodeValueIsRequired
                                     userInfo:userInfo];
        }
        else
        {
            [object setValue:nil forKey:_field];
        }

        return;
    }

    // If we're not in strict mode, we try to convert the value to the expected class.
    if (!_strict && ![value isKindOfClass:_class])
    {
        id convertedValue = nil;

        if (_class == [NSString class])
        {
            if ([value isKindOfClass:[NSNumber class]])
            {
                convertedValue = [value stringValue];
            }
        }
        else if (_class == [NSNumber class])
        {
            if ([value isKindOfClass:[NSString class]])
            {
                NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
                convertedValue = [formatter numberFromString:value];
            }
        }

        if (!convertedValue)
        {
            NSString* description =
                [NSString stringWithFormat:@"Could not convert value for key '%@' of type '%@' to expected type '%@'!",
                                           _key, [value class], _class];

            NSDictionary* userInfo = @
            {
                NSLocalizedDescriptionKey: description
            };

            *error = [NSError errorWithDomain:DDKeyFieldMappingErrorDomain
                                         code:DDKeyFieldMappingErrorCodeValueCouldNotConvert
                                     userInfo:userInfo];
            return;
        }

        value = convertedValue;
    }

    if (![value isKindOfClass:_class])
    {
        NSString* description =
            [NSString stringWithFormat:@"Value for key '%@' has wrong type '%@', expected '%@'!",
                _key, [value class], _class];

        NSDictionary* userInfo = @
        {
            NSLocalizedDescriptionKey: description
        };

        *error = [NSError errorWithDomain:DDKeyFieldMappingErrorDomain
                                     code:DDKeyFieldMappingErrorCodeValueHasWrongType
                                 userInfo:userInfo];
        return;
    }

    [object setValue:value forKey:_field];
}

- (void)mapFromObject:(id)object toDictionary:(NSMutableDictionary*)dictionary error:(NSError**)error
{
    id value = [object valueForKey:_field];

    if (!value)
    {
        if (_required)
        {
            NSString* description =
            [NSString stringWithFormat:@"Value for field '%@' is nil but was set as required!", _field];

            NSDictionary* userInfo = @
            {
                NSLocalizedDescriptionKey: description
            };

            *error = [NSError errorWithDomain:DDKeyFieldMappingErrorDomain
                                         code:DDKeyFieldMappingErrorCodeValueIsRequired
                                     userInfo:userInfo];
        }
        else
        {
            [dictionary setObject:[NSNull null] forKey:_key];
        }
    }
    else
    {
        [dictionary setObject:value forKey:_key];
    }
}

@end