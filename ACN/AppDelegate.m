//
//  AppDelegate.m
//  ACN
//
//  Created by Flamingo Partners on 29/11/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+PushNotifications.h"
#import "AppDelegate+Navigation.h"
#import "UIApplication+AppFunctions.h"

#import "CCReachability.h"
#import "SlideNavigationController.h"
#import "DatabaseManager.h"
#import "Reachability.h"
#import "Utils.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

@synthesize Recheable = _Recheable;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // init Reachability
    [CCReachability sharedManager];
    
    // Add push notifications permissions
    [[UIApplication sharedApplication] registerForUsingPushNotifications];
    [[UIApplication sharedApplication] resetBatge];
    
    //Add root ViewController
    self.navigation = [self getNavigation];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = _navigation;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if ([Utils isShowreelWatched]){
        [self getCategories:YES];
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self LaunchIfExistDeephLinking:userInfo];
    }
    
    return YES;
}

#pragma mark - Reachability

-(BOOL)isRecheable{
    _Recheable = [[CCReachability sharedManager] isRecheableFromCurrentStatus];
    return _Recheable;
}

/**
 *  Get appdelegate sharedInstance
 *
 *  @return AppDelegate
 */
+(instancetype)sharedInstance{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[DatabaseManager sharedInstance] saveCoreDataContext];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[DatabaseManager sharedInstance] saveCoreDataContext];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [[DatabaseManager sharedInstance] saveCoreDataContext];
}


@end
