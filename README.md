# SummaryExperiences

自己用的框架总结下。

## 目录
* [日历](#日历)
* [选择器](#选择器)
* [树状图](#树状图)
* [瀑布流](#瀑布流)
* [分类](#分类)
* [购物车](#购物车)
* [百度地图的集成](#百度地图的集成)
* [OC与JS交互](#OC与JS交互)

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
## 选择器

自己封装UIPickerView，根据枚举类型来进行选择，可以pod集成。
### 效果图
![](https://github.com/liuyik/SummaryExperiences/blob/master/效果图/选择器1.png
)![](https://github.com/liuyik/SummaryExperiences/blob/master/效果图/选择器2.png
)
### 用法

下载后拖入工程，或者用pod 安装
pod 'LYPickerChiceView' 
[下载地址：https://github.com/liuyik/LYPickerChiceView.git](https://github.com/liuyik/LYPickerChiceView.git)

```
//数据类型枚举
typedef NS_ENUM(NSInteger, DATATYPE) {
    LYPickerDataCustom,//自定义
    LYPickerDataGender,//性别
    LYPickerDataHeight,//身高
    LYPickerDataWeight,//体重
    LYPickerDataSalary,//工资
    LYPickerDataDete,//时间
    LYPickerDataArea//地点
};
```
```
//创建
_picker = [[LYPickerChiceView alloc] initWithFrame:self.view.bounds];
            _picker.dataType = LYPickerDataArea;
            _picker.delegate = self;
            [self.view addSubview:_picker];
//协议
- (void)PickerSelectorIndixInfo:(NSDictionary *)info {
    /*
     * 判断类型；
     * 时间类型字典的key为year、month、day；
     * 地点类型字典key为province、city、area；
     * 其他，字典key为：info；
     */    
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
## 瀑布流

自己封装的瀑布流，和标签横向的瀑布流：
### 效果图
![](https://github.com/liuyik/SummaryExperiences/blob/master/效果图/瀑布流.png
)
### 用法

继承UICollectionViewLayout,通过协议可以修改列数、每一列之间的间隙
每一行之间的间隙、边缘的间隙
```
#pragma mark - 瀑布流布局
- (void)waterLayoutView{
    LYWaterFlowLayout *layout = [[LYWaterFlowLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 375, self.view.bounds.size.height) collectionViewLayout:layout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;

    collectionView.backgroundColor = [UIColor whiteColor];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:collectionView];
}
#pragma mark - LYWaterFlowLayoutDelegate
- (CGFloat)waterFlow:(LYWaterFlowLayout *)waterFlow heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemW {

    return (arc4random() % 200);
}

//列数
- (CGFloat)columnCountWaterFlow:(LYWaterFlowLayout *)waterFlow {
    return 2;
}
//每一列之间的间隙
- (CGFloat)columnMarginWaterFlow:(LYWaterFlowLayout *)waterFlow {
    return 4;
}
//每一行之间的间隙
- (CGFloat)rowMarginWaterFlow:(LYWaterFlowLayout *)waterFlow {
    return 7;
}
//边缘的间隙
- (UIEdgeInsets)edgeInsetsWaterFlow:(LYWaterFlowLayout *)waterFlow {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
```
### 效果图
![](https://github.com/liuyik/SummaryExperiences/blob/master/效果图/横向瀑布流.png
)
### 用法

继承UICollectionViewLayout,通过协议可以修改每一行的高度、每一列之间的间隙
每一行之间的间隙、边缘的间隙
```
#pragma mark - 标签流水布局
- (void)leftLayoutView{
    LYLeftWaterAlignedLayout *layout = [[LYLeftWaterAlignedLayout alloc] init];
    layout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 375, self.view.bounds.size.height) collectionViewLayout:layout];
    
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    collectionView.backgroundColor = [UIColor whiteColor];
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    [self.view addSubview:collectionView];
}
#pragma mark - LYLeftWaterAlignedLayout
- (CGFloat)leftWaterAligned:(LYLeftWaterAlignedLayout *)waterFlow widthForItemAtIndexPath:(NSIndexPath *)indexPath {

    return arc4random()%200;
}
//每一行的高度
- (CGFloat)columnHeightWaterAligned:(LYLeftWaterAlignedLayout *)waterAligned {
    
    return 30;
}
//每一列之间的间隙
- (CGFloat)columnMarginWaterAligned:(LYLeftWaterAlignedLayout *)waterAligned {
    
    return 5;
}
//每一行之间的间隙
- (CGFloat)rowMarginWaterAligned:(LYLeftWaterAlignedLayout *)waterAligned {
    
    return 5;
}
//边缘的间隙
- (UIEdgeInsets)edgeInsetsWaterAligned:(LYLeftWaterAlignedLayout *)waterAligned {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

```
## 分类

### 效果图
![](https://github.com/liuyik/SummaryExperiences/blob/master/效果图/分类1.png
)![](https://github.com/liuyik/SummaryExperiences/blob/master/效果图/分类2.png
)

## 购物车

### 效果图
![](https://github.com/liuyik/SummaryExperiences/blob/master/效果图/购物车.png
)

 
## 百度地图的集成

### 效果图
![](https://github.com/liuyik/SummaryExperiences/blob/master/百度地图/.png
)

## OC与JS交互

### 效果图
![](https://github.com/liuyik/SummaryExperiences/blob/master/OCY与JS交互/.png
)
# 未完待续


