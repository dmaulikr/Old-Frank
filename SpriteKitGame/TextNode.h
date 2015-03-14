//
//  TextNode.h
//  SpriteKitGame
//
//  Created by Skyler Lauren on 2/9/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DialogManager.h"

@class TextNode;

@protocol TextNodeDelegate <NSObject>

-(void)didSelectAnswer:(NSString *)answer forTextNode:(TextNode *)textNode;

@end

@interface TextNode : SKNode

-(id)initWithSize:(CGSize)size withDialog:(Dialog *)dialog;

-(void)startAnimation;

@property (weak)id<TextNodeDelegate> delegate;
@property (nonatomic)CGSize size;

@property (nonatomic, strong)Dialog *dialog;
@property (nonatomic, strong)DialogBlock dialogBlock;


@end
