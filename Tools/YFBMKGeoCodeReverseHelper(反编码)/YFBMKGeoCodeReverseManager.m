//
//  YFBMKGeoCodeReverseManager.m
//  YFTools
//
//  Created by yf on 2019/11/28.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFBMKGeoCodeReverseManager.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface YFBMKGeoCodeReverseManager ()<BMKGeoCodeSearchDelegate>

@property (nonatomic, strong)   BMKGeoCodeSearch    *geoSearchService ;
@property (nonatomic, strong)   NSMutableArray      *reverseArr ;

@property (nonatomic, assign)   BOOL    isReversing ;

@end

@implementation YFBMKGeoCodeReverseManager

+ (instancetype)manager{
    static YFBMKGeoCodeReverseManager *manager ;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        manager = [[YFBMKGeoCodeReverseManager alloc] init] ;
    });
    return manager ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.reverseArr = [NSMutableArray array];
        [RACObserve(self, reverseArr) subscribeNext:^(id  _Nullable x) {
            [self beginReverse];
        }];
    }
    return self ;
}

- (void)dealloc{
    self.geoSearchService.delegate = nil ;
    self.geoSearchService = nil ;
}

- (void)addReverseWithIdentify:(NSString *)identify Coor:(CLLocationCoordinate2D)coor{
    
    @synchronized (_reverseArr) {
        NSDictionary *dic = @{@"identify":identify,
                                    @"coor": [NSValue valueWithMKCoordinate:coor]};
        [[self mutableArrayValueForKey:@"reverseArr"] addObject:dic];
    }
}

- (void)beginReverse{
    if (_reverseArr.count == 0 || self.isReversing == YES ) {
        return ;
    }
    self.isReversing = YES ;
    BMKReverseGeoCodeSearchOption *option = [[BMKReverseGeoCodeSearchOption alloc]init];
    NSDictionary *dic = _reverseArr.firstObject ;
    NSValue *value = [dic valueForKey:@"coor"];
    CLLocationCoordinate2D coor ;
    [value getValue:&coor];
    option.location = coor ;
    option.pageSize = 1 ;
    option.pageNum = 1 ;
    if ([self.geoSearchService reverseGeoCode:option]) {
        DLog(@"开始反编码");
    }else{
        DLog(@"反编码初始化失败");
        @synchronized (_reverseArr) {
            self.isReversing = NO ;
            [[NSNotificationCenter defaultCenter] postNotificationName:dic[@"identify"] object:@9999];
            [[self mutableArrayValueForKey:@"reverseArr"] removeObjectAtIndex:0];
        }
    }
}


#pragma  mark -- BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    //do something
    @synchronized (_reverseArr) {
        self.isReversing = NO ;
        if (_reverseArr.count ==0 ) {
            return ;
        }
        NSDictionary *dic = _reverseArr.firstObject ;
        if (result) {
            NSString *address = (result.poiList.count > 0 )? result.poiList.firstObject.name : result.address ;
            [[NSNotificationCenter defaultCenter] postNotificationName:dic[@"identify"] object:address]; 
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:dic[@"identify"] object:@(error)];
        }
        [[self mutableArrayValueForKey:@"reverseArr"] removeObjectAtIndex:0];
    }

}

- (BMKGeoCodeSearch *)geoSearchService{
    if (!_geoSearchService) {
        BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc] init ];
        search.delegate = self ;
        _geoSearchService = search ;
    }
    return _geoSearchService ;
}

@end
