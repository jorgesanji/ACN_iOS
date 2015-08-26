//
//  AlertManager.h
//  ACN
//
//  Created by Flamingo Partners on 31/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface AlertManager : NSObject

+(void)showAlertValidateLoginWithDelegate:(id)delegate;
+(void)showAlertFailNetwork;
+(void)showAlertErrorPhone;
+(void)showAlertDataNoFound;
+(void)showAlertMessageWithString:(NSString *)message;
+(void)showAlertErrorCode;
+(void)showNotificationAlert:(NSString *)message
                    delegate:(id<UIAlertViewDelegate>)delegate;



@end
