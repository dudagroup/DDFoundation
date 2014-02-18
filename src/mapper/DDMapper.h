// DDSerializer.h
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

@class DDObjectMapping;

/**
 * A simple but still powerful mapper/reverse mapper which, for example, can be used to
 * map data returned from a server to objects.
 */
@interface DDMapper : NSObject

extern NSString* const DDMapperErrorDomain;

typedef enum
{
    DDMapperErrorCodeInvalidDictionary = 1,
    DDMapperErrorCodeInvalidObject,
    DDMapperErrorCodeMappingError
} DDMapperErrorCode;

+ (id)objectFromDictionary:(NSDictionary*)dictionary
               withMapping:(DDObjectMapping*)objectMapping
                     error:(NSError**)error;

+ (NSDictionary*)dictionaryFromObject:(id)object
                          withMapping:(DDObjectMapping*)objectMapping
                                error:(NSError**)error;

@end