//
//  FoodStandNode.h
//  Old Frank
//
//  Created by Skyler Lauren on 3/11/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"
#import "FoodStand.h"

@protocol FoodStandControllerDelegate <NSObject>

-(void)doneWithFoodStand:(FoodStand *)foodStand;

@end

@interface FoodStandController : NSObject

@property (nonatomic, strong)SKSpriteNode *foodStandSpriteView;

-(id)initWithSize:(CGSize)size withFoodStand:(FoodStand *)foodStand withPlayer:(Player *)player;

@property (nonatomic, weak)id<FoodStandControllerDelegate> delegate;

@end
