//
//  MainVC.m
//  DimecCuba
//
//  Created by Flamingo Partners on 27/09/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "MainVC.h"

#import "UIBarButtonItem+DefaultConfig.h"
#import "UIImage+AppFeatures.h"
#import "UIColor+CustomColorsApp.h"
#import "AppDelegate+Navigation.h"
#import "UIView+Frame.h"

#import "NewCell.h"
#import "Noticia.h"
#import "NoticiaACN.h"
#import "Categorias.h"
#import "ACNApiClient.h"

#import "ContainerNewsVC.h"
#import "FavouriesVC.h"

#import "MNMBottomPullToRefreshManager.h"
#import "DatabaseManager.h"
#import "Utils.h"
#import "LocalizationHelper.h"
#import "AlertManager.h"
#import "Common.h"

@interface MainVC ()<UITableViewDataSource,UITableViewDelegate,MNMBottomPullToRefreshManagerClient,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic, strong)MNMBottomPullToRefreshManager *pullToRefreshManager;
@property(nonatomic, strong)Categorias *categoria;
@property(nonatomic, strong)NSMutableArray *mData;
@property(nonatomic, strong)NSString *wordBySearch;
@property(nonatomic, strong)UIButton *holderKeyboard;
@property(nonatomic) NSInteger mPage;
@property(nonatomic) BOOL isLaunchedfromEmptySearching;
@end

@implementation MainVC

@synthesize mData = _mData;
@synthesize categoria = _categoria;
@synthesize mPage = _mPage;
@synthesize pullToRefreshManager = _pullToRefreshManager;
@synthesize wordBySearch = _wordBySearch;
@synthesize isLaunchedfromEmptySearching = _isLaunchedfromEmptySearching;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNewsNotification:) name:reloadNewsNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openMenu:)
                                                 name:SlideNavigationControllerDidOpen
                                               object:nil];
    _mPage = 0;
    _isLaunchedfromEmptySearching =  NO;
    _wordBySearch = @"";
    [self initUI];
}


-(void)initUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGFloat hStatusBar = [UIApplication sharedApplication].statusBarFrame.size.height;
    searchBar.tintColor = [UIColor getPrimaryColor];
    searchBar.barTintColor = [UIColor getLightGrayColor];
    [[self navigationController] navigationBar].barTintColor = [UIColor getLightGrayColor];
    CGFloat top = [[self navigationController] navigationBar].height;
    CGFloat bottom = [[UIScreen mainScreen] bounds].size.height;
    self.view.height = bottom;
    self.view.width = [[UIScreen mainScreen] bounds].size.width;
    
    CGFloat heightTable = bottom - top;
    table.top = top + hStatusBar;
    table.height = heightTable;
    
    activ.left = self.view.width/2 - activ.width/2;
    activ.top = self.view.height/2 - activ.height/2;
    [activ setHidden:YES];
    [activ stopAnimating];
    
    self.pullToRefreshManager = [[MNMBottomPullToRefreshManager alloc] initWithPullToRefreshViewHeight:KHeightPullToRefreshView tableView:table withClient:self];
    
    if (_categoria)
        self.title = [_categoria name];
    else
        self.title = [LocalizationHelper getHomeName];
    
    UIBarButtonItem *languagebutton = [UIBarButtonItem buttonWithImage:[[UIImage imageNamed:([Utils isACN]) ? @"acn" : @"cna"] resizeImage] tintColor:nil  target:self action:@selector(changeLanguage:)];
    self.navigationItem.rightBarButtonItem = languagebutton;
}

-(void)openMenu:(id)nt{
    [self dissmiss:_holderKeyboard];
}

-(void)reloadNewsNotification:(id)nt{
    [table reloadData];
}

- (void)addKeyboardDissmiser{
    int topHolderButton = (searchBar.height + [[self navigationController] navigationBar].height + [UIApplication sharedApplication].statusBarFrame.size.height);
    _holderKeyboard = [UIButton buttonWithType:UIButtonTypeCustom];
    [_holderKeyboard addTarget:self action:@selector(dissmiss:) forControlEvents:UIControlEventTouchUpInside];
    _holderKeyboard.height = [[UIScreen mainScreen] bounds].size.height - topHolderButton;
    _holderKeyboard.width = [[UIScreen mainScreen] bounds].size.width;
    _holderKeyboard.top = topHolderButton;
    [[self.navigationController view] addSubview:_holderKeyboard];
}

