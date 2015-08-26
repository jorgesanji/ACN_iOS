//
//  DatabaseManager.h
//  HelPin
//
//  Created by Flamingo Partners on 09/10/14.
//  Copyright (c) 2014 com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CategoriasEntity @"Categorias"
#define KIsFavourite @"isFavourite"
#define NoticiaEntity @"Noticia"
#define SeccionEntity @"Seccions"
#define NotificationsEntity @"Notifications" 

@class Noticia;
@class Categorias;
@class CoreDataHelper;
@class NoticiaACN;
@class Seccions;
@class Notifications;
@interface DatabaseManager : NSObject
@property (readonly, strong, nonatomic) CoreDataHelper *coreDataHelper;

//PUBLIC METHODS

+ (DatabaseManager *) sharedInstance;
- (BOOL)saveCoreDataContext;

- (void) forceReset;

- (Categorias *)getHome;
- (Categorias *)getAlerts;

- (NSMutableArray *) getCategories;
- (void)createDefaultCategories;
- (Categorias *) createCategoria;
- (Categorias *) getCategoryWithId:(NSInteger)id_category;
- (NSMutableArray *) getNewsWithIdCategory:(NSInteger)id_category
                                    cadena:(NSString *)cadena;

- (Noticia *) createNoticia;
- (NSMutableArray *) getNewsWithText:(NSString *)text
                            category:(NSInteger)category;

- (NSMutableArray *) getNewsFavouritesWithText:(NSString *)text;

- (NSMutableArray *) getFavourites;
- (Noticia *) isFavourite:(NSInteger)id_noticia
            andIdCategory:(NSInteger)id_category;

- (Seccions *) createSeccion;
- (NSMutableArray *) getSections;

- (Notifications *) createNotification;
- (NSMutableArray *) getNotifications;
- (Notifications *) existNotificationWithIdNotification:(NSInteger)id_not;
- (void) removeNotificacio:(Notifications *)noticia;
- (NSMutableArray *) getNotificationsWithText:(NSString *)text;

@end
