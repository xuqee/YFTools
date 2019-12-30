//
//  RouteNaviHelper.m
//  QYSanitation
//
//  Created by yf on 2019/11/18.
//  Copyright © 2019 YUEFENG. All rights reserved.
//

#import "YFRouteNaviHelper.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

static const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;

@implementation YFRouteNaviHelper

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (CLLocationCoordinate2D) bd_decryptGGCoor:(CLLocationCoordinate2D)gg_Coor{
    double x = gg_Coor.longitude,  y = gg_Coor.latitude;
    return [YFRouteNaviHelper bd_decrypt:y gg_lon:x];
}

+(CLLocationCoordinate2D) bd_decrypt:(double)gg_lat gg_lon:(double)gg_lon{
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);

    CLLocationCoordinate2D bdCoor = CLLocationCoordinate2DMake(z * sin(theta)+0.006, z * cos(theta)+0.0065);
    
    return bdCoor;
}

+ (CLLocationCoordinate2D) bd_decryptBdCoor:(CLLocationCoordinate2D)bd_Coor{
    double x = bd_Coor.longitude,  y = bd_Coor.latitude;
    return [YFRouteNaviHelper bd_decrypt:y bd_lon:x  ];
}

+(CLLocationCoordinate2D) bd_decrypt:(double)bd_lat bd_lon:(double)bd_lon{
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CLLocationCoordinate2D ggCoor = CLLocationCoordinate2DMake(z * sin(theta), z * cos(theta));
    return ggCoor;
}


+ (void)baiduNaviWithStart:(CLLocationCoordinate2D)startCoor endCoor:(CLLocationCoordinate2D)endCoor presentSourceController:(UIViewController *)presentSourceController scheme:(NSString *)scheme{
  
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"\"%@\"想要打开\"百度地图\"",kAppName]  message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            BMKPlanNode *startNode = [[BMKPlanNode alloc ] init];
            startNode.pt = startCoor ;
            BMKPlanNode *endNode = [[BMKPlanNode alloc] init];
            endNode.pt = endCoor ;
            BMKNaviPara *para = [[BMKNaviPara alloc] init ];
            para.startPoint = startNode ;
            para.endPoint = endNode ;
                   // para.naviType = BMK_NAVI_TYPE_NATIVE ;
            para.appScheme = scheme;
            [BMKNavigation  openBaiduMapNavigation:para] ;
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [presentSourceController presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"即将前往APP Store下载\"百度地图\"？"]  message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            /*百度app链接地址*/
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kBNAVI_APP_STORE_URL] options:@{} completionHandler:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [presentSourceController presentViewController:alert animated:YES completion:nil];
    }
}

+ (void)ggNaviWithEndCoor:(CLLocationCoordinate2D)endCoor presentSourceController:(UIViewController *)presentSourceController fromScheme:(NSString*)scheme{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSString * urlScheme = scheme ;
        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",kAppName,urlScheme,endCoor.latitude, endCoor.longitude];
        [[UIApplication  sharedApplication ] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"即将前往APP Store下载\"高德地图\"？"]  message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"下载" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            /*百度app链接地址*/
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kGMap_APP_STORE_URL] options:@{} completionHandler:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [presentSourceController presentViewController:alert animated:YES completion:nil];
    }
}

+ (void)appleNaviWithEndCoor:(CLLocationCoordinate2D)endCoor{
    //用户位置
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    //终点位置
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:endCoor addressDictionary:nil] ];
    
    NSArray *items = @[currentLoc,toLocation];
    //第一个
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };
    //第二个，都可以用
    //    NSDictionary * dic = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
    //                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]};
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}


@end

