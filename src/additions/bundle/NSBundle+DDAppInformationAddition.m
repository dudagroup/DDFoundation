// NSBundle+DDAppInformationAddition.m
//
// Created by Till Hagger on 20/03/14.

#import "NSBundle+DDAppInformationAddition.h"


@implementation NSBundle (DDAppInformationAddition)

- (NSString*)appName
{
    return [self objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

- (NSString*)appVersion
{
    return [self objectForInfoDictionaryKey:@"CFBundleVersion"];
}

@end