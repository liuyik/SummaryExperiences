//
//  MeiTuanMapController.m
//  SummaryExperiences
//
//  Created by 刘毅 on 2017/7/28.
//  Copyright © 2017年 刘毅. All rights reserved.
//

#import "MeiTuanMapController.h"
#import "RoiResultListView.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface MeiTuanMapController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate> {
    BMKGeoCodeSearch* _geocodesearch;
    UIImageView *_poiView;
    BMKLocationService* _locService;//定位
}

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) RoiResultListView *resultListView;
@end

@implementation MeiTuanMapController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.view.backgroundColor = [UIColor whiteColor];
    
    _geocodesearch = [[BMKGeoCodeSearch alloc] init];
    //初始化mapView
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 300)];
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.zoomLevel = 19.5;
    [self.view addSubview:self.mapView];
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = false;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;//精度圈是否显示
    [_mapView updateLocationViewWithParam:displayParam];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //设置定位精度
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationDistance distance = 10.0;
    _locService.distanceFilter = distance;
    
    [_locService startUserLocationService];
    
    
    UIImageView *poiView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"poi"]];
    poiView.frame = CGRectMake(0, 0, 40, 40);
    poiView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 150 - 20);
    [self.mapView addSubview:poiView];
    _poiView = poiView;
    
    UIButton *getLocationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getLocationBtn.frame = CGRectMake(5, _mapView.frame.size.height - 55, 40, 40);
    [getLocationBtn setBackgroundImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    [getLocationBtn addTarget:self action:@selector(currentAddressMsg:) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:getLocationBtn];
    
    
    _resultListView = [[RoiResultListView alloc] initWithFrame:CGRectMake(0, _mapView.bottom, KScreenWidth, KScreenHeight-_mapView.height-64)];
    [self.view addSubview:_resultListView];
    
    __weak typeof(self) weakSelf = self;
    [_resultListView setPoiListBlock:^(PoiModel *model) {
        
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){model.lat,model.lon};
        [weakSelf.mapView setCenterCoordinate:pt animated:YES];
    }];

    
}

- (void)initLocationService {
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //设置定位精度
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationDistance distance = 10.0;
    _locService.distanceFilter = distance;
     [_locService startUserLocationService];
}
//定位
- (void)currentAddressMsg:(UIButton *)sender{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //设置定位精度
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    CLLocationDistance distance = 10.0;
    _locService.distanceFilter = distance;
    [_locService startUserLocationService];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    static NSString *pinID = @"pinID";
    // 从缓存池取出大头针数据视图
    BMKAnnotationView *customView = [mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
    // 如果取出的为nil , 那么就手动创建大头针视图
    if (customView == nil) {
        customView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinID];
    }
    // 1. 设置大头针图片
    customView.image = [UIImage imageNamed:@"point"];
    // 2. 设置弹框
    customView.canShowCallout = YES;
    
    return customView;
}

/**
 *地图区域改变完成后会调用此接口
 *@param mapView 地图View
 *@param animated 是否动画
 */
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"%lf -------  %lf",mapView.centerCoordinate.latitude,mapView.centerCoordinate.longitude);
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        _poiView.center = CGPointMake(KScreenWidth/2, 150 - 35);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            _poiView.center = CGPointMake(KScreenWidth/2, 150 - 20);
        } completion:nil];
        
    }];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送成功");
    }

}


/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"%@",userLocation.location);
    
    [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        _poiView.center = CGPointMake(KScreenWidth/2, 150 - 35);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            _poiView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 150 - 20);
        } completion:nil];
        
    }];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
    NSString *s = flag?@"反geo检索发送成功":@"反geo检索发送失败";
    NSLog(@"%@",s);
   
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [_locService stopUserLocationService];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"定位失败error%@",error);
}
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < result.poiList.count; i++) {
            BMKPoiInfo* poi = [result.poiList objectAtIndex:i];
            PoiModel *model = [[PoiModel alloc]init];
            model.name = poi.name;
            model.city = poi.city;
            model.address = poi.address;
            model.lat = poi.pt.latitude;
            model.lon = poi.pt.longitude;
            [array addObject:model];
        }
//        self.poiResultArray = [NSArray arrayWithArray:array];
//        self.poiResultVC.resultListArray = [NSArray arrayWithArray:array];
        _resultListView.data = array;
        [_resultListView reloadData];
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}


/**
 管理百度地图的生命周期
 */
- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geocodesearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _geocodesearch.delegate = nil;
}


@end
