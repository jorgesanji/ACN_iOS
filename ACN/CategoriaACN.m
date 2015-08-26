//
//  CategoriaACN.m
//  ACN
//
//  Created by Flamingo Partners on 16/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "CategoriaACN.h"

@implementation CategoriaACN

@synthesize id = _id;
@synthesize name = _name;
@synthesize type = _type;
@synthesize updating_date = _updating_date;
@synthesize isLocal = _isLocal;

-(id)init{
    self = [super init];
    
    if (self) {
        self.isLocal = NO;
        self.id = [NSNumber numberWithInt:-5];
    }
    return self;
}

@end
