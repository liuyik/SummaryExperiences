//
//  UIImageView+CircleImage.m
//  健游天下
//
//  Created by 刘毅 on 16/11/22.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import "UIImageView+CircleImage.h"

@implementation UIImageView (CircleImage)
//- (void)circleImage:(UIImage*) image {
//    self.image = [self quartz2DImage:image];
//}
- (void)setCircleImage:(UIImage *)circleImage {
    
    self.image = [self quartz2DImage:circleImage];
}

- (UIImage *)circleImage {
    return self.image;
}

//Quartz2D绘制
- (UIImage *)quartz2DImage:(UIImage*) image{
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

@end
