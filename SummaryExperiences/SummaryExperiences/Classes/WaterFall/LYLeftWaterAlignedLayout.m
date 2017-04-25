//
//  CollectionViewLeftAlignedLayout.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/4/24.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "LYLeftWaterAlignedLayout.h"

//每一行的高度
static const CGFloat defaultColumnHight = 30;
//每一列之间的间隙
static const CGFloat defaultColumnMargin = 10;
//每一行之间的间隙
static const CGFloat defaultRowMargin = 10;
//边缘的间隙
static const UIEdgeInsets defaultEdgeInsets = {10,10,10,10};


@interface LYLeftWaterAlignedLayout()

//存放所有的布局属性
@property (nonatomic,retain)NSMutableArray *attrsArray;

//多少行总的高度
@property (nonatomic,assign)CGFloat sumHeight;
//内容的宽度
@property (nonatomic,assign)CGFloat contentWidth;

- (CGFloat)columnHeight;
- (CGFloat)columnMargin;
- (CGFloat)rowMargin;
- (UIEdgeInsets)edgeInsets;

@end

@implementation LYLeftWaterAlignedLayout
#pragma mark - 数据处理
- (CGFloat)columnHeight {
    if ([self.delegate respondsToSelector:@selector(columnHeightWaterAligned:)]) {
        return [self.delegate columnHeightWaterAligned:self];
    }else {
        return defaultColumnHight;
    }
}
- (CGFloat)columnMargin {
    if ([self.delegate respondsToSelector:@selector(columnMarginWaterAligned:)]) {
        return [self.delegate columnMarginWaterAligned:self];
    }else {
        return defaultColumnMargin;
    }
}
- (CGFloat)rowMargin {
    if ([self.delegate respondsToSelector:@selector(rowMarginWaterAligned:)]) {
        return [self.delegate rowMarginWaterAligned:self];
    }else {
        return defaultRowMargin;
    }
}
- (UIEdgeInsets)edgeInsets {
    if ([self.delegate respondsToSelector:@selector(edgeInsetsWaterAligned:)]) {
        return [self.delegate edgeInsetsWaterAligned:self];
    }else {
        return defaultEdgeInsets;
    }
}
#pragma mark - 懒加载
- (NSMutableArray *)attrsArray {
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

//初始化
-(void)prepareLayout {
    [super prepareLayout];
    
//    self.contentHeight = 0;
    //清除之前的计算的所有高度
//    [self.columnHeights removeAllObjects];
//    for (int i = 0 ; i < self.columnCount; i ++) {
//        [self.columnHeights addObject:@(self.edgeInsets.top)];
//    }
    
    //清除之前的所有布局属性
    [self.attrsArray removeAllObjects];
    
    self.contentWidth = self.edgeInsets.left;
    self.sumHeight = self.edgeInsets.top;
    //开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i < count; i ++ ) {
        //创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //创建布局属性
        UICollectionViewLayoutAttributes *layoutAtt = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:layoutAtt];
    }
    
}

#pragma mark - UICollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.attrsArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* currentItemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //collectionView 的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    //计算布局属性的frame
    
    CGFloat x = self.contentWidth;
    CGFloat w = 0;
    if ([self.delegate respondsToSelector:@selector(leftWaterAligned:widthForItemAtIndexPath:)]) {
        w = [self.delegate leftWaterAligned:self widthForItemAtIndexPath:indexPath];
    }
    self.contentWidth += w + self.columnMargin;
    
    
    if (self.contentWidth > collectionViewW-self.edgeInsets.right) {
        self.sumHeight += self.columnHeight+self.rowMargin;
        x = self.edgeInsets.left;
        self.contentWidth = x;
    }
    CGFloat y = self.sumHeight;
    currentItemAttributes.frame = CGRectMake(x,y,w,self.columnHeight);

    
    return currentItemAttributes;
}
//返回ContentSize
- (CGSize)collectionViewContentSize {
    
    return CGSizeMake(0, self.sumHeight+self.columnHeight+self.edgeInsets.bottom);
}
@end
