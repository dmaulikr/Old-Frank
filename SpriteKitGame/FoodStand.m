//
//  FoodStand.m
//  Old Frank
//
//  Created by Skyler Lauren on 3/14/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "FoodStand.h"
#import "SMDCoreDataHelper.h"

@interface FoodStand ()

@end

@implementation FoodStand

-(id)initWithEntity:(FoodStandEntity *)foodStandEntity
{
    self = [self init];
    
    self.foodStandEntity = foodStandEntity;
    
    NSMutableArray *items = [[NSMutableArray alloc]init];

    for (ItemEntity *itemEntity in [self.foodStandEntity.items allObjects])
    {
        Item *item = [[Item alloc]initWithItemEntity:itemEntity];
        [items addObject:item];
    }
    
    self.items = items;
    
    return self;
}

-(id)init
{
    self = [super init];
    
    self.items = [[NSMutableArray alloc] init];

    return self;
}

-(void)addItemToFoodStand:(Item *)item fromPlayer:(Player *)player
{
    if(self.items.count < 3)
    {
        [player removeItemToInventory:item];
        
        item.itemEntity.food_stand = self.foodStandEntity;
        [[SMDCoreDataHelper sharedHelper]save];
        
        [self.items addObject:item];
    }
}

-(void)removeItemFromFoodStand:(Item *)item andGiveToPlayer:(Player *)player
{
    item.itemEntity.food_stand = nil;
    [player addItemToInventory:item];
    
    [self.items removeObject:item];
    
    [[SMDCoreDataHelper sharedHelper]save];
}

@end
