//
//  RightCell.m
//  testSVN
//
//  Created by 刘毅 on 2017/3/21.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "RightCell.h"

@implementation RightCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setFModel:(FoodModel *)fModel {
    if (_fModel != fModel) {
        
        _fModel = fModel;
        
        [_imgView sd_setImageWithURL:[NSURL URLWithString:_fModel.picture]];
        _nameLabel.text = _fModel.name;
        _paylabel.text = [NSString stringWithFormat:@"%@ %@",_fModel.month_saled_content,_fModel.praise_content];
    }
        
}

@end
