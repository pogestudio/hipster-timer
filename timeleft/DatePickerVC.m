//
//  DatePickerVC.m
//  timeleft
//
//  Created by CAwesome on 02/09/2014.
//  Copyright (c) 2014 pogestudio. All rights reserved.
//

#import "DatePickerVC.h"

@interface DatePickerVC ()

@property (strong) IBOutlet UIDatePicker *datePicker;

@end

@implementation DatePickerVC

-(void)setUpWithDate:(NSDate *)currentDate
{
    NSDate *dateToShow = currentDate ? currentDate : [NSDate date];
    [self.datePicker setDate:dateToShow];
}

-(IBAction)userWantsToReturn:(id)sender
{
    NSDate *pickedDate = [self.datePicker date];
    [self.parentVC userPickedDate:pickedDate];
}

@end
