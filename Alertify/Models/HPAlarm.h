//
//  HPAlarm.h
//  Alertify
//
//  Created by Hans Pinckaers on 08-10-13.
//  Copyright (c) 2013 Hans Pinckaers. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    aBird,
    aClock
} AlarmSound;

@interface HPAlarm : NSObject

@property (strong) NSDate *dueDate;
@property (assign, getter = isSnoozing) BOOL snoozing;
@property (assign) BOOL shouldSnooze;

@property (strong) NSString *title;
@property (assign) AlarmSound sound;

@end
