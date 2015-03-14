//
//  MapNode.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 5/3/14.
//  Copyright (c) 2014 Sky Mist Development. All rights reserved.
//

#import "MapNode.h"
#import "TileStack.h"
#import "MapTile.h"
#import "PlantManager.h"
#import "MapTrigger.h"
#import "MapEntity.h"
#import "SMDCoreDataHelper.h"
#import "TileStackNode.h"
#import "ItemSprite.h"
#import "AnimatedItem.h"
#import "SMDTextureLoader.h"

@interface MapNode ()

@property (nonatomic, strong)SKSpriteNode *outlineSprite;
@property (nonatomic, strong)NSArray *farmPlots;

@property (nonatomic, strong)NSArray *mapTriggers;

@property (nonatomic)CGPoint playerStart;

@property (nonatomic)BOOL addObjects;

@property (nonatomic, strong)NSArray *tileStackNodes;

@property (nonatomic, strong)SMDTextureLoader *textureLoader;

@end

@implementation MapNode

-(id)initWithMap:(Map *)map
{
    self = [super init];
    
    if (self) {
        self.textureLoader = [[SMDTextureLoader alloc]init];
        NSLog(@"Loading Map now");
        self.map = map;
        [self loadMap:map];
    }
    
    return self;
}

-(void)loadMap:(Map *)map
{
    NSLog(@"looping");
    
    PlayerAnimatedSpriteNode *animatedSprite = [[PlayerAnimatedSpriteNode alloc]initWithPlayer:self.map.player];
    animatedSprite.zPosition = 4;
    self.animatedSpriteNode = animatedSprite;
    [self addChild:animatedSprite];
    
    NSMutableArray *tiles = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < map.mapWidth; i++)
    {
        NSMutableArray *rowArray = [[NSMutableArray alloc]init];
        
        for (NSInteger j = 0; j < map.mapHeight; j++)
        {
            TileStackNode *tilestackNode = [[TileStackNode alloc]init];
            [rowArray addObject:tilestackNode];
        }
        
        [tiles addObject:rowArray];
    }
    
    self.tileStackNodes = tiles;
    
    for (NSInteger i = 0; i < self.map.mapWidth; i++)
    {
        for (NSInteger j = 0; j < self.map.mapHeight; j++)
        {
            TileStack *tileStack = self.map.mapTiles[i][j];
            
            TileStackNode *tileStackNode = self.tileStackNodes[i][j];
            tileStackNode.tileStack = tileStack;
            
            tileStackNode.position = CGPointMake(tileStack.indexX * map.tileWidth, tileStack.indexY  * map.tileWidth);
            
            if (tileStack.backgroundItem)
            {
                
                NSString *itemName = tileStack.backgroundItem.itemName;
                
                SKTexture *texture = [self.textureLoader getTextureForName:itemName];
                
                ItemSprite *itemSprite = [ItemSprite spriteNodeWithTexture:texture];
                itemSprite.name = itemName;
                tileStackNode.backgroundItemSprite = itemSprite;
            }
            
            if (tileStack.objectItem) {

                NSString *itemName = tileStack.objectItem.itemName;
                
                SKTexture *texture = [self.textureLoader getTextureForName:itemName];

                
                
                
                ItemSprite *itemSprite = [ItemSprite spriteNodeWithTexture:texture];
                itemSprite.name = itemName;
                
                if ([tileStack.objectItem isKindOfClass:[AnimatedItem class]])
                {
                    AnimatedItem *animatedItem = (AnimatedItem *)tileStack.objectItem;
                    
                    NSMutableArray *textures = [[NSMutableArray alloc]init];
                    [textures addObject:texture];
                    
                    for (NSInteger i = 1; i < animatedItem.animatedFrames; i++)
                    {
                        NSString *numberString = [NSString stringWithFormat:@"0%@", @(i+1)];
                        NSString *secondString = [itemName stringByReplacingOccurrencesOfString:@"01" withString:numberString];
                        SKTexture *texture2 = [self.textureLoader getTextureForName:secondString];
                        [textures addObject:texture2];
                    }
                   
                    
                    SKAction *animated = [SKAction animateWithTextures:textures timePerFrame:animatedItem.animatedRate];
                    
                    SKAction *repeatAction = [SKAction repeatActionForever:animated];
                    [itemSprite runAction:repeatAction];
                }

                tileStackNode.objectItemSprite = itemSprite;

            }
            if (tileStack.foregroundItem)
            {
                NSString *itemName = tileStack.foregroundItem.itemName;
                
                SKTexture *texture = [self.textureLoader getTextureForName:itemName];
                
                ItemSprite *itemSprite = [ItemSprite spriteNodeWithTexture:texture];
                itemSprite.name = itemName;
                
                tileStackNode.foregroundItemSprite = itemSprite;

            }

            [self addChild:tileStackNode];
        }
    }
    
    NSLog(@"Done");

    self.outlineSprite = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"outline"]];
    self.outlineSprite.zPosition = 3;
    [self addChild:self.outlineSprite];
    
    if (map.foodStand)
    {
        [self updateFoodStand:map.foodStand];
    }
}

