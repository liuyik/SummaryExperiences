//
//  TreeModel.m
//  test
//
//  Created by 刘毅 on 16/9/23.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import "TreeModel.h"

@implementation TreeModel

/*"id": 4,
"orgName": "赛飞奇光子技术有限公司移动测试",
"pid": 14,
"orgType": null,
"orgSort": 2,
"orgLevel": null,
"orgCode": "01050202",
"areaId": null,
"state": null,
"staffs": null,
"errorCount": 1,
"cDtoList": []*/
//初始化一个model
+ (id)dataObjectWithDic:(NSDictionary *)treeDic {
    TreeModel *model = [[TreeModel alloc] init];
    if (![treeDic[@"id"] isKindOfClass:[NSNull class]]) {
        
        model.ID = [treeDic[@"id"] integerValue];
    }
    
    if (![treeDic[@"orgName"] isKindOfClass:[NSNull class]]) {
        model.orgName = treeDic[@"orgName"];
        
    }
    if (![treeDic[@"pid"] isKindOfClass:[NSNull class]]) {
        
        model.pid = [treeDic[@"pid"] integerValue];
        
    }
    if (![treeDic[@"orgSort"] isKindOfClass:[NSNull class]]) {
        
        model.orgSort = [treeDic[@"orgSort"] integerValue];
        
    }
    if (![treeDic[@"orgCode"] isKindOfClass:[NSNull class]]) {
        
        model.orgCode = treeDic[@"orgCode"];
        
    }
    if (![treeDic[@"errorCount"] isKindOfClass:[NSNull class]]) {
        
        model.errorCount = [treeDic[@"errorCount"] integerValue];
    }
    
    model.cDtoList = treeDic[@"cDtoList"];
 
    
    return model;
}

@end


