//
//  ACNApiClient+Endpoints.m
//  ACN
//
//  Created by jorge Sanmartin on 26/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "ACNApiClient+Endpoints.h"
#import "Utils.h"

@implementation ACNApiClient (Endpoints)

+(NSString *)getLogIn{
    return ENDPOINT_LOGIN;
}

+(NSString *)getLogOut{
    return ENDPOINT_LOGOUT;
}

+(NSString *)getNoticiesById{
    return [Utils isACN] ? ENDPOINT_GETFEEDBYID_ACN:ENDPOINT_GETFEEDBYID_CNA;
}

+(NSString *)getNoticies{
    return [Utils isACN] ? ENDPOINT_NOTICIAS_ACN:ENDPOINT_NOTICIAS_CNA;
}

+(NSString *)getAlertByType{
    return ENDPOINT_GET_ALERT_BY_TYPE;
}

+(NSString *)getcategories{
    return [Utils isACN] ? ENDPOINT_CATEGORIAS_ACN:ENDPOINT_CATEGORIAS_CNA;
}

+(NSString *)getBaseUrl{
    return BASE_URL_ACN;
}

@end
