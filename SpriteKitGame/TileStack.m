//
//  TileStack.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/1/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "TileStack.h"
#import "ItemManager.h"
#import "SMDCoreDataHelper.h"
#import "ItemEntity.h"
#import "PlantEntity.h"

@implementation TileStack

-(void)setBackgroundItem:(Item *)backgroundItem
{
    if (self.tileStackEntity.background_item)
    {
        NSLog(@"removing: background");
        [[SMDCoreDataHelper sharedHelper]removeEntity:self.tileStackEntity.background_item andSave:YES];
    }
    
    if (backgroundItem && self.tileStackEntity)
    {
        ItemEntity *itemEntiy = [[SMDCoreDataHelper sharedHelper]createNewEntity:@"ItemEntity"];
        itemEntiy.item_name = backgroundItem.itemName;
        itemEntiy.quantity = @(backgroundItem.quantity);
        
        self.tileStackEntity.background_item = itemEntiy;
    }
    
    if(self.shouldSave)
        [[SMDCoreDataHelper sharedHelper]save];
    
    _backgroundItem = backgroundItem;
}

-(void)setObjectItem:(Item *)objectItem
{
    if (self.tileStackEntity.object_item )
    {
        NSLog(@"removing: object");

        [[SMDCoreDataHelper sharedHelper]removeEntity:self.tileStackEntity.object_item andSave:YES];
    }
    
    if (objectItem  && self.tileStackEntity)
    {
        ItemEntity *itemEntiy = [[SMDCoreDataHelper sharedHelper]createNewEntity:@"ItemEntity"];
        itemEntiy.item_name = objectItem.itemName;
        itemEntiy.quantity = @(objectItem.quantity);
        
        self.tileStackEntity.object_item = itemEntiy;
    }
    
    if(self.shouldSave)
        [[SMDCoreDataHelper sharedHelper]save];
    
    _objectItem = objectItem;
    
    if (objectItem && !objectItem.itemName)
    {
        NSLog(@"Error adding object without a name");
    }

}

-(void)setForegroundItem:(Item *)foregroundItem
{
    if (self.tileStackEntity.foreground_item)
    {
        NSLog(@"removing: foreground");

       [[SMDCoreDataHelper sharedHelper]removeEntity:self.tileStackEntity.foreground_item andSave:YES];
    }
    
    if (foregroundItem  && self.tileStackEntity)
    {
        ItemEntity *itemEntiy = [[SMDCoreDataHelper sharedHelper]createNewEntity:@"ItemEntity"];
        itemEntiy.item_name = foregroundItem.itemName;
        itemEntiy.quantity = @(foregroundItem.quantity);
        
        self.tileStackEntity.foreground_item = itemEntiy;
    }
    
    if(self.shouldSave)
        [[SMDCoreDataHelper sharedHelper]save];
    
    _foregroundItem = foregroundItem;
    
}

-(void)setIsFarmPlot:(BOOL)isFarmPlot
{
    self.tileStackEntity.is_farm_plot = @(isFarmPlot);
    
    _isFarmPlot = isFarmPlot;
}

-(void)setIsTilled:(BOOL)isTilled
{
    self.tileStackEntity.is_tilled = @(isTilled);
    _isTilled = isTilled;
}

-(void)setIsWatered:(BOOL)isWatered
{
    self.tileStackEntity.is_watered = @(isWatered);
    _isWatered = isWatered;
}

-(void)setIndexX:(NSInteger)indexX
{
    self.tileStackEntity.index_x = @(indexX);
    
    _indexX = indexX;
}

-(void)setIndexY:(NSInteger)indexY
{
    self.tileStackEntity.index_y = @(indexY);
    
    _indexY = indexY;
}

-(void)addItem:(Item *)item forLayer:(NSInteger)layer
{
    switch (layer) {
        case 0:
            self.backgroundItem = item;
            break;
        case 1:
            self.objectItem = item;
            break;
        case 2:
            self.foregroundItem = item;
            break;
            
        default:
            break;
    }
}

-(void)setPlant:(Plant *)plant
{
    if (self.tileStackEntity.plant)
    {
        NSLog(@"removing: plant");
        
        [[SMDCoreDataHelper sharedHelper]removeEntity:self.tileStackEntity.plant andSave:YES];
    }
    
    if (self.tileStackEntity && plant)
    {
        Item *item = [[ItemManager sharedManager]getItem:@"planted_seeds"];
        self.objectItem = item;
        
        PlantEntity *plantEntity = [[SMDCoreDataHelper sharedHelper]createNewEntity:@"PlantEntity"];
        plantEntity.plant_name = plant.plantName;
        plant.plantEntity = plantEntity;
        self.tileStackEntity.plant = plantEntity;
    }
    
    _plant = plant;
}

-(void)updateForNewDay
{
    if (self.isWatered && self.plant)
    {
        self.plant.daysWatered++;
        
        NSInteger plantStage = [self.plant currentStage];
        
        if (plantStage)
        {
            NSLog(@"Stage: %@", @(plantStage));
            NSString *plantName = [NSString stringWithFormat:@"%@_%@", self.plant.plantName, @(plantStage)];
            
            if (plantStage == 4)
            {
                Item *item = [[ItemManager sharedManager]getItem:self.plant.plantName];
                self.objectItem = item;
                
                self.plant = nil;
            }
            else if (plantStage == -1)
            {
                Item *item = [[ItemManager sharedManager]getItem:@"weed"];
                self.objectItem = item;
                self.plant = nil;
            }
            else if (![self.objectItem.itemName isEqualToString:plantName] && plantStage)
            {
                Item *item = [[ItemManager sharedManager]getItem:plantName];
                self.objectItem = item;
            }
        }
    }
    
    if (self.isTilled && ![self.backgroundItem.itemName isEqualToString:@"tilled"])
    {
        Item *item = [[ItemManager sharedManager]getItem:@"tilled"];
        self.backgroundItem = item;
    }
    else if (!self.isTilled && ![self.backgroundItem.itemName isEqualToString:@"dirt_5"])
    {
        Item *item = [[ItemManager sharedManager]getItem:@"dirt_5"];
        self.backgroundItem = item;
    }
    
    //check if plant needs to be destroyed
    if (self.plant)
    {
        if ([self.plant currentStage] == -1)
        {
//            Item *item = [[ItemManager sharedManager]getItem:@"weed"];
//            self.objectItem = item;
//            self.plant = nil;
        }
    }
    
    self.isWatered = NO;
}

@end
