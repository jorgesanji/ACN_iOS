//
//  AppDelegate+PushNotifications.h
//  ACN
//
//  Created by jorge Sanmartin on 25/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (PushNotifications)
-(void)LaunchIfExistDeephLinking:(NSDictionary *)userinfo;
@end
