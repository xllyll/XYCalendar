//
//  XYCalendarView.m
//  XYCalendar
//
//  Created by 杨卢银 on 2017/6/14.
//  Copyright © 2017年 杨卢银. All rights reserved.
//

#import "XYCalendarView.h"

@interface XYCalendarDayView : UIControl

@property (strong , nonatomic) NSDate *date;

@property (assign , nonatomic) NSInteger year;
@property (assign , nonatomic) NSInteger month;
@property (assign , nonatomic) NSInteger day;


@end

@implementation XYCalendarDayView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    self = [super initWithFrame:frame];
    if (self) {
        _year = year;
        _month = month;
        _day = day;
        
        _date  = [NSDate initWithYear:_year month:_month day:_day];
        
        [self buildView];
    }
    return self;
}
-(void)buildView{
    
    float x = 0;
    float y = 0;
    float size = 0;
    if (self.bounds.size.width>self.bounds.size.height) {
        size = self.bounds.size.height;
        size = size-4.0;
        x = (self.bounds.size.width - size)/2.0;
        y = (self.bounds.size.height - size)/2.0;
    }else{
        size = self.bounds.size.width;
        size = size-4.0;
        x = (self.bounds.size.width - size)/2.0;
        y = (self.bounds.size.height - size)/2.0;
    }
    
    float labelHeight = size/5.0*3;
    
    UIControl *dayControl = [[UIControl alloc] initWithFrame:CGRectMake(x, y, size, size)];
    dayControl.backgroundColor = [UIColor redColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, dayControl.bounds.size.width, labelHeight)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = [NSString stringWithFormat:@"%ld",_day];
    label.textColor = [UIColor whiteColor];
    
    
    
    [dayControl addSubview:label];
    
    
    UILabel *chinseslabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bounds.size.height, dayControl.bounds.size.width, size-labelHeight)];
    chinseslabel.textAlignment = NSTextAlignmentCenter;
    chinseslabel.text = [NSString stringWithFormat:@"%@",[XYCalendar getChineseCalendarDayWithDate:_date]];
    chinseslabel.font = [UIFont systemFontOfSize:10.0];
    chinseslabel.textColor = [UIColor whiteColor];
    
    [dayControl addSubview:chinseslabel];
    
    [dayControl.layer setCornerRadius:size/2.0];
    
    [self addSubview:dayControl];
}
@end

@interface XYCalendarViewCell : UIControl
{
    CGPoint _oldcontentOffset;
}
@property (strong , nonatomic) XYCalendar *calendar;

@property (strong , nonatomic) NSMutableArray  *dayViewArray;

@end

@implementation XYCalendarViewCell

-(void)setCalendar:(XYCalendar *)calendar{
    _calendar = calendar;
    [self buildView];
}
-(void)dismissAllView{
    [_dayViewArray removeAllObjects];
    _dayViewArray = [NSMutableArray array];
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}
-(void)buildView{
    [self dismissAllView];
    
    
    NSInteger allday = [_calendar getNumberOfDaysInMonth];
    NSInteger firstWeek = _calendar.dateComponents.weekday;
    
    NSInteger tempall = (allday-(7-firstWeek+1));
    NSInteger row = tempall/7;
    row = row+1;
    if (tempall%7) {
        row++;
    }
    float width = self.bounds.size.width/7.0;
    float height = self.bounds.size.height/6.0;
    for(int i = 0 ; i< row ;i++){
        float kt = 0;
        float c = 7;
        if (i==0) {
            kt = firstWeek-1;
            c = 7;
        }
        if (i+1==row) {
            c = tempall%7;
            if (c==0) {
                c = 7;
            }
        }
        for (int k = kt ; k< c ;k++) {
            
            XYCalendarDayView *dayControl = [[XYCalendarDayView alloc] initWithFrame:CGRectMake(k*width, height*i, width, height) year:_calendar.dateComponents.year month:_calendar.dateComponents.month day:_dayViewArray.count+1];
            dayControl.backgroundColor = [UIColor clearColor];
            dayControl.tag = _dayViewArray.count+1;
            [self addSubview:dayControl];
            
            [_dayViewArray addObject:dayControl];
        }
    }
    
    NSDateComponents *dateComponents = [_calendar dateComponents];
    NSLog(@"year(年份): %li---month(月份):%li", (long)dateComponents.year,(long)dateComponents.month);
    NSLog(@"all day(该月天数):%li", allday);
    //NSLog(@"quarter(季度):%li", (long)dateComponents.quarter);
    //NSLog(@"day(日期):%li", (long)dateComponents.day);
    
    
    
//    NSLog(@"hour(小时):%li", (long)dateComponents.hour);
//    NSLog(@"minute(分钟):%li", (long)dateComponents.minute);
//    NSLog(@"second(秒):%li", (long)dateComponents.second);
//    
//    //Sunday:1, Monday:2, Tuesday:3, Wednesday:4, Friday:5, Saturday:6
//    NSLog(@"weekday(星期):%li", (long)dateComponents.weekday);
//    
//    //苹果官方不推荐使用week.week
//    NSLog(@"weekOfYear(该年第几周):%li", (long)dateComponents.weekOfYear);
//    NSLog(@"weekOfMonth(该月第几周):%li", (long)dateComponents.weekOfMonth);
}

