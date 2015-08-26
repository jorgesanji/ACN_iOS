//
//  CategoriaACN.h
//  ACN
//
//  Created by Flamingo Partners on 16/12/14.
//  Copyright (c) 2014 Jorge Sanmartin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoriaACN : NSObject

@property(nonatomic, copy) NSNumber * id;
@property(nonatomic, copy) NSString * name;
@property(nonatomic, copy) NSNumber *type;
@property(nonatomic, strong) NSDate *updating_date;
@property(nonatomic)BOOL isLocal;

@end
