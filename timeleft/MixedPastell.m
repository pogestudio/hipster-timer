//
//  MixedPastell.m
//  timeleft
//
//  Created by CAwesome on 09/09/2014.
//  Copyright (c) 2014 pogestudio. All rights reserved.
//

#import "MixedPastell.h"

@implementation MixedPastell

-(UIColor*)cancelButtonBackground
{
//    return [UIColor colorWithRed:1.0 green:0.745 blue:0.718 alpha:1.0];
    return [self generalBackground];
}
-(UIColor*)doneButtonBackground
{
//        return [UIColor colorWithRed:0.718 green:1 blue:0.78 alpha:1.0];
    return [self generalBackground];
}

-(UIColor*)cancelButtonTitle
{
    return [UIColor colorWithRed:1.0 green:0.502 blue:0.451 alpha:1.0];
}
-(UIColor*)doneButtonTitle
{
    return [UIColor colorWithRed:0.451 green:0.996 blue:0.573 alpha:1.0];
}
-(UIColor*)generalBackground
{
    return [UIColor colorWithRed:254.0/255.0 green:255.0/255.0 blue:237.0/255.0 alpha:1.0];
}
-(UIColor*)timeText
{
    return [UIColor colorWithRed:168.0/255.0 green:168.0/255.0 blue:168.0/255.0 alpha:1.0];
}
-(UIColor*)workDoneCircle
{
    return [UIColor colorWithRed:0.718 green:1.0 blue:0.78 alpha:1.0];
}
-(UIColor*)workRemainingCircle
{
    return [self generalBackground];
    //return [UIColor colorWithRed:0.866 green:0.992 blue:1.0 alpha:1.0];
    //            return [UIColor colorWithRed:0.722 green:0.965 blue:1.0 alpha:1.0];
    
}

-(UIColor*)timeButtonTitle
{
    return [UIColor colorWithRed:117.0/255.0 green:183.0/255.0 blue:1.0 alpha:1.0];
}
@end
