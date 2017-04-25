//
//  CollectionViewLeftAlignedLayout.h
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/4/24.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LYLeftWaterAlignedLayout;
@protocol LYLeftWaterAlignedLayout <NSObject>

@required
- (CGFloat)leftWaterAligned:(LYLeftWaterAlignedLayout *)waterFlow widthForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

//每一行的高度
- (CGFloat)columnHeightWaterAligned:(LYLeftWaterAlignedLayout *)waterAligned;
//每一列之间的间隙
- (CGFloat)columnMarginWaterAligned:(LYLeftWaterAlignedLayout *)waterAligned;
//每一行之间的间隙
- (CGFloat)rowMarginWaterAligned:(LYLeftWaterAlignedLayout *)waterAligned;
//边缘的间隙
- (UIEdgeInsets)edgeInsetsWaterAligned:(LYLeftWaterAlignedLayout *)waterAligned;

@end

@interface LYLeftWaterAlignedLayout : UICollectionViewLayout

@property (nonatomic,weak)id<LYLeftWaterAlignedLayout> delegate;

@end

