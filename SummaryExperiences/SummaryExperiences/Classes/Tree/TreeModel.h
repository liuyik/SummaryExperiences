//
//  TreeModel.h
//  test
//
//  Created by 刘毅 on 16/9/23.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TreeModel : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *areaId;

@property (nonatomic, assign) NSInteger errorCount;

@property (nonatomic, assign) NSInteger orgSort;

@property (nonatomic, copy) NSString *staffs;

@property (nonatomic, strong) NSArray *cDtoList;

@property (nonatomic, copy) NSString *orgType;

@property (nonatomic, copy) NSString *orgLevel;

@property (nonatomic, copy) NSString *orgCode;

@property (nonatomic, copy) NSString *orgName;

@property (nonatomic, assign) NSInteger pid;

//初始化一个model
+ (id)dataObjectWithDic:(NSDictionary *)treeDic;

@end


