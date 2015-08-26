//
//  AboutVC.m
//  ACN
//
//  Created by Flamingo Partners on 6/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "AboutVC.h"
#import "UIColor+CustomColorsApp.h"
#import "UIView+Frame.h"
#import "LocalizationHelper.h"

@interface AboutVC ()
@end

@implementation AboutVC

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.height = [UIScreen mainScreen].bounds.size.height;
    self.view.width = [UIScreen mainScreen].bounds.size.width;
    contentAbout.top = 10.0f;
    contentAbout.text = [LocalizationHelper getAbout];
    [contentAbout sizeToFit];
    CGFloat heightAbout = [contentAbout top] + [contentAbout height] + [self.navigationController navigationBar].height +  [UIApplication sharedApplication].statusBarFrame.size.height + 20;
    [contentAboutScroll setContentSize:CGSizeMake(contentAboutScroll.width, heightAbout)];
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientatio{
    return NO;
}

- (BOOL)shouldAutorotate{
    return NO;
}


@end
