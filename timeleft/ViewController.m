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

@interface ViewController ()
{
    DateTag _lastPickedDate;
}

@property (strong) DatePickerVC *datePickerVC;
@property (strong) NSDate *startDate;
@property (strong) NSDate *endDate;
@property (strong) NSTimer *UIUpdateTimer;

@property (strong) IBOutlet UILabel  *timeLeft;

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

}

-(IBAction)userWantsToPickDate:(id)sender
{
    NSAssert([sender isKindOfClass:[UIButton class]], @"Sender in dateVcPop is wrong class");
    _lastPickedDate = (DateTag)((UIButton*)sender).tag;
    NSAssert(_lastPickedDate == kDateTagStart || _lastPickedDate == kDateTagEnd, @"An incorrect datePickerTag is requesting the date to be picked!");
    NSDate *currentDate = _lastPickedDate == kDateTagStart ? self.startDate : self.endDate;
    [self.datePickerVC setUpWithDate:currentDate];
    
    [self.view addSubview:self.datePickerVC.view];
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
    [self makeSureEndDateIsCorrectDay];
    [self makeSureDatesAreInOrder];
    [self.datePickerVC.view removeFromSuperview];
}

-(void)updateLabels
{
    if (!self.startDate || !self.endDate) {
        return;
    }
    
    NSDate *currentDate = [NSDate date];
    
//    NSInteger currentHour = [self hoursFromDate:currentDate];
//    NSInteger curretMinute = [self minutesFromDate:currentDate];
//    
//    NSInteger endHour = [self hoursFromDate:self.endDate];
//    NSInteger endMinute = [self minutesFromDate:self.endDate];
    
    // Check time between the two
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSDayCalendarUnit fromDate:currentDate toDate:self.endDate options:0];
    NSInteger dayDiff = [difference day];

    difference = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:currentDate toDate:self.endDate options:0];
    NSInteger hourDiff = [difference hour];
    
    difference = [[NSCalendar currentCalendar] components:NSMinuteCalendarUnit fromDate:currentDate toDate:self.endDate options:0];
    NSInteger minDiff = [difference minute];
    
    difference = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:currentDate toDate:self.endDate options:0];
    NSInteger secDiff = [difference second];
    
//    self.daysLabel.text=[NSString stringWithFormat:@"%d",dayDiff];
//    self.hoursLabel.text=[NSString stringWithFormat:@"%d",hourDiff];
//    self.minutesLabel.text=[NSString stringWithFormat:@"%d",minDiff];
//    self.secondsLabel.text=[NSString stringWithFormat:@"%d",secDiff];
    
    NSLog(@"\nDays: %li\nHours: %ld\nMinutes: %li\nSeconds: %li",(long)dayDiff,(long)hourDiff,(long)minDiff,(long)secDiff);
    self.timeLeft.text = [NSString stringWithFormat:@"%ld secs left!",(long)secDiff];
    
}

#pragma mark DateFixes

-(void)makeSureEndDateIsCorrectDay
{
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

//
//-(NSInteger)hoursFromDate:(NSDate*)fromThisDate
//{
//    static NSDateFormatter *_hourFormatter;
//    if (!_hourFormatter) {
//        _hourFormatter = [[NSDateFormatter alloc] init];
//        [_hourFormatter setDateFormat:@"HH"];
//    }
//    NSString *hourString = [_hourFormatter stringFromDate: fromThisDate];
//    return [hourString intValue];
//}
//
//-(NSInteger)minutesFromDate:(NSDate*)fromThisDate
//{
//    static NSDateFormatter *_minuteFormatter;
//    if (!_minuteFormatter) {
//        _minuteFormatter = [[NSDateFormatter alloc] init];
//        [_minuteFormatter setDateFormat:@"mm"];
//    }
//    NSString *minuteString = [_minuteFormatter stringFromDate: fromThisDate];
//    return [minuteString intValue];
//}

@end