@end

@interface XYCalendarScrollView : UIScrollView
{
    float _minScrollX;
    float _maxScrollX;
}
@property (strong , nonatomic) NSMutableArray *calendarArray;

@property (strong , nonatomic) XYCalendarViewCell *currentCell;

@end

@implementation XYCalendarScrollView

-(void)setCalendarArray:(NSMutableArray *)calendarArray{
    _calendarArray = calendarArray;
    [self buildView];
}

-(void)dismissAllView{
    
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}
-(void)buildView{
    [self dismissAllView];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    self.contentSize = CGSizeMake(width*_calendarArray.count, height);
    
    for (int i = 0; i < _calendarArray.count; i++) {
        
        
        XYCalendarViewCell *cell = [[XYCalendarViewCell alloc] initWithFrame:CGRectMake(width*i, 0, self.bounds.size.width, self.bounds.size.height)];
        
        [self addSubview:cell];
        
        cell.calendar = _calendarArray[i];
        
        if (i==0) {
            _currentCell = cell;
            _minScrollX = 0;
        }
        if (i==_calendarArray.count-1) {
            
            _maxScrollX = cell.frame.origin.x+cell.bounds.size.width;
            
        }
        
    }
    
}

-(void)addUpCalendar:(XYCalendar*)aCalendar{
    
    [_calendarArray insertObject:aCalendar atIndex:0];
    
    self.contentSize = CGSizeMake(self.bounds.size.width*_calendarArray.count, self.bounds.size.height);
    
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[XYCalendarViewCell class]]) {
            v.frame = CGRectMake(v.frame.origin.x+v.frame.size.width, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
        }
    }
    
    XYCalendarViewCell *cell = [[XYCalendarViewCell alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    
    [self addSubview:cell];
    
    cell.calendar = aCalendar;
    
    _minScrollX = 0;
    
    //self.contentOffset = CGPointMake(self.bounds.size.width, 0);
    
}
-(void)addDownCalendar:(XYCalendar*)aCalendar{
    
    [_calendarArray addObject:aCalendar];
    
    self.contentSize = CGSizeMake(self.bounds.size.width*_calendarArray.count, self.bounds.size.height);
    
    
    XYCalendarViewCell *cell = [[XYCalendarViewCell alloc] initWithFrame:CGRectMake((_calendarArray.count-1)*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
    
    [self addSubview:cell];
    
    cell.calendar = aCalendar;
    
    _maxScrollX = _maxScrollX+self.bounds.size.width;
}

@end

@interface XYCalendarView ()<UIScrollViewDelegate>
{
    CGPoint _old_contentOffset;
    
    XYCalendar *_currentCalendar;
}
@property (strong , nonatomic) XYCalendarScrollView *scrollView;

@property (strong , nonatomic) NSMutableArray *calendarArray;

@property (strong , nonatomic) UIView *topMenuView;

@property (strong , nonatomic) UILabel *topMenuViewTitleLabel;

@end




@implementation XYCalendarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}
-(void)setup{
    
    
    
    _calendar = [[XYCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _lunarCalendar = [[XYCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSInteger year = _calendar.dateComponents.year;
    NSInteger month = _calendar.dateComponents.month;
    
    NSInteger upyear = year;
    NSInteger upmonth = month-1;
    
    if (upyear<=0) {
        upmonth=12;
        upyear = upyear-1;
    }
    
    
    NSInteger down_year = year;
    NSInteger down_month = month+1;
    if (down_month>12) {
        down_month=1;
        down_year = down_year+1;
    }
    
    XYCalendar *upc = [[XYCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian year:upyear month:upmonth];
    
    XYCalendar *c = [[XYCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian year:year month:month];
    _currentCalendar = c;
    
    XYCalendar *downc = [[XYCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian year:down_year month:down_month];
    
    _calendarArray = [NSMutableArray arrayWithArray:@[c,downc]];
    
    [self buildView];
    
    [_scrollView addUpCalendar:_currentCalendar.getUpCalendar];
    [_scrollView addUpCalendar:upc.getUpCalendar];
    
    _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width*2.0, 0);
    _old_contentOffset = _scrollView.contentOffset;
    
    [_scrollView addDownCalendar:downc.getDownCalendar];
    
    
    
}
-(void)buildView{
    
    float topWeekHeight = 30.0;
    
    float topHeight = 50.0;
    
    _topMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, topHeight)];
    _topMenuView.backgroundColor = [UIColor orangeColor];
    
    [self addSubview:_topMenuView];
    
    
    _topMenuViewTitleLabel = [[UILabel alloc] initWithFrame:_topMenuView.bounds];
    _topMenuViewTitleLabel.textColor = [UIColor whiteColor];
    _topMenuViewTitleLabel.textAlignment = NSTextAlignmentCenter;
    [_topMenuView addSubview:_topMenuViewTitleLabel];
    
    NSArray *titleArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    
    UIControl *weekControl = [[UIControl alloc] initWithFrame:CGRectMake(0, topHeight, self.bounds.size.width, topWeekHeight)];
    weekControl.backgroundColor = [UIColor clearColor];
    [self addSubview:weekControl];
    
    float W = self.bounds.size.width/(float)titleArray.count;
    for (int i = 0 ; i < titleArray.count; i++) {
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(W*i, 0, W, topWeekHeight)];
        control.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:control.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.text = titleArray[i];
        [control addSubview:label];
        
        [weekControl addSubview:control];
    }
    
    _scrollView = [[XYCalendarScrollView alloc] initWithFrame:CGRectMake(0, topWeekHeight + topHeight, self.bounds.size.width, self.bounds.size.height-(topWeekHeight + topHeight))];
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _scrollView.calendarArray = _calendarArray;
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    NSInteger tag = scrollView.contentOffset.x/scrollView.bounds.size.width;
    _currentCalendar  = _calendarArray[tag];
    
    _topMenuViewTitleLabel.text = [NSString stringWithFormat:@"%ld-%ld",_currentCalendar.dateComponents.year,_currentCalendar.dateComponents.month];
    
    if (scrollView.contentOffset.x<_old_contentOffset.x) {
        
        
        NSLog(@"up------------%ld",(long)tag);
        if (tag<2) {
            XYCalendar *c = [_calendarArray firstObject];
            
            [_scrollView addUpCalendar:c.getUpCalendar];
            
            _scrollView.contentOffset = CGPointMake(_scrollView.bounds.size.width*2.0, 0);
            _old_contentOffset = _scrollView.contentOffset;
        }
        
    
    }else{
    
        NSLog(@"down------------%ld",(long)tag);
    
        if (_calendarArray.count-tag<=2) {
            XYCalendar *d = [_calendarArray lastObject];
            
            [_scrollView addDownCalendar:d.getDownCalendar];
        }
        
        
    }
    
    _old_contentOffset = scrollView.contentOffset;
}
@end
