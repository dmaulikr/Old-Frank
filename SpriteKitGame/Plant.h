//
//  Plant.h
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/5/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlantEntity.h"
#import "TimeManager.h"

@interface Plant : NSObject

@property (nonatomic, strong)NSString *plantName;
@property (nonatomic)NSInteger stage1Days;
@property (nonatomic)NSInteger stage2Days;
@property (nonatomic)NSInteger stage3Days;
@property (nonatomic)NSInteger daysWatered;
@property (nonatomic)Season season;
@property (nonatomic)BOOL watered;
@property (nonatomic)BOOL readyToPick;

@property (nonatomic, strong)PlantEntity *plantEntity;


-(NSInteger)currentStage;


@end
