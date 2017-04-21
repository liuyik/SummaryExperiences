//
//  TreeCellCell.h
//  test
//
//  Created by 刘毅 on 16/9/23.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RATreeView.h>

@interface TreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;//图标
@property (weak, nonatomic) IBOutlet UILabel *titleLable;//标题

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidth;

+ (instancetype)treeViewCellWith:(RATreeView *)treeView;

- (void)setCellBasicInfoWith:(NSString *)title level:(NSInteger)level children:(NSInteger )children;


@end
