//
//  ContainerNewsVC.m
//  ACN
//
//  Created by Flamingo Partners on 17/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "ContainerNewsVC.h"
#import "UIPaginator.h"
#import "UIView+Frame.h"
#import "PageNewView.h"
#import "UIColor+CustomColorsApp.h"
#import "LocalizationHelper.h"

@interface ContainerNewsVC ()<UIScrollPaginationViewDataSource, UIScrollPaginationViewDelegate, ScrollShowHideNavigationBarDelegate>

@property(nonatomic ,strong)NSMutableArray *mData;
@property(nonatomic ,strong)NSMutableArray *mPages;
@property(nonatomic)NSInteger mPage;
@property(nonatomic)NSInteger mIndexPage;
@property(nonatomic, strong)UIScrollView *scrollview;
@property(nonatomic)CGFloat lastOffset;

@end

@implementation ContainerNewsVC

@synthesize paginator = _paginator;
@synthesize mData = _mData;
@synthesize mPages = _mPages;
@synthesize mPage = _mPage;
@synthesize mIndexPage = _mIndexPage;
@synthesize scrollview = _scrollview;
@synthesize lastOffset = _lastOffset;

+(instancetype)getInstanceWithData:(NSMutableArray *)data atIndex:(NSInteger)index{
    ContainerNewsVC *container = [[ContainerNewsVC alloc] init];
    container.mData = data;
    container.mIndexPage = index;
    
    return container;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
}

-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.width = [UIScreen mainScreen].bounds.size.width;
    self.view.height = [UIScreen mainScreen].bounds.size.height;
    CGFloat topPosition = [self.navigationController navigationBar].frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect frame = CGRectMake(0.0f, topPosition,self.view.width,self.view.height);
    self.paginator = [[UIPaginator alloc] initWithFrame:frame insetsOfPageView:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    _paginator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_paginator setPagingViewDataSource:self delegate:self];
    [_paginator setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_paginator];
    [self.view bringSubviewToFront:_paginator];
    [_paginator moveToPageWithIndex:_mIndexPage animate:NO];
}

#pragma mark - PagingViewDelegate methods

- (NSInteger)numberOfItemsInPagingView:(UIScrollPaginationView *)thePagingView {
    return [_mData count];
}

- (id)pagingView:(UIScrollPaginationView *)thePagingView reusableViewForPageIndex:(NSUInteger)thePageIndex {
    static NSString *PageNewViewIdentifier = @"PageNewView";
    PageNewView *view = (PageNewView *)[thePagingView dequeueReusableViewWithIdentifier:PageNewViewIdentifier];
    NSObject *data =[_mData objectAtIndex:thePageIndex];
    if (!view) {
        view = [PageNewView getNewView];
        view.delegate = self;
    }
    [view setDataSourse:data];
    return view;
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollPaginationView *)scrollView{
    [self showNavigationBar];
}

-(void)scrollOffset:(CGFloat)offset scrollView:(UIScrollView *)scrollview{
    BOOL down = (_lastOffset > offset);
    _lastOffset = offset;
    _scrollview = scrollview;
    CGFloat height = [[self navigationController] navigationBar].height;
    CGFloat heightSb = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat top = [[self navigationController] navigationBar].top;
    
    if (offset >= height && top > 0 && !down) {
        [UIView animateWithDuration:0.5f animations:^{
            [[self navigationController] navigationBar].top -= (height + heightSb);
            _scrollview.top -= height;
        }];
    }else if (down && top == -height){
        [UIView animateWithDuration:0.5f animations:^{
            [[self navigationController] navigationBar].top += (height + heightSb);
            _scrollview.top += height;
        }];
    }
}

-(void)showNavigationBar{
    CGFloat height = [[self navigationController] navigationBar].height;
    CGFloat heightSb = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGFloat top = [[self navigationController] navigationBar].top;
    if(top == -height){
        [UIView animateWithDuration:0.5f animations:^{
            [[self navigationController] navigationBar].top += (height + heightSb);
            _scrollview.top += height;
        } completion:^(BOOL finished) {
            [_scrollview setContentOffset:CGPointMake(_scrollview.contentOffset.x, 0)
                                 animated:NO];
        }];
    }
}


- (NSUInteger)pagingViewSelectedPageIndex:(UIScrollPaginationView *)thePagingView{
    return _mPage;
}

#pragma mark - Rotation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return NO;
}

- (BOOL)shouldAutorotate{
    return NO;
}

@end
