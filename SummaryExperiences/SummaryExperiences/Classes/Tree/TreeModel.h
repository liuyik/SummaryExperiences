//
//  TreeModel.h
//  test
//
//  Created by 刘毅 on 16/9/23.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TreeModel : NSObject

@property (nonatomic, copy) NSString *orgName;//机构名

@property (nonatomic, strong) NSArray *cDtoList;//子机构列表

//初始化一个model
+ (id)dataObjectWithDic:(NSDictionary *)treeDic;

@end


