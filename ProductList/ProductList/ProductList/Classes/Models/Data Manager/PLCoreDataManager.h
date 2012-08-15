//
//  PLCoreDataManager.h
//  ProductList
//
//  Created by Bhaskar N on 15/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface PLCoreDataManager : NSObject
{
@private
    NSManagedObjectContext          *managedObjectContext_;
    NSManagedObjectModel            *managedObjectModel_;
    NSPersistentStoreCoordinator    *persistentStoreCoordinator_;    
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

#pragma mark Class Specific Methods

/*!
 @method     sharedManager
 @abstract   returns the singleton object for this class
 @discussion to get a singleton object, call this method using class:[LARCoreDataManager sharedManager]
 */
+ (PLCoreDataManager *)sharedManager;

#pragma mark -
#pragma mark Core Data stack

/*!
 @method     managedObjectContext
 @abstract   
 @discussion 
 */
- (NSManagedObjectContext *)managedObjectContext;

/*!
 @method     managedObjectModel
 @abstract   
 @discussion 
 */
- (NSManagedObjectModel *)managedObjectModel;

/*!
 @method     persistentStoreCoordinator
 @abstract   
 @discussion 
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

/*!
 @method     entityDescriptionForEntity:
 @abstract   this method useful when NSFetchRequest is created with which entityName should query
 @discussion accepts entity name as input parameter to which entitydescription should return.
 */
- (NSEntityDescription *)entityDescriptionForEntity:(NSString *)entityName;

/*!
 @method     fetchRequest
 @abstract   returns new fetch request
 @discussion nil
 */
- (NSFetchRequest *)fetchRequest;

#pragma mark -
#pragma mark Core-Data Helper Methods

/*!
 @method     objectsFromEntity:
 @abstract   returns an array of model objects for the given entityName
 @discussion accepts entity name as a input parameter to which it should return objects of name entityName
 */
- (NSArray *)objectsFromEntity:(NSString *)entityName;

/*!
 @method     objectsFromEntity:usingPredicate:
 @abstract   returns an array of model objects for the given entityName using predicate string
 @discussion accepts entity name and predicate as input parameters to which it should return objects of name entityName 
             based on predicate string provided.
 */
- (NSArray *)objectsFromEntity:(NSString *)entityName usingPredicate:(NSPredicate *)predicate;

/*!
 @method     getNewObjectForEntity:
 @abstract   returns the new model object for the given entityName
 @discussion creates new entity object for the entityname which is provided as input parameter
 */
- (id)getNewObjectForEntity:(NSString *)entityName;

/*!
 @method     deleteAllObjectsFromEntity:
 @abstract   deletes all model objects for the give entityName
 @discussion accepts entity name as input parameter to delete objects of type entityName.
 */
- (void)deleteAllObjectsFromEntity:(NSString *)entityName;

/*!
 @method     deleteObjectsFromEntity:usingPredicate:
 @abstract   deletes model objects for the given entityName using predicate string
 @discussion accepts entity name as input parameter to delete objects of type entityName based on predicate string provided.
 */
- (void)deleteObjectsFromEntity:(NSString *)entityName usingPredicate:(NSPredicate *)predicate;

/*!
 @method     deleteObject:
 @abstract   deletes given model object from the context
 @discussion accepts managedobject as input parameter to delete.
 */
- (void)deleteObject:(NSManagedObject *)managedObject;

/*!
 @method     countObjectsForEntity:usingPredicate:
 @abstract   counts the number of objects for the given entityName using based on predicate string or not
 @discussion accepts entity name as input parameter to count objects of type entityName with/without predicate.
 */
- (int)countObjectsForEntity:(NSString *)entityName usingPredicate:(NSPredicate *)predicateOrNil;

/*!
 @method     saveModelContext
 @abstract   saves the core-data context.
 @discussion saves the core-data context if any changes happened in the model.
 */
- (void)saveModelContext;

/*!
 @method     applicationDocumentsDirectory
 @abstract   returns the path for the application's document directory
 @discussion 
 */
- (NSString *)applicationDocumentsDirectory;

@end