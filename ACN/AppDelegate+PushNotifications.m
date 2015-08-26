//
//  AppDelegate+PushNotifications.m
//  ACN
//
//  Created by jorge Sanmartin on 25/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "AppDelegate+PushNotifications.h"
#import "UIApplication+AppFunctions.h"
#import "MenuVC.h"
#import "SlideNavigationController.h"
#import "Utils.h"
#import "AlertManager.h"

@interface AppDelegate()<UIAlertViewDelegate>
@end

@implementation AppDelegate (PushNotifications)

#pragma mark - Delegate push notifications

#pragma mark - get Deephlinking
-(void)LaunchIfExistDeephLinking:(NSDictionary *)userinfo{
    if (userinfo) {
        [((MenuVC *)[self.navigation leftMenu]) LaunchAlerts];
    }
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

/**
 *  Get new token from APNS network
 *
 *  @param application current application launched
 *  @param deviceToken new token sended for APNS
 */

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken{
    
    //Save token data
    [Utils setToken:deviceToken];
}

/**
 *  If something was wrong in device register with APNS network
 *
 *  @param application application current application launched
 *  @param error message sended for APNS
 */

-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
    NSLog(@"Failed to get token, error: %@", error);
}

/**
 *  Get new data from background method
 *
 *  @param application       current application
 *  @param completionHandler block completition
 */

-(void)application:(UIApplication *)application
performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    completionHandler(UIBackgroundFetchResultNoData);
}


/**
 *  Get a message in active state
 *
 *  @param application       current application
 *  @param userInfo          get message from info dictionary
 */

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // The messages arrives to fetchCompletionHandler
}

/**
 *  Get a message in state background or active
 *
 *  @param application       current application
 *  @param userInfo          get message from info dictionary
 *  @param completionHandler block completition
 */

/*
 {
 aps =     {
 alert = hola;
 badge = 1;
 "content-available" = 1;
 };
 "id_categoria" = 1;
 "id_noticia" = 2;
 }
 */

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    
    NSDictionary *aps = userInfo;
    
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive)
    {
        NSLog(@"UIApplicationStateActive");
        
        [[UIApplication sharedApplication] resetBatge];
        
        NSString *message = [[aps objectForKey:@"aps"] objectForKey:@"alert"];
        
        [AlertManager showNotificationAlert:message delegate:self];
        
    }else if (state == UIApplicationStateBackground){
        
        NSLog(@"UIApplicationStateBackground");
        
        if ([[UIApplication sharedApplication] isAvailableBackgroundMode]) {
            //            [self handlerMessage:aps];
        }
        
    }else if (state == UIApplicationStateInactive){
        
        NSLog(@"UIApplicationStateInactive");
        [[UIApplication sharedApplication] resetBatge];
        [((MenuVC *)[self.navigation leftMenu]) LaunchAlerts];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [((MenuVC *)[self.navigation leftMenu]) LaunchAlerts];
    }
}


@end
