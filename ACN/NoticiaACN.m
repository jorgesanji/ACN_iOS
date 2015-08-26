//
//  NoticiaACN.m
//  ACN
//
//  Created by Flamingo Partners on 16/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import "NoticiaACN.h"

@implementation NoticiaACN

@synthesize id = _id;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize description = _description;
@synthesize url = _url;
@synthesize image = _image;
@synthesize type = _type;
@synthesize creation_date = _creation_date;
@synthesize categories = _categories;
@synthesize isFavourite = _isFavourite;

-(id)init{
    self = [super init];
    if (self) {
        self.isFavourite = NO;
    }
    
    return self;
}


@end
