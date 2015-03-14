//
//  Plant.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/5/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "Plant.h"

@implementation Plant

-(void)setDaysWatered:(NSInteger)daysWatered
{
    self.plantEntity.days_watered = @(daysWatered);
    _daysWatered = daysWatered;
}

-(void)setWatered:(BOOL)watered
{
    self.plantEntity.watered = @(watered);
    _watered = watered;
}

-(NSInteger)currentStage
{
    if ([[TimeManager sharedManager]season] != self.season)
    {
        return  -1;
    }
    
    if (self.daysWatered >= (self.stage1Days + self.stage2Days + self.stage3Days))
    {
        self.readyToPick = YES;
        return 3;
    }
    else if (self.daysWatered >= (self.stage1Days + self.stage2Days))
    {
        return 2;
    }
    else if (self.daysWatered >= self.stage1Days)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}

@end
