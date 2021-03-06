//
//  ViewController.m
//  timeleft
//
//  Created by CAwesome on 02/09/2014.
//  Copyright (c) 2014 pogestudio. All rights reserved.
//

typedef enum {
    kDateTagUndefined = 0,
    kDateTagStart = 99,
    kDateTagEnd = 100
} DateTag;

#import "ViewController.h"
#import "DatePickerVC.h"
#import "NSDate+Helper.h"
#import "NSDate+timerHelper.h"
#import "VisualViewVC.h"
#import "AppColors.h"

#define kStartDateKey @"TimeLeftStartDateKey"
#define kEndDateKey @"TimeLeftEndDateKey"

@interface ViewController ()
{
    DateTag _lastPickedDate;
}

@property (strong) DatePickerVC *datePickerVC;
@property (strong) NSDate *startDate;
@property (strong) NSDate *endDate;
@property (strong) NSTimer *UIUpdateTimer;
@property (strong) VisualViewVC *visualVC;

@property (strong) IBOutlet UIButton *startTimeButton;
@property (strong) IBOutlet UIButton *endTimeButton;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (!self.datePickerVC) {
        self.datePickerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DatePickerVC"];
        self.datePickerVC.parentVC = self;
        NSAssert(self.datePickerVC,@"DatePickershould not be nil!");
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.UIUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateLabels) userInfo:nil repeats:YES];
    [self.UIUpdateTimer fire];
    

    
    self.view.backgroundColor = [[AppColors currentColorScheme] generalBackground];
    [self.startTimeButton setTitleColor:[[AppColors currentColorScheme] timeButtonTitle] forState:UIControlStateNormal];
    [self.endTimeButton setTitleColor:[[AppColors currentColorScheme] timeButtonTitle] forState:UIControlStateNormal];

    
    
    //PREPARE
    [self loadDatesIfNeeded];
    [self updateButtonLabels];
    
    
    UIFont *sharedFont;
    if (self.startTimeButton.titleLabel.text.length < 6) {
        sharedFont = [UIFont fontWithName:@"Quicksand-Regular" size:25.0];
    } else {
        sharedFont = [UIFont fontWithName:@"Quicksand-Regular" size:15.0];
    }
    
    [self.startTimeButton.titleLabel setFont:sharedFont];
    [self.endTimeButton.titleLabel setFont:sharedFont];

    
}

-(IBAction)userWantsToPickDate:(id)sender
{
    NSAssert([sender isKindOfClass:[UIButton class]], @"Sender in dateVcPop is wrong class");
    _lastPickedDate = (DateTag)((UIButton*)sender).tag;
    NSAssert(_lastPickedDate == kDateTagStart || _lastPickedDate == kDateTagEnd, @"An incorrect datePickerTag is requesting the date to be picked!");
    NSDate *currentDate = _lastPickedDate == kDateTagStart ? self.startDate : self.endDate;
    [self.datePickerVC setUpWithDate:currentDate];
    [self slideInDatePicker];
}


-(void)userPickedDate:(NSDate*)newDate
{
    NSAssert(newDate, @"Picked date is nil. WTF?");
    
    switch (_lastPickedDate) {
        case kDateTagStart:
        {
            self.startDate = newDate;
            break;
        }
        case kDateTagEnd:
        {
            self.endDate = newDate;
            break;
        }
        default:
            NSLog(@"User canceled or some shits");
            break;
    }
    [self updateButtonLabels];
    [self slideOutDatePicker];
    [self saveCurrentDates];
}

-(void)updateButtonLabels
{
    static NSDateFormatter *_buttonFormatter;
    if (!_buttonFormatter) {
        _buttonFormatter = [[NSDateFormatter alloc] init];
        [_buttonFormatter setDateFormat:@"HH:mm"];
    }

    if (self.startDate) {
        NSString *dateString = [_buttonFormatter stringFromDate:self.startDate];
        [self.startTimeButton setTitle:dateString forState:UIControlStateNormal];
    }
    if (self.endDate) {
        NSString *dateString = [_buttonFormatter stringFromDate:self.endDate];
        [self.endTimeButton setTitle:dateString forState:UIControlStateNormal];

    }

}

