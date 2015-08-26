//
//  NSDateFormatter+FormatDefaultConfig.m
//  ACN
//
//  Created by jorge Sanmartin on 24/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "NSDateFormatter+FormatDefaultConfig.h"

static NSString *const formattDateMatch = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
static NSString *const timezoneMatch = @"UTC";
static NSString *const localeMatch = @"en_US_POSIX";
static NSString *const formattDateBackend = @"yyyy-MM-dd HH:mm";

@implementation NSDateFormatter (FormatDefaultConfig)

+ (instancetype)formattDateMatching{
    return [NSDateFormatter initWithFormatt:formattDateMatch timezone:[NSTimeZone timeZoneWithAbbreviation:timezoneMatch] locale:[[NSLocale alloc] initWithLocaleIdentifier:localeMatch]];
}

+(instancetype)formattToBackend{
    return [NSDateFormatter initWithFormatt:formattDateBackend timezone:[NSTimeZone defaultTimeZone] locale:nil];
}

+ (instancetype)initWithFormatt:(NSString *)formatt timezone:(NSTimeZone *)timezone locale:(NSLocale *)locale{
    
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:formatt];
    dateFormatter.locale = locale;
    dateFormatter.timeZone = timezone;
    
    return dateFormatter;
    
}

@end
