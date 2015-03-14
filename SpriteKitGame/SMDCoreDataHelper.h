//
//  SMDCoreDataHelper.h
//  ScavangerHunt
//
//  Created by Skyler Lauren on 4/28/14.
//  Copyright (c) 2014 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kModelName @"oldfrank" //override this to your .xcdatamodeld file name

@interface SMDCoreDataHelper : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


+(SMDCoreDataHelper *)sharedHelper;

-(NSArray *)fetchEntities:(NSString *)entityName;
-(NSArray *)fetchEntities:(NSString *)entityName withPreditcate:(NSPredicate *)predicate;
-(NSArray *)fetchEntities:(NSString *)entityName withSortDescriptors:(NSArray *)descriptors;
-(NSArray *)fetchEntities:(NSString *)entityName withPredicate:(NSPredicate *)predicate withSortDescriptors:(NSArray *)descriptors;

-(NSUInteger)countForEntities:(NSString*)entityName includeSubentities:(BOOL)shouldInclude;

-(id)createNewEntity:(NSString *)entityName;
-(void)removeEntity:(NSManagedObject *)entity andSave:(BOOL)save;

-(void)save;

@end
