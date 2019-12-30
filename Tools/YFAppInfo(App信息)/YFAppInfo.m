//
//  YFAppInfo.m
//  YFTools
//
//  Created by yf on 2019/11/22.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFAppInfo.h"

@implementation YFAppInfo

+ (NSDictionary *)appInfo{
    NSDictionary *info =  [[NSBundle mainBundle] infoDictionary];
    return info ;
}

///获取当前版本号
+ (NSString *)currentAppVersion{
    return  [YFAppInfo appInfo][@"CFBundleShortVersionString"];
}

+ (NSString *)appName{
    return [YFAppInfo appInfo][@"CFBundleName"] ;
}

+ (NSString *)appShortVersion{
    return [YFAppInfo appInfo][@"CFBundleShortVersionString"] ;
}



@end

