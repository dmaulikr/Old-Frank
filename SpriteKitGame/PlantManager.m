//
//  PlantManager.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/5/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "PlantManager.h"
#import <sqlite3.h>

@implementation PlantManager

+(Plant *)plantforName:(NSString *)plantName
{
    Plant *plant = [[Plant alloc]init];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"items.sqlite3"];
    BOOL success = [fileMgr fileExistsAtPath:dbPath];
    
    if(!success)
    {
        NSLog(@"Cannot locate database file '%@'.", dbPath);
    }
    
    sqlite3 *database;
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
        
        NSString *query = [NSString stringWithFormat:@"SELECT * FROM plants WHERE plant_name = \"%@\"", plantName];
        
        const char *sql =  [query UTF8String]; // "SELECT * FROM dialog WHERE dialog_id = ;";
        sqlite3_stmt *selectStatement;
        if(sqlite3_prepare_v2(database, sql, -1, &selectStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(selectStatement) == SQLITE_ROW) {
                
                plant.plantName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1)];
                plant.stage1Days = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2)] integerValue];
                plant.stage2Days = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 3)] integerValue];
                plant.stage3Days = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 4)] integerValue];
                plant.season = [[NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 5)] integerValue];
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
    
    if (!plant.plantName)
    {
        NSLog(@"Error finding plant: %@", plantName);
    }
    return plant;
}

+ (NSString *)getDatabasePath
{
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"items.sqlite3"];
}

@end
