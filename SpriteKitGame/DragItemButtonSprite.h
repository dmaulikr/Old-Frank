//
//  DragItemButtonSprite.h
//  Old Frank
//
//  Created by Skyler Lauren on 3/11/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "ItemButtonSprite.h"

@class DragItemButtonSprite;

@protocol DragItemButtonSpriteDelegate <NSObject>

-(void)doneDraggingDragItemButtonSprite:(DragItemButtonSprite *)dragItemButtonSprite;

@end

@interface DragItemButtonSprite : ItemButtonSprite

@property (nonatomic, weak)id<DragItemButtonSpriteDelegate> dragDelegate;

@end
