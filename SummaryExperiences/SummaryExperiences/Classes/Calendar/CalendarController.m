//
//  CalendarController.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/3/23.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "CalendarController.h"
#import "LYCalendarPicker.h"

@interface CalendarController ()

@end

@implementation CalendarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    LYCalendarPicker *picker = [[LYCalendarPicker alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, 500)];
    [self.view addSubview:picker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
