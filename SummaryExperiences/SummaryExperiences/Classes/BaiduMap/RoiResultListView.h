//
//  RoiResultListView.h
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/7/28.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoiResultCell.h"

@interface RoiResultListView : UITableView<UITableViewDelegate,UITableViewDataSource>

/** 数据*/
@property (nonatomic, strong) NSArray *data;

/** 回调的block*/
@property (nonatomic, copy) void(^poiListBlock)(PoiModel *model);

@end
