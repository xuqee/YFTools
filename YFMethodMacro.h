//
//  YFMethodMacro.h
//  YFTools
//
//  Created by yf on 2019/11/22.
//  Copyright © 2019 QYHB. All rights reserved.
//

#ifndef YFMethodMacro_h
#define YFMethodMacro_h

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define kIntegerValue(Str)    [Str integerValue]
#define kFloatValue(Str)      [Str floatValue]
#define kBoolValue(Str)       [Str boolValue];

#define RGB(r,g,b)              [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:1]
#define RGBA(r,g,b,a)           [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]
 


#endif /* YFMethodMacro_h */
