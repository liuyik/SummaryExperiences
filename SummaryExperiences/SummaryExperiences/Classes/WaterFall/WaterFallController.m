//
//  WaterFallController.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/4/24.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "WaterFallController.h"
#import "LYLeftWaterAlignedLayout.h"
#import "LYWaterFlowLayout.h"


@interface WaterFallController ()<UICollectionViewDelegate, UICollectionViewDataSource,LYWaterFlowLayoutDelegate,LYLeftWaterAlignedLayout>

@end

@implementation WaterFallController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"瀑布流";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self leftLayoutView];
    
//    [self waterLayoutView];
}
#pragma mark - 标签流水布局
- (void)leftLayoutView{
    LYLeftWaterAlignedLayout *layout = [[LYLeftWaterAlignedLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 375, self.view.bounds.size.height) collectionViewLayout:layout];
    
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:collectionView];
}
#pragma mark - LYLeftWaterAlignedLayout
- (CGFloat)leftWaterAligned:(LYLeftWaterAlignedLayout *)waterFlow widthForItemAtIndexPath:(NSIndexPath *)indexPath {

    return arc4random()%200;
}
//每一行的高度
- (CGFloat)columnHeightWaterAligned:(LYLeftWaterAlignedLayout *)waterAligned {
    
    return 30;
}
//每一列之间的间隙
- (CGFloat)columnMarginWaterAligned:(LYLeftWaterAlignedLayout *)waterAligned {
    
    return 5;
}
//每一行之间的间隙
- (CGFloat)rowMarginWaterAligned:(LYLeftWaterAlignedLayout *)waterAligned {
    
    return 5;
}

//边缘的间隙
- (UIEdgeInsets)edgeInsetsWaterAligned:(LYLeftWaterAlignedLayout *)waterAligned {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor grayColor];
   
    return cell;
}

#pragma mark - 瀑布流布局
- (void)waterLayoutView{
    LYWaterFlowLayout *layout = [[LYWaterFlowLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 375, self.view.bounds.size.height) collectionViewLayout:layout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;

    collectionView.backgroundColor = [UIColor whiteColor];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:collectionView];
}
#pragma mark - LYWaterFlowLayoutDelegate
- (CGFloat)waterFlow:(LYWaterFlowLayout *)waterFlow heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemW {

    return (arc4random() % 200);
}

//列数
- (CGFloat)columnCountWaterFlow:(LYWaterFlowLayout *)waterFlow {
    return 2;
}
//每一列之间的间隙
- (CGFloat)columnMarginWaterFlow:(LYWaterFlowLayout *)waterFlow {
    return 4;
}
//每一行之间的间隙
- (CGFloat)rowMarginWaterFlow:(LYWaterFlowLayout *)waterFlow {
    return 7;
}
//边缘的间隙
- (UIEdgeInsets)edgeInsetsWaterFlow:(LYWaterFlowLayout *)waterFlow {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
