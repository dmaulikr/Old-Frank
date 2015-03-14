//
//  PlayerAnimatedSpriteNode.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 12/30/14.
//  Copyright (c) 2014 Sky Mist Development. All rights reserved.
//

#import "PlayerAnimatedSpriteNode.h"

@interface PlayerAnimatedSpriteNode ()

@property (nonatomic, strong)NSString *eqpuipedToolName;

@property (nonatomic, strong)NSArray *gearRight;
@property (nonatomic, strong)NSArray *gearLeft;
@property (nonatomic, strong)NSArray *gearUp;
@property (nonatomic, strong)NSArray *gearDown;

@property (nonatomic, strong)NSArray *gearArray;

@property (nonatomic, strong)SKSpriteNode *gearSprite;
@end

@implementation PlayerAnimatedSpriteNode

-(id)initWithPlayer:(Player *)player
{
    self = [super initWithImageNamed:player.imageName withWidth:player.columns withHeight:player.rows];
    self.anchorPoint = CGPointMake(.5, .25);
    self.player = player;
    
    return self;
}

-(void)equipItemWithName:(NSString *)name
{
//    self.eqpuipedToolName = name;
//    [self.gearSprite removeFromParent];
//    
//    if (!name.length)
//    {
//        self.gearSprite = nil;
//        return;
//    }
//    
//    SKTexture *fullTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@_gear", name]];
//    
//    float widthPercent = 1.0f/self.columns;
//    
//    float heightPercent = 1.0f/self.rows;
//    
//    for (NSInteger i = 0; i < self.rows; i++)
//    {
//        NSMutableArray *textureArray = [[NSMutableArray alloc]init];
//        
//        for (NSInteger j = 0; j < self.columns; j++)
//        {
//            SKTexture *texture = [SKTexture textureWithRect:CGRectMake(j*widthPercent, i*heightPercent, widthPercent, heightPercent) inTexture:fullTexture];
//            texture.filteringMode = SKTextureFilteringNearest;
//            [textureArray addObject:texture];
//        }
//        
//        switch (i)
//        {
//                
//            case 3:
//                self.gearDown = textureArray;
//                break;
//            case 2:
//                self.gearUp = textureArray;
//                break;
//            case 1:
//                self.gearLeft = textureArray;
//                break;
//            case 0:
//                self.gearRight = textureArray;
//                break;
//                
//            default:
//                break;
//        }
//    }
//    
//    self.gearArray = @[self.gearUp, self.gearDown, self.gearLeft, self.gearRight];
//    
//   self.gearSprite = [[SKSpriteNode alloc]initWithTexture:self.gearArray[self.player.direction][self.player.frameIndex]];
//    self.gearSprite.zPosition = 1;
//    
//    [self addChild:self.gearSprite];
}

-(void)update
{
    [super update];
    
    self.position = self.player.position;
    
    self.texture = self.walkingArray[self.player.direction][self.player.frameIndex];

    if (![self.eqpuipedToolName isEqualToString:self.player.equippedTool.itemName])
    {
        [self equipItemWithName:self.player.equippedTool.itemName];
    }
    
    if (self.gearSprite)
    {
        self.gearSprite.texture = self.gearArray[self.player.direction][self.player.frameIndex];
    }
    
}
@end
