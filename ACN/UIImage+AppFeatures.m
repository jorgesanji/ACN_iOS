//
//  UIImage+AppFeatures.m
//  ACN
//
//  Created by Flamingo Partners on 11/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "UIImage+AppFeatures.h"

@implementation UIImage (AppFeatures)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)resizeImage{    
    UIImage *scaledImage =
    [UIImage imageWithCGImage:[self CGImage]
                        scale:(self.scale * 2.0)
                  orientation:(self.imageOrientation)];
    
    scaledImage = [scaledImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    return scaledImage;
}

@end
