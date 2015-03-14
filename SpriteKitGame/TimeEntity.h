//
//  TimeEntity.h
//  Old Frank
//
//  Created by Skyler Lauren on 3/21/15.
//  Copyright (c) 2015 Sky Mist Development. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TimeEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * current_time;
@property (nonatomic, retain) NSNumber * day;
@property (nonatomic, retain) NSNumber * season;

@end
