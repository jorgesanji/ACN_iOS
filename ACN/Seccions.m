//
//  Seccions.m
//  ACN
//
//  Created by Flamingo Partners on 23/2/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "Seccions.h"
#import "Categorias.h"

@interface Seccions ()

@property(nonatomic, strong)NSArray *OrderCategories;

@end

@implementation Seccions

@synthesize OrderCategories = _OrderCategories;
@dynamic name;
@dynamic order;
@dynamic isACN;
@dynamic categorias;

-(NSArray *)categoriesOrderByOrder{
    
    if (_OrderCategories) {
        return _OrderCategories;
    }
    
    NSArray *cat = [[self categorias] allObjects];
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"id_categoria" ascending: YES];
    self.OrderCategories = [cat sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    return _OrderCategories;
}

@end
