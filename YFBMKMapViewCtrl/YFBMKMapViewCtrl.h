//
//  YFBMKMapViewCtrl.h
//  YFTools
//
//  Created by yf on 2019/11/20.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFBaseViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BMKLocationKit/BMKLocationComponent.h>
NS_ASSUME_NONNULL_BEGIN

@interface YFBMKMapViewCtrl : YFBaseViewController
 
@property (nonatomic, strong)   BMKMapView *mapview ;

@property (nonatomic, strong)   BMKUserLocation *userLocation ;

- (void)beginLocation ;

@end

NS_ASSUME_NONNULL_END
