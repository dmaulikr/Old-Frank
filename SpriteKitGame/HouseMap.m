//
//  HouseMap.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 2/8/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "HouseMap.h"
#import "TileStack.h"
#import "MapManager.h"
#import "TimeManager.h"

@implementation HouseMap

-(void)update:(float)dt
{
    [super update:dt];
    
    
    TileStack *tileStack = [self tileStackForPlayer:self.player];

    if ([tileStack.objectItem.itemName isEqualToString:@"bed4"] ||
        [tileStack.objectItem.itemName isEqualToString:@"bed5"] ||
        [tileStack.objectItem.itemName isEqualToString:@"bed6"] ||
        [tileStack.objectItem.itemName isEqualToString:@"bed3"])
    {
        self.canUseActionButton = YES;
        self.actionButtonType = ActionButtonTypeSleep;
    }
}

-(void)actionButtonPressedForPlayer:(Player *)player
{
    TileStack *tileStack = [self tileStackForPlayer:self.player];
    
    if ([tileStack.objectItem.itemName isEqualToString:@"bed4"] ||
        [tileStack.objectItem.itemName isEqualToString:@"bed5"] ||
        [tileStack.objectItem.itemName isEqualToString:@"bed6"] ||
        [tileStack.objectItem.itemName isEqualToString:@"bed3"])
    {
        
        Dialog *dialog = [DialogManager getDialogWithDialogName:DialogNameSleep];
        
        [self.delegate displayDialog:dialog withBlock:^(DialogResponse response) {
           
            if (response == DialogResponseYes)
            {
                NSLog(@"WE DID IT");
                NSLog(@"SLEEP");
                CGPoint position = self.player.position;
                Map *farm = [MapManager mapForName:@"farm"];
                farm.player = self.player;
                [farm updateForNewDay];
                self.player.position = position;
                [[TimeManager sharedManager]nextDayForTime:480];
                self.player.energy = self.player.maxEnergy;
            }
        }];
    }
}


@end
