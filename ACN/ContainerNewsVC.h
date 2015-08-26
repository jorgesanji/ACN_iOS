//
//  ContainerNewsVC.h
//  ACN
//
//  Created by Flamingo Partners on 17/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIPaginator;
@interface ContainerNewsVC : UIViewController{
    IBOutlet UIView *loader;
    IBOutlet UILabel *loadText;
}

@property (nonatomic, strong) UIPaginator *paginator;

+(instancetype)getInstanceWithData:(NSMutableArray *)data atIndex:(NSInteger)index;

@end
