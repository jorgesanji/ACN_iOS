//
//  AppDelegate+Navigation.h
//  ACN
//
//  Created by jorge Sanmartin on 25/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Navigation)

-(MainVC *)getRootController;
-(SlideNavigationController *)getNavigation;
-(void)changeToMainController;
-(void)getCategories:(BOOL)reload;
-(void)buildMenu:(NSMutableArray *)result;
-(void)reloadMenu;

@end
