//
//  UIBarButtonItem+DefaultConfig.h
//  ACN
//
//  Created by jorge Sanmartin on 25/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DefaultConfig)
+(UIBarButtonItem *)buttonWithImage:(UIImage *)image tintColor: (UIColor *)tintcolor target:(id)target action:(SEL)selector;
@end
