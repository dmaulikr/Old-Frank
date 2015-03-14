//
//  DragItemButtonSprite.m
//  Old Frank
//
//  Created by Skyler Lauren on 3/11/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "DragItemButtonSprite.h"

@interface DragItemButtonSprite ()

@property (nonatomic)NSInteger oldZPosition;

@end

@implementation DragItemButtonSprite

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    self.oldZPosition = self.zPosition;
    
    self.zPosition = 100;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in [touches allObjects])
    {
        CGPoint position = [touch locationInNode:self.parent];
        self.position = position;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self.dragDelegate doneDraggingDragItemButtonSprite:self];
    self.zPosition = self.oldZPosition;
}

@end
