//
//  Player.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/5/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "Player.h"
#import "ItemManager.h"
#import "SMDCoreDataHelper.h"
#import "ItemEntity.h"

@interface Player ()

@property (nonatomic)NSInteger wateringUses;
@property (nonatomic)NSInteger hoeUses;
@property (nonatomic)NSInteger hammerUses;
@property (nonatomic)NSInteger spellbookUses;
@property (nonatomic)NSInteger swordUses;
@property (nonatomic)NSInteger axeUses;

@property (nonatomic)float baseSkillUpCost;

@end

@implementation Player

static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake((int)(a.x + b.x), (int)a.y + b.y);
}

static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

-(id)init
{
    self = [super init];
    
    self.baseSkillUpCost = 5;
    
    NSArray *players = [[SMDCoreDataHelper sharedHelper]fetchEntities:@"PlayerEntity"];
    self.imageName = @"knight";
    
    self.width = 30;
    self.height = 60;
    self.rows = 4;
    self.columns = 4;
//    self.columns = 2;
   
    if (players.count == 1)
    {
        NSLog(@"found old player");
        
        [self loadPlayerFromCoreData:players[0]];
    }
    else
    {
        PlayerEntity *playerEntity = [[SMDCoreDataHelper sharedHelper]createNewEntity:@"PlayerEntity"];
        self.playerEntity = playerEntity;
        
        self.energy = 100;
        self.maxEnergy = 100;
        
        self.swordSkill = 1;
        self.wateringSkill = 1;
        self.hoeSkill = 1;
        self.hammerSkill = 1;
        self.spellbookSkill = 1;
        self.axeSkill = 1;
        
//        [self addItemWithName:@"basic_sword"];
//        [self addItemWithName:@"fire_spellbook"];
        [self addItemWithName:@"basic_watering_can"];
        [self addItemWithName:@"basic_hoe"];
    }
    
    return self;
}

-(void)setEnergy:(float)energy
{
    self.playerEntity.energy = @(energy);
    _energy = energy;
}

-(void)setMaxEnergy:(float)maxEnergy
{
    self.playerEntity.max_energy = @(maxEnergy);
    _maxEnergy = maxEnergy;
}

-(void)setSwordSkill:(NSInteger)swordSkill
{
    self.playerEntity.sword_skill = @(swordSkill);
    _swordSkill = swordSkill;
}

-(void)setWateringSkill:(NSInteger)wateringSkill
{
    self.playerEntity.watering_skill = @(wateringSkill);
    _wateringSkill = wateringSkill;
}

-(void)setHoeSkill:(NSInteger)hoeSkill
{
    self.playerEntity.hoe_skill = @(hoeSkill);
    _hoeSkill = hoeSkill;
}

-(void)setHammerSkill:(NSInteger)hammerSkill
{
    self.playerEntity.hammer_skill = @(hammerSkill);
    _hammerSkill = hammerSkill;
}

-(void)setSpellbookSkill:(NSInteger)spellbookSkill
{
    self.playerEntity.spellbook_skill = @(spellbookSkill);
    _spellbookSkill = spellbookSkill;
}

-(void)setAxeSkill:(NSInteger)axeSkill
{
    self.playerEntity.axe_skill = @(axeSkill);
    _axeSkill = axeSkill;
}

-(void)setWateringUses:(NSInteger)wateringUses
{
    self.playerEntity.watering_uses = @(wateringUses);
    _wateringUses = wateringUses;
}

-(void)setHoeUses:(NSInteger)hoeUses
{
    self.playerEntity.hoe_uses = @(hoeUses);
    _hoeUses = hoeUses;
}

-(void)setHammerUses:(NSInteger)hammerUses
{
    self.playerEntity.hammer_uses = @(hammerUses);
    _hammerUses = hammerUses;
}

-(void)setSpellbookUses:(NSInteger)spellbookUses
{
    self.playerEntity.spellbook_uses = @(spellbookUses);
    _spellbookUses = spellbookUses;
}

