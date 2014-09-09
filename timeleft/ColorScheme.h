//
//  ColorScheme.h
//  timeleft
//
//  Created by CAwesome on 09/09/2014.
//  Copyright (c) 2014 pogestudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorScheme : NSObject

-(UIColor*)cancelButtonBackground;
-(UIColor*)doneButtonBackground;
-(UIColor*)cancelButtonTitle;
-(UIColor*)doneButtonTitle;
-(UIColor*)generalBackground;
-(UIColor*)timeText;
-(UIColor*)workDoneCircle;
-(UIColor*)workRemainingCircle;

@end
