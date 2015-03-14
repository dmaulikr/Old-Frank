//
//  ItemManager.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/7/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "ItemManager.h"
#import "AnimatedItem.h"

@interface ItemManager ()

@property (nonatomic, strong)NSDictionary *items;

@end

@implementation ItemManager

+ (ItemManager *)sharedManager {
    static ItemManager *sharedItemManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedItemManager = [[self alloc] init];
    });
    return sharedItemManager;
}

-(Item *)getItem:(NSString *)itemName
{
    if (!self.items)
    {
        NSLog(@"firing up SQL");
        [self getSQLiteData];
    }
    
    Item *storedItem = self.items[itemName];
    
    if (!storedItem && ![itemName isEqualToString:@"farm_plot"])
    {
        NSLog(@"Error finding Item: %@", itemName);
    }
    
    Item *item;
    
    if ([storedItem isKindOfClass:[AnimatedItem class]])
    {
        item = [[AnimatedItem alloc]init];
        AnimatedItem *animatedItem = (AnimatedItem *)item;
        AnimatedItem *storedAnimatedItem = (AnimatedItem *)storedItem;
        
        animatedItem.animatedFrames = storedAnimatedItem.animatedFrames;
        animatedItem.animatedRate = storedAnimatedItem.animatedRate;
        
        NSLog(@"item: %@", storedItem);
        
    }
    else
    {
        item = [[Item alloc]init];

    }
    item.itemName = storedItem.itemName;
    item.itemType = storedItem.itemType;
    item.maxStack = storedItem.maxStack;
    item.impassable = storedItem.impassable;
    item.canPickUp = storedItem.canPickUp;
    item.quantity = 1;
    item.sellPrice = storedItem.sellPrice;
    item.purchasePrice = storedItem.purchasePrice;
    item.sellable = storedItem.sellable;
    item.energyCost = storedItem.energyCost;

    return item;
}

-(NSArray *)itemsForSale
{
    NSMutableArray *itemsToSell = [[NSMutableArray alloc]init];
    
    for (Item *item in [self.items allValues])
    {
        if (item.purchasePrice)
        {
            
            Item *copyOfItem = [[Item alloc]init];
            copyOfItem.itemName = item.itemName;
            copyOfItem.itemType = item.itemType;
            copyOfItem.maxStack = item.maxStack;
            copyOfItem.impassable = item.impassable;
            copyOfItem.canPickUp = item.canPickUp;
            copyOfItem.quantity = 1;
            copyOfItem.sellPrice = item.sellPrice;
            copyOfItem.purchasePrice = item.purchasePrice;
            copyOfItem.sellable = item.sellable;
            copyOfItem.energyCost = item.energyCost;

            [itemsToSell addObject:item];
        }
    }
    
    return itemsToSell;
}

-(NSString *)getDatabasePath
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"items.sqlite3"];
}

- (NSDictionary *)items
{
    if (!_items)
    {
        NSLog(@"firing up SQL");

        _items = [self getSQLiteData];
        
        NSLog(@"done");
        
    }
    
    
    return _items;
}

-(NSDictionary *)getSQLiteData
{
    NSMutableDictionary *items = [[NSMutableDictionary alloc]init];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"items.sqlite3"];
    BOOL success = [fileMgr fileExistsAtPath:dbPath];
   
    if(!success)
    {
        NSLog(@"Cannot locate database file '%@'.", dbPath);
    }
    
    sqlite3 *database;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        const char *sql = "SELECT * FROM items;";
        sqlite3_stmt *selectStatement;
        if(sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectStatement) == SQLITE_ROW) {
                
                Item *item;
                
               BOOL animated = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 5)] boolValue];
                
                if (animated)
                {
                     item = [[AnimatedItem alloc]init];
                    AnimatedItem *animatedItem = (AnimatedItem *)item;
                     animatedItem.animatedFrames = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 6)] integerValue];
                    animatedItem.animatedRate = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 7)] floatValue];
                }
                else
                {
                    item = [[Item alloc]init];
                }
                
                item.itemName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0)];
                item.itemType = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1)] integerValue];
                item.maxStack = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2)] integerValue];
                item.impassable = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 3)] boolValue];
                item.canPickUp = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 4)] boolValue];
                item.sellPrice = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 8)] integerValue];
                item.purchasePrice = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 9)] integerValue];
                item.sellable = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 10)] boolValue];
                item.energyCost = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 11)] integerValue];

                item.quantity = 1;
                if (animated) {
                    NSLog(@"ANIMATED NAME: %@, %@", item.itemName, item);
                }
                [items setObject:item forKey:item.itemName];
            }
        }
        else
        {
            NSLog(@"error: %s", sqlite3_errmsg(database));
        }
    }
    else
    {
        NSLog(@"error: %s", sqlite3_errmsg(database));

        NSLog(@"did not open");
    }
    sqlite3_close(database);
    
    return items;
}

@end
