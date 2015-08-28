//
//  ShowReelVC.m
//  ACN
//
//  Created by jorge Sanmartin on 21/4/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "ShowReelVC.h"
#import "UIPaginator.h"
#import "UIView+Frame.h"
#import "ShowReelPageView.h"
#import "ShowReelResourcesUtils.h"
#import "AppDelegate+Navigation.h"

@interface ShowReelVC ()<UIScrollPaginationViewDataSource, UIScrollPaginationViewDelegate>
@property(nonatomic, strong)NSMutableArray * mData;
@property(nonatomic, strong)NSTimer *mTimer;
@end

@implementation ShowReelVC

@synthesize paginator = _paginator;
@synthesize mData = _mData;
@synthesize mTimer = _mTimer;

+(instancetype)getInstance{
    ShowReelVC *menu = [[ShowReelVC alloc] init];
    menu.mData = [ShowReelResourcesUtils getImages];
    return menu;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[[self navigationController] navigationBar] setHidden:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view sizeToScreenBounds];
    self.view.height += [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGRect frame = CGRectMake(0.0f, 0.0f,self.view.width,self.view.height);
    self.paginator = [[UIPaginator alloc] initWithFrame:frame insetsOfPageView:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    _paginator.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_paginator setPagingViewDataSource:self delegate:self];
    [_paginator setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_paginator];
    [self.view bringSubviewToFront:_paginator];
    [_paginator moveToPageWithIndex:0 animate:NO];
    [self launchTimer];
}

-(void)launchTimer{
    _mTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(moveToPage:) userInfo:nil repeats:YES];
}

-(void)moveToPage:(NSTimer *)timer{
    NSInteger page = [_paginator selectedPageIndex];
    page++;
    if (page == [_mData count]) {
        [self starter:nil];
    }else{
        [_paginator moveToPageWithIndex:page animate:YES];
    }
}

-(IBAction)starter:(UIButton *)sender{
    if (_mTimer) {
        if ([_mTimer isValid]) {
            [_mTimer invalidate];
        }
        self.mTimer = nil;
    }
    [[AppDelegate sharedInstance] changeToMainController];
}

#pragma mark - PagingViewDelegate methods

- (NSInteger)numberOfItemsInPagingView:(UIScrollPaginationView *)thePagingView {
    return [_mData count];
}

- (id)pagingView:(UIScrollPaginationView *)thePagingView reusableViewForPageIndex:(NSUInteger)thePageIndex {
    static NSString *ShowReelPageViewIdentifier = @"ShowReelPageView";
    ShowReelPageView *view = (ShowReelPageView *)[thePagingView dequeueReusableViewWithIdentifier:ShowReelPageViewIdentifier];
    if (!view) {
        view = [ShowReelPageView getShowReelPageView];
    }
    UIImage *image = [_mData objectAtIndex:thePageIndex];
    [view image:image showStartButton:(([_mData count] - 1) == thePageIndex) selector:@selector(starter:) dellegate:self];
    return view;
    
}

#pragma mark - UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollPaginationView *)scrollView{
    if (_mTimer) {
        if ([_mTimer isValid]) {
            [_mTimer invalidate];
        }
        self.mTimer = nil;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self launchTimer];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self launchTimer];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientatio{
    return NO;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