-(void)setSwordUses:(NSInteger)swordUses
{
    self.playerEntity.sword_uses = @(swordUses);
    _swordUses = swordUses;
}

-(void)setAxeUses:(NSInteger)axeUses
{
    self.playerEntity.axe_uses = @(axeUses);
    _axeUses = axeUses;
}

-(void)loadPlayerFromCoreData:(PlayerEntity *)playerEntity
{
    self.energy = [playerEntity.energy floatValue];
    self.maxEnergy = [playerEntity.max_energy floatValue];
    self.equippedItem = [[Item alloc]initWithItemEntity:playerEntity.equppied_item];
    self.equippedTool = [[Item alloc]initWithItemEntity:playerEntity.equipped_tool];
    self.gold = [playerEntity.gold integerValue];
    
    //skills
    self.wateringSkill = [playerEntity.watering_skill integerValue];
    self.hoeSkill = [playerEntity.hoe_skill integerValue];
    self.hammerSkill = [playerEntity.hammer_skill integerValue];
    self.spellbookSkill = [playerEntity.spellbook_skill integerValue];
    self.swordSkill = [playerEntity.sword_skill integerValue];
    self.axeSkill = [playerEntity.axe_skill integerValue];
    
    self.wateringUses = [playerEntity.watering_uses integerValue];
    self.hoeUses = [playerEntity.hoe_uses integerValue];
    self.hammerUses = [playerEntity.hammer_uses integerValue];
    self.spellbookUses = [playerEntity.spellbook_uses integerValue];
    self.swordUses = [playerEntity.sword_uses integerValue];
    self.axeUses = [playerEntity.axe_uses integerValue];
    
    for (ItemEntity *itemEntity in [playerEntity.inventory allObjects])
    {
        NSLog(@"adding from core data: %@", itemEntity.item_name);
        Item *item = [[Item alloc]initWithItemEntity:itemEntity];
        [self.inventory addObject:item];
    }
    
    self.playerEntity = playerEntity;
}

-(void)setGold:(NSInteger)gold
{
    _gold = gold;
    
    self.playerEntity.gold = @(gold);
    
    [[SMDCoreDataHelper sharedHelper]save];
}

-(NSMutableArray *)inventory
{
    if (!_inventory) {
        _inventory = [[NSMutableArray alloc]init];
    }
    
    return _inventory;
}

-(void)addItemWithName:(NSString *)name
{

    BOOL added = NO;
    
    if (self.equippedItem)
    {
        if ([self.equippedItem.itemName isEqualToString:name]
            && self.equippedItem.maxStack > (self.equippedItem.quantity+1))
        {
            self.equippedItem.quantity += 1;
            NSLog(@"increased equipped: %@ quantity: %@", self.equippedItem.itemName, @(self.equippedItem.quantity));
            added = YES;
            return;
        }
    }
    
    for (Item *item in self.inventory)
    {
        if ([item.itemName isEqualToString:name]
            && item.maxStack > (item.quantity +1))
        {
            item.quantity += 1;
            
            NSLog(@"added new item: %@", item.itemName);

            added = YES;
            
            return;
        }
    }
    
    if (!added)
    {
        
        ItemEntity *itemEntity = [[SMDCoreDataHelper sharedHelper]createNewEntity:@"ItemEntity"];
        itemEntity.item_name = name;
        itemEntity.quantity = @(1);
        itemEntity.player_inventory = self.playerEntity;
        
        Item *item = [[Item alloc]initWithItemEntity:itemEntity];


        NSLog(@"added new stack: %@", item.itemName);

        [self.inventory addObject:item];
        
    }
    
    [[SMDCoreDataHelper sharedHelper]save];

}

-(void)addItemWithName:(NSString *)name withCount:(NSInteger)count
{
    ItemEntity *itemEntity = [[SMDCoreDataHelper sharedHelper]createNewEntity:@"ItemEntity"];
    itemEntity.item_name = name;
    itemEntity.quantity = @(count);
    itemEntity.player_inventory = self.playerEntity;
    
    Item *item = [[Item alloc]initWithItemEntity:itemEntity];
    
    NSLog(@"added new item: %@ quantity: %@", item.itemName, @(item.quantity));
    
    [self.inventory addObject:item];
    
    [[SMDCoreDataHelper sharedHelper]save];
}

