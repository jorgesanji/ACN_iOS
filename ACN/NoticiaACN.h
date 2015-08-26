//
//  NoticiaACN.h
//  ACN
//
//  Created by Flamingo Partners on 16/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticiaACN : NSObject

@property(nonatomic, copy) NSNumber * id;
@property(nonatomic, copy) NSString * title;
@property(nonatomic, copy) NSString * subtitle;
@property(nonatomic, copy) NSString * description;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString * type;
@property(nonatomic, copy) NSString * image;
@property(nonatomic, copy) NSArray *categories;
@property(nonatomic) NSDate *creation_date;
@property(nonatomic)BOOL isFavourite;

@end
