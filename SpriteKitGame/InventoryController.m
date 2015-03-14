//
//  InventoryController.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 2/4/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "InventoryController.h"
#import "ButtonSprite.h"
#import "ItemButtonSprite.h"
#import "SMDTextureLoader.h"
#import "TextSprite.h"

@interface InventoryController ()<ButtonSpriteDelegate, ItemButtonSpriteDelegate>

@property (nonatomic, strong)SKSpriteNode *playerSprite;
@property (nonatomic, strong)Player *player;
@property (nonatomic, strong)ButtonSprite *closeButton;
@property (nonatomic, strong)SKSpriteNode *inventoryItemContainer;

@property (nonatomic, strong)ItemButtonSprite *toolItemButtonSprite;
@property (nonatomic, strong)ItemButtonSprite *itemItemButtonSprite;
@property (nonatomic, strong)SKSpriteNode *selectOutline;
@property (nonatomic)NSInteger selectedIndex;

@property (nonatomic)CGSize size;

@property (nonatomic, strong)NSMutableArray *inventoryButtons;
@property (nonatomic, strong)SMDTextureLoader *textureLoader;
@property (nonatomic, strong)TextSprite *goldTextSprite;

@property (nonatomic, strong)TextSprite *waterSkillLabel;
@property (nonatomic, strong)TextSprite *hoeSkillLabel;
@property (nonatomic, strong)TextSprite *hammerSkillLabel;
@property (nonatomic, strong)TextSprite *spellbookSkillLabel;
@property (nonatomic, strong)TextSprite *swordSkillLabel;
@property (nonatomic, strong)TextSprite *axeSkillLabel;


@end

@implementation InventoryController

