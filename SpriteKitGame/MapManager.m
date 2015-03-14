//
//  MapManager.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 2/8/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "MapManager.h"
#import "HouseMap.h"
#import "FarmMap.h"

@implementation MapManager

+ (Map *)mapForName:(NSString *)mapName
{
    Map *map;
    
    if ([mapName isEqualToString:@"farm"])
    {
        map = [[FarmMap alloc]initWithFileName:mapName];
    }
    else if ([mapName isEqualToString:@"house"])
    {
        map = [[HouseMap alloc]initWithFileName:mapName];
    }
    
    return map;
}

@end
