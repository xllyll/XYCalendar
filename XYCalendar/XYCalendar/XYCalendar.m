//
//  XYCalendar.m
//  XYCalendar
//
//  Created by 杨卢银 on 2017/6/14.
//  Copyright © 2017年 杨卢银. All rights reserved.
//

#import "XYCalendar.h"

@implementation NSDate(XYCalendar)

+(NSDate*)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    
    NSString *dataString = [NSString stringWithFormat:@"%ld-%ld-%ld 12:00:00",year,month,day];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";//指定转date得日期格式化形式
    
    NSDate *date = [dateFormatter dateFromString:dataString];
    
    return date;
}

@end

@interface XYCalendar (){
    NSCalendarIdentifier _ident;
}

@end

@implementation XYCalendar

-(id)initWithCalendarIdentifier:(NSCalendarIdentifier)ident{
    self =  [super init];
    if (self) {
        _ident = ident;
        _firstDate = [NSDate date];
        
        NSCalendar *cl =  [[NSCalendar alloc] initWithCalendarIdentifier:ident];
        
        _dateComponents = [cl components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekdayOrdinal fromDate:_firstDate];
    }
    return self;
}

-(id)initWithCalendarIdentifier:(NSCalendarIdentifier)ident year:(NSInteger)year month:(NSInteger)month{
    self =  [super init];
    if (self) {
        
        _ident = ident;
        
        NSString *dataString = [NSString stringWithFormat:@"%ld-%ld-1",year,month];
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
        
        dateFormatter.dateFormat=@"yyyy-MM-dd";//指定转date得日期格式化形式
        
        _firstDate = [dateFormatter dateFromString:dataString];
        
        NSCalendar *cl =  [[NSCalendar alloc] initWithCalendarIdentifier:ident];
        
        _dateComponents = [cl components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekdayOrdinal fromDate:_firstDate];
        
    }
    return self;
}
// 获取当月的天数
- (NSInteger)getNumberOfDaysInMonth
{
    NSCalendar *cl =  [[NSCalendar alloc] initWithCalendarIdentifier:_ident];
    
    NSRange range = [cl rangeOfUnit:NSCalendarUnitDay  //NSDayCalendarUnit - ios 8
                               inUnit:NSCalendarUnitMonth //NSMonthCalendarUnit - ios 8
                              forDate:self.firstDate];
    return range.length;
}
-(XYCalendar *)getUpCalendar{
    
    NSInteger year = self.dateComponents.year;
    NSInteger month = self.dateComponents.month;
    
    NSInteger upyear = year;
    NSInteger upmonth = month-1;
    
    if (upmonth<=0) {
        upmonth=12;
        upyear = upyear-1;
    }
    
    
    
    
    XYCalendar *upc = [[XYCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian year:upyear month:upmonth];
    return upc;
}
-(XYCalendar *)getDownCalendar{
    
    NSInteger year = self.dateComponents.year;
    NSInteger month = self.dateComponents.month;
    
    NSInteger down_year = year;
    NSInteger down_month = month+1;
    if (down_month>12) {
        down_month=1;
        down_year = down_year+1;
    }
    XYCalendar *downc = [[XYCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian year:down_year month:down_month];
    return downc;
}

+(NSString*)getChineseCalendarWithDate:(NSDate *)date{
    
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSLog(@"%ld_%ld_%ld  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@_%@_%@",y_str,m_str,d_str];
    
    
    return chineseCal_str;  
}

+(NSString *)getChineseCalendarDayWithDate:(NSDate *)date{
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    //NSLog(@"%ld_%ld_%ld  %@",localeComp.year,localeComp.month,localeComp.day, localeComp.date);
    
    
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@",d_str];
    if ([d_str isEqualToString:@"初一"]) {
        NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
        chineseCal_str =[NSString stringWithFormat: @"%@",m_str];
    }
    
    
    return chineseCal_str;
}

@end