-(void)updateLabels
{
    if (!self.startDate || !self.endDate) {
        return;
    }
    
    [self makeSureEndDateIsCorrectDay];
    [self makeSureDatesAreInOrder];
    [self.visualVC showPieChartForStartTime:self.startDate andEndTime:self.endDate];
    
}

#pragma mark DateFixes

-(void)makeSureEndDateIsCorrectDay
{
    //This will execute every time when the span crosses a day shift. Observed, but ignored for now.

    //shift to today
    self.endDate = [self.endDate dateAdjustedToBeTheSameDayAs:[NSDate date]];
    
    //if it's earlier than current time, shift one day forward
    if ([self.endDate isEarlierThanDate:[NSDate date]]) {
        CGFloat secondsInADay = ((60 * 60) * 24);
        NSDate *newDate = [NSDate dateWithTimeInterval:secondsInADay sinceDate:self.endDate];
        self.endDate = newDate;
    }
}

-(void)makeSureDatesAreInOrder
{
    //This will execute every time when the span crosses a day shift. Observed, but ignored for now.
    
    
    //make sure that the end day and start day are on the same day
    BOOL datesAreOnSameDay = [self.startDate isEqualToDateIgnoringTime:self.endDate];
    if (!datesAreOnSameDay) {
        self.startDate = [self.startDate dateAdjustedToBeTheSameDayAs:self.endDate];
    }
    
    //If start date is earlier than end date, all is fine.
    //If not, push back start date 24 hrs.
    BOOL startIsLaterThanEnd = [self.startDate isLaterThanDate:self.endDate];
    if (startIsLaterThanEnd) {
        CGFloat secondsInADay = ((60 * 60) * 24);
        NSDate *newDate = [NSDate dateWithTimeInterval:-secondsInADay sinceDate:self.startDate];
        self.startDate = newDate;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"VisualVCSegue"])
    {
        self.visualVC = (VisualViewVC*)[segue destinationViewController];
        NSAssert(self.visualVC, @"VisualVC is nil!!!!!!!");
    }
}

#pragma mark DatePickerStuff
-(void)slideInDatePicker
{
    CGRect beforeFrame = CGRectMake(self.view.frame.size.width,
                                    self.view.frame.size.height-self.datePickerVC.view.frame.size.height,
                                    self.datePickerVC.view.frame.size.width,
                                    self.datePickerVC.view.frame.size.height);
    self.datePickerVC.view.frame = beforeFrame;
    
    if (!self.datePickerVC.view.superview) {
        [self.view addSubview:self.datePickerVC.view];
    }
    
    CGFloat animationDuration = 0.5;
    CGRect afterFrame = CGRectMake(0,
                                   self.view.frame.size.height-self.datePickerVC.view.frame.size.height,
                                   self.datePickerVC.view.frame.size.width,
                                   self.datePickerVC.view.frame.size.height);
    [UIView animateWithDuration:animationDuration animations:^{
        self.datePickerVC.view.frame = afterFrame;
    }];
}

-(void)slideOutDatePicker
{
    CGFloat animationDuration = 0.5;
    CGRect afterFrame = CGRectMake(-self.datePickerVC.view.frame.size.width,
                                   self.view.frame.size.height-self.datePickerVC.view.frame.size.height,
                                   self.datePickerVC.view.frame.size.width,
                                   self.datePickerVC.view.frame.size.height);
    [UIView animateWithDuration:animationDuration animations:^{
        self.datePickerVC.view.frame = afterFrame;
    }];
}

#pragma mark Saving/Loading
-(void)loadDatesIfNeeded
{
    if (!self.startDate) {
        self.startDate = [[NSUserDefaults standardUserDefaults] objectForKey:kStartDateKey];
    }
    if (!self.endDate) {
        self.endDate = [[NSUserDefaults standardUserDefaults] objectForKey:kEndDateKey];
    }
}

-(void)saveCurrentDates
{
    if (self.startDate) {
        [[NSUserDefaults standardUserDefaults] setObject:self.startDate forKey: kStartDateKey];
    }
    if (self.endDate) {
        [[NSUserDefaults standardUserDefaults] setObject:self.endDate forKey: kEndDateKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
