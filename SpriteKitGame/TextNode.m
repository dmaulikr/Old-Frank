//
//  TextNode.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 2/9/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "TextNode.h"
#import "ButtonSprite.h"
#import "SMDTextureLoader.h"

@interface TextNode ()<ButtonSpriteDelegate>

@property (nonatomic, strong)NSArray *letters;


@property (nonatomic, strong)SKSpriteNode *background;

@property (nonatomic)NSInteger index;

@property (nonatomic, strong)ButtonSprite *yesButton;
@property (nonatomic, strong)ButtonSprite *noButton;
@property (nonatomic, strong)ButtonSprite *okButton;
@property (nonatomic, strong)ButtonSprite *contButton;

@property (nonatomic, strong)NSDictionary *imageDictionary;
@property (nonatomic, strong)SMDTextureLoader *textureLoader;

@end

@implementation TextNode

-(id)initWithSize:(CGSize)size withDialog:(Dialog *)dialog
{
    self = [super init];
    self.textureLoader = [[SMDTextureLoader alloc]init];
    
    self.dialog = dialog;
    self.size = size;

    self.background = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"dialogBackground"]];
    self.background.centerRect = CGRectMake(.4, .4, .2, .2);

    self.background.anchorPoint = CGPointMake(.5, 0);
    self.background.size = size;

    [self addChild:self.background];
    self.userInteractionEnabled = YES;
    
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
                              @":" : @"colon"
                              };

    
    //adding buttons
    NSInteger padding = 10;
    
    if (self.dialog.responseType == DialogResponseTypeYesNo)
    {
        self.yesButton = [ButtonSprite spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(self.size.width/3, 20)];
        SKNode *yesWord = [self nodeWithWord:@"YES"];
        self.yesButton.zPosition = 2;
        CGRect rect = yesWord.calculateAccumulatedFrame;
        yesWord.position = CGPointMake(-rect.size.width/2, rect.size.height/2);
        [self.yesButton addChild:yesWord];
        
        self.yesButton.position = CGPointMake(self.size.width/2-self.yesButton.size.width/2-padding, self.yesButton.size.height/2+padding);
        self.zPosition = 10;
        [self addChild:self.yesButton];
        self.yesButton.delegate = self;
        self.yesButton.userInteractionEnabled = YES;
        
        self.noButton = [ButtonSprite spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(self.size.width/3, 20)];
        SKNode *noWord = [self nodeWithWord:@"NO"];
        self.noButton.zPosition = 2;
        rect = noWord.calculateAccumulatedFrame;
        noWord.position = CGPointMake(-rect.size.width/2, rect.size.height/2);
        [self.noButton addChild:noWord];
        
        self.noButton.position = CGPointMake(-self.size.width/2+self.noButton.size.width/2+padding, self.noButton.size.height/2+padding);
        self.zPosition = 10;
        [self addChild:self.noButton];
        self.noButton.delegate = self;
        self.noButton.userInteractionEnabled = YES;
    }
    else if (self.dialog.responseType == DialogResponseTypeOk)
    {
        self.okButton = [ButtonSprite spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(self.size.width/3, 20)];
        SKNode *okWord = [self nodeWithWord:@"OK"];
        self.okButton.zPosition = 2;
        CGRect rect = okWord.calculateAccumulatedFrame;
        okWord.position = CGPointMake(-rect.size.width/2, rect.size.height/2);
        [self.okButton addChild:okWord];
        
        self.okButton.position = CGPointMake(self.size.width/2-self.okButton.size.width/2-padding, self.okButton.size.height/2+padding);
        self.zPosition = 10;
        [self addChild:self.okButton];
        self.okButton.delegate = self;
        self.okButton.userInteractionEnabled = YES;
    }
    else if (self.dialog.responseType == DialogResponseTypeCont)
    {
        self.contButton = [ButtonSprite spriteNodeWithColor:[SKColor greenColor] size:CGSizeMake(self.size.width/3, 20)];
        SKNode *contWord = [self nodeWithWord:@"CONT."];
        self.contButton.zPosition = 2;
        CGRect rect = contWord.calculateAccumulatedFrame;
        contWord.position = CGPointMake(-rect.size.width/2, rect.size.height/2);
        [self.contButton addChild:contWord];
        
        self.okButton.position = CGPointMake(self.size.width/2-self.contButton.size.width/2-padding, self.contButton.size.height/2+padding);
        self.zPosition = 10;
        [self addChild:self.contButton];
        self.contButton.delegate = self;
        self.contButton.userInteractionEnabled = YES;
    }
    
   
        
    self.background.size = CGSizeMake(10, 10);
    self.background.xScale = size.width/10;
    self.background.yScale = size.height/10;
    
    [self loadMessage];
    
    return self;
}

