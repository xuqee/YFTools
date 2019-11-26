//
//  YFBMKMapViewCtrl.m
//  YFTools
//
//  Created by yf on 2019/11/20.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFBMKMapViewCtrl.h"

#import <Masonry.h>

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BMKLocationKit/BMKLocationComponent.h>


@interface YFBMKMapViewCtrl ()<BMKMapViewDelegate,BMKLocationManagerDelegate>

@property (nonatomic, strong)   BMKMapView *mapview ;
@property (nonatomic, strong)   BMKLocationManager *locationManager ;

@end

@implementation YFBMKMapViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mapview];
    [_mapview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view sendSubviewToBack:_mapview];
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     _mapview.delegate = self ;
    [_mapview viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _mapview.delegate = nil ;
    [_mapview viewWillDisappear];
}

#pragma mark --  BMKLocationManagerDelegate
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        return ;
    }
    if (location) {
        BMKUserLocation *userLocation = [[BMKUserLocation alloc] init];
        userLocation.location = location.location ;
        if (location.rgcData.poiList.count >0) {
            userLocation.title = location.rgcData.poiList.firstObject.name ;
            userLocation.subtitle = location.rgcData.poiList.firstObject.addr ;
        }
        [self.mapview updateLocationData:userLocation];
    }
}

#pragma mark -- BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView{
    NSLog(@"mapViewDidFinishLoading");
}

/**
 *点中底图空白处会回调此接口
 *@param mapView 地图View
 *@param coordinate 空白处坐标点的经纬度
 */
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    [self.view endEditing:YES ];
}

#pragma mark -- lazy
- (BMKMapView *)mapview{
   if (!_mapview) {
       BMKMapView *mapview  =  [[BMKMapView alloc] init];
       mapview.delegate = self ;
       mapview.zoomLevel = 17 ;
       mapview.rotateEnabled = NO ;
          
       CLLocationCoordinate2D coor = CLLocationCoordinate2DMake(39.915, 116.404);
       mapview.centerCoordinate = coor ;
       
       BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
       displayParam.isRotateAngleValid = NO;//跟随态旋转角度是否生效
       displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
       [mapview updateLocationViewWithParam:displayParam];
          
       mapview.showsUserLocation = YES ;
       mapview.userTrackingMode = BMKUserTrackingModeFollow ;
       mapview.isSelectedAnnotationViewFront = YES ;
       _mapview = mapview ;
   }
    return _mapview ;
}

- (BMKLocationManager *)locationManager{
    if (!_locationManager) {
        BMKLocationManager *manager = [[BMKLocationManager alloc] init];
        //设置delegate
        manager.delegate = self;
        //设置返回位置的坐标系类型
        manager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        //设置预期精度参数
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        //设置应用位置类型
        manager.activityType = CLActivityTypeAutomotiveNavigation;
        //设置是否自动停止位置更新
        manager.pausesLocationUpdatesAutomatically = NO;
        //设置是否允许后台定位
        //manager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间
        manager.locationTimeout = 10;
        //设置获取地址信息超时时间
        manager.reGeocodeTimeout = 10;
        manager.distanceFilter =  5 ;
        _locationManager = manager ;
    }
    return _locationManager ;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

