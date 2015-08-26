//
//  PageNewView.h
//  ACN
//
//  Created by Flamingo Partners on 15/2/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIReusableView.h"

@protocol ScrollShowHideNavigationBarDelegate <NSObject>
@optional
- (void)scrollOffset:(CGFloat)offset scrollView:(UIScrollView *)scrollview;
@end

@interface PageNewView : UIView <UIReusableView>{
    IBOutlet UILabel *titleNew;
    IBOutlet UILabel *dateNew;
    IBOutlet UILabel *subtitleNew;
    IBOutlet UIView *separatorNew;
    IBOutlet UILabel *acnNew;
    IBOutlet UILabel *contentNew;
    IBOutlet UIScrollView *contentScrollNew;
    IBOutlet UIImageView *image;
}

@property(nonatomic, assign)id<ScrollShowHideNavigationBarDelegate>delegate;

+(PageNewView *)getNewView;
-(void)setDataSourse:(id)noticia;

@end
