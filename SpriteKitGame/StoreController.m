//
//  StoreController.m
//  Old Frank
//
//  Created by Skyler Lauren on 4/3/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "StoreController.h"
#import "ButtonSprite.h"
#import "ItemButtonSprite.h"
#import "SMDTextureLoader.h"
#import "TextSprite.h"
#import "ItemManager.h"
#import "TextNode.h"
#import "SMDCoreDataHelper.h"

@interface StoreController ()<ButtonSpriteDelegate, ItemButtonSpriteDelegate>

@property (nonatomic, strong)SKSpriteNode *playerSprite;
@property (nonatomic, strong)Player *player;
@property (nonatomic, strong)ButtonSprite *closeButton;
@property (nonatomic, strong)SKSpriteNode *storeItemContainer;

@property (nonatomic, strong)SKSpriteNode *selectOutline;
@property (nonatomic)NSInteger selectedIndex;

@property (nonatomic)CGSize size;

@property (nonatomic, strong)NSMutableArray *storeButtons;
@property (nonatomic, strong)SMDTextureLoader *textureLoader;

@property (nonatomic)NSInteger rows;
@property (nonatomic)NSInteger columns;

@property (nonatomic)NSInteger padding;

@property (nonatomic, strong)TextSprite *ownedLabeledSprite;

@property (nonatomic, strong)NSArray *itemsForSale;

@property (nonatomic, strong)SKSpriteNode *itemSprite;

@property (nonatomic, strong)ButtonSprite *leftButton;
@property (nonatomic, strong)ButtonSprite *rightButton;
@property (nonatomic, strong)ButtonSprite *purchaseButton;

@property (nonatomic, strong)TextSprite *countTextSprite;
@property (nonatomic, strong)TextSprite *costTextSprite;
@property (nonatomic, strong)TextSprite *goldTextSprite;

@property (nonatomic)NSInteger count;

@end

@implementation StoreController

-(id)initWithSize:(CGSize)size andPlayer:(Player *)player
{
    self = [super init];
    self.rows = 6;
    self.columns = 3;
    self.padding = 5;
    
    self.textureLoader = [[SMDTextureLoader alloc]init];
    
    self.size = size;
    
    //background
    self.storeSpriteView = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:size];
    self.storeSpriteView.userInteractionEnabled = YES;
    
    self.storeSpriteView.anchorPoint = CGPointMake(0, 0);
    self.storeSpriteView.zPosition = 30000;
    self.player = player;
    
    //CloseButton
    self.closeButton = [[ButtonSprite alloc]initWithColor:[SKColor purpleColor] size:CGSizeMake(50, 50)];
    self.closeButton.position = CGPointMake(size.width-self.closeButton.size.width/2-10, size.height-self.closeButton.size.height/2-10);
    self.closeButton.userInteractionEnabled = YES;
    self.closeButton.delegate = self;
    [self.storeSpriteView addChild:self.closeButton];
    
    //item container
    self.storeItemContainer = [[SKSpriteNode alloc]initWithColor:[SKColor clearColor] size:CGSizeMake(self.columns*32+(self.padding*(self.columns-1)), self.rows*32)];
    self.storeItemContainer.anchorPoint = CGPointMake(0, 1);
    self.storeItemContainer.xScale = 1.5;
    self.storeItemContainer.yScale = 1.5;
    
    float diff = self.storeSpriteView.size.height-self.storeItemContainer.size.height;
    
    self.storeItemContainer.position = CGPointMake(32, self.storeItemContainer.size.height + diff/2);
    [self.storeSpriteView addChild:self.storeItemContainer];
    
    //gold
    self.goldTextSprite = [[TextSprite alloc]initWithString:[NSString stringWithFormat:@"Gold $%@", @(self.player.gold)]];
    self.goldTextSprite.position = CGPointMake(size.width/2, size.height-self.goldTextSprite.calculateAccumulatedFrame.size.height-5);
    [self.storeSpriteView addChild:self.goldTextSprite];
    
    self.ownedLabeledSprite = [[TextSprite alloc]initWithString:@"Owned:"];
    self.ownedLabeledSprite.position = CGPointMake(size.width*.75, size.height*.75);
    [self.storeSpriteView addChild:self.ownedLabeledSprite];
    
    self.itemSprite = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(32, 32)];
    self.itemSprite.position = CGPointMake(size.width*.75, size.height*.75-32-self.padding);
    self.itemSprite.xScale = 1.5;
    self.itemSprite.yScale = 1.5;
    [self.storeSpriteView addChild:self.itemSprite];

    self.itemsForSale = [[ItemManager sharedManager]itemsForSale];
    
    //right button
    self.rightButton = [[ButtonSprite alloc]initWithColor:[UIColor grayColor] size:CGSizeMake(32, 60)];
    self.rightButton .position = CGPointMake(size.width*.75+50, size.height*.75-32-50-self.padding);
    self.rightButton .delegate = self;
    self.rightButton .userInteractionEnabled = YES;
    [self.storeSpriteView addChild:self.rightButton ];
    
    //left button
    self.leftButton  = [[ButtonSprite alloc]initWithColor:[UIColor grayColor] size:CGSizeMake(32, 60)];
    self.leftButton.position = CGPointMake(size.width*.75-50, size.height*.75-32-50-self.padding);
    self.leftButton.userInteractionEnabled = YES;
    self.leftButton.delegate = self;
    [self.storeSpriteView addChild:self.leftButton];
    
    self.purchaseButton  = [[ButtonSprite alloc]initWithColor:[UIColor grayColor] size:CGSizeMake(90, 32)];
    self.purchaseButton.position = CGPointMake(size.width*.75, size.height*.75-32-125-self.padding*2);
    self.purchaseButton.userInteractionEnabled = YES;
    self.purchaseButton.delegate = self;
    [self.storeSpriteView addChild:self.purchaseButton];
    
    self.countTextSprite = [[TextSprite alloc]initWithString:@"0"];
    self.countTextSprite.position = CGPointMake(size.width*.75, size.height*.75-32-50-self.padding);
    [self.countTextSprite setScale:4];
    [self.storeSpriteView addChild:self.countTextSprite];
    
    self.costTextSprite = [[TextSprite alloc]initWithString:@"$0"];
    self.costTextSprite.position = CGPointMake(size.width*.75, size.height*.75-32-100-self.padding);
    [self.costTextSprite setScale:2];
    [self.storeSpriteView addChild:self.costTextSprite];
    
    [self generateStoreItems];
    [self updateViews];

    return self;
}

