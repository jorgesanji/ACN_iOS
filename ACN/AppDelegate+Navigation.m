//
//  AppDelegate+Navigation.m
//  ACN
//
//  Created by jorge Sanmartin on 25/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "AppDelegate+Navigation.h"
#import "MainVC.h"
#import "MenuVC.h"
#import "ShowReelVC.h"
#import "NotificationsVC.h"
#import "SlideNavigationController.h"
#import "Utils.h"
#import "ACNApiClient.h"
#import "SeccionsACN.h"
#import "Seccions.h"
#import "CategoriaACN.h"
#import "Categorias.h"
#import "DatabaseManager.h"
#import "LocalizationHelper.h"
#import "UIColor+CustomColorsApp.h"
#import "UIBarButtonItem+DefaultConfig.h"
#import "UIImage+AppFeatures.h"

@interface AppDelegate()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@end

@implementation AppDelegate (Navigation)

#pragma mark - Navigation

-(MainVC *)getRootController{
    return (MainVC *)[[self.navigation childViewControllers] firstObject];
}

-(SlideNavigationController *)getNavigation{
    
    BOOL isShowReelReady = [Utils isShowreelWatched];
    
    UIViewController *root = nil;
    UIViewController *menu = nil;
    CGFloat panGesture = 0.0f;
    CGFloat portraitGesture= 0.0f;
    id <UIGestureRecognizerDelegate> delegate = nil;
    BOOL popGestureEnabled = NO;
    UIBarButtonItem *home = nil;
    
    if (isShowReelReady) {
        root = [[MainVC alloc] init];
        menu = [MenuVC getInstance];
        panGesture = 120.0f;
        portraitGesture = 100.0f;
        delegate = self;
        popGestureEnabled = NO;
        home = [UIBarButtonItem buttonWithImage: [UIImage imageNamed:@"menu-button"]tintColor: [UIColor getPrimaryColor]  target:self action:@selector(leftMenuSelected:)];
    }else{
        root = [ShowReelVC getInstance];
    }
    
    SlideNavigationController *navigation = [[SlideNavigationController alloc] initWithRootViewController:root];
    navigation.leftMenu = menu;
    navigation.panGestureSideOffset = panGesture;
    navigation.portraitSlideOffset = portraitGesture;
    navigation.delegate = self;
    navigation.interactivePopGestureRecognizer.enabled = popGestureEnabled;
    navigation.interactivePopGestureRecognizer.delegate = delegate;
    root.navigationItem.leftBarButtonItem = home;
    
    return navigation;
}

-(void)changeToMainController{
    [Utils showReelReady];
    self.navigation = [self getNavigation];
    [UIView transitionWithView:self.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.window.rootViewController = self.navigation;
                    }
                    completion:^(BOOL finished) {
                        [self getCategories:YES];
                    }];
    
}

-(void)getCategories:(BOOL)reload{
    if ([self isRecheable]) {
        [[ACNApiClient sharedInstance] getCategoriesOnCompletition:^(NSMutableArray *result) {
            if (result) {
                if (reload) {
                    [[DatabaseManager sharedInstance] forceReset];
                }
                [self buildMenu:result];
            }
        }];
    }else{
        Categorias *home = [[DatabaseManager sharedInstance] getCategoryWithId:0];
        if (home) {
            [[self getRootController] getNewsByCategory:home cadena:@""];
        }
    }
}

-(void)buildMenu:(NSMutableArray *)result{
    for (SeccionsACN *seccionACN in result) {
        Seccions *seccion = [[DatabaseManager sharedInstance] createSeccion];
        [seccion setOrder:[seccionACN order]];
        [seccion setName:[seccionACN name]];
        [seccion setIsACN:[NSNumber numberWithBool:[Utils isACN]]];
        for (CategoriaACN *cat in [seccionACN categorias]) {
            Categorias *cats = [[DatabaseManager sharedInstance] createCategoria];
            cats.id_categoria = [cat id];
            cats.type = [cat type];
            cats.name = [cat name];
            cats.isLocal = [NSNumber numberWithBool:NO];
            cats.isACN = [NSNumber numberWithBool:[Utils isACN]];
            [seccion addCategoriasObject:cats];
        }
    }
    [[DatabaseManager sharedInstance] saveCoreDataContext];
    [self reloadMenu];
}

-(void)reloadMenu{
    Categorias *home = [[DatabaseManager sharedInstance] getHome];
    [[self getRootController] cleanData];
    [[self getRootController] getNewsByCategory:home cadena:@""];
    if ([[self.navigation leftMenu] isViewLoaded]) {
        [((MenuVC *)[self.navigation leftMenu]) reloadMenu];
    }
}

#pragma mark - Actions

-(void)gotoHome:(UIButton *)sender{
    [self.navigation  popViewControllerAnimated:YES];
    [self reloadMenu];
}

-(void)back:(id)sender{
    [self.navigation popViewControllerAnimated:YES];
}

-(void)leftMenuSelected:(UIButton*)sender{
    if ([self.navigation isMenuOpen])
        [self.navigation closeMenuWithCompletion:nil];
    else
        [self.navigation openMenu:MenuLeft withCompletion:nil];
}

#pragma mark - UINavigationControllerDelegate Methods -

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated{
    
    if ([viewController isKindOfClass:[MainVC class ]]) {
        return;
    }
    
    UIBarButtonItem *languagebutton = [UIBarButtonItem buttonWithImage:[[UIImage imageNamed:([Utils isACN]) ? @"acn" : @"cna"] resizeImage] tintColor:nil  target:self action:@selector(gotoHome:)];
    
    UIBarButtonItem *backbutton = [UIBarButtonItem buttonWithImage: [UIImage imageNamed:@"arrow_left"]tintColor: [UIColor getPrimaryColor]  target:self action:@selector(gotoHome:)];
    
    viewController.navigationItem.leftBarButtonItem = backbutton;
    
    if(![viewController isKindOfClass:[NotificationsVC class]]){
        viewController.navigationItem.rightBarButtonItem = languagebutton;
    }else{
        [viewController.editButtonItem setTitle:[LocalizationHelper getEdit]];
        viewController.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:languagebutton, viewController.editButtonItem, nil];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

@end
