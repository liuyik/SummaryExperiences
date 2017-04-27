//
//  CollectionCategoryModel.m
//  testSVN
//
//  Created by 刘毅 on 2017/3/21.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "CollectionCategoryModel.h"

@implementation CollectionCategoryModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"subcategories":[SubCategoryModel class]};
}
@end

@implementation SubCategoryModel

@end
