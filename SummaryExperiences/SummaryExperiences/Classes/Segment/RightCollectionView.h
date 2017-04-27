//
//  RightCollectionView.h
//  testSVN
//
//  Created by 刘毅 on 2017/3/21.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftTabelView.h"



@interface RightCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource,LeftTabelViewDelegate>

- (instancetype)initWithFrame:(CGRect)frame inView:(UIView *)view;

@property (nonatomic,strong) NSArray *data;

@end
