//
//  MapNode.h
//  SpriteKitGame
//
//  Created by Skyler Lauren on 5/3/14.
//  Copyright (c) 2014 Sky Mist Development. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PlayerAnimatedSpriteNode.h"
#import "Map.h"
#import "Item.h"

@protocol MapNodeDelegate <NSObject>

-(void)doneWithProjectile:(Item *)projectile atPoint:(CGPoint)point;

@end

@interface MapNode : SKNode


@property (nonatomic, strong)Map *map;

-(id)initWithMap:(Map *)map;

-(void)update;
-(void)updateFoodStand:(FoodStand *)foodStand;

-(void)launchProjectile:(Item *)item atPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint;

@property (nonatomic, strong)AnimatedSpriteNode *animatedSpriteNode;
@property (nonatomic, weak)id<MapNodeDelegate> delegate;

@end
