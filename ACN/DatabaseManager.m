//
//  DatabaseManager.m
//  HelPin
//
//  Created by Flamingo Partners on 09/10/14.
//  Copyright (c) 2014 com. All rights reserved.
//

#import "DatabaseManager.h"
#import "Noticia.h"
#import "Categorias.h"
#import "CoreDataHelper.h"
#import "NSManagedObjectContext+RKAdditions.h"
#import <RestKit/RestKit.h>
#import "NoticiaACN.h"
#import "Seccions.h"
#import "LocalizationHelper.H"
#import "Utils.h"
#import "Notifications.h"
#import "Common.h"


@interface DatabaseManager ()
@end

@implementation DatabaseManager

@synthesize coreDataHelper = _coreDataHelper;

#pragma mark - INITIALIZATION

+ (DatabaseManager *) sharedInstance {
    static dispatch_once_t pred;
    static DatabaseManager *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[DatabaseManager alloc] init];
    });
    return sharedInstance;
}
#pragma mark - Core Data Helper

- (BOOL)saveCoreDataContext{
    return [self.coreDataHelper saveManagedObjectChanges];
}

- (CoreDataHelper *)coreDataHelper{
    if (_coreDataHelper != nil) {
        return _coreDataHelper;
    }
    _coreDataHelper = [[CoreDataHelper alloc] init];
    return _coreDataHelper;
}

#pragma mark - UTILITY METHODS RELATED WITH DATABASE

-(void)forceReset{
    [self removeACNSections];
    [self removeACNCategories];
    [self removeACNNoticias];
    [self createDefaultCategories];
}

-(void)createDefaultCategories{
    BOOL isACN = [Utils isACN];
    NSNumber *isACNN = [NSNumber numberWithBool:isACN];
    
    Seccions *firstSection = [[DatabaseManager sharedInstance] createSeccion];
    [firstSection setOrder:[NSNumber numberWithInt:KFirstSection]];
    [firstSection setIsACN:isACNN];
    [firstSection setName:@""];
    
    NSString *LoginName = nil;
    
    if ([Utils stateLogin] == LOGIN || [Utils stateLogin] == VALIDATE_CODE ) {
        LoginName = [LocalizationHelper getLoginName];
    }else{
        LoginName = [LocalizationHelper getLogout];
    }
    
    Categorias *login = [[DatabaseManager sharedInstance] createCategoria];
    login.id_categoria = [NSNumber numberWithInt:KIndexLogin];
    login.type = [NSNumber numberWithInt:1];
    login.name = LoginName;
    login.isLocal = [NSNumber numberWithBool:YES];
    login.isACN = isACNN;
    
    Categorias *starred = [[DatabaseManager sharedInstance] createCategoria];
    starred.id_categoria = [NSNumber numberWithInt:KIndexFavourites];
    starred.type = [NSNumber numberWithInt:1];
    starred.name = [LocalizationHelper getFavouriteName];
    starred.isLocal = [NSNumber numberWithBool:YES];
    starred.isACN = isACNN;
    
    [firstSection addCategoriasObject:login];
    [firstSection addCategoriasObject:starred];
    
    Seccions *LastSection = [[DatabaseManager sharedInstance] createSeccion];
    [LastSection setOrder:[NSNumber numberWithInt:KLastSection]];
    [LastSection setName:@""];
    [LastSection setIsACN:isACNN];
    
    Categorias *about = [[DatabaseManager sharedInstance] createCategoria];
    about.id_categoria = [NSNumber numberWithInt:KIndexAbout];
    about.type = [NSNumber numberWithInt:1];
    about.name = [LocalizationHelper getAboutName];
    about.isLocal = [NSNumber numberWithBool:YES];
    starred.isACN = isACNN;
    
    [LastSection addCategoriasObject:about];
    
    if ([Utils stateLogin] == LOGOUT) {
        
        Seccions *AlertSection = [[DatabaseManager sharedInstance] createSeccion];
        [AlertSection setOrder:[NSNumber numberWithInt:KBeforeLastSection]];
        [AlertSection setName:@""];
        [AlertSection setIsACN:isACNN];
        
        Categorias *alerts = [[DatabaseManager sharedInstance] createCategoria];
        alerts.id_categoria = [NSNumber numberWithInt:KIndexAlerts];
        alerts.type = [NSNumber numberWithInt:1];
        alerts.name = [LocalizationHelper getNotificationsName];
        alerts.isLocal = [NSNumber numberWithBool:YES];
        alerts.isACN = isACNN;
        
        [AlertSection addCategoriasObject:alerts];
    }
    [self saveCoreDataContext];
}

