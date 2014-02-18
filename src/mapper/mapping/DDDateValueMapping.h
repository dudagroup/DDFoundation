// DDDateValueMapper.h
//
// Created by Till Hagger on 17/02/14.

#import <Foundation/Foundation.h>
#import "DDMapping.h"


@interface DDDateValueMapping : NSObject <DDMapping>

extern NSString* const DDDateValueMappingErrorDomain;

typedef enum
{
    DDDateValueMappingErrorCodeNotAString,
    DDDateValueMappingErrorCodeCouldNotFormat
} DDDateValueMappingErrorCode;

@property (nonatomic, readonly) NSString* key;
@property (nonatomic, readonly) NSString* field;

@property (nonatomic, readonly) BOOL required;

@property (nonatomic, readonly) NSDateFormatter* dateFormatter;

- (instancetype)initWithKey:(NSString*)key
                      field:(NSString*)field
                   required:(BOOL)required
                 dateFormat:(NSString*)dateFormat
                   timeZone:(NSTimeZone*)timeZone;

@end