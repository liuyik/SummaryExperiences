//
//  TreeViewController.m
//  test
//
//  Created by 刘毅 on 16/9/23.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import "TreeViewController.h"
#import "TreeModel.h"
#import <RATreeView.h>
#import "TreeCell.h"

@interface TreeViewController ()<RATreeViewDataSource, RATreeViewDelegate>

@property (nonatomic,strong)NSArray *treeList;
@property (nonatomic,strong)RATreeView *treeView;

@end

@implementation TreeViewController
- (BOOL)shouldAutorotate {
    return YES;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"树结构";
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"treeList" ofType:@"plist"];
    _treeList = [NSArray arrayWithContentsOfFile:path];
//    for (int; ; <#increment#>) {
//        <#statements#>
//    }
//    TreeModel *model = [TreeModel dataObjectWithDic:dic];
    
    [self initView];
}
//创建RATreeView 并赋值给控制器的view
- (void)initView {
    
    RATreeView *ratreeView = [[RATreeView alloc] initWithFrame:[UIScreen mainScreen].bounds style:RATreeViewStylePlain];
    ratreeView.delegate = self;
    ratreeView.dataSource = self;
    
    self.view = ratreeView;
    self.view.backgroundColor = [UIColor whiteColor];
//    [self setData];
}
#pragma mark -----------delegate
//返回行高
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return 44;
}
//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    TreeCell *cell = (TreeCell *)[treeView cellForItem:item];
    cell.iconView.highlighted = YES;
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    TreeCell *cell = (TreeCell *)[treeView cellForItem:item];
    cell.iconView.highlighted = NO;
}
//已经展开
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    NSLog(@"已经展开了");
}
//已经收缩
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    NSLog(@"已经收缩了");
}

//# dataSource方法

//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    //获取cell
    TreeCell *cell = [TreeCell treeViewCellWith:treeView];
    
    //当前item
    TreeModel *model = item;
    //当前层级
    NSInteger level = [treeView levelForCellForItem:item];
    //赋值
    NSLog(@"几层%ld",level);
    cell.titleLable.text = model.orgName;
    [cell setCellBasicInfoWith:model.orgName level:level children:model.cDtoList.count];
    return cell;
}
/**
 *  必须实现
 *
 *  @param treeView treeView
 *  @param item    节点对应的item
 *
 *  @return  每一节点对应的个数
 */
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    TreeModel *model = item;
    if (item == nil) {
        
        return self.treeList.count;
    }
    
    return model.cDtoList.count;
}
/**
 *必须实现的dataSource方法
 *
 *  @param treeView treeView
 *  @param index    子节点的索引
 *  @param item     子节点索引对应的item
 *
 *  @return 返回 节点对应的item
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    TreeModel *model = item;
    if (item==nil) {
        model = [TreeModel dataObjectWithDic:self.treeList[index]];
        return model;
    }
    
    NSDictionary *dic = model.cDtoList[index];
    model = [TreeModel dataObjectWithDic:dic];
    
    return model;
}
//cell的点击方法
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    //获取当前的层
    NSInteger level = [treeView levelForCellForItem:item];
    //当前点击的model
    TreeModel *model = item;
    if (model.cDtoList.count == 0) {
        
        NSLog(@"点击的是第%ld层,name=%@",level,model.orgName);
    }
}
//单元格是否可以编辑 默认是YES
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    return NO;
}
//编辑要实现的方法
- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item {
    NSLog(@"编辑了实现的方法");
}

@end
