//
//  FavouriesVC.m
//  ACN
//
//  Created by Flamingo Partners on 6/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "FavouriesVC.h"
#import "NewCell.h"
#import "Noticia.h"
#import "DatabaseManager.h"
#import "ContainerNewsVC.h"
#import "LocalizationHelper.h"
#import "UIColor+CustomColorsApp.h"
#import "UIView+Frame.h"
#import "AlertManager.h"
#import "Common.h"

@interface FavouriesVC ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>
@property(nonatomic, strong)NSMutableArray *mData;
@property(nonatomic, strong)NSString *wordToSearch;
@property(nonatomic, strong)UIButton *holderKeyboardFav;
@end

@implementation FavouriesVC

@synthesize mData = _mData;
@synthesize wordToSearch = _wordToSearch;

+(instancetype)getInstance{
    FavouriesVC *fav = [[FavouriesVC alloc] init];
    fav.mData = [[DatabaseManager sharedInstance] getFavourites];
    return fav;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    [self validateData];
}

- (void)initUI{
    self.view.height = [[UIScreen mainScreen] bounds].size.height;
    self.view.width = [[UIScreen mainScreen] bounds].size.width;
    noFavourites.textColor = [UIColor getPrimaryColor];
    noFavourites.text = [LocalizationHelper getNoFavouriteName];
    [noFavourites centerInSuperView];
    searchBar.tintColor = [UIColor getPrimaryColor];
    searchBar.barTintColor = [UIColor getLightGrayColor];
    [[self navigationController] navigationBar].barTintColor = [UIColor getLightGrayColor];
}

-(void)validateData{
    if (_mData && [_mData count] > 0) {
        [noFavourites setHidden:YES];
    }else{
        [noFavourites setHidden:NO];
        [table setHidden:YES];
    }
}

- (void)addKeyboardDissmiser{
    NSInteger topHolderButton = (searchBar.height + [[self navigationController] navigationBar].height + [UIApplication sharedApplication].statusBarFrame.size.height);
    _holderKeyboardFav = [UIButton buttonWithType:UIButtonTypeCustom];
    [_holderKeyboardFav addTarget:self action:@selector(dissmiss:) forControlEvents:UIControlEventTouchUpInside];
    _holderKeyboardFav.height = [[UIScreen mainScreen] bounds].size.height - topHolderButton;
    _holderKeyboardFav.width = [[UIScreen mainScreen] bounds].size.width;
    _holderKeyboardFav.top = topHolderButton;
    [[self.navigationController view] addSubview:_holderKeyboardFav];
}

#pragma mark - UITableView Delegate & Datasrouce

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
    Noticia * noticia = [_mData objectAtIndex:indexPath.row];
    [cell setCellWithNoticia:noticia enabled:NO];
    
    cell.clickFavourite = ^(UIButton * sender){
        
        [noticia setIsFavourite:[NSNumber numberWithBool:NO]];
        [[DatabaseManager sharedInstance] saveCoreDataContext];
        NSInteger index = [_mData indexOfObject:noticia];
        [table beginUpdates];
        [_mData removeObject:noticia];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];
        [table endUpdates];
        [self validateData];
        [[NSNotificationCenter defaultCenter] postNotificationName:reloadNewsNotification
                                                            object:nil];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [ContainerNewsVC getInstanceWithData:_mData atIndex:indexPath.row];
    vc.title = self.title;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchBar delegate

- (void)searchBar:(UISearchBar *)searB
    textDidChange:(NSString *)searchText{
    _wordToSearch = searchText;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searb{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self dissmiss:_holderKeyboardFav];
    self.mData = [[DatabaseManager sharedInstance] getNewsFavouritesWithText:_wordToSearch];
    [table reloadData];
    if ([_mData count] == 0) {
        [AlertManager showAlertDataNoFound];
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
    _wordToSearch = @"";
    [self dissmiss:_holderKeyboardFav];
}


#pragma mark - IBActions

-(IBAction)dissmiss:(UIButton *)sender{
    if (!sender) {
        return;
    }
    [sender removeFromSuperview];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    if (_mData && [_mData count] == 0) {
        self.mData = [[DatabaseManager sharedInstance] getFavourites];
        [table reloadData];
    }
}

#pragma mark - Rotation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return NO;
}

- (BOOL)shouldAutorotate{
    return NO;
}


@end
