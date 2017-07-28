//
//  PoiModel.h
//  MeiTuanMapDemo
//
//  Created by 刘毅 on 2017/7/28.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoiModel : NSObject

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,assign)double lat;
@property (nonatomic,assign)double lon;

@end
