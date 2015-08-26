//
//  UIReusableViewToday.h
//  ACN
//
//  Created by Flamingo Partners on 16/09/14.
//  Copyright (c) 2014 Mubiquo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIReusableView.h"

@interface UIPageView : UIView <UIReusableView>

- (UIViewController *) parentViewController;

@end
