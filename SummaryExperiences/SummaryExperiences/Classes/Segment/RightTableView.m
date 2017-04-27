//
//  RightTableView.m
//  testSVN
//
//  Created by 刘毅 on 2017/3/20.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "RightTableView.h"
#import "RightCell.h"

@implementation RightTableView {
    
    LeftTabelView *_lfView;
    BOOL _isScrollDown;
}
- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)view{
    self = [super initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        [self _init:view];
    }
    return self;
}
//初始化
- (void)_init:(UIView *)view{
    
    //设置代理
    self.delegate = self;
    self.dataSource = self;
    
    //注册单元格
    [self registerNib:[UINib nibWithNibName:@"RightCell" bundle:nil] forCellReuseIdentifier:@"RightCell"];
    
    //创建左边视图
    _lfView = [[LeftTabelView alloc] initWithFrame:CGRectMake(0, self.top, self.left, self.height)];
    _lfView.leftDelegate = self;
    
    //添加到父视图上
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


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _lfView.data.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
     CategoryModel *cModel = [CategoryModel mj_objectWithKeyValues:self.data[section]];
    
    return cModel.spus.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RightCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RightCell" forIndexPath:indexPath];
     CategoryModel *cModel = [CategoryModel mj_objectWithKeyValues:self.data[indexPath.section]];
    cell.fModel = cModel.spus[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 93;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
     CategoryModel *cModel = [CategoryModel mj_objectWithKeyValues:self.data[section]];
    
    UILabel *label = [[UILabel alloc] init];
    
    label.backgroundColor = [UIColor grayColor];
    label.text = cModel.name;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:16];
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
// TableView分区标题即将展示
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    if (tableView.dragging&&!_isScrollDown)
    {
        [self selectRowAtIndexPath:section];
    }
}
// TableView分区标题展示结束
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ( tableView.dragging&&_isScrollDown)
    {
        [self selectRowAtIndexPath:section+1];
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
    
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [_lfView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

@end
