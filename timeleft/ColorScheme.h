//
//  ColorScheme.h
//  timeleft
//
//  Created by CAwesome on 09/09/2014.
//  Copyright (c) 2014 pogestudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorScheme : NSObject

//BUTTONS
-(UIColor*)cancelButtonBackground;
-(UIColor*)doneButtonBackground;
-(UIColor*)cancelButtonTitle;
-(UIColor*)doneButtonTitle;

-(UIColor*)timeButtonTitle;


//TEXT
-(UIColor*)generalBackground;
-(UIColor*)timeText;

//App specific Elements
-(UIColor*)workDoneCircle;
-(UIColor*)workRemainingCircle;

@end
