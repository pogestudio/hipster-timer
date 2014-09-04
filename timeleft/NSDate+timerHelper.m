//
//  NSDate+timerHelper.m
//  timeleft
//
//  Created by CAwesome on 04/09/2014.
//  Copyright (c) 2014 pogestudio. All rights reserved.
//

#import "NSDate+timerHelper.h"


#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (timerHelper)


//Create a new date from the current date
//set the date to be the same as the reference date
-(NSDate*)dateAdjustedToBeTheSameDayAs:(NSDate *)referenceDate
{
    NSDateComponents *endDateComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:referenceDate];
    
    //gather date components from date
    NSDateComponents *newDateComponents = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    //set date components
    [newDateComponents setYear:[endDateComponents year]];
    [newDateComponents setMonth:[endDateComponents month]];
    [newDateComponents setDay:[endDateComponents day]];
    
    //save date relative from date
    NSDate *newDate = [CURRENT_CALENDAR dateFromComponents:newDateComponents];
    return newDate;
}

@end
