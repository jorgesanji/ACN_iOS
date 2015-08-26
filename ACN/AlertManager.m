//
//  AlertManager.m
//  ACN
//
//  Created by Flamingo Partners on 31/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "AlertManager.h"
#import "LocalizationHelper.h"
#import "Utils.h"

@implementation AlertManager

+(void)showAlertValidateLoginWithDelegate:(id)delegate{
    NSString *validation_code = [LocalizationHelper getValidationTitle];
    NSString *enter_code = [LocalizationHelper getValidationMessage];
    [self show:validation_code message:enter_code delegate:delegate];
}

+(void)showAlertMessageWithString:(NSString *)message{
    NSString *title_error = @" ";
    NSString *message_error = message;
    [self show:title_error message:message_error delegate:nil];
}


+(void)showAlertFailNetwork{
    NSString *title_error = [LocalizationHelper getNetworkTitleError];
    NSString *message_error = [LocalizationHelper getNetworkMessageError];
    [self show:title_error message:message_error delegate:nil];
}

+(void)showAlertErrorPhone{
    NSString *title_error = [LocalizationHelper getPhoneError];
    NSString *message_error = [LocalizationHelper getPhoneAvailableError];
    [self show:title_error message:message_error delegate:nil];
}

+(void)showAlertDataNoFound{
    NSString *title_error = @" ";
    NSString *message_error = [LocalizationHelper getDataNoFound];
    [self show:title_error message:message_error delegate:nil];
}

+(void)showAlertErrorCode{
    NSString *title_error = @" ";
    NSString *message_error = [LocalizationHelper getErrorCode];
    [self show:title_error message:message_error delegate:nil];
}

+(void)showNotificationAlert:(NSString *)message
                    delegate:(id<UIAlertViewDelegate>)delegate{
    
    NSString *title = [Utils isACN] ? @"ACN":@"CNA";
    NSString *ok = [LocalizationHelper getMostrarAlertas];
    NSString *cancel = [LocalizationHelper getCancel];
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles: ok,nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}

+(void)show:(NSString *)title
    message:(NSString *)mesage
   delegate:(id<UIAlertViewDelegate>)delegate{
    
    NSString *ok = nil;
    NSString *cancel = nil;
    UIAlertViewStyle style;
    if (delegate) {
        cancel = [LocalizationHelper getCancel];
        ok = [LocalizationHelper getValidate];
        style = UIAlertViewStylePlainTextInput;
    }else{
        ok = [LocalizationHelper getOk];
        style = UIAlertViewStyleDefault;
    }
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:title message:mesage delegate:delegate cancelButtonTitle:cancel otherButtonTitles: ok,nil];
    alert.alertViewStyle = style;
    [alert show];
    if (style == UIAlertViewStylePlainTextInput) {
        [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
        [[alert textFieldAtIndex:0] becomeFirstResponder];
    }
}


@end
