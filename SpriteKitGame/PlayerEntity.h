//
//  PlayerEntity.h
//  Old Frank
//
//  Created by Skyler Lauren on 5/31/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ItemEntity;

@interface PlayerEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * energy;
@property (nonatomic, retain) NSNumber * gold;
@property (nonatomic, retain) NSNumber * health;
@property (nonatomic, retain) NSNumber * max_energy;
@property (nonatomic, retain) NSNumber * max_health;
@property (nonatomic, retain) NSNumber * watering_skill;
@property (nonatomic, retain) NSNumber * hoe_skill;
@property (nonatomic, retain) NSNumber * hammer_skill;
@property (nonatomic, retain) NSNumber * sword_skill;
@property (nonatomic, retain) NSNumber * spellbook_skill;
@property (nonatomic, retain) NSNumber * axe_skill;
@property (nonatomic, retain) NSNumber * watering_uses;
@property (nonatomic, retain) NSNumber * hoe_uses;
@property (nonatomic, retain) NSNumber * hammer_uses;
@property (nonatomic, retain) NSNumber * spellbook_uses;
@property (nonatomic, retain) NSNumber * sword_uses;
@property (nonatomic, retain) NSNumber * axe_uses;
@property (nonatomic, retain) ItemEntity *equipped_tool;
@property (nonatomic, retain) ItemEntity *equppied_item;
@property (nonatomic, retain) NSSet *inventory;
@end

@interface PlayerEntity (CoreDataGeneratedAccessors)

- (void)addInventoryObject:(ItemEntity *)value;
- (void)removeInventoryObject:(ItemEntity *)value;
- (void)addInventory:(NSSet *)values;
- (void)removeInventory:(NSSet *)values;

@end
