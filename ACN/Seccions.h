//
//  Seccions.h
//  ACN
//
//  Created by Flamingo Partners on 23/2/15.
//  Copyright (c) 2015 Jorge Sanmartin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Categorias;

@interface Seccions : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSNumber * isACN;
@property (nonatomic, retain) NSSet *categorias;
@end

@interface Seccions (CoreDataGeneratedAccessors)

- (void)addCategoriasObject:(Categorias *)value;
- (void)removeCategoriasObject:(Categorias *)value;
- (void)addCategorias:(NSSet *)values;
- (void)removeCategorias:(NSSet *)values;

-(NSArray *)categoriesOrderByOrder;

@end
