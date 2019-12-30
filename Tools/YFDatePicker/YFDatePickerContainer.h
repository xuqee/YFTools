//
//  YFDatePickerContainer.h
//  YFTools
//
//  Created by yf on 2019/12/6.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFDatePickerContainer : UIView

+(instancetype)dateContainer ;

- (void)addMiniDate:(NSDate *__nullable)miniDate maxDate:(NSDate *__nullable)maxDate ;

- (void)showDate:(NSDate *)date ;

@property (nonatomic, copy) dispatch_block_t dismissBlock ;
@property (nonatomic, copy) void(^dateBlock)(NSDate *date);

@end

NS_ASSUME_NONNULL_END
