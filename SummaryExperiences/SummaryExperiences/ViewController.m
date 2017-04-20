//
//  ViewController.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/3/23.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "ViewController.h"
#import "CalendarController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *data;
    
    
@end

@implementation ViewController

    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
}

//数据
- (NSArray *)data {
    if (_data == nil) {
        _data = @[@"日历"];
    }
    return _data;
}
//创建表示图
- (void)createTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
}
    
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.data[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CalendarController *cc = [[CalendarController alloc] init];
    cc.title = @"日历";
    [self showViewController:cc sender:nil];
}
    
@end
