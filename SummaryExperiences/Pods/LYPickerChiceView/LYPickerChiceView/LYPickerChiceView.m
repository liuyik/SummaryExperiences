//
//  LYPickerChiceView.m
//  Register
//
//  Created by 刘毅 on 16/7/15.
//  Copyright © 2016年 刘毅. All rights reserved.
//

#import "LYPickerChiceView.h"
#import "NSCalendar+LYTime.h"

//屏幕宽和高
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

//RGB
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 缩放比
#define kScaleWidth ([UIScreen mainScreen].bounds.size.width) / 375

#define kScaleHeight ([UIScreen mainScreen].bounds.size.height) / 667

// 年份
#define kMinYear 1900
#define kYearNumber 200

@interface LYPickerChiceView ()<UIPickerViewDelegate,UIPickerViewDataSource>

/** 背景 */
@property (nonatomic,strong)UIView         *bgView;
/** 标题 */
@property (nonatomic,strong)UILabel  *titleLabel;
/** 取消按钮 */
@property (nonatomic,strong)UIButton       *cancelBtn;
/** 完成按钮 */
@property (nonatomic,strong)UIButton       *completesBtn;
/** 选择器 */
@property (nonatomic,strong)UIPickerView   *pickerView;
/** 数据 */
@property (nonatomic,strong)NSArray        *data;


/** 时间 */
/** 年 */
@property (nonatomic, assign)NSInteger      year;
/** 月 */
@property (nonatomic, assign)NSInteger      month;
/** 日 */
@property (nonatomic, assign)NSInteger      day;

/** 地区 */
/** 当前省数组 */
@property (nonatomic, strong)NSMutableArray *provinces;
/** 当前城市数组 */
@property (nonatomic, strong)NSMutableArray *citys;
/** 当前地区数组 */
@property (nonatomic, strong)NSMutableArray *areas;
/** 当前选中数组 */
@property (nonatomic, strong)NSMutableArray *arraySelected;
/** 省份 */
@property (nonatomic, strong)NSString       *province;
/** 城市 */
@property (nonatomic, strong)NSString       *city;
/** 地区 */
@property (nonatomic, strong)NSString       *area;

/** 其他 */
@property (nonatomic, strong)NSString       *info;

@end

