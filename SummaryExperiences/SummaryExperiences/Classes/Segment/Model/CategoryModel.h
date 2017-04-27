//
//  ShoppingController.h
//  testSVN
//
//  Created by 刘毅 on 2017/3/20.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FoodModel;
@interface CategoryModel : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *icon;

@property (nonatomic,strong) NSArray<FoodModel*> *spus;

@end

@interface FoodModel : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *foodId;

@property (nonatomic,strong) NSString *picture;

@property (nonatomic,strong) NSString *month_saled_content;

@property (nonatomic,strong) NSString *praise_content;

@property (nonatomic,assign) float min_price;

@end
