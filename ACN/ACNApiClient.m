//
//  ACNApiClient.m
//  ACN
//
//  Created by Flamingo Partners on 29/11/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "ACNApiClient.h"
#import "Utils.h"
#import <RestKit/RestKit.h>
#import "NSMutableURLRequest+HeaderDefaultConfiguration.h"
#import "NSDictionary+JSONData.h"
#import "ACNApiClient+Mapping.h"
#import "ACNApiClient+Endpoints.h"
#import "NSDateFormatter+FormatDefaultConfig.h"

#import "CategoriaACN.h"
#import "NoticiaACN.h"
#import "Categorias.h"
#import "Noticia.h"
#import "Utils.h"
#import "SeccionsACN.h"
#import "CategoriesResponse.h"
#import "CategoriasCNA.h"
#import "KeychainItemWrapper.h"

@interface ACNApiClient()
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) KeychainItemWrapper *keychain;
@end

typedef void (^RKSuccess)(RKObjectRequestOperation *operation, RKMappingResult *result);
typedef void (^RKFailure)(RKObjectRequestOperation *operation, NSError *error);

@implementation ACNApiClient

// 1 = ACN Catalan language
// 0 = CNA English Language

#pragma mark - INITIALIZATION

+ (instancetype)sharedInstance {
    static dispatch_once_t pred;
    static ACNApiClient *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[ACNApiClient alloc] init];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue setMaxConcurrentOperationCount:10];
        sharedInstance.queue = queue;
        sharedInstance.keychain = [[KeychainItemWrapper alloc] initWithIdentifier:KNameIndentifier accessGroup:nil];
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    });
    return sharedInstance;
}

- (void)cancelAllOperations{
    [_queue cancelAllOperations];
}

-(void)getNewsWithIdCategory:(Categorias*)category
                   pageStart:(NSInteger)indexStart
                     pageEnd:(NSInteger)indexEnd
                      cadena:(NSString *)cadena
                completition:(onCompletition)completition{
    
    NSInteger idCategoria = (category)?[category.id_categoria intValue]:0;
    NSNumber *type = @(0);
    NSArray *categories = @[@(idCategoria)];
    NSNumber *numResultats = @(indexEnd);
    NSNumber *firstResult = @(indexStart);
    NSData *jsonData = [@{ @"categories":categories, @"cadenaCerca":cadena,@"numResultats":numResultats,@"firstResult":firstResult,@"tipusFitxer":type} toData];
    
    id success = ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        completition([[result array] mutableCopy]);
    };
    
    id failure = ^(RKObjectRequestOperation *operation, NSError *error) {
        completition(nil);
    };
    
    [self requestWithUrl:[ACNApiClient getNoticies] data:jsonData descriptor:[ACNApiClient descriptorNoticia] success:success failure:failure];
}

-(void)getNotificationsWithcompletition:(onCompletition)completition{
    
    NSString *token = [Utils getToken];
    NSString *phone = [_keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    NSDate *date = [Utils getLastDateUpdatedNotifications];
    NSDateFormatter *dateFormater = [NSDateFormatter formattToBackend];
    NSString *dateStr = [dateFormater stringFromDate:date];
    NSData *jsonData = [@{ @"idToken":token, @"phoneNumber":phone,@"os":@"iOS",@"lastUpdate":dateStr} toData];
    id success = ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        completition([[result array] mutableCopy]);
    };
    
    id failure = ^(RKObjectRequestOperation *operation, NSError *error) {
        completition(nil);
    };
    
    [self requestWithUrl:[ACNApiClient getAlertByType] data:jsonData descriptor:[ACNApiClient descriptorNoticia]  success:success failure:failure];
}

