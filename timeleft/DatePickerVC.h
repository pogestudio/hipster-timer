//
//  DatePickerVC.h
//  timeleft
//
//  Created by CAwesome on 02/09/2014.
//  Copyright (c) 2014 pogestudio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface DatePickerVC : UIViewController

@property (weak) ViewController *parentVC;


-(void)setUpWithDate:(NSDate*)currentDate;

@end
