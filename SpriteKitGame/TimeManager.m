//
//  TimeManager.m
//  SpriteKitGame
//
//  Created by Skyler Lauren on 2/9/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import "TimeManager.h"
#import "TimeEntity.h"
#import "SMDCoreDataHelper.h"

@interface TimeManager ()

@property (nonatomic, strong)TimeEntity *timeEntiy;

@end

@implementation TimeManager

+(TimeManager *)sharedManager
{
    static TimeManager *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[TimeManager alloc] init];
        
       
    });
    
    return _sharedInstance;
}

-(id)init{
    self = [super init];
    
    NSArray *results = [[SMDCoreDataHelper sharedHelper]fetchEntities:@"TimeEntity"];
    
    if (!results.count)
    {
        self.timeEntiy = [[SMDCoreDataHelper sharedHelper]createNewEntity:@"TimeEntity"];
        self.timeEntiy.current_time = @(360);
        self.timeEntiy.day = @(1);
        self.timeEntiy.season = @(SeasonSpring);
        [[SMDCoreDataHelper sharedHelper]save];
    }
    else if (results.count == 1)
    {
        self.timeEntiy = [results firstObject];
    }
    else
    {
        NSLog(@"Error: too many time entities");
    }
    
    self.time = [self.timeEntiy.current_time floatValue];
    self.day = [self.timeEntiy.day integerValue];
    self.season = [self.timeEntiy.season integerValue];
    
    return self;
}

-(void)nextDayForTime:(float)time
{
    self.time = time;
    self.day++;
    
    if (self.day > 30)
    {
        self.day = 1;
        
        switch (self.season)
        {
            case SeasonSpring:
                self.season = SeasonSummer;
                break;
            case SeasonSummer:
                self.season = SeasonFall;
                break;
            case SeasonFall:
                self.season = SeasonWinter;
                break;
            case SeasonWinter:
                self.season = SeasonSpring;
                break;
            default:
                break;
        }
    }

}

-(void)addTime:(float)dt
{
    self.time += (dt *1);
    
    if (self.time > 1440)
    {
        [self nextDayForTime:0];
    }
    
    
    if ((self.time >= 0 && self.time < 360) ||
        (self.time >= 1200))
    {
        self.isNight = YES;
    }
    else
    {
        self.isNight = NO;
    }
    
    self.timeEntiy.current_time = @(self.time);
}

-(void)setDay:(NSInteger)day
{
    _day = day;
    self.timeEntiy.day = @(day);
}

-(void)setSeason:(Season)season
{
    _season = season;
    self.timeEntiy.season = @(season);
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    if (minutes > 12)
    {
        minutes = minutes-12;
    }
    else if (minutes == 0)
    {
        minutes = 12;
    }
    
    NSString *AMPM;
    
    if (totalSeconds >= 720)
    {
        AMPM = @"PM";
    }
    else
    {
        AMPM = @"AM";
    }
    
    NSString *seasonString;
    
    switch (self.season)
    {
        case SeasonSpring:
            seasonString = @"Spring";
            break;
        case SeasonSummer:
            seasonString = @"Summer";
            break;
        case SeasonFall:
            seasonString = @"Fall";
            break;
        case SeasonWinter:
            seasonString = @"Winter";
            break;
        default:
            break;
    }
    
    NSInteger rmd = self.day % 6;
    
    NSString *day = @"";
    
    switch (rmd)
    {
        case 1:
            day = @"Mon";
            break;
        case 2:
            day = @"Tue";
            break;
        case 3:
            day = @"Wed";
            break;
        case 4:
            day = @"Thu";
            break;
        case 5:
            day = @"Fri";
            break;
        case 0:
            day = @"Wek";
            break;
            
        default:
            day = @"error";
            break;
    }


    return [NSString stringWithFormat:@"%@ %@ %@ %02d:%02d %@", seasonString, day, @(self.day), minutes, seconds, AMPM];
}


-(NSString *)timeStringValue
{
    return [self timeFormatted:self.time];
}


@end
