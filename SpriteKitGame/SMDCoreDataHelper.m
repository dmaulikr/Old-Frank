//
//  SMDCoreDataHelper.m
//  ScavangerHunt
//
//  Created by Skyler Lauren on 4/28/14.
//  Copyright (c) 2014 Sky Mist Development. All rights reserved.
//

#import "SMDCoreDataHelper.h"

@interface SMDCoreDataHelper ()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation SMDCoreDataHelper

#pragma mark - Inits

+(SMDCoreDataHelper *)sharedHelper
{
    static SMDCoreDataHelper *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[SMDCoreDataHelper alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - FetchRequests

-(NSArray *)fetchEntities:(NSString *)entityName
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entityName];
    
    NSError *error;
    NSArray * entityArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"CoreDataError: %@", error.localizedDescription);
    }
    
    return entityArray;
}

-(NSArray *)fetchEntities:(NSString *)entityName withPreditcate:(NSPredicate *)predicate
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entityName];
    
    request.predicate = predicate;
    
    NSError *error;
    NSArray * entityArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"CoreDataError: %@", error.localizedDescription);
    }
    
    return entityArray;
}

-(NSArray *)fetchEntities:(NSString *)entityName withSortDescriptors:(NSArray *)descriptors
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entityName];
    
    request.sortDescriptors = descriptors;
    
    NSError *error;
    NSArray * entityArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error)
    {
        NSLog(@"CoreDataError: %@", error.localizedDescription);
    }
    
    return entityArray;
}

-(NSArray *)fetchEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entityName];
    
    request.predicate = predicate;
    request.sortDescriptors = descriptors;
    
    NSError *error;
    NSArray * entityArray = [self.managedObjectContext executeFetchRequest:request error:&error];

    if (error)
    {
        NSLog(@"CoreDataError: %@", error.localizedDescription);
    }
    
    return entityArray;
}

#pragma mark - counts

-(NSUInteger)countForEntities:(NSString*)entityName includeSubentities:(BOOL)shouldInclude
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]];
    
    [request setIncludesSubentities:shouldInclude];
    
    NSError *error;
    NSUInteger count = [self.managedObjectContext countForFetchRequest:request error:&error];

    if(count == NSNotFound || error) {
        //Handle error
        NSLog(@"Error while counting entities: %@", error);
    }
    
    return count;
}

#pragma mark - create/delete

-(id)createNewEntity:(NSString *)entityName
{
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
}

-(void)removeEntity:(NSManagedObject *)entity andSave:(BOOL)save
{
    [self.managedObjectContext deleteObject:entity];
    
    if (save)
    {
        [self save];
    }
}

-(void)save
{
    NSError *error;
    [self.managedObjectContext save:&error];
    
    if (error)
    {
        NSLog(@"CoreDataError: %@", error.localizedDescription);
    }
}


#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel= [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", kModelName]];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error])
    {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
