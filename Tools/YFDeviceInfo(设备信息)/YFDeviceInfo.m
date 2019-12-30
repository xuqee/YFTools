//
//  YFDeviceInfo.m
//  YFTools
//
//  Created by ggg on 2019/12/30.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFDeviceInfo.h"

@implementation YFDeviceInfo


///电池电量
+ (NSInteger)batteryLevel{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    NSInteger level = (NSInteger)([UIDevice currentDevice].batteryLevel*100) ;
    return level ;
}

@end