-(void)generateStoreItems
{
    NSInteger x = 0;
    NSInteger y = 0;
    
    NSInteger i = 0;
    
    self.storeButtons = [[NSMutableArray alloc]init];
    
    for (Item *item in self.itemsForSale)
    {
        
        //button
        ItemButtonSprite *itemButtonSprite = [[ItemButtonSprite alloc]initWithItem:item];
        itemButtonSprite.position = CGPointMake(x+itemButtonSprite.size.width/2, y-itemButtonSprite.size.height/2);
        itemButtonSprite.delegate = self;
        [self.storeItemContainer addChild:itemButtonSprite];
        [self.storeButtons addObject:itemButtonSprite];
        
        //label
        TextSprite *textSprite = [[TextSprite alloc]initWithString:[NSString stringWithFormat:@"$%@",@(item.purchasePrice)]];
        textSprite.position = CGPointMake(x+itemButtonSprite.size.width/2,(itemButtonSprite.position.y-textSprite.calculateAccumulatedFrame.size.height/2-itemButtonSprite.size.height/2-self.padding));
        [self.storeItemContainer addChild:textSprite];
        
        x += 32+self.padding;
        
        if (!((i+1) % 3))
        {
            x = 0;
            y-= 32+self.padding*2+textSprite.calculateAccumulatedFrame.size.height;
        }
        
        i++;
    }

}

-(void)updateViews
{
    
    //selection and owned info
    for (NSInteger i = 0; i < self.storeButtons.count; i++)
    {
        ItemButtonSprite *itemButtonSprite = self.storeButtons[i];

        if (i == self.selectedIndex)
        {
            SKTexture *texture = [self.textureLoader getTextureForName:@"select_outline"];
            itemButtonSprite.texture = texture;
            
            self.itemSprite.texture = [self.textureLoader getTextureForName:itemButtonSprite.item.itemName];
            
            NSArray *items = self.player.inventory;
            
            NSInteger count = 0;
            
            for (Item *inventoryItem in items)
            {
                if ([itemButtonSprite.item.itemName isEqualToString:inventoryItem.itemName])
                {
                    count += inventoryItem.quantity;
                }
            }
            
            self.ownedLabeledSprite.text = [NSString stringWithFormat:@"Owned: %@", @(count)];
        }
        else
        {
            SKTexture *texture = [self.textureLoader getTextureForName:@"outline"];
            itemButtonSprite.texture = texture;
        }
    }
    
    //gold
    self.goldTextSprite.text = [NSString stringWithFormat:@"Gold: %@", @(self.player.gold)];
    
    [self updateCostLabels];
}

-(void)updateCostLabels
{
    Item *item = self.itemsForSale[self.selectedIndex];
    
    self.costTextSprite.text = [NSString stringWithFormat:@"$%@", @(item.purchasePrice*self.count)];
    self.countTextSprite.text = [NSString stringWithFormat:@"%@", @(self.count)];
}

-(void)buttonSpritePressed:(ButtonSprite *)buttonSprite
{
    NSLog(@"Touch");
    
    if (buttonSprite == self.closeButton)
    {
        [self.storeSpriteView removeFromParent];
    }
    else if (buttonSprite == self.leftButton)
    {
        [self subtractCount];
    }
    else if (buttonSprite == self.rightButton)
    {
        [self addToCount];
    }
    else if (buttonSprite == self.purchaseButton)
    {
        Item *item = self.itemsForSale[self.selectedIndex];
        self.player.gold -= self.count*item.purchasePrice;
        
        [self.player addItemWithName:item.itemName withCount:self.count];
        
        self.count = 0;
        [self updateViews];
    }
}

-(void)addToCount
{
    Item *item = self.itemsForSale[self.selectedIndex];

    if (self.player.gold >= item.purchasePrice*(self.count+1) && self.count+1 <= item.maxStack)
    {
        self.count++;
    }
    
    [self updateViews];

}

-(void)subtractCount
{
    self.count--;
    
    if (self.count < 0)
    {
        self.count = 0;
    }
    
    [self updateViews];
}

-(void)itemButtonSpritePressed:(ItemButtonSprite *)itemButtonSprite
{
    self.selectedIndex = [self.itemsForSale indexOfObject:itemButtonSprite.item];
    self.count = 0;
    
    [self updateViews];
    
    NSLog(@"You pressed: %@", itemButtonSprite.item.itemName);
}

@end
