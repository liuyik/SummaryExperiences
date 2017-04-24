//
//  TreeModel.m
//  test
//
//  Created by 刘毅 on 16/9/23.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import "TreeModel.h"

@implementation TreeModel


//初始化一个model
+ (id)dataObjectWithDic:(NSDictionary *)treeDic {
    TreeModel *model = [[TreeModel alloc] init];
    
    if (![treeDic[@"orgName"] isKindOfClass:[NSNull class]]) {
        model.orgName = treeDic[@"orgName"];
        
    }
    
    model.cDtoList = treeDic[@"cDtoList"];
 
    
    return model;
}

@end


