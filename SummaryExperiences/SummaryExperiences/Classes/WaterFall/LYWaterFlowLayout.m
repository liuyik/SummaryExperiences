//
//  LYWaterFlowLayout.m
//  瀑布流
//
//  Created by 刘毅 on 16/4/21.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import "LYWaterFlowLayout.h"
//默认的列数
static const CGFloat defaultColumnCount = 3;
//每一列之间的间隙
static const CGFloat defaultColumnMargin = 10;
//每一行之间的间隙
static const CGFloat defaultRowMargin = 10;
//边缘的间隙
static const UIEdgeInsets defaultEdgeInsets = {10,10,10,10};

@interface LYWaterFlowLayout()

//存放所有的布局属性
@property (nonatomic,retain)NSMutableArray *attrsArray;
//存放所有列的高度
@property (nonatomic,retain)NSMutableArray *columnHeights;
//内容的高度
@property (nonatomic,assign)CGFloat contentHeight;

- (CGFloat)columnCount;
- (CGFloat)columnMargin;
- (CGFloat)rowMargin;
- (UIEdgeInsets)edgeInsets;

@end

@implementation LYWaterFlowLayout
#pragma mark - 数据处理
- (CGFloat)columnCount {
    if ([self.delegate respondsToSelector:@selector(columnCountWaterFlow:)]) {
        return [self.delegate columnCountWaterFlow:self];
    }else {
        return defaultColumnCount;
    }
}
- (CGFloat)columnMargin {
    if ([self.delegate respondsToSelector:@selector(columnMarginWaterFlow:)]) {
        return [self.delegate columnMarginWaterFlow:self];
    }else {
        return defaultColumnMargin;
    }
}
- (CGFloat)rowMargin {
    if ([self.delegate respondsToSelector:@selector(rowMarginWaterFlow:)]) {
        return [self.delegate rowMarginWaterFlow:self];
    }else {
        return defaultRowMargin;
    }
}
- (UIEdgeInsets)edgeInsets {
    if ([self.delegate respondsToSelector:@selector(edgeInsetsWaterFlow:)]) {
        return [self.delegate edgeInsetsWaterFlow:self];
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

- (NSMutableArray *)columnHeights {
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
#pragma mark - 布局
//初始化
-(void)prepareLayout {
    [super prepareLayout];
    
    self.contentHeight = 0;
    //清除之前的计算的所有高度
    [self.columnHeights removeAllObjects];
    for (int i = 0 ; i < self.columnCount; i ++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    //清除之前的所有布局属性
    [self.attrsArray removeAllObjects];
    
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

//决定cell的排布
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
  
    return self.attrsArray;
}
//返回indexpath位置对应cell的布局属性
- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //创建布局属性
    UICollectionViewLayoutAttributes *layoutAtt = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //collectionView 的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    //计算布局属性的frame
    CGFloat w = (collectionViewW - self.edgeInsets.left-self.edgeInsets.right - self.columnMargin*(self.columnCount-1))/self.columnCount;
    CGFloat h = 0;
    if ([self.delegate respondsToSelector:@selector(waterFlow:heightForItemAtIndexPath:itemWidth:)]) {
        h = [self.delegate waterFlow:self heightForItemAtIndexPath:indexPath itemWidth:w];
    }
    //找出高度最短的那一列
    NSInteger destColumn = 0;
    CGFloat minHeight = [self.columnHeights[0] doubleValue];
    for (int i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        if (columnHeight < minHeight) {
            minHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    layoutAtt.frame = CGRectMake(x,y,w,h);
    
    //更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(layoutAtt.frame));
    
    if (self.contentHeight < [self.columnHeights[destColumn] doubleValue]) {
        self.contentHeight = [self.columnHeights[destColumn] doubleValue];
    }
    
    return layoutAtt;
}

//返回ContentSize
- (CGSize)collectionViewContentSize {

    return CGSizeMake(0, self.contentHeight+self.edgeInsets.bottom);
}

@end
