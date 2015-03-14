//
//  TextSprite.m
//  Old Frank
//
//  Created by Skyler Lauren on 3/21/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "TextSprite.h"
#import "SMDTextureLoader.h"

@interface TextSprite ()

@property (nonatomic, strong)SMDTextureLoader *textureLoader;
@property (nonatomic, strong)NSDictionary *imageDictionary;
@property (nonatomic, strong)SKNode *positionNode;

@end

@implementation TextSprite

-(id)initWithString:(NSString *)string
{
    self = [super init];
    
    self.textureLoader = [[SMDTextureLoader alloc]init];
    
    self.imageDictionary = @{ @"a" : @"a",
                              @"b" : @"b",
                              @"c" : @"c",
                              @"d" : @"d",
                              @"e" : @"e",
                              @"f" : @"f",
                              @"g" : @"g",
                              @"h" : @"h",
                              @"i" : @"i",
                              @"j" : @"j",
                              @"k" : @"k",
                              @"l" : @"l",
                              @"m" : @"m",
                              @"n" : @"n",
                              @"o" : @"o",
                              @"p" : @"p",
                              @"q" : @"q",
                              @"r" : @"r",
                              @"s" : @"s",
                              @"t" : @"t",
                              @"u" : @"u",
                              @"v" : @"v",
                              @"w" : @"w",
                              @"x" : @"x",
                              @"y" : @"y",
                              @"z" : @"z",
                              @"A" : @"capA",
                              @"B" : @"capB",
                              @"C" : @"capC",
                              @"D" : @"capD",
                              @"E" : @"capE",
                              @"F" : @"capF",
                              @"G" : @"capG",
                              @"H" : @"capH",
                              @"I" : @"capI",
                              @"J" : @"capJ",
                              @"K" : @"capK",
                              @"L" : @"capL",
                              @"M" : @"capM",
                              @"N" : @"capN",
                              @"O" : @"capO",
                              @"P" : @"capP",
                              @"Q" : @"capQ",
                              @"R" : @"capR",
                              @"S" : @"capS",
                              @"T" : @"capT",
                              @"U" : @"capU",
                              @"V" : @"capV",
                              @"W" : @"capW",
                              @"X" : @"capX",
                              @"Y" : @"capY",
                              @"Z" : @"capZ",
                              @" " : @"space",
                              @"$" : @"dollar",
                              @"." : @"period",
                              @"?" : @"questionMark",
                              @"!" : @"explanationMark",
                              @"0" : @"0",
                              @"1" : @"1",
                              @"2" : @"2",
                              @"3" : @"3",
                              @"4" : @"4",
                              @"5" : @"5",
                              @"6" : @"6",
                              @"7" : @"7",
                              @"8" : @"8",
                              @"9" : @"9",
                              @":" : @"colon",
                              @"/" : @"slash"
                              };
    
    
       self.zPosition = 10;
    self.positionNode = [[SKNode alloc]init];
    self.positionNode.zPosition = 1;
    //centering after adding all letters
    [self addChild:self.positionNode];
    
    self.text = string;
    
    return self;
}

-(void)loadText
{
    NSInteger xPositionLetter = 0;
    NSInteger height = 0;
    
    for (SKNode *node in self.positionNode.children)
    {
        [node removeFromParent];
    }
    
    for (NSInteger i = 0; i < self.text.length; i++)
    {
        NSString *tmp_str = [self.text substringWithRange:NSMakeRange(i, 1)];
        NSString *imageName = self.imageDictionary[tmp_str];
        
        if (!imageName)
        {
            NSLog(@"TEMP: %@", tmp_str);
        }
        
        SKSpriteNode *letter = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:imageName]];
        letter.anchorPoint = CGPointMake(0, .5);
        letter.position = CGPointMake(xPositionLetter, 0);
        [self.positionNode addChild:letter];
        
        xPositionLetter += letter.size.width;
        height = letter.size.height;
                
    }
    self.size = CGSizeMake(xPositionLetter, height);
    self.positionNode.position = CGPointMake(-xPositionLetter/2, 0);
}

-(void)setText:(NSString *)text
{
    _text = text;
    [self loadText];
}

@end
