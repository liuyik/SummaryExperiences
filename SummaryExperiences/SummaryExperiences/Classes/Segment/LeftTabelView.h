//
//  LeftTabelView.h
//  testSVN
//
//  Created by 刘毅 on 2017/3/20.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

@protocol LeftTabelViewDelegate <NSObject>

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface LeftTabelView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *data;

@property (nonatomic,weak)id<LeftTabelViewDelegate> leftDelegate;

@end
