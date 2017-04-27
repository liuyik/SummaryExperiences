//
//  CollectionCategoryModel.h
//  testSVN
//
//  Created by 刘毅 on 2017/3/21.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SubCategoryModel;
@interface CollectionCategoryModel : NSObject

@property (nonatomic ,strong) NSString *name;

@property (nonatomic ,strong) NSArray<SubCategoryModel *> *subcategories;

@end

@interface SubCategoryModel : NSObject

@property (nonatomic ,strong) NSString *name;

@property (nonatomic ,strong) NSString *icon_url;

@property (nonatomic ,strong) NSString *items_count;

@end
