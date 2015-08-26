//
//  Noticia.m
//  ACN
//
//  Created by Flamingo Partners on 23/2/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import "Noticia.h"


@implementation Noticia

@dynamic categories;
@dynamic creation_date;
@dynamic descriptionFeed;
@dynamic id_categoria;
@dynamic id_noticia;
@dynamic image;
@dynamic isFavourite;
@dynamic subtitle;
@dynamic title;
@dynamic type;
@dynamic url;
@dynamic isACN;

- (NSComparisonResult)compare:(Noticia *)otherNew {
    
    return [self.creation_date compare:otherNew.creation_date];
}

@end
