//
//  UIPaginator.h
//  ACN
//
//  Created by Flamingo Partners on 15/06/14.
//  Copyright (c) 2014 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollPaginationView.h"

@interface UIPaginator : UIView
@property (assign, nonatomic) UIEdgeInsets edgeInsets;
@property (strong, nonatomic) UIScrollPaginationView *pagingView;
@property (nonatomic, assign) NSUInteger selectedPageIndex;
@property (nonatomic, assign) BOOL ignoreInputsForSelection;

- (id)initWithFrame:(CGRect)theFrame insetsOfPageView:(UIEdgeInsets)theEdgeInsets;

- (void)setPagingViewDataSource:(id<UIScrollPaginationViewDataSource>)thePagingViewDataSource delegate:(id<UIScrollPaginationViewDelegate>)
thePagingViewDelegate;

- (void)setSelectedPageIndex:(NSUInteger)theSelectedPageIndex;
- (void)moveToPageWithIndex:(NSInteger)page animate:(BOOL)animate;
- (void)reloadPaginatorData;

- (void)HideOrShowContent;
@end
