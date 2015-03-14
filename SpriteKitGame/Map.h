//
//  Map.h
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/15/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "TileStack.h"
#import "DialogManager.h"
#import "ItemManager.h"
#import "FoodStand.h"

typedef struct {
    NSInteger x;
    NSInteger y;
} MapIndex;

typedef NS_ENUM(NSUInteger, ActionButtonType) {
    ActionButtonTypeNone,
    ActionButtonTypeHarvest,
    ActionButtonTypeSleep,
    ActionButtonTypeTalk,
    ActionButtonTypeOpen,
};

@protocol MapDelegate <NSObject>

-(void)loadMapWithName:(NSString *)mapName;
-(void)displayDialog:(Dialog *)dialog withBlock:(DialogBlock)completion;
-(void)launchProjectile:(Item *)projectile fromPoint:(CGPoint)startPoint toPoint:(CGPoint)point;
-(void)showFoodStand:(FoodStand *)foodStand;
-(void)showStore;

@end

@interface Map : NSObject

@property (nonatomic)NSInteger tileWidth;

@property (nonatomic)NSInteger mapWidth;
@property (nonatomic)NSInteger mapHeight;

@property (nonatomic, strong)NSArray *mapTiles;
@property (nonatomic, strong)NSArray *impassableArray;
@property (nonatomic, strong)Player *player;
@property (nonatomic)CGPoint outlinePosition;

@property (nonatomic)float currentTime;

@property (nonatomic)BOOL updateTime;
@property (nonatomic)BOOL canUseActionButton;
@property (nonatomic)ActionButtonType actionButtonType;

@property (nonatomic, strong)NSMutableArray *dirtyIndexes;
@property (nonatomic, strong)NSArray *farmPlots;
@property (nonatomic, strong)FoodStand *foodStand;
@property (nonatomic)BOOL updateFoodStand;

@property (weak)id <MapDelegate> delegate;

-(id)initWithFileName:(NSString *)fileName;

-(void)updateForNewDay;
-(void)update:(float)dt;

-(void)primaryButtonPressedForPlayer:(Player *)player;
-(void)actionButtonPressedForPlayer:(Player *)player;

-(void)doneWithProjectile:(Item *)projectile atPoint:(CGPoint)point;


-(TileStack *)tileStackForPlayer:(Player *)player;
-(void)clean;

@end
