//
//  ItemManager.h
//  SpriteKitGame
//
//  Created by Skyler Lauren on 1/7/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
#import <sqlite3.h>

@interface ItemManager : NSObject

-(Item *)getItem:(NSString *)itemName;
-(NSArray *)itemsForSale;

+(ItemManager *)sharedManager;


@end