- (Categorias *)getHome{
    NSNumber *acn = [NSNumber numberWithBool:[Utils isACN]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isACN = %i AND id_categoria = 0",[acn intValue]];
    NSArray *data = [self.coreDataHelper getManagedObjectsWithEntityName:CategoriasEntity predicate:predicate];
    return [data firstObject];
}

- (Categorias *)getAlerts{
    NSNumber *acn = [NSNumber numberWithBool:[Utils isACN]];
    NSNumber *id_alerts = [NSNumber numberWithInt:KIndexAlerts];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isACN = %i AND id_categoria = %i",[acn intValue],[id_alerts intValue]];
    NSArray *data = [self.coreDataHelper getManagedObjectsWithEntityName:CategoriasEntity predicate:predicate];
    return [data firstObject];
}


- (Categorias *) createCategoria{
    return (Categorias *)[self.coreDataHelper createManagedObjectWithEntityName:CategoriasEntity];
}

- (void) removeCategoria:(Categorias *)ans {
    [self.coreDataHelper removeManagedObject:ans];
}

-(NSInteger)getCountCategories{
    return [self.coreDataHelper countManagedObjectsWithEntityName:CategoriasEntity];
}

- (NSMutableArray *) getCategories{
    return [[self.coreDataHelper  getAllManagedObjectsWithEntityName:CategoriasEntity orderBy:@"id_categoria" ascending:YES] mutableCopy];
}

-(void) removeAllCategories{
    [self.coreDataHelper removeAllManagerObjects:CategoriasEntity];
}

- (void) removeCategories{
    NSNumber *isLocal = [NSNumber numberWithBool:NO];
    NSString *str = [NSString stringWithFormat:@"isLocal = %i",[isLocal intValue]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str argumentArray:nil];
    NSMutableArray *data = [[self.coreDataHelper getManagedObjectsWithEntityName:CategoriasEntity predicate:predicate] mutableCopy];
    for (Categorias *cat in data) {
        [self removeCategoria:cat];
    }
}

- (void) removeACNCategories{
    NSNumber *isACN = [NSNumber numberWithBool:[Utils isACN]];
    NSString *str = [NSString stringWithFormat:@"isACN = %i",[isACN intValue]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str argumentArray:nil];
    NSMutableArray *data = [[self.coreDataHelper getManagedObjectsWithEntityName:CategoriasEntity predicate:predicate] mutableCopy];
    for (Categorias *cat in data) {
        [self removeCategoria:cat];
    }
}

- (void) removeLocalCategories{
    NSNumber *isLocal = [NSNumber numberWithBool:YES];
    NSString *str = [NSString stringWithFormat:@"isLocal = %i",[isLocal intValue]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str argumentArray:nil];
    NSMutableArray *data = [[self.coreDataHelper getManagedObjectsWithEntityName:CategoriasEntity predicate:predicate] mutableCopy];
    for (Categorias *cat in data) {
        [self removeCategoria:cat];
        [self saveCoreDataContext];
    }
}


- (Noticia *) createNoticia{
    return (Noticia *)[self.coreDataHelper createManagedObjectWithEntityName:NoticiaEntity];
}

- (void) removeNoticia:(Noticia *)noticia{
    [self.coreDataHelper removeManagedObject:noticia];
}

- (void) removeNoticias{
    NSNumber *fav = [NSNumber numberWithBool:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavourite = %i",[fav intValue]];
    NSMutableArray *data = [[self.coreDataHelper getManagedObjectsWithEntityName:NoticiaEntity predicate:predicate] mutableCopy];
    for (Noticia *nt in data) {
        [self.coreDataHelper removeManagedObject:nt];
    }
}

- (void) removeACNNoticias{
    NSNumber *acn = [NSNumber numberWithBool:[Utils isACN]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isACN = %i",[acn intValue]];
    NSMutableArray *data = [[self.coreDataHelper getManagedObjectsWithEntityName:NoticiaEntity predicate:predicate] mutableCopy];
    for (Noticia *nt in data){
        [self.coreDataHelper removeManagedObject:nt];
    }
}

- (NSMutableArray *) getNewsWithIdCategory:(NSInteger)id_category
                                    cadena:(NSString *)cadena{
    BOOL isACN = [Utils isACN];
    NSNumber *isACNN = [NSNumber numberWithBool:isACN];
    NSString *query = nil;
    if([cadena length] > 0){
        query = [NSString stringWithFormat:@"title contains[c] %@ OR subtitle contains[c] %@ AND id_categoria = %li AND isACN = %i",cadena,cadena,(long)id_category, [isACNN intValue]];
    }else{
        query = [NSString stringWithFormat:@"id_categoria = %li AND isACN = %i",(long)id_category, [isACNN intValue]];
    }
    NSArray *array = [self.coreDataHelper getManagedObjectsWithEntityName:NoticiaEntity predicate:[NSPredicate predicateWithFormat:query argumentArray:nil] orderBy:@"creation_date" ascending:NO];
    return [array mutableCopy];
}

- (NSMutableArray *) getNewsWithText:(NSString *)text
                            category:(NSInteger)category{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@ OR subtitle contains[c] %@ AND id_categoria = %li", text, text,category];
    NSMutableArray *data = [[self.coreDataHelper getManagedObjectsWithEntityName:NoticiaEntity predicate:predicate orderBy:@"creation_date" ascending:NO] mutableCopy];
    return data;
}

- (NSMutableArray *) getNewsFavouritesWithText:(NSString *)text{
    NSNumber *fav = [NSNumber numberWithBool:YES];
    text = [text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFavourite = %i AND (title contains[c] %@ OR subtitle contains[c] %@)",[fav intValue], text, text];
    NSMutableArray *data = [[self.coreDataHelper getManagedObjectsWithEntityName:NoticiaEntity predicate:predicate orderBy:@"creation_date" ascending:NO] mutableCopy];
    return data;
}

- (Noticia *) isFavourite:(NSInteger)id_noticia
            andIdCategory:(NSInteger)id_category{
    NSNumber *fav = [NSNumber numberWithBool:YES];
    NSString *str = [NSString stringWithFormat:@"isFavourite = %i AND id_categoria = %li AND id_noticia  = %li ",[fav intValue],(long)id_category,(long)id_noticia];
    NSArray *array = [self.coreDataHelper getManagedObjectsWithEntityName:NoticiaEntity predicate:[NSPredicate predicateWithFormat:str argumentArray:nil]];
    return [array firstObject];
}

- (BOOL) existNewsWithText:(NSString *)text category:(NSInteger)category{
    text = [text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@ OR subtitle contains[c] %@ AND id_categoria = %li", text, text,category];
    NSMutableArray *data = [[self.coreDataHelper getManagedObjectsWithEntityName:NoticiaEntity predicate:predicate] mutableCopy];
    return ([data count] > 0);
}

- (NSMutableArray *) getFavourites{
    NSNumber *isFavourite = [NSNumber numberWithBool:YES];
    NSString *str = [NSString stringWithFormat:@"%@ = %i",KIsFavourite,[isFavourite intValue]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str argumentArray:nil];
    NSMutableArray *data = [[self.coreDataHelper getManagedObjectsWithEntityName:NoticiaEntity predicate:predicate orderBy:@"creation_date" ascending:NO] mutableCopy];
    return data;
}

- (Categorias *) getCategoryWithId:(NSInteger)id_category {
    NSString *str = [NSString stringWithFormat:@"id_categoria = %li",(long)id_category];
    NSArray *array = [self.coreDataHelper getManagedObjectsWithEntityName:CategoriasEntity predicate:[NSPredicate predicateWithFormat:str argumentArray:nil]];
    return [array firstObject];
}

- (void) removeAllSections{
    [self.coreDataHelper removeAllManagerObjects:SeccionEntity];
}

- (Seccions *) createSeccion{
    return (Seccions *)[self.coreDataHelper createManagedObjectWithEntityName:SeccionEntity];
}

- (NSMutableArray *) getSections{
    NSNumber *isACN = [NSNumber numberWithBool:[Utils isACN]];
    NSString *str = [NSString stringWithFormat:@"isACN = %i",[isACN intValue]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str argumentArray:nil];
    NSMutableArray *sections = [[self.coreDataHelper getManagedObjectsWithEntityName:SeccionEntity predicate:predicate orderBy:@"order" ascending:YES] mutableCopy];
    return sections;
}

- (void) removeSections{
    NSMutableArray *sections = [self getSections];
    for (Seccions *section in sections) {
        if ([[section order] intValue] !=  KFirstSection && [[section order] intValue] !=  KLastSection && [[section order] intValue] !=  KBeforeLastSection) {
            [self.coreDataHelper removeManagedObject:section];
        }
    }
}

- (void) removeACNSections{
    NSNumber *isACN = [NSNumber numberWithBool:[Utils isACN]];
    NSString *str = [NSString stringWithFormat:@"isACN = %i",[isACN intValue]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str argumentArray:nil];
    NSMutableArray *data = [[self.coreDataHelper getManagedObjectsWithEntityName:SeccionEntity predicate:predicate] mutableCopy];
    for (Seccions *section in data) {
        [self.coreDataHelper removeManagedObject:section];
    }
}

- (Notifications *) createNotification{
    return (Notifications *)[self.coreDataHelper createManagedObjectWithEntityName:NotificationsEntity];
}

- (void) removeNotificacio:(Notifications *)notification{
    [self.coreDataHelper removeManagedObject:notification];
}

- (NSMutableArray *) getNotifications{
    NSNumber *deleted = [NSNumber numberWithBool:NO];
    NSString *str = [NSString stringWithFormat:@"deleted = %i",[deleted intValue]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:str argumentArray:nil];
    return [[self.coreDataHelper  getAllManagedObjectsWithEntityName:NotificationsEntity  orderBy:@"creation_date" predicate:predicate  ascending:NO] mutableCopy];
}

- (Notifications *) existNotificationWithIdNotification:(NSInteger)id_not{
    NSString *str = [NSString stringWithFormat:@"id_noticia = %li",(long)id_not];
    NSArray *array = [self.coreDataHelper getManagedObjectsWithEntityName:NotificationsEntity predicate:[NSPredicate predicateWithFormat:str argumentArray:nil]];
    return [array firstObject] ;
}

- (NSMutableArray *) getNotificationsWithText:(NSString *)text{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title contains[c] %@ OR subtitle contains[c] %@", text, text];
    NSMutableArray *data = [[self.coreDataHelper getManagedObjectsWithEntityName:NotificationsEntity predicate:predicate orderBy:@"creation_date" ascending:NO] mutableCopy];
    return data;
}

@end
