//
//  RoiResultListView.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/7/28.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "RoiResultListView.h"


@implementation RoiResultListView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        
        self.dataSource = self;
        self.delegate = self;
        
        [self registerNib:[UINib nibWithNibName:@"PoiResultCell" bundle:nil] forCellReuseIdentifier:@"PoiResultCell"];
        
    }
    return self;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PoiResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoiResultCell" forIndexPath:indexPath];
    PoiModel *model = self.data[indexPath.row];
    
    if (indexPath.row == 0) {
        cell.nameLabel.textColor = [UIColor redColor];
        if (![model.name containsString:@"[当前]"]) {
            model.name = [NSString stringWithFormat:@"[当前]%@",model.name];
        }
        
    }else{
        cell.nameLabel.textColor = [UIColor blackColor];
    }
    cell.model = model;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PoiModel *model = self.data[indexPath.row];
    if (self.poiListBlock) {
        
        self.poiListBlock(model);
    }

}

@end
