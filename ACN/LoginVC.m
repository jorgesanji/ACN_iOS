//
//  LoginVC.m
//  ACN
//
//  Created by Flamingo Partners on 6/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "LoginVC.h"
#import "UIColor+CustomColorsApp.h"
#import "AppDelegate+Navigation.h"
#import "ACNApiClient.h"
#import "Utils.h"
#import "NBPhoneNumberUtil.h"
#import "AlertManager.h"
#import "LocalizationHelper.h"
#import "UIView+Frame.h"
#import "CategoriesResponse.h"
#import "AppDelegate.h"
#import "KeychainItemWrapper.h"
#import "DatabaseManager.h"
#import "Common.h"


@interface LoginVC ()<UIAlertViewDelegate, UITextFieldDelegate>
@property(nonatomic, strong)KeychainItemWrapper *keychain;
@end

@implementation LoginVC

@synthesize keychain = _keychain;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.keychain = [[KeychainItemWrapper alloc] initWithIdentifier:KNameIndentifier accessGroup:nil];
    
    [self initUI];
    [self initFromState];
}

- (void)initUI{
    self.view.height = [[UIScreen mainScreen] bounds].size.height;
    self.view.width = [[UIScreen mainScreen] bounds].size.width;
    telefono.placeholder = [LocalizationHelper getPlaceholderName];
    bottomLine.backgroundColor = [UIColor getLightGrayColor];
    telefono.delegate = self;
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [login setBackgroundColor:[UIColor getPrimaryColor]];
    [login.layer setCornerRadius:4.0f];
    activ.hidden = YES;
    [self.view bringSubviewToFront:activ];
}

-(void)initFromState{
    NSString *title = @"";
    NSInteger  state = [Utils stateLogin];
    switch (state) {
        case VALIDATE_CODE:
            telefono.enabled = NO;
            telefono.hidden = YES;
            title = [LocalizationHelper getValidate];
            login.top = telefono.top - KTopValidaOrLogout;
            break;
        case LOGIN:
            telefono.enabled = YES;
            title = [LocalizationHelper getLoginButtonName];
            break;
        case LOGOUT:
            telefono.enabled = NO;
            telefono.hidden = YES;
            title = [LocalizationHelper getLogout];
            login.top = telefono.top - KTopValidaOrLogout;
            break;
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [login setTitle:title forState:UIControlStateNormal];
    });
    login.tag = state;
}

-(void)hideOrShow:(BOOL)hide title:(NSString *)title{
    CGFloat posy = bottomLine.top + bottomLine.height + KDefaultPosition;
    if (hide) {
        posy = telefono.top - KTopValidaOrLogout;
    }
    [UIView animateWithDuration:0.5f animations:^{
        login.top = posy;
        [login setTitle:title forState:UIControlStateNormal];
    }];
}

#pragma mark - Operations with database

-(void)removeAllDataSaved:(NSArray *)secciones{
    [[DatabaseManager sharedInstance]forceReset];
    [[AppDelegate sharedInstance] buildMenu:[secciones mutableCopy]];
    [[DatabaseManager sharedInstance] saveCoreDataContext];
}

#pragma mark - IBActions

-(IBAction)sendPhoneNumber:(id)sender{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case VALIDATE_CODE:
            telefono.enabled = NO;
            activ.color = [UIColor whiteColor];
            [AlertManager showAlertValidateLoginWithDelegate:self];
            break;
        case LOGIN:
            telefono.enabled = YES;
            activ.color = [UIColor getPrimaryColor];
            [self sendLogin];
            break;
        case LOGOUT:
            telefono.enabled = NO;
            activ.color = [UIColor whiteColor];
            [self sendLogout];
            break;
        default:
            break;
    }
}

#pragma mark - Requests to Backend

