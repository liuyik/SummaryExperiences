//
//  CalendarController.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/3/23.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "CalendarController.h"
#import "LYCalendarPicker.h"

@interface CalendarController ()<LYCalendarPickerDelegate>

@end

@implementation CalendarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日历";
    self.view.backgroundColor = [UIColor whiteColor];
    
    LYCalendarPicker *picker = [[LYCalendarPicker alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, 0)];
    picker.delegate = self;
    [self.view addSubview:picker];
}

- (void)calenderBackYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day {
    
     NSLog(@"%ld年%ld月%ld日",year,month,day);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
