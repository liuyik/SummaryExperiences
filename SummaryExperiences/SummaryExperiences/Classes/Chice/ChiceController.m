//
//  ChiceController.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/4/25.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "ChiceController.h"
#import "LYPickerChiceView.h"

@interface ChiceController ()<UITextFieldDelegate,LYPickerChiceViewDelegate>

@end

@implementation ChiceController{
    
    LYPickerChiceView *_picker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择器";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *arr = @[@"姓名",@"性别",@"身高",@"体重",@"工资",@"时间",@"地点"];
    
    for (int i=0; i < arr.count; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(35, 50*i+100, 230, 30)];
        textField.tag = 100 + i;
        textField.delegate = self;
        textField.secureTextEntry = NO;
        textField.borderStyle = UITextBorderStyleLine;
        textField.font = [UIFont systemFontOfSize:16];
        textField.textColor = [UIColor blackColor];
        NSString *placeholder = [NSString stringWithFormat:@"请选择%@",arr[i]];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                          attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.7 alpha:1],
                                                                                       NSFontAttributeName:[UIFont systemFontOfSize:16]}];
        [self.view addSubview:textField];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    NSLog(@"%ld",textField.tag);
    
    switch (textField.tag) {
        case 100:
        {
            /*
             * 自定义数据要先给数据，标题，在设置自定义类型，不然没数据
             */
            _picker = [[LYPickerChiceView alloc] initWithFrame:self.view.bounds];
            NSArray *customs = @[@"小胜哥",@"阿祥",@"周大波",@"自定义4",@"自定义5",@"自定义6",@"自定义7"];
            _picker.customTitle = @"请选择姓名";
            _picker.customData = customs;
            _picker.dataType = LYPickerDataCustom;
            _picker.delegate = self;
            [self.view addSubview:_picker];
            
        }
            break;
        case 101:
        {
            _picker = [[LYPickerChiceView alloc] initWithFrame:self.view.bounds];
            _picker.dataType = LYPickerDataGender;
            _picker.delegate = self;
            [self.view addSubview:_picker];
            
        }
            break;
        case 102:
        {
            _picker = [[LYPickerChiceView alloc] initWithFrame:self.view.bounds];
            _picker.dataType = LYPickerDataHeight;
            _picker.delegate = self;
            [self.view addSubview:_picker];
            
        }
            break;
        case 103:
        {
            _picker = [[LYPickerChiceView alloc] initWithFrame:self.view.bounds];
            _picker.dataType = LYPickerDataWeight;
            _picker.delegate = self;
            [self.view addSubview:_picker];
            
        }
            break;
        case 104:
        {
            _picker = [[LYPickerChiceView alloc] initWithFrame:self.view.bounds];
            _picker.dataType = LYPickerDataSalary;
            _picker.delegate = self;
            [self.view addSubview:_picker];
            
        }
            break;
        case 105:
        {
            _picker = [[LYPickerChiceView alloc] initWithFrame:self.view.bounds];
            _picker.dataType = LYPickerDataDete;
            _picker.delegate = self;
            [self.view addSubview:_picker];
            
        }
            break;
        case 106:
        {
            _picker = [[LYPickerChiceView alloc] initWithFrame:self.view.bounds];
            _picker.dataType = LYPickerDataArea;
            _picker.delegate = self;
            [self.view addSubview:_picker];
            
        }
            break;
            
        default:
            break;
    }
    return NO;
}
#pragma mark - 返回选中内容的协议
- (void)PickerSelectorIndixInfo:(NSDictionary *)info {
    /*
     * 判断类型；
     * 时间类型字典的key为year、month、day；
     * 地点类型字典key为province、city、area；
     * 其他，字典key为：info；
     */
    switch (_picker.dataType) {
            
        case LYPickerDataCustom:
        {
            UITextField *textField = [self.view viewWithTag:100];
            textField.text = info[@"info"];
        }
            break;
        case LYPickerDataGender:
        {
            UITextField *textField = [self.view viewWithTag:101];
            textField.text = info[@"info"];
        }
            break;
        case LYPickerDataHeight:
        {
            UITextField *textField = [self.view viewWithTag:102];
            textField.text = info[@"info"];
        }
            break;
        case LYPickerDataWeight:
        {
            UITextField *textField = [self.view viewWithTag:103];
            textField.text = info[@"info"];
        }
            break;
        case LYPickerDataSalary:
        {
            UITextField *textField = [self.view viewWithTag:104];
            textField.text = info[@"info"];
        }
            break;
        case LYPickerDataDete:
        {
            UITextField *textField = [self.view viewWithTag:105];
            textField.text = [NSString stringWithFormat:@"%@／%@／%@",info[@"year"],info[@"month"],info[@"day"]];
        }
            break;
        case LYPickerDataArea:
        {
            UITextField *textField = [self.view viewWithTag:106];
            textField.text = [NSString stringWithFormat:@"%@ %@ %@",info[@"province"],info[@"city"],info[@"area"]];
        }
            break;
        default:
            break;
    }
}

@end
