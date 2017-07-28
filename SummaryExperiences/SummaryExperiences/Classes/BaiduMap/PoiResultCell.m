//
//  PoiResultCell.m
//  DianJiaManageSystem
//
//  Created by 刘毅 on 2017/7/28.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "PoiResultCell.h"

@implementation PoiResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(PoiModel *)model{
    _model = model;
    self.nameLabel.text = model.name;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",model.city, model.address];
}


@end
