//
//  ShowReelResourcesUtils.h
//  ACN
//
//  Created by jorge Sanmartin on 22/4/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Image1,
    Image2,
    Image3,
    Image4
} ShowReelImage;

@interface ShowReelResourcesUtils : NSObject

+(NSMutableArray *)getImages;

@end
