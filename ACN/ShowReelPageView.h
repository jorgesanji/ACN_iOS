//
//  ShowReelPageView.h
//  ACN
//
//  Created by jorge Sanmartin on 21/4/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIReusableView.h"


@interface ShowReelPageView : UIView <UIReusableView>{
    IBOutlet UIImageView *mImage;
    IBOutlet UIButton *mStarter;
}

+(ShowReelPageView *)getShowReelPageView;
-(void)image:(UIImage *)image showStartButton:(BOOL)show selector:(SEL)selector dellegate:(id)delegate;
@end