@implementation LYPickerChiceView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initViews];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}
#pragma mark - 初始化子视图
- (void)initViews {
    self.data = [NSMutableArray array];
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = RGBA(51, 51, 51, 0.8);
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 260*kScaleHeight)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgView];
    
    [self showAnimation];
    
    //取消
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgView addSubview:self.cancelBtn];
  
    self.cancelBtn.frame = CGRectMake(15, 0, 30, 44);
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitleColor:RGBA(0, 122, 255, 1) forState:UIControlStateNormal];
    //完成
    self.completesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgView addSubview:self.completesBtn];
    self.completesBtn.frame = CGRectMake(kScreenWidth-45, 0, 30, 44);
    self.completesBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.completesBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.completesBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.completesBtn setTitleColor:RGBA(0, 122, 255, 1) forState:UIControlStateNormal];
    
    //选择titi
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelBtn.frame)+5, 0, kScreenWidth-100, 44)];
    [self.bgView addSubview:self.titleLabel];

    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cancelBtn.frame), kScreenWidth, 0.5)];
    [self.bgView addSubview:line];
    
    line.backgroundColor = RGBA(224, 224, 224, 1);
    
    //选择器
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line.frame), kScreenWidth, CGRectGetHeight(self.bgView.frame)-CGRectGetMaxY(self.cancelBtn.frame))];
    [self.bgView addSubview:self.pickerView];
    
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;

}
#pragma mark - 数据类型
- (void)setDataType:(DATATYPE)dataType {
    _dataType = dataType;

    switch (_dataType) {
        case LYPickerDataCustom:
        {
            self.data = _customData;
            self.info = [self.data firstObject];
            self.titleLabel.text = _customTitle;
        }
            break;
        case LYPickerDataGender:
        {
            self.titleLabel.text = @"请选择性别";
            self.data = @[@"男",@"女"];
            self.info = [self.data firstObject];
        }
            break;
        case LYPickerDataHeight:
        {
            self.titleLabel.text = @"请选择身高";
            NSMutableArray *heightArr = [NSMutableArray array];
            for (int i = 100; i<=250; i++) {
                NSString *height = [NSString stringWithFormat:@"%d",i];
                [heightArr addObject:height];
            }
            self.data = heightArr;
            self.info = [self.data firstObject];
        }
            break;
        case LYPickerDataWeight:
        {
            self.titleLabel.text = @"请选择体重";
            NSMutableArray *weightArr = [NSMutableArray array];
            for (int i = 30; i<=200; i++) {
                NSString *weight = [NSString stringWithFormat:@"%d",i];
                [weightArr addObject:weight];
            }
            self.data = weightArr;
            self.info = [self.data firstObject];
        }
            break;
        case LYPickerDataSalary:
        {
            self.titleLabel.text = @"请选择工资";
            NSMutableArray *salaryArr = [NSMutableArray array];
            for (int i = 2000; i<=20000; i=i+500) {
                NSString *salary = [NSString stringWithFormat:@"%d",i];
                [salaryArr addObject:salary];
            }
            self.data = salaryArr;
            self.info = [self.data firstObject];
        }
            break;
        case LYPickerDataDete:
        {
            self.titleLabel.text = @"请选择出生年月";
            //加载时间数据
            [self loadDate];
        }
            break;
        case LYPickerDataArea:
        {
            self.titleLabel.text = @"请选择地区";
            NSString *path = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
            self.data = [[NSArray alloc]initWithContentsOfFile:path];
            //加载地址数据
            [self loadArea];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 时间数据的处理
//加载时间
- (void)loadDate {
    
    _year  = [NSCalendar currentYear];
    _month = [NSCalendar currentMonth];
    _day   = [NSCalendar currentDay];
    [self.pickerView selectRow:(_year - kMinYear) inComponent:0 animated:NO];
    [self.pickerView selectRow:(_month - 1) inComponent:1 animated:NO];
    [self.pickerView selectRow:(_day - 1) inComponent:2 animated:NO];
}
//更新时间
- (void)reloadDate {
    self.year  = [self.pickerView selectedRowInComponent:0] + kMinYear;
    self.month = [self.pickerView selectedRowInComponent:1] + 1;
    self.day   = [self.pickerView selectedRowInComponent:2] + 1;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld年%ld月%ld日", self.year, self.month, self.day];
}

#pragma mark - 加载地区的处理
//加载地区数据
- (void)loadArea {
    if (self.provinces == nil) {
        self.provinces = [NSMutableArray array];
    }
    if (self.citys == nil) {
        self.citys = [NSMutableArray array];
    }
    if (self.areas == nil) {
        self.areas = [NSMutableArray array];
    }
    
    for (NSDictionary *dic in self.data) {
        
        [self.provinces addObject:dic[@"state"]];
    }
    
    NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.data firstObject][@"cities"]];
    for (NSDictionary *dic in citys) {
        
        [self.citys addObject:dic[@"city"]];
    }
    self.areas = [citys firstObject][@"area"];
    
    self.province = self.provinces[0];
    self.city = self.citys[0];
    if (self.areas.count != 0) {
        self.area = self.areas[0];
    }else{
        self.area = @"";
    }

}
//更新地区数据
- (void)reloadArea {
    NSInteger index0 = [self.pickerView selectedRowInComponent:0];
    NSInteger index1 = [self.pickerView selectedRowInComponent:1];
    NSInteger index2 = [self.pickerView selectedRowInComponent:2];
    self.province = self.provinces[index0];
    self.city = self.citys[index1];
    if (self.areas.count != 0) {
        self.area = self.areas[index2];
    }else{
        self.area = @"";
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@", self.province, self.city, self.area];
    self.titleLabel.text = title;
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
//组数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_dataType == LYPickerDataDete) {
        return 3;
    }
    else if (_dataType == LYPickerDataArea) {
        return 3;
    }
    return 1;
}
//个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_dataType == LYPickerDataDete) {
        if (component == 0) {
            return kYearNumber;
        }else if(component == 1) {
            return 12;
        }else {
            NSInteger yearSelected = [pickerView selectedRowInComponent:0] + kMinYear;
            NSInteger monthSelected = [pickerView selectedRowInComponent:1] + 1;
            return  [NSCalendar getDaysWithYear:yearSelected month:monthSelected];
        }
    }
    else if (_dataType == LYPickerDataArea) {
        if (component == 0) {
            return self.provinces.count;
        }else if (component == 1) {
            return self.citys.count;
        }else{
            return self.areas.count;
        }
    }
    return self.data.count;
    
}
//高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 28;
}
//自定义单元格
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view{
    
    UILabel *label=[[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    if (_dataType == LYPickerDataDete) {
        NSString *text;
        if (component == 0) {
            text =  [NSString stringWithFormat:@"%ld", row + 1900];
        }else if (component == 1){
            text =  [NSString stringWithFormat:@"%ld", row + 1];
        }else{
            text = [NSString stringWithFormat:@"%ld", row + 1];
        }
        label.text = text;
    }
    else if (_dataType == LYPickerDataArea) {
        NSString *text;
        if (component == 0) {
            text =  self.provinces[row];
        }else if (component == 1){
            text =  self.citys[row];
        }else{
            if (self.areas.count > 0) {
                text = self.areas[row];
            }else{
                text =  @"";
            }
        }
        label.text = text;
    }else {
        
        label.text= self.data[row];
    }
    
    return label;
    
    
}

//选中的单元格
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_dataType == LYPickerDataDete) {
        switch (component) {
            case 0:
                [pickerView reloadComponent:1];
                [pickerView reloadComponent:2];
                break;
            case 1:
                [pickerView reloadComponent:2];
            default:
                break;
        }
        
        [self reloadDate];
    }else if (_dataType == LYPickerDataArea){
        if (component == 0) {
            self.arraySelected = self.data[row][@"cities"];
            
            [self.citys removeAllObjects];
            [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.citys addObject:obj[@"city"]];
            }];
            
            self.areas = [NSMutableArray arrayWithArray:[self.arraySelected firstObject][@"areas"]];
            
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:1 animated:YES];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
        }else if (component == 1) {
            if (self.arraySelected.count == 0) {
                self.arraySelected = [self.data firstObject][@"cities"];
            }
            
            self.areas = [NSMutableArray arrayWithArray:[self.arraySelected objectAtIndex:row][@"areas"]];
            
            [pickerView reloadComponent:2];
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
        }else{
        }
        
        [self reloadArea];
    }
    else {
        self.info = self.data[row];
        self.titleLabel.text = self.info;
    }
    NSLog(@"%ld,%ld",component,row);
}


