//
//  RightCollectionView.m
//  testSVN
//
//  Created by 刘毅 on 2017/3/21.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "RightCollectionView.h"
#import "RightCollectionCell.h"
#import "CollectionReusableView.h"
#import "LJCollectionViewFlowLayout.h"

@implementation RightCollectionView

{
    LeftTabelView *_lfView;
    BOOL _isScrollDown;
}
- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)view{

//
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //左右间距
    layout.minimumInteritemSpacing = 2;
    //上下间距
    layout.minimumLineSpacing = 2;
    
    layout.sectionHeadersPinToVisibleBounds = YES;

    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self _init:view];
    }
    return self;
}
//初始化
- (void)_init:(UIView *)view{
    
    self.delegate = self;
    self.dataSource = self;
    
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    // 注册Cell
    
    [self registerNib:[UINib nibWithNibName:@"RightCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"RightCollectionCell"];
    
    [self registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    _lfView = [[LeftTabelView alloc] initWithFrame:CGRectMake(0, self.top, self.left, self.height)];
    _lfView.leftDelegate = self;
    [view addSubview:_lfView];
    
    [view addSubview:self];
    
}

//数据
- (void)setData:(NSArray *)data {
    if (_data != data) {
        _data = data;
        [self reloadData];
        
        if (_lfView) {
            _lfView.data = _data;
            [_lfView reloadData];
            [_lfView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }
    }
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _lfView.data.count;
}
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CollectionCategoryModel *ccModel = [CollectionCategoryModel mj_objectWithKeyValues:self.data[section]];
    
    return ccModel.subcategories.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RightCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RightCollectionCell"forIndexPath:indexPath];
    
    CollectionCategoryModel *ccModel = [CollectionCategoryModel mj_objectWithKeyValues:self.data[indexPath.section]];
    cell.scModel =  ccModel.subcategories[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((KScreenWidth - self
                       .left- 4 - 4) / 3,115);
}
-(UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
   
    CollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    CollectionCategoryModel *ccModel = [CollectionCategoryModel mj_objectWithKeyValues:self.data[indexPath.section]];
    header.titleLabel.text = ccModel.name ;
    return header;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(KScreenWidth-self.left, 30);
}

// collectionView分区标题即将展示
-(void) collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if (_isScrollDown && collectionView.dragging) {
        [self selectRowAtIndexPath:indexPath.section+1];
    }
}

// collectionView分区标题展示结束
-(void) collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if (!_isScrollDown && collectionView.dragging) {
        [self selectRowAtIndexPath:indexPath.section];
    }
    
}
// 当拖动右边TableView的时候，处理左边TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [_lfView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - UISrcollViewDelegate
// 标记一下RightTableView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static CGFloat lastOffsetY = 0;
    
    _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
    lastOffsetY = scrollView.contentOffset.y;
    
    
}
#pragma mark - LeftTabelViewDelegate
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
    [_lfView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}



@end
