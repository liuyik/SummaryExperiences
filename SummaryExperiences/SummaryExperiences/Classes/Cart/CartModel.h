//
//  CartModel.h
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/1/16.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartModel : NSObject
//自定义模型时,这三个属性必须有
@property (nonatomic,assign) BOOL select;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic,copy) NSString *price;
//下面的属性可根据自己的需求修改
@property (nonatomic,copy) NSString *sizeStr;
@property (nonatomic,copy) NSString *nameStr;
@property (nonatomic,copy) NSString *dateStr;
@property (nonatomic,retain)UIImage *image;

@end