-(void)equipItem:(Item *)item
{
    switch (item.itemType)
    {
        case ItemTypeSword:
            [self equipTool:item];
            break;
        case ItemTypeHammer:
            [self equipTool:item];
            break;
        case ItemTypePlant:
            [self equipRegularItem:item];
            break;
        case ItemTypeHoe:
            [self equipTool:item];
            break;
        case ItemTypeWateringCan:
            [self equipTool:item];
            break;
        case ItemTypeSeed:
            [self equipRegularItem:item];
            break;
        case ItemTypeSpellbook:
            [self equipRegularItem:item];
            break;
            
        default:
            break;
    }
}

-(void)equipTool:(Item *)item
{
    if (self.equippedTool)
    {
        [self unequipTool];
    }
    
    [self.inventory removeObject:item];
    self.equippedTool = item;
    
    item.itemEntity.player_inventory = nil;
    item.itemEntity.player_tool = self.playerEntity;

}

-(void)equipRegularItem:(Item *)item
{
    if (self.equippedItem)
    {
        [self unequipItem];
    }
    
    [self.inventory removeObject:item];
    self.equippedItem = item;
    
    item.itemEntity.player_inventory = nil;
    item.itemEntity.player_item = self.playerEntity;

}

-(void)unequipItem
{
    Item *item = self.equippedItem;
    
    [self.inventory addObject:item];
    self.equippedItem = nil;
    
    item.itemEntity.player_inventory = nil;
    item.itemEntity.player_item = self.playerEntity;
}
         
-(void)unequipTool
{
    Item *item = self.equippedTool;
    
    [self.inventory addObject:item];
    self.equippedTool = nil;
    
    item.itemEntity.player_tool = nil;
    item.itemEntity.player_inventory = self.playerEntity;
}

-(void)removeItem
{
    self.equippedItem.quantity--;
    
    NSLog(@"Equip count: %@", @(self.equippedItem.quantity));
    
    if (!self.equippedItem.quantity)
    {
         [[SMDCoreDataHelper sharedHelper]removeEntity:self.equippedItem.itemEntity andSave:YES];
        
        self.equippedItem = nil;
    }
    else if (self.equippedItem.quantity < 0)
    {
        NSLog(@"ERROR FOR QUANTITY!!!");
    }
}

-(void)update:(float)dt
{
    self.frameTimer += dt;
    
    if (self.frameTimer > self.frameTimerMax)
    {
        self.frameIndex = (self.frameIndex + 1) % 4;
        self.frameTimer = 0;
    }
    
    if (!self.isMoving)
    {
        self.frameIndex = 1;
    }
    
    float speedModifier = 1.25;
    
    switch (self.direction)
    {
        case DirectionDown:
            self.moveVelocity = CGPointMake(0, -100);
            break;
        case DirectionUp:
            self.moveVelocity = CGPointMake(0, 100);
            break;
        case DirectionLeft:
            self.moveVelocity = CGPointMake(-100, 0);
            break;
        case DirectionRight:
            self.moveVelocity = CGPointMake(100, 0);
            break;
            
        default:
            break;
    }
    
    //frame logic
    float frameMax = 20;
    float frameTimerMaxX = frameMax * (1.0f/fabs(self.moveVelocity.x));
    float frameTimerMaxY = frameMax * (1.0f/fabs(self.moveVelocity.y));
    
    self.frameTimerMax = (frameTimerMaxX > frameTimerMaxY) ? frameTimerMaxY : frameTimerMaxX;
    
    self.moveVelocity = rwMult(self.moveVelocity, dt*speedModifier);
    self.moveVelocity = CGPointMake((int)self.moveVelocity.x, (int)self.moveVelocity.y);
    
    self.position = rwAdd(self.position, self.moveVelocity);
    
    if (self.direction == DirectionRight && self.position.x > self.moveToPoint.x)
    {
        self.position = self.moveToPoint;
    }
    else if (self.direction == DirectionLeft && self.position.x < self.moveToPoint.x)
    {
        self.position = self.moveToPoint;
    }
    else if (self.direction == DirectionUp && self.position.y > self.moveToPoint.y)
    {
        self.position = self.moveToPoint;
    }
    else if (self.direction == DirectionDown && self.position.y < self.moveToPoint.y)
    {
        self.position = self.moveToPoint;
    }
    
    if (self.position.x == self.moveToPoint.x && self.position.y == self.moveToPoint.y)
    {
        self.isMoving = NO;
        self.moveToPoint = CGPointMake(0, 0);
    }
}

