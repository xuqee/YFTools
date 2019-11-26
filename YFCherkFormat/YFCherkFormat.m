//
//  YFCherkFormat.m
//  YFTools
//
//  Created by yf on 2019/11/22.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFCherkFormat.h"

@implementation YFCherkFormat

+ (BOOL)isEmptyStr:(NSString *)str{
    
    if (str == nil || str == NULL || str == Nil ) {
        return YES ;
    }
    if ([str isEqualToString:@""] || [str isEqualToString:@"(null)"]) {
        return YES ;
    }
    
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO ;
}


@end
