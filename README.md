# SummaryExperiences

自己用的框架总结下。
## 日历
看过一些其它的日历控件，感觉还是自己写个，后面用时自己也好改。

### 用法

```
- (void)viewDidLoad {
    [super viewDidLoad];
    
    LYCalendarPicker *picker = [[LYCalendarPicker alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, 0)];
    picker.delegate = self;
    [self.view addSubview:picker];
}

- (void)calenderBackYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day {
    
     NSLog(@"%ld年%ld月%ld日",year,month,day);
    
}
```
### 效果图
![](https://github.com/liuyik/SummaryExperiences/blob/master/效果图/日历.png
)

