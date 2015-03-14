//
//  StoreController.h
//  Old Frank
//
//  Created by Skyler Lauren on 4/3/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import <SpriteKit/SpriteKit.h>

@interface StoreController : NSObject

@property (nonatomic, strong)SKSpriteNode *storeSpriteView;


-(id)initWithSize:(CGSize)size andPlayer:(Player *)player;
-(void)updateViews;

@end
