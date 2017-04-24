//
//  TreeCellCell.m
//  test
//
//  Created by 刘毅 on 16/9/23.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import "TreeCell.h"

@implementation TreeCell
+ (instancetype)treeViewCellWith:(RATreeView *)treeView
{
    TreeCell *cell = [treeView dequeueReusableCellWithIdentifier:@"TreeCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TreeCell" owner:nil options:nil] firstObject];
    }
    
    return cell;
}

- (void)setCellBasicInfoWith:(NSString *)title level:(NSInteger)level children:(NSInteger )children{
    
    //有子数组时显示图标
    if (children==0) {
        self.iconView.hidden = YES;
        
    }
    else { //否则不显示
        self.iconView.hidden = NO;
    }
    self.titleLable.text = title;
    //每一层的布局
    CGFloat left = 6+level*30;
    
    _leftWidth.constant = left;
    
}

@end