#pragma mark-----点击方法
//取消
- (void)cancelBtnClick{
    
    [self hideAnimation];
    
}
//完成
- (void)completeBtnClick{

    if (_dataType == LYPickerDataDete) {
        
        NSString *yearStr = [NSString stringWithFormat:@"%ld",self.year];
        NSString *monthStr = [NSString stringWithFormat:@"%ld",self.month];
        NSString *dayStr = [NSString stringWithFormat:@"%ld",self.day];
        NSDictionary *dateDic = @{@"year":yearStr,@"month":monthStr,@"day":dayStr};
        [self.delegate PickerSelectorIndixInfo:dateDic];
    }
    else if (_dataType == LYPickerDataArea) {
        NSDictionary *areaDic = @{@"province":self.province,@"city":self.city,@"area":self.area};
        [self.delegate PickerSelectorIndixInfo:areaDic];
    }
    else {
        if (self.info) {
            NSDictionary *infoDic = @{@"info":self.info};
            [self.delegate PickerSelectorIndixInfo:infoDic];
        }else {
            NSDictionary *infoDic = @{@"info":@"没有数据"};
            [self.delegate PickerSelectorIndixInfo:infoDic];
        }
       
    }
    [self hideAnimation];
    
}
//点击
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self hideAnimation];
    
}
#pragma mark - 显示隐藏动画
//隐藏动画
- (void)hideAnimation{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.bgView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
        
    }];
    
}

//显示动画
- (void)showAnimation{
   
    [UIView animateWithDuration:0.5 animations:^{

        self.bgView.transform = CGAffineTransformMakeTranslation(0, -260*kScaleHeight);
    }];
    
}

@end
