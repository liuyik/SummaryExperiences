//
//  BaiduMapController.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/7/27.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "BaiduMapController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件


#import "JSONKit.h"

#import "MeiTuanMapController.h"

// 运动结点信息类
@interface BMKSportNode : NSObject

//经纬度
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//方向（角度）
@property (nonatomic, assign) CGFloat angle;
//距离
@property (nonatomic, assign) CGFloat distance;
//速度
@property (nonatomic, assign) CGFloat speed;

@end

@implementation BMKSportNode

@synthesize coordinate = _coordinate;
@synthesize angle = _angle;
@synthesize distance = _distance;
@synthesize speed = _speed;

@end

// 自定义BMKAnnotationView，用于显示运动者
@interface SportAnnotationView : BMKAnnotationView

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SportAnnotationView

@synthesize imageView = _imageView;

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBounds:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 22.f, 22.f)];
        _imageView.image = [UIImage imageNamed:@"sportarrow.png"];
        [self addSubview:_imageView];
    }
    return self;
}

@end



@interface BaiduMapController ()<BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView;
@end

@implementation BaiduMapController {
    
    BMKPolygon *pathPloygon;
    BMKPointAnnotation *sportAnnotation;
    SportAnnotationView *sportAnnotationView;
    
    NSMutableArray *sportNodes;//轨迹点
    NSInteger sportNodeNum;//轨迹点数
    NSInteger currentIndex;//当前结点
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.view = _mapView;
    
    _mapView.zoomLevel = 19;
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(40.056898, 116.307626);
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
    //初始化轨迹点
    [self initSportNodes];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 80, 250, 30);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"跳到仿美团地址检索界面" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonAction:(UIButton *)btn {
    MeiTuanMapController *mt = [[MeiTuanMapController alloc]init];
    [self.navigationController pushViewController:mt animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

//初始化轨迹点
- (void)initSportNodes {
    sportNodes = [[NSMutableArray alloc] init];
    //读取数据
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sport_path" ofType:@"json"]];
    if (jsonData) {
        NSArray *array = [jsonData objectFromJSONData];
        for (NSDictionary *dic in array) {
            BMKSportNode *sportNode = [[BMKSportNode alloc] init];
            sportNode.coordinate = CLLocationCoordinate2DMake([dic[@"lat"] doubleValue], [dic[@"lon"] doubleValue]);
            sportNode.angle = [dic[@"angle"] doubleValue];
            sportNode.distance = [dic[@"distance"] doubleValue];
            sportNode.speed = [dic[@"speed"] doubleValue];
            [sportNodes addObject:sportNode];
        }
    }
    sportNodeNum = sportNodes.count;
}

//开始
- (void)start {
    CLLocationCoordinate2D paths[sportNodeNum];
    for (NSInteger i = 0; i < sportNodeNum; i++) {
        BMKSportNode *node = sportNodes[i];
        paths[i] = node.coordinate;
    }
    
    pathPloygon = [BMKPolygon polygonWithCoordinates:paths count:sportNodeNum];
    [_mapView addOverlay:pathPloygon];
    
    sportAnnotation = [[BMKPointAnnotation alloc]init];
    sportAnnotation.coordinate = paths[0];
    sportAnnotation.title = @"test";
    [_mapView addAnnotation:sportAnnotation];
    currentIndex = 0;
}

//runing
- (void)running {
    BMKSportNode *node = [sportNodes objectAtIndex:currentIndex % sportNodeNum];
    sportAnnotationView.imageView.transform = CGAffineTransformMakeRotation(node.angle);
    [UIView animateWithDuration:node.distance/node.speed animations:^{
        currentIndex++;
        BMKSportNode *node = [sportNodes objectAtIndex:currentIndex % sportNodeNum];
        sportAnnotation.coordinate = node.coordinate;
    } completion:^(BOOL finished) {
        [self running];
    }];
    
    
}

#pragma mark - BMKMapViewDelegate

- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    [self start];
}

//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0.5 blue:0.0 alpha:0.6];
        polygonView.lineWidth = 3.0;
        return polygonView;
    }
    return nil;
}


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (sportAnnotationView == nil) {
        sportAnnotationView = [[SportAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"sportsAnnotation"];
        
        
        sportAnnotationView.draggable = NO;
        BMKSportNode *node = [sportNodes firstObject];
        sportAnnotationView.imageView.transform = CGAffineTransformMakeRotation(node.angle);
        
    }
    return sportAnnotationView;
}

- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    [self running];
}


@end