-(void)loadMessage
{
    for (SKSpriteNode *sprite in self.letters)
    {
        [sprite removeFromParent];
    }
    
    NSMutableArray *letters = [[NSMutableArray alloc]init];
    
    NSInteger padding = 6;
    NSInteger xPosition = -self.size.width/2+padding;
    NSInteger yPosition = -(padding-self.size.height);
    
    NSInteger lineHeight = 0;
    
    NSArray *words = [self.dialog.text componentsSeparatedByString:@" "];
    
    for (NSString *word in words)
    {
        SKNode *wordNode = [[SKNode alloc]init];
        
        NSInteger xPositionLetter = 0;
        
        for (int i = 0; i < word.length; i++)
        {
            NSString *tmp_str = [word substringWithRange:NSMakeRange(i, 1)];
            
            SKTexture *texture = [self.textureLoader getTextureForName:self.imageDictionary[tmp_str]];
            SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:texture];
            sprite.anchorPoint = CGPointMake(0, 0);
            sprite.size = CGSizeMake(sprite.size.width * 2, sprite.size.height * 2);
            sprite.anchorPoint = CGPointMake(0, 1);
            sprite.position = CGPointMake(xPositionLetter, 0);
            sprite.zPosition = 10;
            
            sprite.hidden = YES;
            
            lineHeight = sprite.size.height;
            
            xPositionLetter += sprite.size.width;
            
            
            [wordNode addChild:sprite];
            [letters addObject:sprite];
        }
        
        if (xPosition + xPositionLetter + padding > self.size.width/2)
        {
            xPosition = -self.size.width/2+padding;
            yPosition -= lineHeight+padding;
        }
        
        wordNode.position = CGPointMake(xPosition, yPosition);
        
        [self addChild:wordNode];
        
        xPosition += xPositionLetter+padding;
        
        if (word == words.lastObject)
        {
            yPosition -= lineHeight+padding;
        }
        
    }
    
    //    self.background.size = CGSizeMake(self.background.size.width, -yPosition);
    
    self.letters = letters;
}


-(SKNode *)nodeWithWord:(NSString *)word
{
    NSInteger xPositionLetter = 0;
    SKNode *wordNode = [[SKNode alloc]init];
    wordNode.zPosition = 1;

    for (int i = 0; i < word.length; i++)
    {
        NSString *tmp_str = [word substringWithRange:NSMakeRange(i, 1)];
        
        SKTexture *texture = [self.textureLoader getTextureForName:self.imageDictionary[tmp_str]];
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:texture];
        sprite.anchorPoint = CGPointMake(0, 0);
        sprite.size = CGSizeMake(sprite.size.width * 2, sprite.size.height * 2);
        sprite.anchorPoint = CGPointMake(0, 1);
        sprite.position = CGPointMake(xPositionLetter, 0);
        sprite.zPosition = 10;
        
        sprite.hidden = NO;
        
        xPositionLetter += sprite.size.width;
        
        [wordNode addChild:sprite];
    }

    return wordNode;
}


-(void)startAnimation
{
    [self revealLetterWithDelay:@(.1)];
}

-(void)revealLetterWithDelay:(NSNumber *)delay
{
    float waitDelay = delay.floatValue;
    
    NSLog(@"index: %@", @(self.index));
    
    if (self.index < self.letters.count)
    {
        SKSpriteNode *sprite = self.letters[self.index];
        sprite.hidden = NO;
        
        self.index++;
        
        if (self.index < self.letters.count)
        {
            [self performSelector:@selector(revealLetterWithDelay:) withObject:delay afterDelay:waitDelay];
        }
    }
}

-(void)buttonSpritePressed:(ButtonSprite *)buttonSprite
{
    if (buttonSprite == self.yesButton)
    {
        [self.delegate didSelectAnswer:@"yes" forTextNode:self];
        self.dialogBlock(DialogResponseYes);
    }
    else if (buttonSprite == self.noButton)
    {
        [self.delegate didSelectAnswer:@"no" forTextNode:self];
        self.dialogBlock(DialogResponseNo);
    }
    else if (buttonSprite == self.okButton)
    {
        [self.delegate didSelectAnswer:@"ok" forTextNode:self];
        self.dialogBlock(DialogResponseNo);
    }
    else if (buttonSprite == self.contButton)
    {
        [self.delegate didSelectAnswer:@"cont" forTextNode:self];
        self.dialogBlock(DialogResponseNo);
    }
}

@end
