//
//  TextSprite.h
//  Old Frank
//
//  Created by Skyler Lauren on 3/21/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TextSprite : SKSpriteNode

-(id)initWithString:(NSString *)string;
@property (nonatomic, strong)NSString *text;

@end
