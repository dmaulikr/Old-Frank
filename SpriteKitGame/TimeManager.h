//
//  TimeManager.h
//  SpriteKitGame
//
//  Created by Skyler Lauren on 2/9/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Season) {
    SeasonSpring = 0,
    SeasonSummer = 1,
    SeasonFall = 2,
    SeasonWinter = 3
};


@interface TimeManager : NSObject

@property (nonatomic)float time;
@property (nonatomic)NSInteger day;
@property (nonatomic)Season season;
@property (nonatomic)BOOL isNight;

+(TimeManager *)sharedManager;

-(void)addTime:(float)dt;
-(NSString *)timeStringValue;
-(void)nextDayForTime:(float)time;

@end
