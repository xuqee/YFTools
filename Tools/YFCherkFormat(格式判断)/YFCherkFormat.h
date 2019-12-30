//
//  YFCherkFormat.h
//  YFTools
//
//  Created by yf on 2019/11/22.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <Foundation/Foundation.h>

#define isEmptyStr(str)  [YFCherkFormat isEmptyStr:str]

NS_ASSUME_NONNULL_BEGIN

@interface YFCherkFormat : NSObject


+ (BOOL)isEmptyStr:(NSString *)str ;

@end

NS_ASSUME_NONNULL_END
