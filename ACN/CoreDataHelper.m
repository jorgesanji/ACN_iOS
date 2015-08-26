//
//  CoreDataHelper.m
//  HelPin
//
//  Created by Flamingo Partners on 09/10/14.
//  Copyright (c) 2014 com. All rights reserved.
//

#import "CoreDataHelper.h"

@interface CoreDataHelper ()

@property(nonatomic)NSInteger limit;
@property(nonatomic)NSInteger offset;

-(void)createManagedObjectContext;
@end

@implementation CoreDataHelper

@synthesize backgroundmanagedObjectContext;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;
@synthesize limit;
@synthesize offset;

#pragma mark - INITIALIZATION

- (id) init {
    if (self = [super init]) {
        [self createManagedObjectContext];
    }
    return self;
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Jorge-Sanmartin.ACN" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)createManagedObjectContext {
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ACN" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // Create the coordinator and store
    
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ACN.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
    [self.managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    self.managedObjectContext.retainsRegisteredObjects = YES;
}



#pragma mark - UTILITY METHODS

- (void) cloneFieldsFromManagedObject:(NSManagedObject *)fromManagedObject toManagedObject:(NSManagedObject *)toManagedObject {
    NSString *entityName = [[fromManagedObject entity] name];
    //loop through all attributes and assign then to the clone
    NSDictionary *attributes = [[NSEntityDescription
                                 entityForName:entityName
                                 inManagedObjectContext:self.managedObjectContext] attributesByName];
    
    for (NSString *attr in attributes) {
        [toManagedObject setValue:[fromManagedObject valueForKey:attr] forKey:attr];
    }
}

- (NSUInteger) countManagedObjectsWithEntityName:(NSString*)entityName {
    // 1. Creamos el fetch request.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchOffset = offset;
    fetchRequest.fetchLimit = limit;
    
    // 2. Seteamos la entidad.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&err];
    
    return count;
}


- (NSUInteger) countManagedObjectsWithEntityName:(NSString*)entityName predicate:(NSPredicate *)predicate{
    
    // 1. Creamos el fetch request.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchOffset = offset;
    fetchRequest.fetchLimit = limit;
    
    // 2. Seteamos la entidad.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setIncludesSubentities:NO];//Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&err];
    
    return count;
    
}

- (NSArray*) getAllManagedObjectsWithEntityName:(NSString *)entityName {
    return [self getAllManagedObjectsWithEntityName:entityName orderByArray:nil ascendingArray:nil];
}


- (NSArray*) getAllManagedObjectsWithEntityName:(NSString *)entityName
                                   orderByArray:(NSArray *)orderBy
                                 ascendingArray:(NSArray *)ascending {
    // 1. Creamos el fetch request.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchOffset = offset;
    fetchRequest.fetchLimit = limit;
    
    // 2. Seteamos la entidad.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    // 3. Seteamos le orden
    if(orderBy != nil) {
        NSInteger count = [orderBy count];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
        for (int i=0; i < count; i++) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:(NSString *)[orderBy objectAtIndex:i]
                                                                           ascending:[[ascending objectAtIndex:i] boolValue]];
            [array addObject:sortDescriptor];
        }
        [fetchRequest setSortDescriptors:array];
    }
    
    // 4. Finalmente realizamos la consulta
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return result;
    
}

-(NSArray*)getFirstManagedObjectsWithEntityName:(NSString*)entityName
                                        orderBy:(NSString*)orderBy
                                      ascending:(BOOL)ascending {
    
    
    NSArray *order = [NSArray arrayWithObject:orderBy];
    NSArray *asc = [NSArray arrayWithObject:[NSNumber numberWithBool:ascending]];
    
    // 1. Creamos el fetch request.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchLimit = 1;
    
    // 2. Seteamos la entidad.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    // 3. Seteamos le orden
    if(order != nil) {
        NSUInteger count = [order count];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
        for (int i=0; i<count; i++) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:(NSString *)[order objectAtIndex:i]
                                                                           ascending:[[asc objectAtIndex:i] boolValue]];
            [array addObject:sortDescriptor];
        }
        [fetchRequest setSortDescriptors:array];
    }
    
    // 4. Finalmente realizamos la consulta
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return result;
}


-(NSArray*)getAllManagedObjectsWithEntityName:(NSString*)entityName
                                      orderBy:(NSString*)orderBy
                                    predicate:(NSPredicate *)predicate
                                    ascending:(BOOL)ascending {
    
    return [self getManagedObjectsWithEntityName:entityName predicate:predicate orderByArray:[NSArray arrayWithObject:orderBy] ascendingArray:[NSArray arrayWithObject:[NSNumber numberWithBool:ascending]]];
    
}

-(NSArray*)getAllManagedObjectsWithEntityName:(NSString*)entityName
                                      orderBy:(NSString*)orderBy
                                    ascending:(BOOL)ascending {
    return [self getAllManagedObjectsWithEntityName:entityName orderByArray:[NSArray arrayWithObject:orderBy] ascendingArray:[NSArray arrayWithObject:[NSNumber numberWithBool:ascending]]];
}

