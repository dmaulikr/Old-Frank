//
//  Player.h
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/5/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import "PlayerEntity.h"

typedef NS_ENUM(NSUInteger, Direction) {
    DirectionUp,
    DirectionDown,
    DirectionLeft,
    DirectionRight
};


@interface Player : NSObject

@property (nonatomic, strong)PlayerEntity *playerEntity;

@property (nonatomic, strong)NSMutableArray *inventory;
@property (nonatomic)Direction direction;
@property (nonatomic, strong)Item *equippedItem;
@property (nonatomic, strong)Item *equippedTool;

@property (nonatomic)float energy;
@property (nonatomic)float maxEnergy;
@property (nonatomic)NSInteger gold;

@property (nonatomic)NSInteger wateringSkill;
@property (nonatomic)NSInteger hoeSkill;
@property (nonatomic)NSInteger hammerSkill;
@property (nonatomic)NSInteger spellbookSkill;
@property (nonatomic)NSInteger swordSkill;
@property (nonatomic)NSInteger axeSkill;

@property (nonatomic)CGPoint position;

@property (nonatomic)float frameTimerMax;
@property (nonatomic)float frameTimer;
@property (nonatomic)NSInteger frameIndex;

@property (nonatomic)NSInteger numberOfFrames;
@property (nonatomic)BOOL isMoving;

@property (nonatomic, strong)NSString *imageName;
@property (nonatomic)NSInteger rows;
@property (nonatomic)NSInteger columns;
@property (nonatomic)NSInteger width;
@property (nonatomic)NSInteger height;

@property (nonatomic, strong)NSArray *collisionRects;

@property (nonatomic)CGPoint moveVelocity;
@property (nonatomic)CGPoint moveToPoint;
@property (nonatomic)BOOL skilledUp;

-(void)update:(float)dt;

-(void)addItemWithName:(NSString *)name;
-(void)addItemWithName:(NSString *)name withCount:(NSInteger)count;

-(void)equipItem:(Item *)item;

-(void)unequipTool;
-(void)unequipItem;

-(void)removeItem;

-(void)addItemToInventory:(Item *)item;
-(void)removeItemToInventory:(Item *)item;

-(void)useTool;

@end
