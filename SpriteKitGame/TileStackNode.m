//
//  TileStackNode.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/21/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "TileStackNode.h"
#import "ItemSprite.h"

@implementation TileStackNode

-(id)initWithTileStack:(TileStack *)tileStack
{
    self = [super init];
    
    self.tileStack = tileStack;
    
    return self;
}

-(void)setBackgroundItemSprite:(ItemSprite *)backgroundItemSprite
{
    if (_backgroundItemSprite)
    {
        [_backgroundItemSprite removeFromParent];
    }
    
    if (backgroundItemSprite)
    {
        backgroundItemSprite.zPosition = 1;
        [self addChild:backgroundItemSprite];
    }
    else
    {
        NSLog(@"nil");
    }
    
    _backgroundItemSprite = backgroundItemSprite;
}

-(void)setObjectItemSprite:(ItemSprite *)objectItemSprite
{
    if (_objectItemSprite)
    {
        [_objectItemSprite removeFromParent];
    }
    
    if (objectItemSprite)
    {
        objectItemSprite.zPosition = 2;
        [self addChild:objectItemSprite];
    }
    
    _objectItemSprite = objectItemSprite;
}

-(void)setForegroundItemSprite:(ItemSprite *)foregroundItemSprite
{
    if (_foregroundItemSprite)
    {
        [_foregroundItemSprite removeFromParent];
    }
    
    if (foregroundItemSprite)
    {
        foregroundItemSprite.zPosition = 3;
        [self addChild:foregroundItemSprite];
    }
    
    _foregroundItemSprite = foregroundItemSprite;
}

-(void)update
{
    
}

@end
