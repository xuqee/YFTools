//
//  YFBMKGeoCodeReverseManager.h
//  YFTools
//
//  Created by yf on 2019/11/28.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFBMKGeoCodeReverseManager : NSObject

+ (instancetype)manager ;

- (void)addReverseWithIdentify:(NSString *)identify Coor:(CLLocationCoordinate2D)coor ;


@property (nonatomic, copy) void(^reverseSuccess)(void);

@end

NS_ASSUME_NONNULL_END
