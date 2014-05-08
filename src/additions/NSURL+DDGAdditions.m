// NSURL+DDGAdditions.m
//
// Created by Till Hagger on 23/04/14.

#import "NSURL+DDGAdditions.h"


@implementation NSURL (DDGAdditions)

- (id)queryParameters
{
    NSMutableDictionary* queryComponents = [NSMutableDictionary dictionary];
    NSArray* keyValueComponents = [self.query componentsSeparatedByString:@"&"];

    for (NSString* keyValueString in keyValueComponents)
    {
        NSArray* keyValueArray = [keyValueString componentsSeparatedByString:@"="];

        if ([keyValueArray count] < 2) continue;

        NSString* key = [keyValueArray[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* value = [keyValueArray[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        id results = [queryComponents objectForKey:key];

        if (results)
        {
            if ([results isKindOfClass:[NSMutableArray class]])
            {
                [(NSMutableArray*)results addObject:value];
            }
            else
            {
                NSMutableArray* values = [NSMutableArray arrayWithObjects:results, value, nil];
                [queryComponents setObject:values forKey:key];
            }
        }
        else
        {
            [queryComponents setObject:value forKey:key];
        }

        [results addObject:value];
    }

    return [queryComponents copy];
}

@end