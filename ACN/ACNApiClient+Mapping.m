//
//  ACNApiClient+Mapping.m
//  ACN
//
//  Created by jorge Sanmartin on 26/8/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "ACNApiClient+Mapping.h"
#import "NSDateFormatter+FormatDefaultConfig.h"
#import "CategoriaACN.h"
#import "NoticiaACN.h"
#import "CategoriesResponse.h"
#import "SeccionsACN.h"

@implementation ACNApiClient (Mapping)

+(NSDictionary *)mappSeccions{
    NSDictionary *seccions = @{
                               @"order": @"order",
                               @"name": @"name"
                               };
    return seccions;
}

+(NSDictionary *)mappACNCategories{
    NSDictionary *categorie = @{
                                @"id": @"id",
                                @"name": @"name",
                                @"type": @"type"
                                };
    return categorie;
}

+(NSDictionary *)mappingACNSeccionesCategories{
    NSDictionary *seccionesCategories = @{
                                          @"statusMessage": @"statusMessage",
                                          @"statusLogin": @"statusLogin"
                                          };
    return seccionesCategories;
}


+(NSDictionary *)mappACNNoticias{
    
    NSDictionary *noticias = @{
                               @"id": @"id",
                               @"title": @"title",
                               @"subtitle": @"subtitle",
                               @"description": @"description",
                               @"type": @"type",
                               @"url": @"url",
                               @"image": @"image",
                               @"categories": @"categories",
                               @"creation_date": @"creation_date"
                               };
    
    return noticias;
}

+ (RKResponseDescriptor *)descriptorCategories{
    
    RKObjectMapping *mappingSeccionsCategories = [RKObjectMapping mappingForClass:[CategoriesResponse class]];
    [mappingSeccionsCategories addAttributeMappingsFromDictionary:[ACNApiClient mappingACNSeccionesCategories]];
    
    RKObjectMapping *mappingSeccions = [RKObjectMapping mappingForClass:[SeccionsACN class]];
    [mappingSeccions addAttributeMappingsFromDictionary:[ACNApiClient mappSeccions]];
    
    [mappingSeccionsCategories addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"seccions" toKeyPath:@"seccions" withMapping:mappingSeccions]];
    
    RKObjectMapping *mappingCategories = [RKObjectMapping mappingForClass:[CategoriaACN class]];
    [mappingCategories addAttributeMappingsFromDictionary:[ACNApiClient mappACNCategories]];
    
    [mappingSeccions addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"categorias" toKeyPath:@"categorias" withMapping:mappingCategories]];
    
    return [RKResponseDescriptor responseDescriptorWithMapping:mappingSeccionsCategories method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

+ (RKResponseDescriptor *)descriptorNoticia{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[NoticiaACN class]];
    [mapping addAttributeMappingsFromDictionary:[ACNApiClient mappACNNoticias]];
    mapping.dateFormatters = @[[NSDateFormatter formattDateMatching]];
    
    return [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:@"elements" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
}

@end
