//
//  LYCalendarPicker.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/3/23.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "LYCalendarPicker.h"
#import "LYCalendarCell.h"

#define SWidth self.frame.size.width
#define SHeight self.frame.size.height


@implementation LYCalendarPicker {
    
    UICollectionView *_collectionView;
    UILabel *_monthLabel;
    UIButton *_previousButton;
    UIButton *_nextButton;
}

#pragma mark - 初始化
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    self.backgroundColor = [UIColor whiteColor];
    //显示XX年XX月Label
    _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SWidth, 30)];
    _monthLabel.backgroundColor = [UIColor orangeColor];
    _monthLabel.textColor = [UIColor blackColor];
    _monthLabel.textAlignment = NSTextAlignmentCenter;
    _monthLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:_monthLabel];

    //上一年
    _previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _previousButton.frame = CGRectMake(0, 0, 30, 30);
    [_previousButton setImage:[UIImage imageNamed:@"bt_previous"] forState:UIControlStateNormal];
    [_previousButton addTarget:self action:@selector(previouseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_previousButton];
    
    //下一年
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _nextButton.frame = CGRectMake(SWidth-30, 0, 30, 30);
    [_nextButton setImage:[UIImage imageNamed:@"bt_next"] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(nexAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nextButton];

    
    //星期
    NSArray *arr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i=0; i<arr.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SWidth/arr.count*i, 30, SWidth/arr.count, SWidth/arr.count)];
        label.backgroundColor = [UIColor whiteColor];
        label.text = arr[i];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        [self addSubview:label];
    }
    
    //collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SWidth-8)/arr.count, (SWidth-8)/arr.count);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SWidth/arr.count+30, SWidth, SHeight-SWidth/arr.count-30) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor grayColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"LYCalendarCell" bundle:nil] forCellWithReuseIdentifier:@"LYCalendarCell"];
    [self addSwipe];
}
//重写set、get方法
@synthesize date = _date;
- (NSDate *)date {
    if (!_date) {
        _date = [NSDate date];
         [_monthLabel setText:[NSString stringWithFormat:@"%ld年%ld月",[self year:_date],(long)[self month:_date]]];
        [self setViewToHeight];
    }
    return _date;
}


- (void)setDate:(NSDate *)date {
    _date = date;
    [_monthLabel setText:[NSString stringWithFormat:@"%ld年%ld月",[self year:_date],(long)[self month:_date]]];
    [self setViewToHeight];
}
//添加手势
- (void)addSwipe
{
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nexAction:)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction:)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}
//上
- (void)previouseAction:(UIButton *)sender
{
//    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
        self.date = [self lastMonth:self.date];
//
        [_collectionView reloadData];
//
//    } completion:nil];
}
//下
- (void)nexAction:(UIButton *)sender
{
//    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
        self.date = [self nextMonth:self.date];

        [_collectionView reloadData];
        
        
//    } completion:nil];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:self.date];
    NSInteger days = [self totaldaysInThisMonth:self.date];
    NSInteger sumDays = firstWeekday+days;
    
    return sumDays>35?42:sumDays>28?35:28;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LYCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYCalendarCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:self.date];
     NSInteger days = [self totaldaysInThisMonth:self.date];
    if (indexPath.row>=firstWeekday&&indexPath.row<=firstWeekday+days) {
        
        cell.dayLable.text = [NSString stringWithFormat:@"%ld",indexPath.row-firstWeekday+1];
    }else {
        cell.dayLable.text = @"";
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    LYCalendarCell *cell = (LYCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"%ld年%ld月%@日",[self year:self.date],[self month:self.date],cell.dayLable.text);
    if ([self.delegate respondsToSelector:@selector(calenderBackYear:month:day:)]) {
        [self.delegate calenderBackYear:[self year:self.date] month:[self month:self.date] day:[cell.dayLable.text integerValue]];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:self.date];
    if (indexPath.row>=firstWeekday)return YES;
    return NO;
}
#pragma mark - date
//天
- (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

//月
- (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}
//年
- (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

//这个月的第一天是星期几
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}
//这个月的天数
- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

//上个月
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
//下个月
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
//计算并设置view的高度
- (void)setViewToHeight {
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:self.date];
    NSInteger days = [self totaldaysInThisMonth:self.date];
    NSInteger sumDays = firstWeekday+days;
    NSInteger row = sumDays>35?7:sumDays>=28?6:5;
    CGFloat h = (SWidth/7)*row+30;
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
    
    _collectionView.frame = CGRectMake(0, SWidth/7+30, SWidth, SHeight-SWidth/7-30);
}
@end
