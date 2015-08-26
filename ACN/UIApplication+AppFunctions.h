//
//  UIApplication+AppFunctions.h
//  ACN
//
//  Created by Flamingo Partners on 22/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (AppFunctions)

-(void)resetBatge;
-(void)registerForUsingPushNotifications;
-(BOOL)isPushEnabled;
-(BOOL)isAvailableBackgroundMode;

@end
