//
//  Common.h
//  ACN
//
//  Created by Flamingo Partners on 19/2/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

typedef enum {
    LOGIN = 0,
    VALIDATE_CODE = 1,
    LOGOUT = 2
} LoginState;

#define KMAXpage 20
#define KTimeOutDefault 60
#define KHeightRow 80
#define KHeightPullToRefreshView 60.0f

#define HelveticaNeueBold @"HelveticaNeue-Bold"

#define KFirstSection -1
#define KBeforeLastSection 999
#define KLastSection 1000
#define KIndexLogin -2
#define KIndexFavourites -1
#define KIndexAbout - 3
#define KIndexAlerts - 4

#define KTopValidaOrLogout 13
#define KDefaultPosition 16

//SECURITY
#define KNameIndentifier @"PHONE_KEY"

// WEB SERVICE
//#define BASE_URL_ACN @"http://88.87.203.208:7080"

#define BASE_URL_ACN @"http://mobile.acn.cat:7080"
#define ENDPOINT_CATEGORIAS_ACN @"/getCategoriesACN"
#define ENDPOINT_CATEGORIAS_CNA @"/getCategoriesCNA"
#define ENDPOINT_GETFEEDBYID_CNA @"/getFeedByIdCNA"
#define ENDPOINT_GETFEEDBYID_ACN @"/getFeedByIdACN"
#define ENDPOINT_GET_ALERT_BY_TYPE @"/getAlertByType"
#define ENDPOINT_NOTICIAS_ACN @"/getFeedACN"
#define ENDPOINT_NOTICIAS_CNA @"/getFeedCNA"
#define ENDPOINT_LOGIN @"/login"
#define ENDPOINT_LOGOUT @"/logout"

