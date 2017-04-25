//
//  CartViewController.m
//  SummaryExperiences
//
//  Created by 刘毅 on 16/8/11.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import "CartViewController.h"
#import "CartTableViewCell.h"
#import "CartModel.h"

@interface CartViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)NSMutableArray *dataArray;
@property (strong,nonatomic)NSMutableArray *selectedArray;
@property (strong,nonatomic)UITableView *myTableView;
@property (strong,nonatomic)UIButton *allSellectedButton;
@property (strong,nonatomic)UILabel *totlePriceLabel;

@end

@implementation CartViewController
#pragma mark - viewController life cicle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    
    //当进入购物车的时候判断是否有已选择的商品,有就清空
    //主要是提交订单后再返回到购物车,如果不清空,还会显示
    if (self.selectedArray.count > 0) {
        for (CartModel *model in self.selectedArray) {
            model.select = NO;//这个其实有点多余,提交订单后的数据源不会包含这些,保险起见,加上了
        }
        [self.selectedArray removeAllObjects];
    }
    
    //初始化显示状态
    _allSellectedButton.selected = NO;
    _totlePriceLabel.attributedText = [self SetString:@"￥0.00"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];

    
#warning 模仿请求数据,延迟1s加载数据
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1];
    
    
//    [self setupCustomNavigationBar];
    if (self.dataArray.count > 0) {
        
        [self setupCartView];
    } else {
        [self setupCartEmptyView];
    }
}

#pragma mark - 初始化数组
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectedArray;
}


#pragma mark - 数据
-(void)requestData {
    
    for (int i = 0; i < 10; i++) {
        CartModel *model = [[CartModel alloc]init];
        
        model.nameStr = [NSString stringWithFormat:@"测试数据%d",i];
        model.price = @"100.00";
        model.number = 1;
        model.image = [UIImage imageNamed:@"cart_shop"];
        model.dateStr = @"2016.02.18";
        model.sizeStr = @"200ml";
        
        [self.dataArray addObject:model];
    }
    
}
- (void)loadData {
    [self requestData];
    [self changeView];
}


//计算已选中商品金额
-(void)countPrice {
    double totlePrice = 0.0;
    
    for (CartModel *model in self.selectedArray) {
        
        double price = [model.price doubleValue];
        
        totlePrice += price*model.number;
    }
    NSString *string = [NSString stringWithFormat:@"￥%.2f",totlePrice];
    self.totlePriceLabel.attributedText = [self SetString:string];
}

#pragma mark - 布局页面视图
#pragma mark -- 自定义底部视图
- (void)setupCustomBottomView {
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight -  49, KScreenWidth, 49)];
    backgroundView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    backgroundView.tag = 100 + 1;
    [self.view addSubview:backgroundView];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, KScreenWidth, 1);
    lineView.backgroundColor = [UIColor lightGrayColor];
    [backgroundView addSubview:lineView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:16];
    selectAll.frame = CGRectMake(10, 5, 80, 49 - 10);
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"cart_unSelect_btn"] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:@"cart_selected_btn"] forState:UIControlStateSelected];
    [selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:selectAll];
    self.allSellectedButton = selectAll;
    
    //结算按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(KScreenWidth - 80, 0, 80, 49);
    [btn setTitle:@"去结算" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    
    //合计
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor redColor];
    [backgroundView addSubview:label];
    
    label.attributedText = [self SetString:@"¥0.00"];
    CGFloat maxWidth = KScreenWidth - selectAll.bounds.size.width - btn.bounds.size.width - 30;
 
    label.frame = CGRectMake(selectAll.bounds.size.width + 20, 0, maxWidth - 10, 49);
    self.totlePriceLabel = label;
}

- (NSMutableAttributedString*)SetString:(NSString*)string {
    
    NSString *text = [NSString stringWithFormat:@"合计:%@",string];
    NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange rang = [text rangeOfString:@"合计:"];
    [LZString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:rang];
    [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:rang];
    return LZString;
}
#pragma mark -- 购物车为空时的默认视图
- (void)changeView {
    if (self.dataArray.count > 0) {
        UIView *view = [self.view viewWithTag:100];
        if (view != nil) {
            [view removeFromSuperview];
        }
        
        [self setupCartView];
    } else {
        UIView *bottomView = [self.view viewWithTag:100 + 1];
        [bottomView removeFromSuperview];
        
        [self.myTableView removeFromSuperview];
        self.myTableView = nil;
        [self setupCartEmptyView];
    }
}