-(void)getAllFromEmptySearching{
    if ([[AppDelegate sharedInstance] isRecheable]) {
        [self cleanData];
        [self getNewsByCategory:_categoria cadena:@""];
    }else{
        NSInteger idCategoria = (_categoria)?[_categoria.id_categoria intValue]:0;
        self.mData = [[DatabaseManager sharedInstance] getNewsWithIdCategory:idCategoria cadena:@""];
        [self reloadDataIndexNext:0];
        _isLaunchedfromEmptySearching = NO;
    }
}

#pragma mark - Load Data

-(void)cleanData{
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    _wordBySearch = @"";
    _mPage = 0;
    _categoria = nil;
    [_mData removeAllObjects];
    _mData = nil;
    [table reloadData];
    [activ setHidden:NO];
    [activ startAnimating];
}

-(void)getNewsByCategory:(Categorias*)categoria cadena:(NSString *)cadena{
    if (!self.categoria) {
        self.categoria = categoria;
    }
    self.title = [_categoria name];
    NSInteger idCategoria = [self.categoria.id_categoria intValue];
    if ([[AppDelegate sharedInstance] isRecheable]) {
        [_pullToRefreshManager setPullToRefreshViewVisible:YES];
        if (_mPage == 0) {
            [activ setHidden:NO];
            [activ startAnimating];
        }
        NSInteger startPage = _mPage * KMAXpage;
        NSInteger endPage = startPage + KMAXpage;
        [[ACNApiClient sharedInstance] getNewsWithIdCategory:_categoria pageStart:startPage pageEnd:endPage cadena:cadena completition:^(NSMutableArray *result) {
            if (result) {
                [_categoria setDate_updated:[NSDate date]];
                if ([result count] == 0 && [_wordBySearch length] > 0) {
                    [AlertManager showAlertDataNoFound];
                }else _mPage++;
                if (!_mData) {
                    self.mData = [NSMutableArray arrayWithCapacity:0];
                }
                NSInteger indexStart = [_mData count];
                for (NoticiaACN *nt in result) {
                    Noticia *noticia = [[DatabaseManager sharedInstance] isFavourite:[[nt id] integerValue] andIdCategory:idCategoria];
                    if (!noticia) {
                        noticia = [[DatabaseManager sharedInstance] createNoticia];
                        [noticia setId_noticia:nt.id];
                        [noticia setId_categoria:[NSNumber numberWithInteger:idCategoria]];
                        [noticia setTitle:nt.title];
                        [noticia setSubtitle:nt.subtitle];
                        [noticia setCategories:noticia.categories];
                        [noticia setCreation_date:nt.creation_date];
                        [noticia setDescriptionFeed:nt.description];
                        [noticia setType:nt.type];
                        [noticia setImage:nt.image];
                        [noticia setUrl:nt.url];
                        [noticia setIsFavourite:[NSNumber numberWithBool:NO]];
                        [noticia setIsACN:[NSNumber numberWithBool:[Utils isACN]]];
                    }
                    [_mData addObject:noticia];
                }
                [[DatabaseManager sharedInstance] saveCoreDataContext];
                [self reloadDataIndexNext:indexStart];
                _isLaunchedfromEmptySearching = NO;
            }else{
                [self reloadNoConnection:cadena];
            }
        }];
    }else{
        [self reloadNoConnection:cadena];
    }
}

-(void)reloadNoConnection:(NSString *)cadena{
    [activ setHidden:YES];
    [activ stopAnimating];
    NSInteger idCategoria = [self.categoria.id_categoria intValue];
    self.mData = [[DatabaseManager sharedInstance] getNewsWithIdCategory:idCategoria cadena:cadena];
    [_pullToRefreshManager setPullToRefreshViewVisible:NO];
    if (_mData && [_mData count] > 0) {
        [self reloadDataIndexNext:0];
    }else [AlertManager showAlertFailNetwork];
}

