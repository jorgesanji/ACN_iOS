//
//  UIApplication+AppFunctions.m
//  ACN
//
//  Created by Flamingo Partners on 22/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "UIApplication+AppFunctions.h"

@implementation UIApplication (AppFunctions)

-(void)resetBatge{
    [self setApplicationIconBadgeNumber:1];
    [self setApplicationIconBadgeNumber:0];
}

//#define GREATHER_THAN_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

-(void)registerForUsingPushNotifications{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    
    if ([self respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [self registerUserNotificationSettings:notificationSettings];
        [self registerForRemoteNotifications];
    } else {
        [self registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeAlert)];
    }
#else
    
    [self registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeAlert)];
    
#endif
    
}


-(BOOL)isPushEnabled{
    
#ifdef __IPHONE_8_0
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0){
        return [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
    }
#endif
    
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    return (types & UIRemoteNotificationTypeAlert);
}

-(BOOL)isAvailableBackgroundMode{
    
    return ([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusAvailable);
    
}

@end
