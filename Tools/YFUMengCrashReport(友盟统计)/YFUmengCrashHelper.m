//
//  YFUmengCrashHelper.m
//  YFTools
//
//  Created by ggg on 2020/1/2.
//  Copyright © 2020 QYHB. All rights reserved.
//

#import "YFUmengCrashHelper.h"

@implementation YFUmengCrashHelper

+ (void)addUMENGSettingsWithAppKey:(NSString *)appKey{
#ifdef DEBUG
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
#else
    [UMConfigure setEncryptEnabled:YES];//打开加密传输
    [UMConfigure initWithAppkey:appKey channel:@"App Store"];
    [MobClick setCrashReportEnabled:YES];
#endif
}

////测试奔溃定位 通过 “image lookup -address 可能的地址” 命令去定位可能崩溃的地方
//NSException *exception = [NSException exceptionWithName:@"异常" reason:@"崩溃吧孩子" userInfo:@{@"Hello":@"World"}];
//  @throw exception ;
static void uncaughtExceptionHandler(NSException *exception) {
    DLog(@"%@\n%@", exception, [exception callStackSymbols]);
}


@end
