//
//  PLCoreDataManager.m
//  ProductList
//
//  Created by Bhaskar N on 15/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PLCoreDataManager.h"

static PLCoreDataManager *sharedManager = nil;

@implementation PLCoreDataManager

@synthesize managedObjectContext = managedObjectContext_;
@synthesize managedObjectModel = managedObjectModel_;
@synthesize persistentStoreCoordinator = persistentStoreCoordinator_;

#pragma mark -
#pragma mark SingleTon Object Creation

+ (PLCoreDataManager *)sharedManager
{
	@synchronized(self) {
		if (sharedManager == nil) {
			sharedManager = [[PLCoreDataManager alloc] init];
		}
	}
	
	return sharedManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
	@synchronized(self) 
	{
		if (sharedManager == nil) 
		{
			sharedManager = [super allocWithZone:zone];
			
			return sharedManager;  
		}
	}
	return nil; 
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext 
{    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel 
{    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"ProductList" ofType:@"momd"];
    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator 
{    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"ProductList.sqlite"]];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
	
	// try to automatically update.
	NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */		
        abort();
    }    
    
    return persistentStoreCoordinator_;
}

- (NSEntityDescription *)entityDescriptionForEntity:(NSString *)entityName
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName 
                                                         inManagedObjectContext:[self managedObjectContext]];
    return entityDescription;
}

- (NSFetchRequest *)fetchRequest
{
    NSFetchRequest *newFetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    return newFetchRequest;
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory 
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Core-Data Helper Methods

- (NSArray *)objectsFromEntity:(NSString *)entityName
{
    NSManagedObjectContext *objectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [self fetchRequest];
    NSEntityDescription *entityDescription = [self entityDescriptionForEntity:entityName];
    [fetchRequest setEntity:entityDescription];
    NSError *error = nil;
    
    NSArray *resultArray = [objectContext executeFetchRequest:fetchRequest error:&error];
    return resultArray;
}

- (NSArray *)objectsFromEntity:(NSString *)entityName usingPredicate:(NSPredicate *)predicate
{
    NSManagedObjectContext *objectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [self fetchRequest];
    NSEntityDescription *entityDescription = [self entityDescriptionForEntity:entityName];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    
    NSArray *resultArray = [objectContext executeFetchRequest:fetchRequest error:&error];
    return resultArray;
}

- (id)getNewObjectForEntity:(NSString *)entityName
{
    id newEntityObj = [NSEntityDescription insertNewObjectForEntityForName:entityName 
                                                    inManagedObjectContext:[self managedObjectContext]];
    return newEntityObj;
}

- (void)deleteAllObjectsFromEntity:(NSString *)entityName
{
    NSManagedObjectContext *objectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [self fetchRequest];
    NSEntityDescription *entityDescription = [self entityDescriptionForEntity:entityName];
    [fetchRequest setEntity:entityDescription];
    NSError *error = nil;
    
    NSArray *resultArray = [objectContext executeFetchRequest:fetchRequest error:&error];
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [objectContext deleteObject:obj];
    }];
    
    [self saveModelContext];
}

- (void)deleteObjectsFromEntity:(NSString *)entityName usingPredicate:(NSPredicate *)predicate
{
    NSManagedObjectContext *objectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [self fetchRequest];
    NSEntityDescription *entityDescription = [self entityDescriptionForEntity:entityName];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    
    NSArray *resultArray = [objectContext executeFetchRequest:fetchRequest error:&error];
    [resultArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [objectContext deleteObject:obj];
    }];
    
    [self saveModelContext];
}

- (void)deleteObject:(NSManagedObject *)managedObject
{
    NSManagedObjectContext *objectContext = [self managedObjectContext];
    [objectContext deleteObject:managedObject]; 
    
    [self saveModelContext];
}

- (int)countObjectsForEntity:(NSString *)entityName usingPredicate:(NSPredicate *)predicateOrNil
{
    NSManagedObjectContext *objectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [self fetchRequest];
    NSEntityDescription *entityDescription = [self entityDescriptionForEntity:entityName];
    [fetchRequest setEntity:entityDescription];
    if (predicateOrNil) {
        [fetchRequest setPredicate:predicateOrNil];
    }
	NSError *error = nil;
    
	int count = [objectContext countForFetchRequest:fetchRequest error:&error];    
    return count;
}

- (void)saveModelContext
{
    NSManagedObjectContext *objectContext = [self managedObjectContext];
    NSError *error = nil;
    
    @synchronized(self) {
        if (objectContext != nil)
        {
            if ([objectContext hasChanges] && ![objectContext save:&error])
            {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
                 */
                NSLog(@"Failed to save context with error %@, %@", error, [error userInfo]);
                abort();
            } 
        }
    }
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc 
{
	[persistentStoreCoordinator_ release];
    [managedObjectModel_ release];
    [managedObjectModel_ release];
    
    [super dealloc];
}

@end