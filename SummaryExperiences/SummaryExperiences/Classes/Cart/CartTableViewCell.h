//
//  CartTableViewCell.h
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/1/16.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CartModel;
typedef void(^NumberChangedBlock)(NSInteger number);
typedef void(^CellSelectedBlock)(BOOL select);

@interface CartTableViewCell : UITableViewCell

//商品数量
@property (assign,nonatomic)NSInteger number;
@property (assign,nonatomic)BOOL selectedCell;

//数据加载
- (void)reloadDataWithModel:(CartModel*)model;
//加
- (void)numberAddWithBlock:(NumberChangedBlock)block;
//减
- (void)numberCutWithBlock:(NumberChangedBlock)block;
//选择
- (void)cellSelectedWithBlock:(CellSelectedBlock)block;

@end
