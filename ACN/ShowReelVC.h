//
//  ShowReelVC.h
//  ACN
//
//  Created by jorge Sanmartin on 21/4/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIPaginator;
@interface ShowReelVC : UIViewController

@property (nonatomic, strong) UIPaginator *paginator;

+(instancetype)getInstance;

@end
