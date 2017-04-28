//
//  SegmentController.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/4/26.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "SegmentController.h"
#import "RightTableView.h"
#import "RightCollectionView.h"

@interface SegmentController ()

@end

@implementation SegmentController{
    RightTableView *rtView;
    RightCollectionView *rcView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"分类";
    
    [self createTabelView];
//        [self createCollectionView];
    
}


- (void)createTabelView {
    rtView = [[RightTableView alloc] initWithFrame:CGRectMake(90, 64, KScreenWidth-90, KScreenHeight-64) inView:self.view];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"meituan" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *foods = dict[@"data"][@"food_spu_tags"];
    
    rtView.data = foods;
}
- (void)createCollectionView {
    
    rcView = [[RightCollectionView alloc] initWithFrame:CGRectMake(90, 64, KScreenWidth-90, KScreenHeight-64) inView:self.view];
    
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"liwushuo" ofType:@"json"];
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:data1 options:NSJSONReadingAllowFragments error:nil];
    NSArray *shop = dict1[@"data"][@"categories"];
    
    rcView.data = shop;
}
@end