-(void)reloadDataIndexNext:(NSInteger)indexFinal{
    dispatch_async(dispatch_get_main_queue(), ^{
        [table reloadData];
        [activ setHidden:YES];
        [activ stopAnimating];
        [_pullToRefreshManager relocatePullToRefreshView];
        [_pullToRefreshManager tableViewReloadFinished];
        NSIndexPath *indexPath = nil;
        UITableViewScrollPosition position = UITableViewScrollPositionNone;
        if (_mPage == 1 && [_mData count] > 0) {
            [table reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)] withRowAnimation:UITableViewRowAnimationBottom];
        }else{
            if ([_mData count] == 0) {
                [_pullToRefreshManager setPullToRefreshViewVisible:NO];
            }else{
                
                if (indexFinal < [_mData count]) {
                    indexPath = [NSIndexPath indexPathForRow:indexFinal inSection:0];
                    position = UITableViewScrollPositionBottom;
                    if (indexFinal) {
                        [table scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:YES];
                    }
                }
            }
        }
    });
}

#pragma mark - IBAction

-(IBAction)changeLanguage:(UIButton *)sender{
    [searchBar setShowsCancelButton:NO animated:YES];
    [Utils swipeService];
    UIBarButtonItem *languagebutton = [UIBarButtonItem buttonWithImage:[[UIImage imageNamed:([Utils isACN]) ? @"acn" : @"cna"] resizeImage] tintColor:nil  target:self action:@selector(changeLanguage:)];
    self.navigationItem.rightBarButtonItem = languagebutton;
    if ([[AppDelegate sharedInstance] isRecheable]) {
        [[AppDelegate sharedInstance] getCategories:YES];
    }else{
        [[AppDelegate sharedInstance] reloadMenu];
    }
}


-(IBAction)dissmiss:(UIButton *)sender{
    if (!sender) {
        return;
    }
    [sender removeFromSuperview];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    if (_mData && [_mData count] == 0 ) {
        [self getAllFromEmptySearching];
    }
}

#pragma mark - UITableView Delegate & Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KHeightRow;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_mData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"NewCell";
    NewCell *cell = (NewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    id noticia = [_mData objectAtIndex:indexPath.row];
    [cell setCellWithNoticia:noticia enabled:YES];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [ContainerNewsVC getInstanceWithData:_mData atIndex:indexPath.row];
    vc.title = self.title;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark MNMBottomPullToRefreshManagerClient

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pullToRefreshManager tableViewScrolled];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_pullToRefreshManager tableViewReleased];
}

- (void)bottomPullToRefreshTriggered:(MNMBottomPullToRefreshManager *)manager {
    [self getNewsByCategory:_categoria cadena:_wordBySearch];
}

#pragma mark - UISearchBar delegate

- (void)searchBar:(UISearchBar *)searB
    textDidChange:(NSString *)searchText{
    _wordBySearch = searchText;
    if ([searchBar.text length] == 0) {
        if (!_isLaunchedfromEmptySearching){
            _isLaunchedfromEmptySearching = YES;
            [self getAllFromEmptySearching];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searb{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self dissmiss:_holderKeyboard];
    [_mData removeAllObjects];
    self.mData = nil;
    self.mPage = 0;
    if ([[AppDelegate sharedInstance] isRecheable]) {
        [table reloadData];
        [activ setHidden:NO];
        [activ startAnimating];
        [self getNewsByCategory:_categoria cadena:_wordBySearch];
    }else{
        self.mData = [[DatabaseManager sharedInstance] getNewsWithText:_wordBySearch category:[[_categoria id_categoria] intValue]];
        [table reloadData];
        if ([_mData count] == 0 && [_wordBySearch length] > 0) {
            [AlertManager showAlertDataNoFound];
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)search{
    [searchBar setShowsCancelButton:YES animated:YES];
    searchBar.text = @"";
    [self addKeyboardDissmiser];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)search{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    searchBar.text = @"";
    _wordBySearch = @"";
    [self dissmiss:_holderKeyboard];
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    return YES;
}

- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
    return NO;
}

#pragma mark - Rotation

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    return NO;
}

@end
