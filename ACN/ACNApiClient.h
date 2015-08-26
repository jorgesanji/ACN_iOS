//
//  ACNApiClient.h
//  ACN
//
//  Created by Flamingo Partners on 29/11/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onCompletition)(NSMutableArray *result);
typedef void (^onLoginCompletition)(id result);

@class Categorias;
@interface ACNApiClient : NSObject

+ (instancetype)sharedInstance;

- (void)cancelAllOperations;

-(void)getNewsWithIdCategory:(Categorias *)id_category pageStart:(NSInteger)indexStart pageEnd:(NSInteger)indexEnd cadena:(NSString *)cadena completition:(onCompletition)completition;

-(void)getCategoriesOnCompletition:(onCompletition)completition;

-(void)makeLogin:(NSString *)phone token:(NSString *)token completition:(onLoginCompletition)completition;

-(void)validate:(NSString *)phone token:(NSString *)token code:(NSString *)code completition:(onLoginCompletition)completition;

-(void)makeLogout:(NSString *)phone token:(NSString *)token completition:(onLoginCompletition)completition;

-(void)getNotificationsWithcompletition:(onCompletition)completition;

@end
