# SummaryExperiences

## 目录
* [日历](#日历)
* [树状图](#树状图)
* [购物车](#购物车)
自己用的框架总结下。

## 日历
看过一些其它的日历控件，感觉还是自己写个，后面用时自己也好改。

### 效果图
![](https://github.com/liuyik/SummaryExperiences/blob/master/效果图/日历.png
)

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

## 树状图

使用第三方[RATreeView](https://github.com/Augustyniak/RATreeView)实现折叠效果

### 效果图
![](https://github.com/liuyik/SummaryExperiences/blob/master/效果图/树状图.png
)

### 用法
1、先pod [RATreeView](https://github.com/Augustyniak/RATreeView)

2、创建个数据模型,这个数据模型必须有一个子节点数组属性：

```
@interface TreeModel : NSObject

@property (nonatomic, copy) NSString *orgName;//机构名

@property (nonatomic, strong) NSArray *cDtoList;//子机构列表

//初始化一个model
+ (id)dataObjectWithDic:(NSDictionary *)treeDic;

@end
```
3、创建cell：
```
@interface TreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;//图标
@property (weak, nonatomic) IBOutlet UILabel *titleLable;//标题
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidth;//图标离左边宽度的约束

//初始化Cell
+ (instancetype)treeViewCellWith:(RATreeView *)treeView;
//赋值
- (void)setCellBasicInfoWith:(NSString *)title level:(NSInteger)level children:(NSInteger )children;

@end
```
```
@implementation TreeCell
+ (instancetype)treeViewCellWith:(RATreeView *)treeView
{
    TreeCell *cell = [treeView dequeueReusableCellWithIdentifier:@"TreeCell"];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TreeCell" owner:nil options:nil] firstObject];
    }
    
    return cell;
}

- (void)setCellBasicInfoWith:(NSString *)title level:(NSInteger)level children:(NSInteger )children{
    
    //有子数组时显示图标
    if (children==0) {
        self.iconView.hidden = YES;
        
    }
    else { //否则不显示
        self.iconView.hidden = NO;
    }
    self.titleLable.text = title;
    //每一层的布局
    CGFloat left = 6+level*30;
    
    _leftWidth.constant = left;
    
}

@end
```
4、最后一步完成[RATreeView](https://github.com/Augustyniak/RATreeView)，它的用法和UITableView的用法类似：

```
RATreeView *ratreeView = [[RATreeView alloc] initWithFrame:[UIScreen mainScreen].bounds style:RATreeViewStylePlain];
    ratreeView.delegate = self;
    ratreeView.dataSource = self;
    
    self.view = ratreeView;
    self.view.backgroundColor = [UIColor whiteColor];
```

```
#pragma mark -----------delegate
//返回行高
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item {
    return 44;
}
//将要展开
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item {
    TreeCell *cell = (TreeCell *)[treeView cellForItem:item];
    cell.iconView.highlighted = YES;
}
//将要收缩
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item {
    TreeCell *cell = (TreeCell *)[treeView cellForItem:item];
    cell.iconView.highlighted = NO;
}
//已经展开
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item {
    NSLog(@"已经展开了");
}
//已经收缩
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item {
    NSLog(@"已经收缩了");
}

//# dataSource方法

//返回cell
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    //获取cell
    TreeCell *cell = [TreeCell treeViewCellWith:treeView];
    
    //当前item
    TreeModel *model = item;
    //当前层级
    NSInteger level = [treeView levelForCellForItem:item];
    //赋值
    NSLog(@"几层%ld",level);
    cell.titleLable.text = model.orgName;
    [cell setCellBasicInfoWith:model.orgName level:level children:model.cDtoList.count];
    return cell;
}
/**
 *  必须实现
 *
 *  @param treeView treeView
 *  @param item    节点对应的item
 *
 *  @return  每一节点对应的个数
 */
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    TreeModel *model = item;
    if (item == nil) {
        
        return self.treeList.count;
    }
    
    return model.cDtoList.count;
}
/**
 *必须实现的dataSource方法
 *
 *  @param treeView treeView
 *  @param index    子节点的索引
 *  @param item     子节点索引对应的item
 *
 *  @return 返回 节点对应的item
 */
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    TreeModel *model = item;
    if (item==nil) {
        model = [TreeModel dataObjectWithDic:self.treeList[index]];
        return model;
    }
    
    NSDictionary *dic = model.cDtoList[index];
    model = [TreeModel dataObjectWithDic:dic];
    
    return model;
}
//cell的点击方法
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    //获取当前的层
    NSInteger level = [treeView levelForCellForItem:item];
    //当前点击的model
    TreeModel *model = item;
    if (model.cDtoList.count == 0) {
        
        NSLog(@"点击的是第%ld层,name=%@",level,model.orgName);
    }
}
//单元格是否可以编辑 默认是YES
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    return NO;
}
//编辑要实现的方法
- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item {
    NSLog(@"编辑了实现的方法");
}
```
## 购物车

### 效果图
![](https://github.com/liuyik/SummaryExperiences/blob/master/效果图/购物车.png
)

