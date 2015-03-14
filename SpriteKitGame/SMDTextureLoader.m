//
//  TextureLoader.m
//  Old Frank
//
//  Created by Skyler Lauren on 3/14/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "SMDTextureLoader.h"


@interface SMDTextureLoader ()

@property (nonatomic, strong)NSMutableDictionary *textures;

@end

@implementation SMDTextureLoader

-(id)init
{
    self = [super init];
    
    self.textures = [[NSMutableDictionary alloc]init];
    
    return self;
}

-(SKTexture *)getTextureForName:(NSString *)name
{
    
    SKTexture *texture = self.textures[name];
    
    if (!texture)
    {
        texture = [SKTexture textureWithImageNamed:name];
        texture.filteringMode = FILTER_MODE;
        [self.textures setObject:texture forKey:name];
    }
    
    return texture;
}

@end
