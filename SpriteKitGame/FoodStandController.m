//
//  FoodStandNode.m
//  Old Frank
//
//  Created by Skyler Lauren on 3/11/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "FoodStandController.h"
#import "ButtonSprite.h"
#import "DragItemButtonSprite.h"
#import "SMDTextureLoader.h"
#import "FoodStand.h"
#import "TextSprite.h"

@interface FoodStandController ()<ItemButtonSpriteDelegate, ButtonSpriteDelegate, DragItemButtonSpriteDelegate>

@property (nonatomic, strong)SKSpriteNode *inventoryItemContainer;
@property (nonatomic, strong)Player *player;
@property (nonatomic, strong)NSMutableArray *inventoryButtons;
@property (nonatomic, strong)ButtonSprite *closeButtonSprite;

@property (nonatomic, strong)SMDTextureLoader *textureLoader;
@property (nonatomic, strong)FoodStand *foodStand;

@property (nonatomic, strong)NSArray *foodStandSlots;
@property (nonatomic, strong)TextSprite *goldTextSprite;

@end

@implementation FoodStandController

-(id)initWithSize:(CGSize)size withFoodStand:(FoodStand *)foodStand withPlayer:(Player *)player
{
    self = [super init];
    
    self.foodStand = foodStand;
    
    self.textureLoader = [[SMDTextureLoader alloc]init];
    
    self.player = player;

    self.foodStandSpriteView = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:size];
    
    self.foodStandSpriteView.zPosition = 20;
    self.foodStandSpriteView.position = CGPointMake(size.width/2, size.height/2);
    
    NSMutableArray *foodStandSlots = [[NSMutableArray alloc]init];
    
    //food stand positioning
    NSInteger positionX = 0;
    NSInteger positionY = 0;
    
    SKSpriteNode *foodStandSprite = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"foodstand_1"]];
    foodStandSprite.position = CGPointMake(positionX, positionY);
    [self.foodStandSpriteView addChild:foodStandSprite];
    
    //Button
    ItemButtonSprite *buttonSprite = [[ItemButtonSprite alloc]initWithItem:nil];
    buttonSprite.delegate = self;
    buttonSprite.position = foodStandSprite.position;
    [foodStandSlots addObject:buttonSprite];
    [self.foodStandSpriteView addChild:buttonSprite];
    
    positionX += foodStandSprite.size.width;
    
    foodStandSprite = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"foodstand_2"]];
    foodStandSprite.position = CGPointMake(positionX, positionY);
    [self.foodStandSpriteView addChild:foodStandSprite];
    
    //Button
    buttonSprite = [[ItemButtonSprite alloc]initWithItem:nil];
    buttonSprite.delegate = self;
    buttonSprite.position = foodStandSprite.position;
    [foodStandSlots addObject:buttonSprite];
    [self.foodStandSpriteView addChild:buttonSprite];
    
    positionX += foodStandSprite.size.width;

    
    foodStandSprite = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"foodstand_3"]];
    foodStandSprite.position = CGPointMake(positionX, positionY);
    [self.foodStandSpriteView addChild:foodStandSprite];
    
    //Button
    buttonSprite = [[ItemButtonSprite alloc]initWithItem:nil];
    buttonSprite.delegate = self;
    buttonSprite.position = foodStandSprite.position;
    [foodStandSlots addObject:buttonSprite];
    [self.foodStandSpriteView addChild:buttonSprite];

    self.foodStandSlots = foodStandSlots;
    
    positionX -= foodStandSprite.size.width*2;
    positionY -= foodStandSprite.size.height;

    
    foodStandSprite = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"foodstand_4"]];
    foodStandSprite.position = CGPointMake(positionX, positionY);
    [self.foodStandSpriteView addChild:foodStandSprite];
    
    positionX += foodStandSprite.size.width;

    
    foodStandSprite = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"foodstand_5"]];
    foodStandSprite.position = CGPointMake(positionX, positionY);
    [self.foodStandSpriteView addChild:foodStandSprite];
    
    positionX += foodStandSprite.size.width;
    
    foodStandSprite = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"foodstand_6"]];
    foodStandSprite.position = CGPointMake(positionX, positionY);
    [self.foodStandSpriteView addChild:foodStandSprite];
    
    self.inventoryItemContainer = [[SKSpriteNode alloc]initWithColor:[SKColor greenColor] size:CGSizeMake(5*32, 8*32)];
    self.inventoryItemContainer.anchorPoint = CGPointMake(0, 1);
    
    NSInteger diff = (size.height-self.inventoryItemContainer.size.height)/2;
    
    self.inventoryItemContainer.position = CGPointMake(-size.width/2+32, size.height/2-diff);
    [self.foodStandSpriteView addChild:self.inventoryItemContainer];
    [self updateViews];

    NSInteger padding = 10;
    
    self.closeButtonSprite = [ButtonSprite spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(32, 32)];
    self.closeButtonSprite.delegate = self;
    self.closeButtonSprite.zPosition = 10;
    self.closeButtonSprite.position = CGPointMake(size.width/2-self.closeButtonSprite.size.width/2-padding, size.height/2-self.closeButtonSprite.size.height/2 -padding);
    self.closeButtonSprite.userInteractionEnabled = YES;
    [self.foodStandSpriteView addChild:self.closeButtonSprite];
    
    
    //gold
    self.goldTextSprite = [[TextSprite alloc]initWithString:[NSString stringWithFormat:@"Gold $%@", @(self.player.gold)]];
    self.goldTextSprite.position = CGPointMake(0, size.height/2-self.goldTextSprite.calculateAccumulatedFrame.size.height-5);
    [self.foodStandSpriteView addChild:self.goldTextSprite];

    return self;
}

