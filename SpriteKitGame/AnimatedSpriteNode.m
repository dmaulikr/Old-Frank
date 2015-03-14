//
//  AnimatedSpriteNode.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 5/2/14.
//  Copyright (c) 2014 Sky Mist Development. All rights reserved.
//

#import "AnimatedSpriteNode.h"
#import "SMDTextureLoader.h"

@interface AnimatedSpriteNode ()

@property (nonatomic, strong)NSArray *walkRight;
@property (nonatomic, strong)NSArray *walkLeft;
@property (nonatomic, strong)NSArray *walkUp;
@property (nonatomic, strong)NSArray *walkDown;
@property (nonatomic, strong)SMDTextureLoader *textureLoader;

@end


@implementation AnimatedSpriteNode

-(instancetype)initWithImageNamed:(NSString *)imageName withWidth:(NSInteger)width withHeight:(NSInteger)height
{
    self = [super init];
    
    if (self)
    {
        self.textureLoader = [[SMDTextureLoader alloc]init];
//        self.rows = height;
//        self.columns = width;
//        
//        SKTexture *fullTexture = [SKTexture textureWithImageNamed:imageName];
//        
//        float widthPercent = 1.0f/width;
//        float heightPercent = 1.0f/height;
//        
//        for (NSInteger i = 0; i < height; i++)
//        {
//            NSMutableArray *textureArray = [[NSMutableArray alloc]init];
//            
//            for (NSInteger j = 0; j < width; j++)
//            {
//                SKTexture *texture = [SKTexture textureWithRect:CGRectMake(j*widthPercent, i*heightPercent, widthPercent, heightPercent) inTexture:fullTexture];
//                texture.filteringMode = SKTextureFilteringNearest;
//
//                [textureArray addObject:texture];
//            }
//            
//            switch (i)
//            {
//                case 3:
//                    self.walkDown = textureArray;
//                    break;
//                case 2:
//                    self.walkUp = textureArray;
//                    break;
//                case 1:
//                    self.walkLeft = textureArray;
//                    break;
//                case 0:
//                    self.walkRight = textureArray;
//                    break;
//                    
//                default:
//                    break;
//            }
//        }
        
        NSMutableArray *walkingArray = [[NSMutableArray alloc]init];
        
        NSMutableArray *walkingTexture;
        SKTexture *texture;
        
        
        
        walkingTexture = [[NSMutableArray alloc]init];
        
        texture =  [self.textureLoader getTextureForName:@"up1"];
        [walkingTexture addObject:texture];
        texture =  [self.textureLoader getTextureForName:@"up2"];
        [walkingTexture addObject:texture];
        texture =  [self.textureLoader getTextureForName:@"up1"];
        [walkingTexture addObject:texture];
        texture =  [self.textureLoader getTextureForName:@"up3"];
        [walkingTexture addObject:texture];
        
        [walkingArray addObject:walkingTexture];
        
        
        walkingTexture = [[NSMutableArray alloc]init];
        
        texture =  [self.textureLoader getTextureForName:@"down1"];
        [walkingTexture addObject:texture];
        texture =  [self.textureLoader getTextureForName:@"down2"];
        [walkingTexture addObject:texture];
        texture =  [self.textureLoader getTextureForName:@"down1"];
        [walkingTexture addObject:texture];
        texture =  [self.textureLoader getTextureForName:@"down3"];
        [walkingTexture addObject:texture];
        
        [walkingArray addObject:walkingTexture];
        
        walkingTexture = [[NSMutableArray alloc]init];
        
        texture =  [self.textureLoader getTextureForName:@"left1"];
        [walkingTexture addObject:texture];
        texture =  [self.textureLoader getTextureForName:@"left2"];
        [walkingTexture addObject:texture];
        texture =  [self.textureLoader getTextureForName:@"left1"];
        [walkingTexture addObject:texture];
        texture =  [self.textureLoader getTextureForName:@"left3"];
        [walkingTexture addObject:texture];
        
        [walkingArray addObject:walkingTexture];
        

        
        walkingTexture = [[NSMutableArray alloc]init];
        
        texture =  [self.textureLoader getTextureForName:@"right1"];
        [walkingTexture addObject:texture];
        texture =  [self.textureLoader getTextureForName:@"right2"];
        [walkingTexture addObject:texture];
        texture =  [self.textureLoader getTextureForName:@"right1"];
        [walkingTexture addObject:texture];
        texture =  [self.textureLoader getTextureForName:@"right3"];
        [walkingTexture addObject:texture];
        
        [walkingArray addObject:walkingTexture];


        self.walkingArray = walkingArray;
        
        self.texture = self.walkingArray[0][0];
        self.size = self.texture.size;
        //NSLog(@"Size: %@", NSStringFromCGSize(self.size));

        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.size.width, self.size.height/2) center:CGPointMake(0, -self.size.height/4)];
        self.physicsBody.dynamic = YES;
        self.physicsBody.allowsRotation = NO;

    }
    
    return self;
}

-(void)update
{
    
}

@end
