//
//  PoiResultCell.h
//  DianJiaManageSystem
//
//  Created by 刘毅 on 2017/7/28.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoiModel.h"

@interface PoiResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic,strong)PoiModel *model;

@end
