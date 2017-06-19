//
//  ViewController.m
//  XYCalendar
//
//  Created by 杨卢银 on 2017/6/14.
//  Copyright © 2017年 杨卢银. All rights reserved.
//

#import "ViewController.h"
#import "XYCalendarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    XYCalendarView *v  =[[XYCalendarView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [self.view addSubview:v];
    
    NSString *S = [XYCalendar getChineseCalendarWithDate:[NSDate date]];
    NSLog(@"%@",S);
    
    
    NSString *dataString = [NSString stringWithFormat:@"%d-%d-18",2017,6];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    
    dateFormatter.dateFormat=@"yyyy-MM-dd";//指定转date得日期格式化形式
    
    NSDate *firstDate = [dateFormatter dateFromString:dataString];

    NSString *S2 = [XYCalendar getChineseCalendarWithDate:firstDate];
    NSLog(@"%@",S2);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
