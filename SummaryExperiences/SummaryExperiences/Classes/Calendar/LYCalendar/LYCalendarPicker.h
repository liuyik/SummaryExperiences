//
//  LYCalendarPicker.h
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/3/23.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LYCalendarPickerDelegate <NSObject>


- (void)calenderBackYear:(NSInteger)year
                  month:(NSInteger)month
                    day:(NSInteger)day;

@end

@interface LYCalendarPicker : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, weak) id<LYCalendarPickerDelegate>delegate;

@end
