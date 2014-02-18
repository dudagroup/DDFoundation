// DDDateValueMapper.m
//
// Created by Till Hagger on 17/02/14.

#import "DDDateValueMapping.h"


@implementation DDDateValueMapping
{

}

NSString* const DDDateValueMappingErrorDomain = @"com.dudagroup.mapper.datevalue";

- (instancetype)initWithKey:(NSString*)key
                      field:(NSString*)field
                   required:(BOOL)required
                 dateFormat:(NSString*)dateFormat
                   timeZone:(NSTimeZone*)timeZone;
{
    NSParameterAssert(key);
    NSParameterAssert(field);
    NSParameterAssert(dateFormat);
    NSParameterAssert(timeZone);

    self = [super init];

    if (self)
    {
        _key = key;
        _field = field;
        _required = required;

        _dateFormatter = [[NSDateFormatter alloc] init];

        _dateFormatter.dateFormat = dateFormat;
        _dateFormatter.timeZone = timeZone;
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

    id dateString = dictionary[_key];

    if ([dateString isKindOfClass:[NSString class]])
    {
        NSDate* date = [_dateFormatter dateFromString:dateString];

        if (date)
        {
            [object setValue:date forKey:_field];
        }
        else
        {
            NSString* description =
                [NSString stringWithFormat:@"Could not format string '%@' for key '%@' to date with format '%@'",
                                           dateString, _key, _dateFormatter.dateFormat];

            NSDictionary* userInfo = @
            {
                NSLocalizedDescriptionKey: description
            };

            *error = [NSError errorWithDomain:DDDateValueMappingErrorDomain
                                         code:DDDateValueMappingErrorCodeCouldNotFormat
                                     userInfo:userInfo];
        }
    }
    else
    {
        NSString* description =
            [NSString stringWithFormat:@"Value for key '%@' is not of type '%@', received '%@' instead!",
                                       _key, [NSString class], [dateString class]];

        NSDictionary* userInfo = @
        {
            NSLocalizedDescriptionKey: description
        };

        *error = [NSError errorWithDomain:DDDateValueMappingErrorDomain
                                     code:DDDateValueMappingErrorCodeNotAString
                                 userInfo:userInfo];
    }
}

- (void)mapFromObject:(id)object
         toDictionary:(NSMutableDictionary*)dictionary
                error:(NSError**)error
{
    NSParameterAssert(object);
    NSParameterAssert(dictionary);
    NSParameterAssert(error);

    NSDate* date = [object valueForKey:_field];

    if ([date isKindOfClass:[NSString class]])
    {
        NSString* dateString = [_dateFormatter stringFromDate:date];
        [dictionary setObject:dateString forKey:_key];
    }
}


@end