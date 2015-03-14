//
//  ItemEntity.h
//  Old Frank
//
//  Created by Skyler Lauren on 3/14/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodStandEntity, PlayerEntity, TileStackEntity;

@interface ItemEntity : NSManagedObject

@property (nonatomic, retain) NSString * item_name;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) PlayerEntity *player_inventory;
@property (nonatomic, retain) PlayerEntity *player_item;
@property (nonatomic, retain) PlayerEntity *player_tool;
@property (nonatomic, retain) TileStackEntity *tile_stack_background;
@property (nonatomic, retain) TileStackEntity *tile_stack_foreground;
@property (nonatomic, retain) TileStackEntity *tile_stack_object;
@property (nonatomic, retain) FoodStandEntity *food_stand;

@end
