//
//  ShowReelPageView.m
//  ACN
//
//  Created by jorge Sanmartin on 21/4/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "ShowReelPageView.h"
#import "UIView+Frame.h"
#import "LocalizationHelper.h"
#import "UIColor+CustomColorsApp.h"

@implementation ShowReelPageView

/*
 Get an instance of an ExampleCustomView, which will be loaded from a Nib file
 */
+(ShowReelPageView *)getShowReelPageView{
    
    ShowReelPageView *view;
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSArray *nib = [bundle loadNibNamed:@"ShowReelPageView" owner:self options:nil];
    for (id item in nib)
    {
        if ([item isKindOfClass:[ShowReelPageView class]])
        {
            view = (ShowReelPageView *)item;
            break;
        }
    }
    return view;
}

- (void) initialize {
    CGRect frame = [UIScreen mainScreen].bounds;
    self.width = frame.size.width;
    self.height = frame.size.height;
}

-(void)image:(UIImage *)image showStartButton:(BOOL)show selector:(SEL)selector dellegate:(id)delegate{
    
    [mImage setImage:image];
    [mStarter setHidden:!show];
    if (show) {
        [mStarter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [mStarter setTitle:[LocalizationHelper getStart] forState:UIControlStateNormal];
        [mStarter addTarget:delegate action:selector forControlEvents:UIControlEventTouchUpInside];
        [mStarter setBackgroundColor:[UIColor getPrimaryColor]];
        [mStarter.layer setCornerRadius:4.0f];
        mStarter.top = [UIScreen mainScreen].bounds.size.height - (mStarter.height + 20.0f);
    }
}

- (void)prepareForReuse{
    NSLog(@"UIReusableView");
}

- (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}


@end
