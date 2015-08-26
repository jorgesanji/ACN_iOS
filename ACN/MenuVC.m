//
//  MenuVC.m
//  DimecCuba
//
//  Created by Flamingo Partners on 27/09/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "MenuVC.h"
#import "AboutVC.h"
#import "FavouriesVC.h"
#import "LoginVC.h"
#import "SlideNavigationController.h"
#import "MenuCell.h"
#import "MainVC.h"
#import "AppDelegate+Navigation.h"
#import "DatabaseManager.h"
#import "UIView+Frame.h"
#import "Noticia.h"
#import "Categorias.h"
#import "DatabaseManager.h"
#import "LocalizationHelper.h"
#import "Seccions.h"
#import "NotificationsVC.h"
#import "Common.h"
#import "UIColor+CustomColorsApp.h"
#import "ACNApiClient.h"

@interface MenuVC () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic ,strong)NSMutableArray *data;
@property(nonatomic ,strong)NSMutableArray *sections;
@property(nonatomic ,strong)NSIndexPath *lastindexpath;
@end

@implementation MenuVC

@synthesize sections = _sections;
@synthesize data = _data;
@synthesize lastindexpath = _lastindexpath;

+(instancetype)getInstance{
    MenuVC *menu = [[MenuVC alloc] init];
    return menu;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    table.backgroundColor = [UIColor clearColor];
    table.top = [UIApplication sharedApplication].statusBarFrame.size.height - 5.0;
    table.height += [UIApplication sharedApplication].statusBarFrame.size.height + 5.0;
    table.contentInset = UIEdgeInsetsMake(-30.0f,0.0,30.0,0.0);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openMenu:)
                                                 name:SlideNavigationControllerDidOpen
                                               object:nil];
    [self reloadMenu];
}


-(void)openMenu:(NSObject *)obj{
    if(_lastindexpath && [[AppDelegate sharedInstance] isRecheable]){
        if (_sections) {
            [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:_lastindexpath] withRowAnimation:UITableViewRowAnimationFade];
            
            [table selectRowAtIndexPath:_lastindexpath
                               animated:NO
                         scrollPosition:UITableViewScrollPositionNone];
        }
        _lastindexpath = nil;
    }
}

#pragma mark - UITableView Delegate & Datasrouce -

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.0f;
    }
    return 25.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.width, 25.0f)];
    [sectionView setBackgroundColor:[UIColor getLightGrayColor]];
    
    Seccions *sect = [_sections objectAtIndex:section];
    NSString *title = sect.name;
    
    UILabel *titleSection = [UILabel new];
    titleSection.text = title;
    [titleSection sizeToFit];
    [titleSection setTextColor:[UIColor getgrayColor]];
    [titleSection setFont:[UIFont fontWithName:HelveticaNeueBold size:15.0f]];
    titleSection.left = 10.0f;
    titleSection.top = sectionView.height / 2 - titleSection.height / 2;
    
    [sectionView addSubview:titleSection];
    
    return sectionView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Seccions *sc = [_sections objectAtIndex:section];
    return [[sc  categoriesOrderByOrder] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuCell";
    
    MenuCell *cell = (MenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Seccions *sc = [_sections objectAtIndex:indexPath.section];
    Categorias *categoria = [[sc  categoriesOrderByOrder] objectAtIndex:indexPath.row];
    [cell setCellWithCategorias:categoria];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _lastindexpath = indexPath;
    
    Seccions *sc = [_sections objectAtIndex:indexPath.section];
    Categorias *categoria = [[sc  categoriesOrderByOrder] objectAtIndex:indexPath.row];
    
    UIViewController *vc = nil;
    
    switch ([categoria.id_categoria intValue]) {
        case KIndexLogin:
            vc = [[LoginVC alloc] init];
            break;
        case KIndexFavourites:
            vc = [FavouriesVC getInstance];
            break;
        case KIndexAbout:
            vc = [[AboutVC alloc] init];
            break;
        case KIndexAlerts:
            vc = [[NotificationsVC alloc] init];
            break;
        default:
            break;
    }
    
    if (vc) {
        vc.title = categoria.name;
        [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                                 withSlideOutAnimation:YES andCompletion:^{
                                                                     
                                                                 }];
    }else{
        
        [[ACNApiClient sharedInstance] cancelAllOperations];
        
        MainVC *mainvc = [[AppDelegate sharedInstance] getRootController];
        mainvc.title = categoria.name;
        [mainvc cleanData];
        [mainvc getNewsByCategory:categoria cadena:@""];
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
            
        }];
    }
}


-(void)reloadMenu{
    [_sections removeAllObjects];
    self.sections = [[DatabaseManager sharedInstance] getSections];
    NSLog(@"%@",_sections);
    _lastindexpath = [self getHomeIndexPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        [table reloadData];
        if (_lastindexpath) {
            [table selectRowAtIndexPath:_lastindexpath
                               animated:NO
                         scrollPosition:UITableViewScrollPositionNone];
        }
    });
}

-(NSIndexPath *)getHomeIndexPath{
    
    NSInteger rowIndexPath = 0;
    NSInteger sectionIndexPath = 0;
    BOOL findIt = NO;
    
    for (Seccions *section in _sections) {
        
        for (Categorias *category in [section categoriesOrderByOrder]){
            
            NSLog(@"%@",category.name);
            
            if ([category id_categoria] && [[category id_categoria] intValue] == 0){
                findIt = YES;
                break;
            }
            if (findIt) {
                break;
            }else rowIndexPath++;
        }
        
        if (findIt){
            break;
        }else sectionIndexPath++;
        
        rowIndexPath = 0;
        
    }
    
    if (findIt) {
        return [NSIndexPath indexPathForRow:rowIndexPath inSection:sectionIndexPath];
    }
    
    return nil;
}

-(void)LaunchAlerts{
    Categorias *categoria = [[DatabaseManager sharedInstance] getAlerts];
    NotificationsVC *vc = [[NotificationsVC alloc] init];
    vc.title = categoria.name;
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:YES andCompletion:^{
                                                             }];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientatio{
    return NO;
}

- (BOOL)shouldAutorotate{
    return NO;
}

@end
