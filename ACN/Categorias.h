//
//  Categorias.h
//  ACN
//
//  Created by Flamingo Partners on 23/2/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Seccions;

@interface Categorias : NSManagedObject

@property (nonatomic, retain) NSDate * date_updated;
@property (nonatomic, retain) NSNumber * id_categoria;
@property (nonatomic, retain) NSNumber * isLocal;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * isACN;
@property (nonatomic, retain) Seccions *seccion;

@end
