//
//  UIButton+MultiAction.m
//  YFTools
//
//  Created by yf on 2019/12/5.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "UIButton+MultiAction.h"
 
#define kAcceptEventInterval 1

@implementation UIButton (MultiAction)
 
// 在load时执行hook
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         Method before   = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
         Method after    = class_getInstanceMethod(self, @selector(mySendAction:to:forEvent:));
        BOOL overrideSuccess = class_addMethod(self, before, method_getImplementation(after), method_getTypeEncoding(after));
        
        //如果添加成功
        if (overrideSuccess) {
            //自定义函数名执行系统函数
            class_replaceMethod(self, after, method_getImplementation(before), method_getTypeEncoding(before));
        } else {
            method_exchangeImplementations(before, after);
        }
    });
}


static const char *UIControl_acceptEventTime = "UIControl_acceptEventTime";

- (NSTimeInterval)acceptEventTime {
    return  [objc_getAssociatedObject(self, UIControl_acceptEventTime) doubleValue];
}

- (void)setAcceptEventTime:(NSTimeInterval)acceptEventTime {
    objc_setAssociatedObject(self, UIControl_acceptEventTime, @(acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
     
    if ([self isKindOfClass:[UIButton class]]) {
        if ([NSDate date].timeIntervalSince1970 - self.acceptEventTime < kAcceptEventInterval) {
             return;
         }
         self.acceptEventTime = [NSDate date].timeIntervalSince1970;
    }

    [self mySendAction:action to:target forEvent:event];
}
@end
