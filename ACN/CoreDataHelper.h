//
//  CoreDataHelper.h
//  HelPin
//
//  Created by Flamingo Partners on 09/10/14.
//  Copyright (c) 2014 com. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CoreDataHelper : NSObject
{
	NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
}
@property(nonatomic, strong) NSManagedObjectContext *backgroundmanagedObjectContext;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void) cloneFieldsFromManagedObject:(NSManagedObject *)fromManagedObject toManagedObject:(NSManagedObject *)toManagedObject;


- (NSUInteger) countManagedObjectsWithEntityName:(NSString*)entityName predicate:(NSPredicate *)predicate;

- (NSUInteger) countManagedObjectsWithEntityName:(NSString*)entityName;

- (NSArray*) getManagedObjectsWithEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate
                                     orderBy:(NSString*)orderBy
                                   ascending:(BOOL)ascending;

- (NSArray*) getManagedObjectsWithEntityName:(NSString*)entityName
predicate:(NSPredicate*)predicate;

- (NSArray *) getManagedObjectsWithEntityName:(NSString *)entityName
                                    predicate:(NSPredicate *)predicate
                                 orderByArray:(NSArray *)orderBy
                               ascendingArray:(NSArray *)ascending;

-(NSArray*)getAllManagedObjectsWithEntityName:(NSString*)entityName
									  orderBy:(NSString*)orderBy
                                    predicate:(NSPredicate *)predicate
									ascending:(BOOL)ascending;

-(NSArray*)getManagedObjectsWithEntityName:(NSString*)entityName
								 predicate:(NSPredicate*)predicate
								   orderBy:(NSString*)orderBy
								 ascending:(BOOL)ascending
                                    offset:(NSInteger)moffset
                                     limit:(NSInteger)mlimit
                                   groupBy:(NSArray *)group;

-(NSArray*)getFirstManagedObjectsWithEntityName:(NSString*)entityName
                                        orderBy:(NSString*)orderBy
                                      ascending:(BOOL)ascending;

- (NSArray*) getAllManagedObjectsWithEntityName:(NSString *)entityName;

- (NSArray*) getAllManagedObjectsWithEntityName:(NSString*)entityName
                                        orderBy:(NSString*)orderBy
                                      ascending:(BOOL)ascending;

- (NSArray*) getAllManagedObjectsWithEntityName:(NSString*)entityName
                                   orderByArray:(NSArray*)orderBy
                                 ascendingArray:(NSArray *)ascending;


- (NSArray*) getManagedObjectsWithFetchRequestName:(NSString*)fetchRequestName;

- (NSManagedObject*) getManagedObjectWithEntityName:(NSString*)entityName
                                          predicate:(NSPredicate*)predicate;

- (NSManagedObject*) createManagedObjectWithEntityName:(NSString*)entityName;

- (void) removeManagedObject:(NSManagedObject*)managedObject;

- (void) removeAllManagerObjects:(NSString*)entityName;

- (BOOL) saveManagedObjectChanges;

- (void) undoManagedObjectChanges;

@end

