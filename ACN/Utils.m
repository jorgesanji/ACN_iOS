//
//  Utils.m
//  ACN
//
//  Created by Flamingo Partners on 16/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "Utils.h"

#define KLoginKey @"LOGIN"
#define KAcnKEY @"ACN"
#define KTokenKEY @"TOKEN"
#define KStateLogin @"STATE_LOGIN"
#define KLocalCategories @"LOCAL_CATEGORIES"
#define KLastUpdateNotifications @"LAST_DATE_UPDATE_NOTFICATIONS"
#define KShowWathed @"SHOWREEL"


@implementation Utils


+(BOOL)isACN{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return ![defaults boolForKey:KAcnKEY];
}

+(void)swipeService{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL acn = [defaults boolForKey:KAcnKEY];
    [defaults setObject:[NSNumber numberWithBool:!acn] forKey:KAcnKEY];
    [defaults synchronize];
}

+(NSString *)getToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tk = [defaults stringForKey:KTokenKEY];
    return (tk)?tk:@"";
}

+(void)setToken:(NSData *)data{
    
    NSString *token = [data description];
	token = [token stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	token= [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"Token: %@",token);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:KTokenKEY];
    [defaults synchronize];
}

+(BOOL)isLogin{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:KLoginKey];
}

+(NSInteger)stateLogin{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:KStateLogin] intValue];

}

+(void)setStateLogin:(NSInteger)state{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInteger:state] forKey:KStateLogin];
    [defaults synchronize];
    
}

+(BOOL)readyLocalCategories{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:KLocalCategories];

}

+(void)LoadLocalCategories{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:KLocalCategories];
    [defaults synchronize];
    
}

+(void)UnLoadLocalCategories{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:KLocalCategories];
    [defaults synchronize];
    
}

+(void)saveLastDateUpdatedNotifications{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:KLastUpdateNotifications];
    [defaults synchronize];
    
}

+(NSDate *)getLastDateUpdatedNotifications{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSObject *date = [defaults objectForKey:KLastUpdateNotifications];
    if (!date) {
        date = [NSDate date];
    }
    
    return (NSDate *)date;
}


+(void)showReelReady{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:KShowWathed];
    [defaults synchronize];
}

+(BOOL)isShowreelWatched{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL shreel = [defaults boolForKey:KShowWathed];
    return shreel;
    
}


@end
