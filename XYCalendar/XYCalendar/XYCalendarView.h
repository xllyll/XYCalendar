//
//  XYCalendarView.h
//  XYCalendar
//
//  Created by 杨卢银 on 2017/6/14.
//  Copyright © 2017年 杨卢银. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYCalendar.h"

@interface XYCalendarView : UIControl


/**
 公历
 */
@property (strong , nonatomic) XYCalendar *calendar;

/**
 农历
 */
@property (strong , nonatomic) XYCalendar *lunarCalendar;




@end
