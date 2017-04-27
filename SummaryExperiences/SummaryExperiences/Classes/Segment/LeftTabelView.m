//
//  LeftTabelView.m
//  testSVN
//
//  Created by 刘毅 on 2017/3/20.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "LeftTabelView.h"

@implementation LeftTabelView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init{
    
    self.delegate = self;
    self.dataSource = self;
    
    self.showsVerticalScrollIndicator = NO;
    
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    CategoryModel *cModel = [CategoryModel mj_objectWithKeyValues:self.data[indexPath.row]];
    cell.textLabel.text = cModel.name;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.numberOfLines = 2;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.leftDelegate) {
        [self.leftDelegate didSelectItemAtIndexPath:indexPath];
    }
    
}

@end
