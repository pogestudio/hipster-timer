//
//  DatePickerVC.m
//  timeleft
//
//  Created by CAwesome on 02/09/2014.
//  Copyright (c) 2014 pogestudio. All rights reserved.
//

#import "DatePickerVC.h"
#import "AppColors.h"

@interface DatePickerVC ()

@property (strong) IBOutlet UIDatePicker *datePicker;
@property (strong) IBOutlet UIButton *doneButton;
@property (strong) IBOutlet UIButton *cancelButton;

@end



@implementation DatePickerVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.doneButton setBackgroundColor:[[Colors currentColorScheme] doneButtonBackground]];
//    [self.cancelButton setBackgroundColor:[[Colors currentColorScheme] cancelButtonBackground]];
    [self.doneButton setBackgroundColor:[[AppColors currentColorScheme] generalBackground]];
    [self.cancelButton setBackgroundColor:[[AppColors currentColorScheme] generalBackground]];
    [self.doneButton setTitleColor:[[AppColors currentColorScheme] doneButtonTitle] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[[AppColors currentColorScheme] cancelButtonTitle] forState:UIControlStateNormal];
    self.view.backgroundColor = [[AppColors currentColorScheme] generalBackground];
    
    UIFont *sharedFont = [UIFont fontWithName:@"Quicksand-Regular" size:20.0];
    [self.doneButton.titleLabel setFont:sharedFont];
    [self.cancelButton.titleLabel setFont:sharedFont];
    

}

-(void)setUpWithDate:(NSDate *)currentDate
{
    NSDate *dateToShow = currentDate ? currentDate : [NSDate date];
    [self.datePicker setDate:dateToShow animated:NO];
}

-(IBAction)userWantsToReturn:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]] && ((UIButton*)sender) == self.doneButton) {
        NSDate *pickedDate = [self.datePicker date];
        [self.parentVC userPickedDate:pickedDate];
        
    } else {
        [self.parentVC slideOutDatePicker];
    }
}

@end
