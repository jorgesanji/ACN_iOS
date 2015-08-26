//
//  Utils.h
//  ACN
//
//  Created by Flamingo Partners on 16/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+(BOOL)isACN;
+(void)swipeService;
+(NSString *)getToken;
+(void)setToken:(NSData *)data;
+(BOOL)isLogin;
+(NSInteger)stateLogin;
+(void)setStateLogin:(NSInteger)state;
+(BOOL)readyLocalCategories;
+(void)LoadLocalCategories;
+(void)UnLoadLocalCategories;
+(void)saveLastDateUpdatedNotifications;
+(NSDate *)getLastDateUpdatedNotifications;
+(void)showReelReady;
+(BOOL)isShowreelWatched;

@end
