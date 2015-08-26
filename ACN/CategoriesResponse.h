//
//  CategoriesResponse.h
//  ACN
//
//  Created by Flamingo Partners on 15/2/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoriesResponse : NSObject

@property(nonatomic, copy) NSNumber * statusLogin;
@property(nonatomic, copy) NSString * statusMessage;
@property(nonatomic, copy) NSArray * seccions;

@end