-(id)initWithSize:(CGSize)size andPlayer:(Player *)player
{
    self = [super init];
    
    self.textureLoader = [[SMDTextureLoader alloc]init];
    
    self.size = size;
    
    self.inventorySpriteView = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:size];
    self.inventorySpriteView.userInteractionEnabled = YES;
    
    self.inventorySpriteView.anchorPoint = CGPointMake(0, 0);
    self.inventorySpriteView.zPosition = 30000;
    self.player = player;
    
    SKTexture *playerTexture = [self.textureLoader getTextureForName:@"down1"];

    self.playerSprite = [SKSpriteNode spriteNodeWithTexture:playerTexture];
    self.playerSprite.size = CGSizeMake(playerTexture.size.width*4, playerTexture.size.height*4);

    self.playerSprite.position = CGPointMake(size.width-self.playerSprite.size.width*2, size.height/2);
    [self.inventorySpriteView addChild:self.playerSprite];
    
    SKSpriteNode *outline = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"outline"]];
    outline.position = CGPointMake(self.playerSprite.position.x, size.height/2-self.playerSprite.size.height/2-outline.size.width/2-10);
    [self.inventorySpriteView addChild:outline];
    
    outline = [SKSpriteNode spriteNodeWithTexture:[self.textureLoader getTextureForName:@"outline"]];
    outline.position = CGPointMake(self.playerSprite.position.x, size.height/2+self.playerSprite.size.height/2+outline.size.width/2+10);
    [self.inventorySpriteView addChild:outline];
    
    //CloseButton
    self.closeButton = [[ButtonSprite alloc]initWithColor:[SKColor purpleColor] size:CGSizeMake(50, 50)];
    self.closeButton.position = CGPointMake(size.width-self.closeButton.size.width/2-10, size.height-self.closeButton.size.height/2-10);
    self.closeButton.userInteractionEnabled = YES;
    self.closeButton.delegate = self;
    
    [self.inventorySpriteView addChild:self.closeButton];
    
    self.inventoryItemContainer = [[SKSpriteNode alloc]initWithColor:[SKColor greenColor] size:CGSizeMake(5*32, 8*32)];
    self.inventoryItemContainer.anchorPoint = CGPointMake(0, 1);
    
    float diff = self.inventorySpriteView.size.height-self.inventoryItemContainer.size.height;
    
    self.inventoryItemContainer.position = CGPointMake(32, self.inventoryItemContainer.size.height + diff/2);
    [self.inventorySpriteView addChild:self.inventoryItemContainer];
    [self updateViews];
    
    //gold
    self.goldTextSprite = [[TextSprite alloc]initWithString:[NSString stringWithFormat:@"Gold $%@", @(self.player.gold)]];
    self.goldTextSprite.position = CGPointMake(size.width/2, size.height-self.goldTextSprite.calculateAccumulatedFrame.size.height-5);
    [self.inventorySpriteView addChild:self.goldTextSprite];
    
    NSInteger x = self.inventoryItemContainer.position.x+self.inventoryItemContainer.size.width+10;
    NSInteger y = self.inventoryItemContainer.position.y;
    NSInteger padding = 10;
    
    self.waterSkillLabel = [[TextSprite alloc]initWithString:[NSString stringWithFormat:@"Watering Skill %@/100", @(self.player.wateringSkill)]];
    self.waterSkillLabel.position = CGPointMake(x+(self.waterSkillLabel.size.width/2), y-self.waterSkillLabel.size.height/2);
    [self.inventorySpriteView addChild: self.waterSkillLabel];
    
    y -= self.waterSkillLabel.size.height/2 + padding;
    
    self.hoeSkillLabel = [[TextSprite alloc]initWithString:[NSString stringWithFormat:@"Hoe Skill %@/100", @(self.player.hoeSkill)]];
    self.hoeSkillLabel.position = CGPointMake(x+(self.hoeSkillLabel.size.width/2), y-self.hoeSkillLabel.size.height/2);
    [self.inventorySpriteView addChild: self.hoeSkillLabel];
    
    y -= self.waterSkillLabel.size.height/2 + padding;
    
    self.hammerSkillLabel = [[TextSprite alloc]initWithString:[NSString stringWithFormat:@"Hammer Skill %@/100", @(self.player.hammerSkill)]];
    self.hammerSkillLabel.position = CGPointMake(x+(self.hammerSkillLabel.size.width/2), y-self.hammerSkillLabel.size.height/2);
    [self.inventorySpriteView addChild: self.hammerSkillLabel];
    
    y -= self.waterSkillLabel.size.height/2 + padding;
    
    self.spellbookSkillLabel = [[TextSprite alloc]initWithString:[NSString stringWithFormat:@"Spellbook Skill %@/100", @(self.player.spellbookSkill)]];
    self.spellbookSkillLabel.position = CGPointMake(x+(self.spellbookSkillLabel.size.width/2), y-self.spellbookSkillLabel.size.height/2);
    [self.inventorySpriteView addChild: self.spellbookSkillLabel];
    
    y -= self.waterSkillLabel.size.height/2 + padding;
    
    self.swordSkillLabel = [[TextSprite alloc]initWithString:[NSString stringWithFormat:@"Sword Skill %@/100", @(self.player.swordSkill)]];
    self.swordSkillLabel.position = CGPointMake(x+(self.swordSkillLabel.size.width/2), y-self.swordSkillLabel.size.height/2);
    [self.inventorySpriteView addChild: self.swordSkillLabel];
    
    return self;
}

