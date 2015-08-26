//
//  CCProgressView.h
//  ACN
//
//  Created by jorge Sanmartin on 15/08/14.
//  Copyright (c) 2014 JP Simard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCProgressView : UIView

@property (nonatomic, assign) float progress;
@property (nonatomic, strong) UIColor *progressTintColor;
@property (nonatomic, strong) UIColor *backgroundTintColor;

+(instancetype)getProgressView;
-(void)updateprogress:(CGFloat)prg;

@end
