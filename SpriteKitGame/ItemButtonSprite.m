//
//  ItemButtonSprite.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 2/4/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "ItemButtonSprite.h"
#import "SMDTextureLoader.h"

@interface ItemButtonSprite ()

@property (nonatomic, strong)SMDTextureLoader *textureLoader;

@end

@implementation ItemButtonSprite

-(id)initWithItem:(Item *)item
{
    
    self = [super init];
    self.textureLoader = [[SMDTextureLoader alloc]init];
    
    self.texture = [self.textureLoader getTextureForName:@"outline"];
    self.size = self.texture.size;
    
    self.item = item;
    
    if (item)
    {
        self.itemSprite = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:item.itemName]];
        self.userInteractionEnabled = YES;
        [self addChild:self.itemSprite];
        
        if (item.quantity > 1)
        {
            NSInteger leftDigit = item.quantity/10;
            NSInteger rightDigit = item.quantity-(leftDigit *10);
            
            SKTexture *rightTexture = [self.textureLoader getTextureForName:[NSString stringWithFormat:@"num%@", @(rightDigit)]];
            SKTexture *leftTexture = [self.textureLoader getTextureForName:[NSString stringWithFormat:@"num%@", @(leftDigit)]];
            
            rightTexture.filteringMode = SKTextureFilteringNearest;
            leftTexture.filteringMode = SKTextureFilteringNearest;
            

            SKSpriteNode *leftNode = [SKSpriteNode spriteNodeWithTexture:leftTexture];
            SKSpriteNode *rightNode = [SKSpriteNode spriteNodeWithTexture:rightTexture];
            
            leftNode.size = CGSizeMake(leftNode.size.width*1.5, leftNode.size.height*1.5);
            rightNode.size = CGSizeMake(rightNode.size.width*1.5, rightNode.size.height*1.5);
            
            leftNode.zPosition = 5;
            rightNode.zPosition = 5;
            
            rightNode.position = CGPointMake(self.size.width/2-rightNode.size.width/2-1, -self.size.height/2+rightNode.size.height/2+1);
            leftNode.position = CGPointMake(rightNode.position.x-leftNode.size.width/2-rightNode.size.width/2, rightNode.position.y);


            [self.itemSprite addChild:leftNode];
            [self.itemSprite addChild:rightNode];
        }

    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touched");
    self.alpha = .5;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        self.alpha = 1;
        CGPoint location = [touch locationInNode:self.parent];
        
        if(CGRectContainsPoint(self.calculateAccumulatedFrame, location))
        {
            NSLog(@"UP IN SIDE");
            [self.delegate itemButtonSpritePressed:self];
        }
        else
        {
            NSLog(@"not touched");
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.alpha = 1;
}

@end