- (NSArray*) getManagedObjectsWithEntityName:(NSString*)entityName
                                   predicate:(NSPredicate*)predicate {
    return [self getManagedObjectsWithEntityName:entityName predicate:predicate orderByArray:nil ascendingArray:nil];
}

- (NSArray *) getManagedObjectsWithEntityName:(NSString *)entityName
                                    predicate:(NSPredicate *)predicate
                                 orderByArray:(NSArray *)orderBy
                               ascendingArray:(NSArray *)ascending {
    
    // 1. Creamos el fetch request.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchOffset = offset;
    fetchRequest.fetchLimit = limit;
    
    // 2. Seteamos la entidad.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // 3. Seteamos un predicado
    [fetchRequest setPredicate:predicate];
    
    // 4. Seteamos le orden
    if(orderBy != nil) {
        NSUInteger count = [orderBy count];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
        for (int i=0; i<count; i++) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:(NSString *)[orderBy objectAtIndex:i]
                                                                           ascending:[[ascending objectAtIndex:i] boolValue]];
            [array addObject:sortDescriptor];
        }
        [fetchRequest setSortDescriptors:array];
    }
    
    // 5. Finalmente realizamos la consulta
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return result;
}

-(NSArray*)getManagedObjectsWithEntityName:(NSString*)entityName
                                 predicate:(NSPredicate*)predicate
                                   orderBy:(NSString*)orderBy
                                 ascending:(BOOL)ascending {
    
    return [self getManagedObjectsWithEntityName:entityName predicate:predicate orderByArray:[NSArray arrayWithObject:orderBy] ascendingArray:[NSArray arrayWithObject:[NSNumber numberWithBool:ascending]]];
}

-(NSArray*)getManagedObjectsWithEntityName:(NSString*)entityName
                                 predicate:(NSPredicate*)predicate
                                   orderBy:(NSString*)orderBy
                                 ascending:(BOOL)ascending offset:(NSInteger)moffset limit:(NSInteger)mlimit groupBy:(NSArray *)group{
    
    return [self getManagedObjectsWithEntityName:entityName predicate:predicate orderByArray:[NSArray arrayWithObject:orderBy] ascendingArray:[NSArray arrayWithObject:[NSNumber numberWithBool:ascending]] offset:moffset limit:mlimit groupBy:group];
}


- (NSArray *) getManagedObjectsWithEntityName:(NSString *)entityName
                                    predicate:(NSPredicate *)predicate
                                 orderByArray:(NSArray *)orderBy
                               ascendingArray:(NSArray *)_ascending offset:(NSInteger)moffset limit:(NSInteger)mlimit groupBy:(NSArray *)groupBY{
    
    
    
    // 1. Creamos el fetch request.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.fetchOffset = moffset;
    fetchRequest.fetchLimit = mlimit;
    
    // 2. Seteamos la entidad.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    // 3. Seteamos un predicado
    [fetchRequest setPredicate:predicate];
    
    // 4. Seteamos le orden
    if(orderBy != nil) {
        NSInteger count = [orderBy count];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:count];
        for (int i=0; i<count; i++) {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:(NSString *)[orderBy objectAtIndex:i]
                                                                           ascending:[[_ascending objectAtIndex:i] boolValue]];
            [array addObject:sortDescriptor];
        }
        [fetchRequest setSortDescriptors:array];
    }
    
    // 5. Finalmente realizamos la consulta
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return result;
}

-(NSArray*)getManagedObjectsWithFetchRequestName:(NSString*)fetchRequestName {
    
    // 1. Obtenemos el fetch request.
    NSFetchRequest *fetchRequest = [self.managedObjectModel fetchRequestTemplateForName:fetchRequestName];
    
    
    // 2. Realizamos la consulta
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return result;
}

-(NSManagedObject*)getManagedObjectWithEntityName:(NSString*)entityName
                                        predicate:(NSPredicate*)predicate {
    
    // 1. Creamos el fetch request.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // 2. Seteamos la entidad.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // 3. Seteamos un predicado
    [fetchRequest setPredicate:predicate];
    
    // 4. Solo traemos un objeto como maximo
    [fetchRequest setFetchLimit:1];
    
    // 4. Finalmente realizamos la consulta
    NSError *error = nil;
    NSArray *result = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // 5. Devolvemos el primer objeto
    if ([result count] > 0) {
        return [result objectAtIndex:0];
    } else {
        return nil;
    }
    
}

-(NSManagedObject*)createManagedObjectWithEntityName:(NSString*)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:self.managedObjectContext];
}

-(void)removeManagedObject:(NSManagedObject*)managedObject {
    [self.managedObjectContext deleteObject:managedObject];
}

-(void)removeAllManagerObjects:(NSString*)entityName
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [managedObjectContext deleteObject:managedObject];
    }
    if (![managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityName,error);
    }
}


- (BOOL)saveManagedObjectChanges {
    NSError *error = nil;
    NSManagedObjectContext *_managedObjectContext = self.managedObjectContext;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //            abort();
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}

- (void)undoManagedObjectChanges {
    NSManagedObjectContext *_managedObjectContext = self.managedObjectContext;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges]) {
            [_managedObjectContext undo];
        }
    }
    
}

@end