-(void)addItemToInventory:(Item *)item
{
    [self.inventory addObject:item];
    item.itemEntity.player_inventory = self.playerEntity;
    [[SMDCoreDataHelper sharedHelper]save];
}

-(void)removeItemToInventory:(Item *)item
{
    [self.inventory removeObject:item];
    item.itemEntity.player_inventory = nil;
    [[SMDCoreDataHelper sharedHelper]save];
}

-(void)useTool
{
    switch (self.equippedTool.itemType)
    {
        case ItemTypeHammer:
            [self useHammer];
            break;
            
        case ItemTypeHoe:
            [self useHoe];
            break;
            
        case ItemTypeSpellbook:
            [self useSpellbook];
            break;
        
        case ItemTypeSword:
            [self useSword];
            break;
            
        case ItemTypeWateringCan:
            [self useWateringCan];
            break;
            
        default:
            break;
    }
    
    [[SMDCoreDataHelper sharedHelper]save];
}

-(float)energyForSkill:(float)skill
{
    float costReduction =  (float)self.equippedTool.energyCost * (skill/100.0f);
    
    if (costReduction > self.equippedTool.energyCost-1)
    {
        costReduction = self.equippedTool.energyCost -1;
    }
    
    return (float)self.equippedTool.energyCost - costReduction;
}

-(void)useHammer
{
    self.energy -= [self energyForSkill:self.hammerSkill];;
    
    if (self.energy > 0)
    {
        self.hammerUses++;
        
        if (self.hammerUses >= self.hammerSkill *self.baseSkillUpCost)
        {
            self.hammerUses = 0;
            self.hammerSkill++;
            
            self.skilledUp = YES;
        }
    }
}

-(void)useHoe
{
    self.energy -= [self energyForSkill:self.hoeSkill];
    
    if (self.energy > 0)
    {
        self.hoeUses++;
        
        if (self.hoeUses >= self.hoeSkill *self.baseSkillUpCost)
        {
            self.hoeUses = 0;
            self.hoeSkill++;
            
            self.skilledUp = YES;
        }
    }
}

-(void)useSpellbook
{
    self.energy -= [self energyForSkill:self.spellbookSkill];
    
    if (self.energy > 0)
    {
        self.spellbookUses++;
        
        if (self.spellbookUses >= self.spellbookSkill *self.baseSkillUpCost)
        {
            self.spellbookUses = 0;
            self.hoeSkill++;
            
            self.skilledUp = YES;
        }
    }
}

-(void)useSword
{
    self.energy -= [self energyForSkill:self.swordSkill];
    
    if (self.energy > 0)
    {
        self.swordUses++;
        
        if (self.swordUses >= self.swordSkill *self.baseSkillUpCost)
        {
            self.swordUses = 0;
            self.swordSkill++;
            
            self.skilledUp = YES;
        }
    }
}

-(void)useWateringCan
{
    self.energy -= [self energyForSkill:self.wateringSkill];
    
    if (self.energy > 0)
    {
        self.wateringUses++;
        
        if (self.wateringUses >= self.wateringSkill *self.baseSkillUpCost)
        {
            self.wateringUses = 0;
            self.wateringSkill++;
            
            self.skilledUp = YES;
        }
    }
}



@end
