//
//  FoodStandEntity.h
//  Old Frank
//
//  Created by Skyler Lauren on 3/18/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemEntity, MapEntity;

@interface FoodStandEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * item_1_index_x;
@property (nonatomic, retain) NSNumber * item_1_index_y;
@property (nonatomic, retain) NSNumber * item_2_index_x;
@property (nonatomic, retain) NSNumber * item_2_index_y;
@property (nonatomic, retain) NSNumber * item_3_index_x;
@property (nonatomic, retain) NSNumber * item_3_index_y;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) MapEntity *map;
@end

@interface FoodStandEntity (CoreDataGeneratedAccessors)

- (void)addItemsObject:(ItemEntity *)value;
- (void)removeItemsObject:(ItemEntity *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
