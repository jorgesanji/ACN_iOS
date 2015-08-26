//
//  ACNApiClient+Mapping.h
//  ACN
//
//  Created by jorge Sanmartin on 26/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "ACNApiClient.h"
#import <RestKit/RestKit.h>

@interface ACNApiClient (Mapping)
+ (RKResponseDescriptor *)descriptorCategories;
+ (RKResponseDescriptor *)descriptorNoticia;
@end
