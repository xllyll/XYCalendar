//
//  XYCalendar.h
//  XYCalendar
//
//  Created by 杨卢银 on 2017/6/14.
//  Copyright © 2017年 杨卢银. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate(XYCalendar)

+(NSDate*)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end

@interface XYCalendar : NSObject

@property (strong , readonly, nonatomic) NSDate *firstDate;

@property (strong , readonly, nonatomic) NSDateComponents *dateComponents;

-(id)initWithCalendarIdentifier:(NSCalendarIdentifier)ident;

-(id)initWithCalendarIdentifier:(NSCalendarIdentifier)ident
                           year:(NSInteger)year
                          month:(NSInteger)month;



/**
 获取当月的天数

 @return 数量
 */
- (NSInteger)getNumberOfDaysInMonth;

+(XYCalendar*)currentCalendar;


-(XYCalendar*)getUpCalendar;
-(XYCalendar*)getDownCalendar;

+(NSString*)getChineseCalendarWithDate:(NSDate *)date;

+(NSString*)getChineseCalendarDayWithDate:(NSDate *)date;


@end
