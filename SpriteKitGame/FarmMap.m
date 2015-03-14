//
//  FarmMap.m
//  Old Frank
//
//  Created by Skyler Lauren on 3/14/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "FarmMap.h"
#import "SMDCoreDataHelper.h"

@implementation FarmMap

-(void)addRandomObjects
{
    NSArray *objectArray = @[@"rose", @"",@"stump", @"",@"",@"weed",@"weed",@"weed",@"",@"",@"small_rock",@"small_rock",@"medium_rock",@"", @"large_rock", @"", @"", @"large_rock", @"", @"", @"", @"", @"", @"", @"", @""];
    
    for (TileStack *tileStack in self.farmPlots)
    {
        if (!tileStack.isTilled && !tileStack.objectItem)
        {
            NSInteger random = arc4random() % objectArray.count;
            NSString *randomItemName = objectArray[random];
            
            if (randomItemName.length)
            {
                Item *item = [[ItemManager sharedManager]getItem:randomItemName];
                tileStack.objectItem = item;
            }
        }
    }
}

-(void)updateForNewDay
{
    [super updateForNewDay];
    
    for (TileStack *tileStack in self.farmPlots)
    {
        [tileStack updateForNewDay];
        
        CGPoint index = CGPointMake(tileStack.indexX, tileStack.indexY);
        
        [self.dirtyIndexes addObject:[NSValue valueWithCGPoint:index]];
    }
    
    [self addRandomObjects];
//    [self addRandomSeedBag];
    
    NSInteger earnedGold = 0;
    
    if (self.foodStand)
    {
        
        for (Item *item in self.foodStand.items.copy)
        {
            self.updateFoodStand = YES;
            earnedGold += (item.sellPrice*item.quantity);
            [[SMDCoreDataHelper sharedHelper]removeEntity:item.itemEntity andSave:NO];
            [self.foodStand.items removeObject:item];
        }
    }
    
    self.player.gold += earnedGold;

}

-(void)addRandomSeedBag
{
    for (NSInteger i = 0; i < 2; i++)
    {
        Item *seeds;
        
        while (!seeds)
        {
            NSInteger randomX = arc4random() % self.mapWidth;
            NSInteger randomY = arc4random() % self.mapHeight;
            TileStack *tileStack = self.mapTiles[randomX][randomY];
            
            if (!tileStack.objectItem)
            {
                seeds = [[ItemManager sharedManager]getItem:@"corn_seeds"];
                tileStack.objectItem = seeds;
                
                CGPoint index = CGPointMake(tileStack.indexX, tileStack.indexY);
                
                [self.dirtyIndexes addObject:[NSValue valueWithCGPoint:index]];
                
            }
        }
    }
}


@end
