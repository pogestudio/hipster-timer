//
//  NSDate+timerHelper.h
//  timeleft
//
//  Created by CAwesome on 04/09/2014.
//  Copyright (c) 2014 pogestudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (timerHelper)

-(NSDate*)dateAdjustedToBeTheSameDayAs:(NSDate*)referenceDate;

@end
