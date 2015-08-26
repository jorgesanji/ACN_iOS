//
//  UIReusableViewToday.m
//  ACN
//
//  Created by Flamingo Partners on 16/09/14.
//  Copyright (c) 2014 Mubiquo. All rights reserved.
//

#import "UIPageView.h"

@implementation UIPageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)prepareForReuse{
    NSLog(@"UIReusableView");
}

- (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (UIViewController *) parentViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

@end
