//
//  RouteNaviHelper.h
//  QYSanitation
//
//  Created by yf on 2019/11/18.
//  Copyright © 2019 YUEFENG. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFRouteNaviHelper : UIView
//高德转百度
+ (CLLocationCoordinate2D) bd_decryptGGCoor:(CLLocationCoordinate2D)gg_Coor ;
+(CLLocationCoordinate2D) bd_decrypt:(double)gg_lat gg_lon:(double)gg_lon ;
//百度转高德
+ (CLLocationCoordinate2D) bd_decryptBdCoor:(CLLocationCoordinate2D)bd_Coor ;
+(CLLocationCoordinate2D) bd_decrypt:(double)bd_lat bd_lon:(double)bd_lon ;

//百度导航
+ (void)baiduNaviWithStart:(CLLocationCoordinate2D)startCoor endCoor:(CLLocationCoordinate2D)endCoor presentSourceController:(UIViewController *)presentSourceController scheme:(NSString *)scheme;
//高德导航
+ (void)ggNaviWithEndCoor:(CLLocationCoordinate2D)endCoor presentSourceController:(UIViewController *)presentSourceController fromScheme:(NSString *)scheme ;

//苹果导航
+ (void)appleNaviWithEndCoor:(CLLocationCoordinate2D)endCoor ;
 
@end

NS_ASSUME_NONNULL_END
