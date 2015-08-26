//
//  AppDelegate.h
//  ACN
//
//  Created by Flamingo Partners on 29/11/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SlideNavigationController;
@class MainVC;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SlideNavigationController *navigation;
@property (nonatomic) BOOL Recheable;

+(instancetype)sharedInstance;

-(BOOL)isRecheable;


@end

