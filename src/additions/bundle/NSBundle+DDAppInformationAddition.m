// NSBundle+DDAppInformationAddition.m
//
// Created by Till Hagger on 20/03/14.

#import "NSBundle+DDAppInformationAddition.h"


@implementation NSBundle (DDAppInformationAddition)

- (NSString*)appName
{
    [self objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

- (NSString*)appVersion
{
    [self objectForInfoDictionaryKey:@"CFBundleVersion"];
}

@end