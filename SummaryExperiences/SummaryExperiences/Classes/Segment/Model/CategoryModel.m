//
//  ShoppingController.h
//  testSVN
//
//  Created by 刘毅 on 2017/3/20.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"spus":[FoodModel class]};
}

@end

@implementation FoodModel


@end
