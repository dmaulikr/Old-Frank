//
//  InventoryController.h
//  SpriteKitGame
//
//  Created by Skyler Lauren on 2/4/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Player.h"

@interface InventoryController : NSObject

@property (nonatomic, strong)SKSpriteNode *inventorySpriteView;

-(id)initWithSize:(CGSize)size andPlayer:(Player *)player;
-(void)updateViews;

@end
