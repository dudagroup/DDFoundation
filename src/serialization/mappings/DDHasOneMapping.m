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
#import "DDSerializationMapping.h"
#import "DDSerializer.h"


@implementation DDHasOneMapping
{

}

NSString* const DDHasOneMappingErrorDomain = @"com.dudagroup.serialization.hasone";

- (instancetype)init
{
    NSAssert(false, @"Use 'initWithKey:field:serializationMapping:'!");
    return nil;
}

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
    NSParameterAssert(dictionary);
    NSParameterAssert(object);
    NSParameterAssert(error);

    NSError* underlyingError = nil;

    NSDictionary* dataDictionary = dictionary[_key];
    id deserializedObject = [DDSerializer objectFromDictionary:dataDictionary
                                                   withMapping:_serializationMapping
                                                         error:&underlyingError];

    if (underlyingError)
    {
        NSString* description =
            [NSString stringWithFormat:@"Failed to deserialize object of type '%@' for key '%@'! "
                                        "Look at the underlying error (NSUnderlyingErrorKey) for more information.",
                                        _serializationMapping.objectClass, _key];

        NSDictionary* userInfo = @
        {
            NSLocalizedDescriptionKey: description,
            NSUnderlyingErrorKey: underlyingError
        };

        *error = [NSError errorWithDomain:DDHasOneMappingErrorDomain
                                     code:DDHasOneMappingErrorCodeCouldNotDeserialize
                                 userInfo:userInfo];

        return;
    }

    [object setValue:deserializedObject forKey:_field];
}

- (void)mapFromObject:(id)object toDictionary:(NSDictionary*)dictionary error:(NSError**)error
{

}


@end