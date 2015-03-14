//
//  MapEntity.h
//  Old Frank
//
//  Created by Skyler Lauren on 3/18/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodStandEntity, MapTriggerEntity, TileStackEntity;

@interface MapEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * add_objects;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSString * map_name;
@property (nonatomic, retain) NSNumber * start_x;
@property (nonatomic, retain) NSNumber * start_y;
@property (nonatomic, retain) NSNumber * tile_width;
@property (nonatomic, retain) NSNumber * update_time;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) FoodStandEntity *food_stand;
@property (nonatomic, retain) NSSet *tiles;
@property (nonatomic, retain) NSSet *triggers;
@end

@interface MapEntity (CoreDataGeneratedAccessors)

- (void)addTilesObject:(TileStackEntity *)value;
- (void)removeTilesObject:(TileStackEntity *)value;
- (void)addTiles:(NSSet *)values;
- (void)removeTiles:(NSSet *)values;

- (void)addTriggersObject:(MapTriggerEntity *)value;
- (void)removeTriggersObject:(MapTriggerEntity *)value;
- (void)addTriggers:(NSSet *)values;
- (void)removeTriggers:(NSSet *)values;

@end
