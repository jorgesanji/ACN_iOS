//
//  NotificaitionsVC.m
//  ACN
//
//  Created by Flamingo Partners on 21/2/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "NotificationsVC.h"

#import "UIColor+CustomColorsApp.h"
#import "UIView+Frame.h"

#import "NewCell.h"
#import "Notifications.h"
#import "NoticiaACN.h"
#import "ACNApiClient.h"

#import "ContainerNewsVC.h"

#import "DatabaseManager.h"
#import "Utils.h"
#import "Reachability.h"
#import "LocalizationHelper.h"
#import "AlertManager.h"
#import "AppDelegate.h"
#import "Common.h"

@interface NotificationsVC ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic, strong)NSMutableArray *mData;
@property(nonatomic, strong)NSString *wordBySearch;
@property(nonatomic, strong)UIButton *holderKeyboardNotifications;
@end

@implementation NotificationsVC

@synthesize mData = _mData;
@synthesize wordBySearch = _wordBySearch;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [table setEditing:editing animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initUI];
    self.mData = [NSMutableArray arrayWithCapacity:0];
    [self getNotifications];
}

- (void)initUI{
    searchBar.tintColor = [UIColor getPrimaryColor];
    searchBar.barTintColor = [UIColor getLightGrayColor];
    [[self navigationController] navigationBar].barTintColor = [UIColor getLightGrayColor];
    CGFloat top = [[self navigationController] navigationBar].height;
    CGFloat bottom = [[UIScreen mainScreen] bounds].size.height;
    [self.view sizeToScreenBounds];
    CGFloat heightTable = bottom - top;
    table.height = heightTable + searchBar.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    table.width = [[UIScreen mainScreen] bounds].size.width;
    [activ centerInSuperView];
    [activ startAnimating];
    [activ setHidden:NO];
    [self.view bringSubviewToFront:activ];
    self.navigationController.navigationBar.tintColor = [UIColor getPrimaryColor];
}

- (void)addKeyboardDissmiser{
    NSInteger topHolderButton = (searchBar.height + [[self navigationController] navigationBar].height + [UIApplication sharedApplication].statusBarFrame.size.height);
    _holderKeyboardNotifications = [UIButton buttonWithType:UIButtonTypeCustom];
    [_holderKeyboardNotifications addTarget:self action:@selector(dissmiss:) forControlEvents:UIControlEventTouchUpInside];
    _holderKeyboardNotifications.height = [[UIScreen mainScreen] bounds].size.height - topHolderButton;
    _holderKeyboardNotifications.width = [[UIScreen mainScreen] bounds].size.width;
    _holderKeyboardNotifications.top = topHolderButton;
    [[self.navigationController view] addSubview:_holderKeyboardNotifications];
}

#pragma mark -  List notifications request

-(void)getNotifications{
    if ([[AppDelegate sharedInstance] isRecheable]) {
        [[ACNApiClient sharedInstance] getNotificationsWithcompletition:^(NSMutableArray *result) {
            [activ stopAnimating];
            [activ setHidden:YES];
            if (result) {
                [Utils saveLastDateUpdatedNotifications];
                for (NoticiaACN *nt in result) {
                    Notifications *notification = [[DatabaseManager sharedInstance] existNotificationWithIdNotification:[nt.id integerValue]];
                    if (!notification) {
                        notification = [[DatabaseManager sharedInstance] createNotification];
                        [notification setId_noticia:nt.id];
                        [notification setTitle:nt.title];
                        [notification setSubtitle:nt.subtitle];
                        [notification setCreation_date:nt.creation_date];
                        [notification setDescriptionFeed:nt.description];
                        [notification setType:nt.type];
                        [notification setImage:nt.image];
                        [notification setUrl:nt.url];
                        [notification setIsFavourite:[NSNumber numberWithBool:NO]];
                        [notification setDeleted:[NSNumber numberWithBool:NO]];
                    }
                }
                [[DatabaseManager sharedInstance] saveCoreDataContext];
                [self setDataSource];
            }else{
                [AlertManager showAlertFailNetwork];
                [self setDataSource];
            }
        }];
    }else{
        [activ stopAnimating];
        [activ setHidden:YES];
        if (![self setDataSource]) {
            [AlertManager showAlertFailNetwork];
        }
    }
}

-(BOOL)setDataSource{
    self.mData = [[DatabaseManager sharedInstance] getNotifications];
    if (_mData && [_mData count] > 0) {
        [table reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,1)] withRowAnimation:UITableViewRowAnimationBottom];
        return YES;
    }
    return NO;
}

#pragma mark -
#pragma mark UISearchBar delegate

- (void)searchBar:(UISearchBar *)searB
    textDidChange:(NSString *)searchText{
    _wordBySearch = searchText;
    if ([searchBar.text length] == 0) {
        [self setDataSource];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searb{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [self dissmiss:_holderKeyboardNotifications];
    [_mData removeAllObjects];
    self.mData = nil;
    self.mData = [[DatabaseManager sharedInstance] getNotificationsWithText:_wordBySearch];
    [table reloadData];
    if ([_mData count] == 0 && [_wordBySearch length] > 0) {
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
    [self dissmiss:_holderKeyboardNotifications];
}

#pragma mark - IBActions

-(IBAction)dissmiss:(UIButton *)sender{
    if (!sender) {
        return;
    }
    [sender removeFromSuperview];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    if (_mData && [_mData count] == 0 ) {
        [self setDataSource];
    }
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
    Notifications *notificacion = [_mData objectAtIndex:indexPath.row];
    cell.title = notificacion.title;
    cell.creationDate = notificacion.creation_date;
    cell.hideButtonFavourite = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [ContainerNewsVC getInstanceWithData:_mData atIndex:indexPath.row];
    vc.title = self.title;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Notifications *nt = [_mData objectAtIndex:indexPath.row];
        [nt setDeleted:[NSNumber numberWithBool:YES]];
        [[DatabaseManager sharedInstance] saveCoreDataContext];
        [_mData removeObjectAtIndex:indexPath.row];
        //add code here for when you hit delete
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Rotation

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientatio{
    return NO;
}

- (BOOL)shouldAutorotate{
    return NO;
}

@end