-(void)updateViews
{
    
    self.waterSkillLabel.text = [NSString stringWithFormat:@"Watering Skill %@/100", @(self.player.wateringSkill)];
    self.hoeSkillLabel.text = [NSString stringWithFormat:@"Hoe Skill %@/100", @(self.player.hoeSkill)];
    self.hammerSkillLabel.text = [NSString stringWithFormat:@"Hammer Skill %@/100", @(self.player.hammerSkill)];
    self.spellbookSkillLabel.text = [NSString stringWithFormat:@"Spellbook Skill %@/100", @(self.player.spellbookSkill)];
    self.swordSkillLabel.text = [NSString stringWithFormat:@"Sword Skill %@/100", @(self.player.swordSkill)];
    self.axeSkillLabel.text = [NSString stringWithFormat:@"Axe Skill %@/100", @(self.player.axeSkill)];




    [self.toolItemButtonSprite removeFromParent];
    [self.itemItemButtonSprite removeFromParent];
    
    for (SKSpriteNode *sprite in self.inventoryItemContainer.children)
    {
        [sprite removeFromParent];
    }
    NSInteger x = 0;
    NSInteger y = 0;
    
    NSInteger i = 0;

    self.inventoryButtons = [[NSMutableArray alloc]init];
    
    for (Item *item in self.player.inventory)
    {
        ItemButtonSprite *itemButtonSprite = [[ItemButtonSprite alloc]initWithItem:item];
        itemButtonSprite.position = CGPointMake(x+itemButtonSprite.size.width/2, y-itemButtonSprite.size.height/2);
        itemButtonSprite.delegate = self;
        [self.inventoryItemContainer addChild:itemButtonSprite];
        x += 32;
        
        if (x >= self.inventoryItemContainer.size.width)
        {
            x = 0;
            y-= 32;
        }
        
#if TARGET_OS_MAC
        
        if (i == self.selectedIndex)
        {
            SKTexture *texture = [self.textureLoader getTextureForName:@"select_outline"];
            texture.filteringMode = SKTextureFilteringNearest;
            itemButtonSprite.texture = texture;
        }
        
        [self.inventoryButtons addObject:itemButtonSprite];
       
#endif
        i++;
        
    }
    
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
    

    
    self.toolItemButtonSprite = [[ItemButtonSprite alloc]initWithItem:self.player.equippedTool];
    self.toolItemButtonSprite.position = CGPointMake(self.playerSprite.position.x-self.playerSprite.size.width/2-self.toolItemButtonSprite.size.width/2-10, self.size.height/2-self.toolItemButtonSprite.size.width/2);
    self.toolItemButtonSprite.delegate = self;
    [self.inventorySpriteView addChild:self.toolItemButtonSprite];
    
    
    self.itemItemButtonSprite = [[ItemButtonSprite alloc]initWithItem:self.player.equippedItem];
    self.itemItemButtonSprite.position =  CGPointMake(self.playerSprite.position.x+self.playerSprite.size.width/2+self.itemItemButtonSprite.size.width/2+10, self.size.height/2-self.itemItemButtonSprite.size.width/2);
    self.itemItemButtonSprite.delegate = self;
    [self.inventorySpriteView addChild:self.itemItemButtonSprite];
    
    //gold
    self.goldTextSprite.text = [NSString stringWithFormat:@"Gold: %@", @(self.player.gold)];
}

-(void)buttonSpritePressed:(ButtonSprite *)buttonSprite
{
    NSLog(@"Touch");

    if (buttonSprite == self.closeButton)
    {
        [self.inventorySpriteView removeFromParent];
    }
}

-(void)itemButtonSpritePressed:(ItemButtonSprite *)itemButtonSprite
{
    if (itemButtonSprite == self.toolItemButtonSprite)
    {
        [self.player unequipTool];
    }
    else if (itemButtonSprite == self.itemItemButtonSprite)
    {
        [self.player unequipItem];
    }
    else if (itemButtonSprite.item.itemType == ItemTypeSword ||
             itemButtonSprite.item.itemType == ItemTypeWateringCan ||
             itemButtonSprite.item.itemType == ItemTypeHoe ||
             itemButtonSprite.item.itemType == ItemTypeHammer
             )
    {
        [self.player equipItem:itemButtonSprite.item];
    }
    else
    {
        [self.player equipItem:itemButtonSprite.item];
    }
    
    [self updateViews];
    
    NSLog(@"You pressed: %@", itemButtonSprite.item.itemName);
}


@end