- (void)setupCartEmptyView {
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64)];
    backgroundView.tag = 100;
    [self.view addSubview:backgroundView];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cart_default_bg"]];
    img.center = CGPointMake(KScreenWidth/2.0, KScreenHeight/2.0 - 120);
    img.bounds = CGRectMake(0, 0, 247.0/187 * 100, 100);
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.center = CGPointMake(KScreenWidth/2.0, KScreenHeight/2.0 - 10);
    warnLabel.bounds = CGRectMake(0, 0, KScreenWidth, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = @"购物车为空!";
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.textColor = [UIColor orangeColor];
    [backgroundView addSubview:warnLabel];
}
#pragma mark -- 购物车有商品时的视图
- (void)setupCartView {
    //创建底部视图
    [self setupCustomBottomView];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64 - 49) style:UITableViewStylePlain];
    
    table.delegate = self;
    table.dataSource = self;
    
    table.rowHeight = 100;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:248/255.0 alpha:1];
    [table registerClass:[CartTableViewCell class] forCellReuseIdentifier:@"CartReusableCell"];
    [self.view addSubview:table];
    self.myTableView = table;
   
}
#pragma mark --- UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartReusableCell" forIndexPath:indexPath];
   
    CartModel *model = self.dataArray[indexPath.row];
    __block typeof(cell)wsCell = cell;
    
    [cell numberAddWithBlock:^(NSInteger number) {
        wsCell.number = number;
        model.number = number;
        
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell numberCutWithBlock:^(NSInteger number) {
        
        wsCell.number = number;
        model.number = number;
        
        //替换
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            [self countPrice];
        }
    }];
    
    [cell cellSelectedWithBlock:^(BOOL select) {
        //选择
        model.select = select;
        if (select) {
            [self.selectedArray addObject:model];
        } else {
            [self.selectedArray removeObject:model];
        }
        
        if (self.selectedArray.count == self.dataArray.count) {
            _allSellectedButton.selected = YES;
        } else {
            _allSellectedButton.selected = NO;
        }
        
        [self countPrice];
    }];
    
    [cell reloadDataWithModel:model];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该商品?删除后无法恢复!" preferredStyle:1];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            CartModel *model = [self.dataArray objectAtIndex:indexPath.row];
            
            [self.dataArray removeObjectAtIndex:indexPath.row];
            //    删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            //判断删除的商品是否已选择
            if ([self.selectedArray containsObject:model]) {
                //从已选中删除,重新计算价格
                [self.selectedArray removeObject:model];
                [self countPrice];
            }
            
            if (self.selectedArray.count == self.dataArray.count) {
                _allSellectedButton.selected = YES;
            } else {
                _allSellectedButton.selected = NO;
            }
            
            if (self.dataArray.count == 0) {
                [self changeView];
            }
            
            //如果删除的时候数据紊乱,可延迟0.5s刷新一下
            [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
            
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
- (void)reloadTable {
    [self.myTableView reloadData];
}
#pragma mark -- 页面按钮点击事件
//全选按钮点击事件
- (void)selectAllBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (CartModel *model in self.selectedArray) {
        model.select = NO;
    }
    
    [self.selectedArray removeAllObjects];
    
    if (button.selected) {
        
        for (CartModel *model in self.dataArray) {
            model.select = YES;
            [self.selectedArray addObject:model];
        }
    }
    
    [self.myTableView reloadData];
    [self countPrice];
}

//确认选择
- (void)goToPayButtonClick:(UIButton*)button {
    
    if (self.selectedArray.count > 0) {
        
        for (CartModel *model in self.selectedArray) {
            NSLog(@"选择的商品%@---%ld",model,(long)model.number);
        }
    } else {
        NSLog(@"你还没有选择任何商品");
    }
    
}
@end
