//
//  ACNApiClient+Endpoints.h
//  ACN
//
//  Created by jorge Sanmartin on 26/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "ACNApiClient.h"
#import "Common.h"

@interface ACNApiClient (Endpoints)
+(NSString *)getLogIn;
+(NSString *)getLogOut;
+(NSString *)getNoticiesById;
+(NSString *)getNoticies;
+(NSString *)getAlertByType;
+(NSString *)getcategories;
+(NSString *)getBaseUrl;

@end
