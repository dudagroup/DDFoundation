// DDHasManyMapping.m
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

#import "DDHasManyMapping.h"
#import "DDSerializationMapping.h"
#import "DDSerializer.h"


@implementation DDHasManyMapping
{

}

NSString* const DDHasManyMappingErrorDomain = @"com.dudagroup.serialization.hasmany";

- (instancetype)initWithKey:(NSString*)key
                      field:(NSString*)field
       serializationMapping:(DDSerializationMapping*)serializationMapping
                   required:(BOOL)required
{
    NSParameterAssert(key);
    NSParameterAssert(field);
    NSParameterAssert(serializationMapping);

    self = [super init];

    if (self)
    {
        _key = key;
        _field = field;

        _required = required;
        _serializationMapping = serializationMapping;
    }

    return self;
}

- (void)mapFromDictionary:(NSDictionary*)dictionary toObject:(id)object error:(NSError**)error
{
    NSArray* array = dictionary[_key];

    if (![array isKindOfClass:[NSArray class]])
    {
         NSString* description =
            [NSString stringWithFormat:@"Value for key '%@' is no an array! ", _key];

        NSDictionary* userInfo = @
        {
            NSLocalizedDescriptionKey: description
        };

        *error = [NSError errorWithDomain:DDHasManyMappingErrorDomain
                                     code:DDHasManyMappingErrorCodeNotAnArray
                                 userInfo:userInfo];

        return;
    }

    NSMutableArray* objects = [[NSMutableArray alloc] init];

    for (NSUInteger i = 0; i < [array count]; i++)
    {
        NSDictionary* objectDictionary = array[i];
        NSError* underlyingError = nil;

        id deserializedObject = [DDSerializer objectFromDictionary:objectDictionary
                                                       withMapping:_serializationMapping
                                                             error:&underlyingError];

        if (underlyingError)
        {
            NSString* description =
                [NSString stringWithFormat:@"Failed to deserialize object of type '%@' for key '%@' at index %ul! "
                                            "Look at the underlying error (NSUnderlyingErrorKey) for more information.",
                                            _serializationMapping.objectClass, _key, i];

            NSDictionary* userInfo = @
            {
                NSLocalizedDescriptionKey: description,
                NSUnderlyingErrorKey: underlyingError
            };

            *error = [NSError errorWithDomain:DDHasManyMappingErrorDomain
                                         code:DDHasManyMappingErrorCodeCouldNotDeserialize
                                     userInfo:userInfo];

            return;
        }

        [objects addObject:deserializedObject];
    }

    [object setValue:objects forKey:_field];
}

- (void)mapFromObject:(id)object toDictionary:(NSDictionary*)dictionary error:(NSError**)error
{

}


@end