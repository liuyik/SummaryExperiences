//
//  LYWaterFlowLayout.h
//  瀑布流
//
//  Created by 刘毅 on 16/4/21.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYWaterFlowLayout;
@protocol LYWaterFlowLayoutDelegate <NSObject>

@required
- (CGFloat)waterFlow:(LYWaterFlowLayout *)waterFlow heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemW;

@optional
//列数
- (CGFloat)columnCountWaterFlow:(LYWaterFlowLayout *)waterFlow;
//每一列之间的间隙
- (CGFloat)columnMarginWaterFlow:(LYWaterFlowLayout *)waterFlow;
//每一行之间的间隙
- (CGFloat)rowMarginWaterFlow:(LYWaterFlowLayout *)waterFlow;
//边缘的间隙
- (UIEdgeInsets)edgeInsetsWaterFlow:(LYWaterFlowLayout *)waterFlow;

@end


@interface LYWaterFlowLayout : UICollectionViewLayout

@property (nonatomic,weak)id<LYWaterFlowLayoutDelegate> delegate;

@end
