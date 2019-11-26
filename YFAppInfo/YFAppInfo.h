//
//  YFAppInfo.h
//  YFTools
//
//  Created by yf on 2019/11/22.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAppVersion             [YFAppInfo currentAppVersion]
#define kAppName                 [YFAppInfo appName]
#define kAppShortVersion       [YFAppInfo appShortVersion]

NS_ASSUME_NONNULL_BEGIN

@interface YFAppInfo : NSObject

///获取当前版本号
+ (NSString *)currentAppVersion ;

+ (NSString *)appName ;

+ (NSString *)appShortVersion ;

@end

NS_ASSUME_NONNULL_END