-(void)updateViews
{
    
    for (SKSpriteNode *sprite in self.inventoryItemContainer.children)
    {
        [sprite removeFromParent];
    }
    
    NSMutableArray *newSlots = [[NSMutableArray alloc]init];
    
    NSInteger index = 0;
    
    for (ItemButtonSprite *buttonSprite in self.foodStandSlots)
    {
        [buttonSprite removeFromParent];
        
        ItemButtonSprite *newItemButtonSprite;
        
        if (self.foodStand.items.count > index)
        {
            newItemButtonSprite = [[ItemButtonSprite alloc]initWithItem:self.foodStand.items[index]];
        }
        else
        {
            newItemButtonSprite = [[ItemButtonSprite alloc]initWithTexture:[self.textureLoader getTextureForName:@"outline"]];
        }
        
        newItemButtonSprite.delegate = self;
        newItemButtonSprite.position = buttonSprite.position;
        [newSlots addObject:newItemButtonSprite];
        [self.foodStandSpriteView addChild:newItemButtonSprite];
        
        index++;
    }
    
    self.foodStandSlots = newSlots;
    
    
    NSInteger x = 0;
    NSInteger y = 0;
    
    NSInteger i = 0;
    
    self.inventoryButtons = [[NSMutableArray alloc]init];
    
    for (Item *item in self.player.inventory)
    {
        DragItemButtonSprite *itemButtonSprite = [[DragItemButtonSprite alloc]initWithItem:item];
        itemButtonSprite.position = CGPointMake(x+itemButtonSprite.size.width/2, y-itemButtonSprite.size.height/2);
        itemButtonSprite.delegate = self;
        itemButtonSprite.dragDelegate = self;
        [self.inventoryItemContainer addChild:itemButtonSprite];
        x += 32;
        
        if (x >= self.inventoryItemContainer.size.width)
        {
            x = 0;
            y-= 32;
        }
        
        i++;
    }
    
    x = 0;
    y = 0;
    
    while (y > -self.inventoryItemContainer.size.height)
    {
        SKSpriteNode *outline = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"outline"]];
        
        outline.position = CGPointMake(x+outline.size.width/2, y -outline.size.height/2);
        
        [self.inventoryItemContainer addChild:outline];
        
        x += 32;
        
        if (x >= self.inventoryItemContainer.size.width)
        {
            x = 0;
            y-= 32;
        }
    }
    
    //gold
    self.goldTextSprite.text = [NSString stringWithFormat:@"Gold: %@", @(self.player.gold)];
}

-(void)itemButtonSpritePressed:(ItemButtonSprite *)itemButtonSprite
{
    if ([self.foodStandSlots containsObject:itemButtonSprite] && itemButtonSprite.item)
    {
        [self.foodStand removeItemFromFoodStand:itemButtonSprite.item andGiveToPlayer:self.player];
        [self updateViews];
    }
}

-(void)buttonSpritePressed:(ButtonSprite *)buttonSprite
{
    [self.foodStandSpriteView removeFromParent];
    [self.delegate doneWithFoodStand:self.foodStand];
}

#pragma mark - DragItemButtonSpriteDelegate

-(void)doneDraggingDragItemButtonSprite:(DragItemButtonSprite *)dragItemButtonSprite
{
    NSLog(@"Done Dragging");
    
    if(dragItemButtonSprite.item.sellable)
    {
        for (ButtonSprite *button in self.foodStandSlots)
        {
            if ([button intersectsNode:dragItemButtonSprite])
            {
                NSLog(@"bingo");
                [self.foodStand addItemToFoodStand:dragItemButtonSprite.item fromPlayer:self.player];
                break;
            }
        }

    }
    
    
    [self updateViews];
}

@end
