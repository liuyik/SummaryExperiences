//
//  UIImageView+CircleImage.h
//  健游天下
//
//  Created by 刘毅 on 16/11/22.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CircleImage)

@property (nonatomic,strong)UIImage *circleImage;

- (void)setCircleImage:(UIImage *)circleImage;

- (UIImage *)circleImage;
@end
