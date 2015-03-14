//
//  FoodStand.h
//  Old Frank
//
//  Created by Skyler Lauren on 3/14/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "Player.h"
#import "FoodStandEntity.h"

@interface FoodStand : NSObject

@property (nonatomic, strong)NSMutableArray *items;
@property (nonatomic, strong)FoodStandEntity *foodStandEntity;

-(id)initWithEntity:(FoodStandEntity *)foodStandEntity;

-(void)addItemToFoodStand:(Item *)item fromPlayer:(Player *)player;
-(void)removeItemFromFoodStand:(Item *)item andGiveToPlayer:(Player *)player;

@end
