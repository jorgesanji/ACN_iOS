//
//  UIBarButtonItem+DefaultConfig.m
//  ACN
//
//  Created by jorge Sanmartin on 25/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "UIBarButtonItem+DefaultConfig.h"

@implementation UIBarButtonItem (DefaultConfig)

+(UIBarButtonItem *)buttonWithImage:(UIImage *)image tintColor: (UIColor *)tintcolor target:(id)target action:(SEL)selector{
    UIBarButtonItem *bt = [[UIBarButtonItem alloc] initWithImage:image  style:UIBarButtonItemStylePlain target:target action:selector];
    bt.tintColor = tintcolor;
    return bt;
}

@end
