//
//  UIImage+AppFeatures.h
//  ACN
//
//  Created by Flamingo Partners on 11/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AppFeatures)

+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)resizeImage;

@end
