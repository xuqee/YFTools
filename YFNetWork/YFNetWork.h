//
//  YFNetWork.h
//  YFTools
//
//  Created by yf on 2019/11/22.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HttpRequestProgress)(NSProgress * _Nonnull progress);

typedef void(^HttpRequestSuccess)(NSURLSessionTask *_Nonnull task , id _Nullable responseObject);

typedef void(^HttpRequestFailure)(NSURLSessionTask *_Nonnull task , NSError *_Nullable error);

typedef void(^HttpRequestCache)(id responseCache);

@interface YFNetWork : NSObject

+ (instancetype)shareManager ;
 
@property (nonatomic, copy)  void(^netWorkStatusBlock)(AFNetworkReachabilityStatus status);
 
+ (NSURLSessionTask *)POST:(NSString *)URL
                    params:(NSDictionary *)params
                  progress:(nullable HttpRequestProgress) progress
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailure)failure ;

+ (NSURLSessionTask *)POST:(NSString *)URL
                    params:(NSDictionary *)params
                  progress:(nullable HttpRequestProgress) progress
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailure)failure
                     cache:(nullable HttpRequestCache)cache;

+ (NSURLSessionTask *)POST:(NSString *)URL
                    params:(NSDictionary *)params
             timeIntervarl:(NSTimeInterval )timeIntervarl
                  progress:(nullable HttpRequestProgress) progress
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailure)failure
                     cache:(nullable HttpRequestCache)cache;


#pragma mark -- GET
+ (NSURLSessionTask *)GET:(NSString *)URL
                   params:(NSDictionary *)params
                 progress:(nullable HttpRequestProgress) progress
                  success:(HttpRequestSuccess)success
                  failure:(HttpRequestFailure)failure ;

 + (NSURLSessionTask *)GET:(NSString *)URL
                     params:(NSDictionary *)params
                   progress:(nullable HttpRequestProgress) progress
                    success:(HttpRequestSuccess)success
                    failure:(HttpRequestFailure)failure
                      cache:(nullable HttpRequestCache)cache;


+ (NSURLSessionTask *)GET:(NSString *)URL
                   params:(NSDictionary *)params
            timeIntervarl:(NSTimeInterval )timeIntervarl
                 progress:(nullable HttpRequestProgress) progress
                  success:(HttpRequestSuccess)success
                  failure:(HttpRequestFailure)failure
                    cache:(nullable HttpRequestCache)cache ;

@end

NS_ASSUME_NONNULL_END
