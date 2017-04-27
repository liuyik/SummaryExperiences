//
//  RightCollectionCell.m
//  testSVN
//
//  Created by 刘毅 on 2017/3/21.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "RightCollectionCell.h"

@implementation RightCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) setScModel:(SubCategoryModel *)scModel
{
    if (_scModel != scModel) {
        _scModel = scModel;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:_scModel.icon_url]];
        self.nameLabel.text = _scModel.name;
        
        if ([[_scModel.items_count substringToIndex:1] isEqual:@"-"]) {
            self.paylabel.text =[NSString stringWithFormat:@"￥%@",[_scModel.items_count substringFromIndex:1]];
        }else{
            self.paylabel.text = [NSString stringWithFormat:@"￥%@", _scModel.items_count];
        }
    }
    
    
}
@end
