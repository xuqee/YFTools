//
//  NSString+PinYin.h
//  YFTools
//
//  Created by yf on 2019/12/2.
//  Copyright © 2019 QYHB. All rights reserved.
//
 
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (PinYin)

/**
 把汉字字符串转为拼音
 
 @param aString 汉字字符串
 @return 拼音字符串
 */
+ (NSString *)transformToPinyin:(NSString *)aString  ;

@end

NS_ASSUME_NONNULL_END