-(void)getCategoriesOnCompletition:(onCompletition)completition{
    
    [_queue cancelAllOperations];
    
    id success = ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        if ( [[result dictionary] isKindOfClass:[NSDictionary class]] && [[[result dictionary] allValues] count] > 0) {
            if([Utils isACN]){
                completition([[[[[result dictionary] allValues] firstObject] seccions] mutableCopy]);
            }else{
                CategoriasCNA *cna = [[result array] objectAtIndex:0];
                completition([[cna seccions] mutableCopy]);
            }
        }else{
            completition(nil);
        }
    };
    
    id failure = ^(RKObjectRequestOperation *operation, NSError *error) {
        completition(nil);
    };
    
    [self requestWithUrl:[ACNApiClient getcategories] data:nil descriptor:[ACNApiClient descriptorCategories] success:success failure:failure];
}

-(void)makeLogin:(NSString *)phone
           token:(NSString *)token
    completition:(onLoginCompletition)completition{
    
    NSInteger source = [Utils isACN]?1:0;
    NSData *jsonData = [@{@"phoneNumber":phone, @"idToken":token, @"os":@"iOS",@"source":[NSNumber numberWithInteger:source]} toData];
    
    id success = ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        if ( [[result dictionary] isKindOfClass:[NSDictionary class]] && [[[result dictionary] allValues] count] > 0) {
            completition([[[result dictionary] allValues] firstObject]);
        }else{
            completition(nil);
        }
    };
    
    id failure = ^(RKObjectRequestOperation *operation, NSError *error) {
        completition(nil);
    };
    
    [self requestWithUrl:[ACNApiClient getLogIn] data:jsonData descriptor:[ACNApiClient descriptorCategories] success:success failure:failure];
}

-(void)validate:(NSString *)phone
          token:(NSString *)token
           code:(NSString *)code
   completition:(onLoginCompletition)completition{
    
    NSInteger source = [Utils isACN]?1:0;
    NSData *jsonData = [@{@"phoneNumber":phone, @"idToken":token, @"key":code, @"os":@"iOS",@"source":[NSNumber numberWithInteger:source]} toData];
    
    id success = ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        if ( [[result dictionary] isKindOfClass:[NSDictionary class]] && [[[result dictionary] allValues] count] > 0) {
            completition([[[result dictionary] allValues] firstObject]);
        }else{
            completition(nil);
        }
    };
    
    id failure = ^(RKObjectRequestOperation *operation, NSError *error) {
        completition(nil);
    };
    
    [self requestWithUrl:[ACNApiClient getLogIn] data:jsonData descriptor:[ACNApiClient descriptorCategories] success:success failure:failure];
}

-(void)makeLogout:(NSString *)phone
            token:(NSString *)token
     completition:(onLoginCompletition)completition{
    
    NSInteger source = [Utils isACN]?1:0;
    NSData *jsonData = [@{@"phoneNumber":phone, @"idToken":token, @"os":@"iOS",@"source":[NSNumber numberWithInteger:source]} toData];
    
    id success = ^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        if ( [[result dictionary] isKindOfClass:[NSDictionary class]] && [[[result dictionary] allValues] count] > 0) {
            completition([[[result dictionary] allValues] firstObject]);
        }else{
            completition(nil);
        }
    };
    
    id failure = ^(RKObjectRequestOperation *operation, NSError *error) {
        completition(nil);
    };
    
    [self requestWithUrl:[ACNApiClient getLogOut] data:jsonData descriptor:[ACNApiClient descriptorCategories] success:success failure:failure];
}

- (void)requestWithUrl:(NSString *)url
                  data:(NSData *)data
            descriptor:(RKResponseDescriptor *)responseDescriptor
               success:(RKSuccess)sucess
               failure:(RKFailure)failure
{
    
    NSString *urlAbsolute = [[ACNApiClient getBaseUrl]stringByAppendingString:url];
    NSURL *URL_ENDPOINT = [NSURL URLWithString:urlAbsolute];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL_ENDPOINT method:@"POST" bodyData:data defaultHeader:YES timeOut:KTimeOutDefault];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:sucess
                                     failure:failure];
    [_queue addOperation:operation];
}

@end
