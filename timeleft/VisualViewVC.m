//
//  VisualViewVC.m
//  timeleft
//
//  Created by CAwesome on 04/09/2014.
//  Copyright (c) 2014 pogestudio. All rights reserved.
//

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)


#import "VisualViewVC.h"
#import "NSDate+Helper.h"
#import "CERoundProgressView.h"

@interface VisualViewVC()
{
    
}

@property (strong) CERoundProgressView *progressView;

@property (strong) IBOutlet UILabel  *timeLeft;
@property (strong) IBOutlet UILabel  *clockStartsIn;

@end

@implementation VisualViewVC

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.progressView) {
        CGFloat width = 250;
        self.progressView = [[CERoundProgressView alloc] initWithFrame:
                             CGRectMake((self.view.frame.size.width - width)/2.0,
                                        10,
                                        width,
                                        width)];
        [self.view addSubview:self.progressView];
        UIColor *tintColor = [UIColor greenColor];
        //        [[CERoundProgressView appearance] setTintColor:tintColor];
        
        self.progressView.tintColor = tintColor;
        self.progressView.trackColor = [UIColor colorWithWhite:0.80 alpha:1.0];
        self.progressView.startAngle = (3.0*M_PI)/2.0;
    }
}

-(void)showPieChartForStartTime:(NSDate*)startTime andEndTime:(NSDate*)endTime
{
    //MODIFY PIECHART
    [self hideOrShowElementsDependingOnIfWeAreInRightTimeZoneWithDates:startTime and:endTime];
    
    CGFloat totalTimeBetweenDates = [endTime timeIntervalSinceDate:startTime];
    CGFloat timeElapsed = [[NSDate date] timeIntervalSinceDate:startTime];
    self.progressView.progress = timeElapsed / totalTimeBetweenDates;
    
    //Update Labels
    NSDate *currentDate = [NSDate date];

    //create the string we are going to create on the "Time left until endtime";
    // Check time between the two
    NSDateComponents *difference = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:currentDate toDate:endTime options:0];
    NSInteger secDiff = [difference second];
    //    NSLog(@"\nDays: %li\nHours: %ld\nMinutes: %li\nSeconds: %li",(long)dayDiff,(long)hourDiff,(long)minDiff,(long)secDiff);
    NSInteger hours = secDiff / 3600;
    NSInteger minutes = (secDiff %3600) /60;
    NSInteger seconds =(secDiff %3600) %60;
    
    NSString *timeLeftString = @"";
    if (hours) {
        timeLeftString = [NSString stringWithFormat:@"%@ %ldh",timeLeftString,(long)hours];
    }
    if (minutes) {
        timeLeftString = [NSString stringWithFormat:@"%@ %ldm",timeLeftString,(long)minutes];
    }
    if (seconds) {
        timeLeftString = [NSString stringWithFormat:@"%@ %lds",timeLeftString,(long)seconds];
    }
    
    self.timeLeft.text = timeLeftString;


    difference = [[NSCalendar currentCalendar] components:NSSecondCalendarUnit fromDate:currentDate toDate:startTime options:0];
    secDiff = [difference second];
    //    NSLog(@"\nDays: %li\nHours: %ld\nMinutes: %li\nSeconds: %li",(long)dayDiff,(long)hourDiff,(long)minDiff,(long)secDiff);
    hours = secDiff / 3600;
    minutes = (secDiff %3600) /60;
    seconds =(secDiff %3600) %60;
    
    //create the string we are going to create on the "Time left until endtime";
    timeLeftString = @"";
    if (hours) {
        timeLeftString = [NSString stringWithFormat:@"%@ %ldh",timeLeftString,(long)hours];
    }
    if (minutes) {
        timeLeftString = [NSString stringWithFormat:@"%@ %ldm",timeLeftString,(long)minutes];
    }
    if (seconds) {
        timeLeftString = [NSString stringWithFormat:@"%@ %lds",timeLeftString,(long)seconds];
    }
    
    self.clockStartsIn.text = timeLeftString;
}

-(void)hideOrShowElementsDependingOnIfWeAreInRightTimeZoneWithDates:(NSDate*)start and:(NSDate*)end
{
    BOOL pieShouldBeVisible = [start isEarlierThanDate:[NSDate date]] && [end isLaterThanDate:[NSDate date]];
    //    self.progressView.alpha = pieShouldBeVisible ? 1 : 0;
    [self.progressView setHidden:!pieShouldBeVisible];
    [self.timeLeft setHidden:!pieShouldBeVisible];
    
}

@end
