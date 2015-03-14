//
//  AnalogSpriteNode.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/28/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "AnalogSpriteNode.h"
#import "SMDTextureLoader.h"

@interface AnalogSpriteNode ()

@property (nonatomic, strong)SKSpriteNode *background;
@property (nonatomic, strong)SKSpriteNode *joyStick;
@property (nonatomic, strong)SMDTextureLoader *textureLoader;

@end

@implementation AnalogSpriteNode

-(id)init{
    
    self.textureLoader = [[SMDTextureLoader alloc]init];
    
    self = [super initWithColor:[SKColor clearColor] size:CGSizeMake(200,200)];
    
    self.zPosition = 1;
    
    self.background = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"joystic_background"]];
    self.background.zPosition = 2;
    self.background.alpha = .5;
    [self addChild:self.background];
    
    self.userInteractionEnabled = YES;
    
    self.joyStick = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"joystic"]];
    self.joyStick.zPosition = 3;
    self.joyStick.alpha = .5;
    

    [self addChild:self.joyStick];

    return self;
}

-(CGPoint)velocity
{
    float x = self.joyStick.position.x - self.background.position.x;
    float y = self.joyStick.position.y - self.background.position.y;
    
    return CGPointMake(x/(self.size.width/2), y/(self.size.height/2));
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touched");
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        
        self.background.position = location;
        self.joyStick.position = location;
        
        self.background.alpha = .5;
        self.joyStick.alpha = .5;
    
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        self.alpha = 1;
        CGPoint location = [touch locationInNode:self];
        
        self.joyStick.position = location;
        
        if (self.joyStick.position.x > (self.background.position.x + self.background.size.width/2))
            self.joyStick.position = CGPointMake((self.background.position.x + self.background.size.width/2), self.joyStick.position.y);
        
        if (self.joyStick.position.x < (self.background.position.x - self.background.size.width/2))
            self.joyStick.position = CGPointMake((self.background.position.x - self.background.size.width/2), self.joyStick.position.y);
        
        if (self.joyStick.position.y > (self.background.position.y + self.background.size.height/2))
            self.joyStick.position = CGPointMake(self.joyStick.position.x, (self.background.position.y + self.background.size.height/2));
        
        if (self.joyStick.position.y < (self.background.position.y - self.background.size.height/2))
            self.joyStick.position = CGPointMake(self.joyStick.position.x, (self.background.position.y - self.background.size.height/2));
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.background.alpha = 0;
    self.joyStick.alpha = 0;
    self.background.position = CGPointZero;
    self.joyStick.position = self.background.position;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.background.alpha = 0;
    self.joyStick.alpha = 0;
    self.background.position = CGPointZero;

    self.joyStick.position = self.background.position;
}

@end
