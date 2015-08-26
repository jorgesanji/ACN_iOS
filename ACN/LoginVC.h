//
//  LoginVC.h
//  ACN
//
//  Created by Flamingo Partners on 6/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController{
    IBOutlet UITextField *telefono;
    IBOutlet UIButton *login;
    IBOutlet UIView *bottomLine;
    IBOutlet UIActivityIndicatorView *activ;
}

-(IBAction)sendPhoneNumber:(id)sender;

@end