-(void)update
{
    [self.animatedSpriteNode update];
    self.outlineSprite.position = self.map.outlinePosition;
    
    for (NSValue *value in self.map.dirtyIndexes)
    {
        CGPoint index = [value CGPointValue];

        [self updateTileStackAtIndex:index];
    }
    
    if (self.map.updateFoodStand)
    {
        [self updateFoodStand:self.map.foodStand];
    }
}

-(void)updateTileStackAtIndex:(CGPoint)index
{
    MapIndex mapIndex;
    mapIndex.x = index.x;
    mapIndex.y = index.y;
    
    TileStackNode *tileStackNode = self.tileStackNodes[mapIndex.x][mapIndex.y];
    TileStack *tileStack = self.map.mapTiles[mapIndex.x][mapIndex.y];
    
    if (![tileStackNode.backgroundItemSprite.name isEqualToString:tileStack.backgroundItem.itemName])
    {
        ItemSprite *itemSprite;
        
        if (tileStack.backgroundItem)
        {
            NSString *itemName = tileStack.backgroundItem.itemName;
            itemSprite = [[ItemSprite alloc]initWithTexture:[self.textureLoader getTextureForName:itemName]];
            itemSprite.name = itemName;
        }
       
        tileStackNode.backgroundItemSprite = itemSprite;
    }
    
    if (![tileStackNode.objectItemSprite.name isEqualToString:tileStack.objectItem.itemName])
    {
        ItemSprite *itemSprite;
        
        if (tileStack.objectItem)
        {
            NSString *itemName = tileStack.objectItem.itemName;
            itemSprite = [[ItemSprite alloc]initWithTexture:[self.textureLoader getTextureForName:itemName]];
            itemSprite.name = itemName;
        }
        
        tileStackNode.objectItemSprite = itemSprite;
    }

    if (![tileStackNode.foregroundItemSprite.name isEqualToString:tileStack.foregroundItem.itemName])
    {
        ItemSprite *itemSprite;
        
        if (tileStack.foregroundItem)
        {
            NSString *itemName = tileStack.foregroundItem.itemName;
            itemSprite = [[ItemSprite alloc]initWithTexture:[self.textureLoader getTextureForName:itemName]];
            itemSprite.name = itemName;
        }
        
        tileStackNode.foregroundItemSprite = itemSprite;
    }
}

-(void)updateFoodStand:(FoodStand *)foodStand
{
    NSInteger x = [foodStand.foodStandEntity.item_1_index_x integerValue];
    NSInteger y = [foodStand.foodStandEntity.item_1_index_y integerValue];
    
    for (NSInteger i = 0; i < 3; i++)
    {
        TileStackNode *tileStackNode = self.tileStackNodes[x+i][y];
        SKSpriteNode *objectSprite = tileStackNode.objectItemSprite;
        
        //removing old sprites
        for (SKSpriteNode *sprite in objectSprite.children)
        {
            [sprite removeFromParent];
        }
    }
    
    NSInteger index = 0;
    
    for (Item *item in foodStand.items)
    {
        TileStackNode *tileStackNode = self.tileStackNodes[x+index][y];
        SKSpriteNode *objectSprite = tileStackNode.objectItemSprite;
        
        SKSpriteNode *itemSprite = [[ItemSprite alloc]initWithTexture:[self.textureLoader getTextureForName:item.itemName]];
        itemSprite.name = item.itemName;
        itemSprite.zPosition = 1;
        [objectSprite addChild:itemSprite];
        
        [tileStackNode.backgroundItemSprite removeFromParent];

        index++;
    }
}

-(void)launchProjectile:(Item *)item atPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    AnimatedItem *animatedItem = (AnimatedItem *)item;
    
    NSMutableArray *textures = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < animatedItem.animatedFrames; i++)
    {
        NSString *textureString = [item.itemName stringByReplacingOccurrencesOfString:@"01" withString:[NSString stringWithFormat:@"0%@", @(i+1)]];
        SKTexture *texture = [self.textureLoader getTextureForName:textureString];
        [textures addObject:texture];
    }
    
    SKSpriteNode *projectile = [SKSpriteNode spriteNodeWithTexture:textures[0]];
    projectile.position = startPoint;
    projectile.zPosition = 4;
    [self addChild:projectile];
    
    SKAction *animateAction = [SKAction animateWithTextures:textures timePerFrame:animatedItem.animatedRate];
    SKAction *repeatAction = [SKAction repeatActionForever:animateAction];
    [projectile runAction:repeatAction];
    
    SKAction *moveAction = [SKAction moveTo:endPoint duration:.5];
    SKAction *waitAction = [SKAction waitForDuration:1];
    SKAction *fadeAction = [SKAction fadeAlphaTo:0 duration:.2];
    SKAction *customAction = [SKAction customActionWithDuration:0 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        [self.delegate doneWithProjectile:item atPoint:endPoint];
    }];
    
    SKAction *removeAction = [SKAction removeFromParent];
    
    SKAction *sequence = [SKAction sequence:@[moveAction, waitAction, customAction, fadeAction, removeAction]];
    [projectile runAction:sequence];
    
}

@end