-(void)sendValidationCode:(NSString *)code{
    activ.color = [UIColor whiteColor];
    [activ setHidden:NO];
    login.enabled = NO;
    [activ startAnimating];
    NSString *token = [Utils getToken];
    NSString *phone = [_keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    [[ACNApiClient sharedInstance] validate:phone token:token  code:code completition:^(id result) {
        [activ setHidden:YES];
        [activ stopAnimating];
        login.enabled = YES;
        if (result) {
            CategoriesResponse *response = (CategoriesResponse *)result;
            [AlertManager showAlertMessageWithString:[response statusMessage]];
            if ([[response statusLogin] intValue] == 1) {
                [login setTitle:[LocalizationHelper getLogout] forState:UIControlStateNormal];
                [Utils setStateLogin:LOGOUT];
                login.tag = LOGOUT;
                self.title = [LocalizationHelper getLogout] ;
                [self removeAllDataSaved:[response seccions]];
            }
        }else{
            [AlertManager showAlertFailNetwork];
        }
    }];
    
}

-(void)sendLogout{
    login.enabled = NO;
    activ.hidden = NO;
    [activ startAnimating];
    NSString *token = [Utils getToken];
    NSString *phone = [_keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    [[ACNApiClient sharedInstance] makeLogout:phone token:token completition:^(id result) {
        [telefono resignFirstResponder];
        login.enabled = YES;
        activ.hidden = YES;
        [activ stopAnimating];
        if (result) {
            CategoriesResponse *response = (CategoriesResponse *)result;
            [AlertManager showAlertMessageWithString:[response statusMessage]];
            if ([[response statusLogin] intValue] == 3) {
                [self hideOrShow:NO title:[LocalizationHelper getLoginName]];
                login.tag = LOGIN;
                [Utils setStateLogin:LOGIN];
                telefono.enabled = YES;
                telefono.hidden = NO;
                activ.color = [UIColor getPrimaryColor];
                self.title = [LocalizationHelper getLoginName];
                [self removeAllDataSaved:[response seccions]];
            }
        }else{
            [AlertManager showAlertFailNetwork];
        }
        
    }];
}

-(void)sendLogin{
    NBPhoneNumberUtil *phoneUtil = [NBPhoneNumberUtil sharedInstance];
    NSError *aError = nil;
    NBPhoneNumber *aPhoneNumber = [phoneUtil parse:telefono.text defaultRegion:@"ES" error:&aError];
    NBEPhoneNumberType type = [phoneUtil getNumberType:aPhoneNumber];
    BOOL isValidType = (type == NBEPhoneNumberTypeMOBILE);
    BOOL isValidNumber = [phoneUtil isValidNumber:aPhoneNumber] && [phoneUtil isViablePhoneNumber:telefono.text];
    if (isValidNumber && isValidType) {
        login.enabled = NO;
        activ.hidden = NO;
        [activ startAnimating];
        [[ACNApiClient sharedInstance] makeLogin:telefono.text token:[Utils getToken] completition:^(id result) {
            [telefono resignFirstResponder];
            login.enabled = YES;
            activ.hidden = YES;
            [activ stopAnimating];
            [_keychain setObject:telefono.text forKey:(__bridge id)(kSecAttrAccount)];
            if (result) {
                telefono.enabled = NO;
                telefono.hidden = YES;
                CategoriesResponse *response = (CategoriesResponse *)result;
                [AlertManager showAlertMessageWithString:[response statusMessage]];
                NSInteger statusLogin = [[response statusLogin] intValue];
                NSString *titleSt = nil;
                activ.color = [UIColor whiteColor];
                if (statusLogin == 2) {
                    [Utils setStateLogin:VALIDATE_CODE];
                    login.tag = VALIDATE_CODE;
                    titleSt = [LocalizationHelper getValidate];
                }else if (statusLogin == 1) {
                    [Utils setStateLogin:LOGOUT];
                    login.tag = LOGOUT;
                    titleSt = [LocalizationHelper getLogout];
                    self.title = titleSt;
                    [self removeAllDataSaved:[response seccions]];
                }
                if (titleSt) {
                    [self hideOrShow:YES title:titleSt];
                }
            }else{
                telefono.enabled = YES;
                [AlertManager showAlertFailNetwork];
            }
        }];
    }else{
        [AlertManager showAlertErrorPhone];
    }
}


#pragma mark - UISearchViewDelegate

- (BOOL) textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)textEntered{
    if (range.length == 1) {
        return YES;
    }
    NSCharacterSet *numbers = [NSCharacterSet decimalDigitCharacterSet];
    return ([numbers characterIsMember:[textEntered characterAtIndex:0]] && (textField.text.length < 20));
    return YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //Login
        UITextField *code = [alertView textFieldAtIndex:0];
        [code resignFirstResponder];
        if ([code.text length] == 0) {
            [AlertManager showAlertErrorCode];
        }else [self sendValidationCode:code.text];
    }else{
        telefono.enabled = YES;
        [Utils setStateLogin:LOGIN];
        login.tag = LOGIN;
        [self hideOrShow:NO title:[LocalizationHelper getLoginName]];
    }
}

#pragma mark - Rotation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientatio{
    return NO;
}

- (BOOL)shouldAutorotate{
    return NO;
}

@end
