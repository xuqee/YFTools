//
//  NSString+PinYin.m
//  YFTools
//
//  Created by yf on 2019/12/2.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "NSString+PinYin.h"
 
@implementation NSString (PinYin)

/**
 把汉字字符串转为拼音
 
 @param aString 汉字字符串
 @return 拼音字符串
 */
+ (NSString *)transformToPinyin:(NSString *)aString {
    
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [[NSMutableString alloc] init];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++)
    {
        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];
                //区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
        }
        [allString appendString:@","];
        count ++;
    }
    NSMutableString *initialStr = [[NSMutableString alloc] init];
    //拼音首字母
    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {
            [initialStr appendString:  [s substringToIndex:1]];
        }
    }
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",aString];
    return allString;
}

@end
