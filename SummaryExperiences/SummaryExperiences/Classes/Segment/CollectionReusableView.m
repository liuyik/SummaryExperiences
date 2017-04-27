//
//  CollectionReusableView.m
//  testSVN
//
//  Created by 刘毅 on 2017/3/21.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 375 - 80, 30)];
        self.titleLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
    }
    return self;
}
@end
