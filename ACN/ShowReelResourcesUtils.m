//
//  ShowReelResourcesUtils.m
//  ACN
//
//  Created by jorge Sanmartin on 22/4/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "ShowReelResourcesUtils.h"
#import <UIKit/UIKit.h>

#define background4 @"background0%i.jpg"
#define background5 @"background0%i-568h@2x.jpg"
#define background6 @"background0%i-667h@2x.jpg"
#define background6p @"background%i-736h@2x.jpg"

@implementation ShowReelResourcesUtils

+(NSMutableArray *)getImages{
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSString *name = [self image];
    
    for (NSInteger i = 1; i <= 4; i++) {
        NSString *nameImage = [NSString stringWithFormat:name,i];
        UIImage *image = [UIImage imageNamed:nameImage];
        [array addObject:image];
    }
    
    return array;
}

+(NSString *)image{
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    BOOL iphone4 = (screenHeight == 480.0f);
    BOOL iphone5 = (scale = 2.0f && screenHeight == 568.0f);
    BOOL iphone6 = (scale = 2.0f && screenHeight == 667.0f);
    BOOL iphone6p = (scale = 3.0f && screenHeight == 736.0f);
    
    if (iphone4) {
        return background4;
    }else if(iphone5){
        return background5;
    }else if(iphone6){
        return background6;
    }else if(iphone6p){
        return background6p;
    }else{
        return background6p;
    }
}

@end
