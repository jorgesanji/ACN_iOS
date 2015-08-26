//
//  Noticia.h
//  ACN
//
//  Created by Flamingo Partners on 23/2/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Noticia : NSManagedObject

@property (nonatomic, retain) NSString * categories;
@property (nonatomic, retain) NSDate * creation_date;
@property (nonatomic, retain) NSString * descriptionFeed;
@property (nonatomic, retain) NSNumber * id_categoria;
@property (nonatomic, retain) NSNumber * id_noticia;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * isFavourite;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * isACN;

- (NSComparisonResult)compare:(Noticia *)otherNew;

@end
