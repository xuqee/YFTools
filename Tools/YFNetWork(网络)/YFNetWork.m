//
//  YFNetWork.m
//  YFTools
//
//  Created by yf on 2019/11/22.
//  Copyright © 2019 QYHB. All rights reserved.
//

#import "YFNetWork.h"
#import "YFNetWorkingCacheManager.h"


static NSMutableDictionary *httpTasks;

@interface YFNetWork ()
 


@end

@implementation YFNetWork

+ (instancetype)shareManager {
    static YFNetWork *instance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YFNetWork alloc] init] ;
    });
    return instance ;
}

- (instancetype)init{
    self = [super init ];
    if (self) {
        [self startMonitoringNetwork] ;
    }
    return self ;
}


#pragma mark -- request

+ (NSURLSessionTask *)POST:(NSString *)URL
                    params:(NSDictionary *  )params
                  progress:( HttpRequestProgress) progress
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailure)failure{
    
    return [YFNetWork POST:URL params:params  progress:progress success:success failure:failure cache:nil];
}

+ (NSURLSessionTask *)POST:(NSString *)URL
                    params:(NSDictionary *)params
                  progress:(HttpRequestProgress) progress
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailure)failure
                     cache:(nullable HttpRequestCache)cache{
    
    return [YFNetWork POST:URL params:params timeIntervarl:30 progress:progress success:success failure:failure cache:cache];
}
 
+ (NSURLSessionTask *)POST:(NSString *)URL
                    params:(NSDictionary *)params
             timeIntervarl:(NSTimeInterval )timeIntervarl
                  progress:(HttpRequestProgress) progress
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailure)failure
                     cache:(nullable HttpRequestCache)cache{
    //读取缓存
    cache?cache([YFNetWorkingCacheManager getResponseCacheForKey:URL]):nil;
    
    AFHTTPSessionManager *manager = [self sessionManager];
    manager.requestSerializer.timeoutInterval = timeIntervarl ;
    __weak typeof(self) ws = self ;
    NSString *url = [NSString stringWithFormat:@"%@?",URL] ;
    for (NSString *key in [params allKeys]) {
        url = [url stringByAppendingFormat:@"&%@=%@",key,params[@"key"]];
    }
    NSURLSessionTask *task =  [manager POST:URL parameters:params progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(task ,responseObject) : nil ;
        //对数据进行异步缓存
        cache ? [YFNetWorkingCacheManager saveResponseCache:responseObject forKey:URL] : nil ;
        [[ws httpTasks] removeObjectForKey:URL];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(task,error) : nil ;
        [[ws httpTasks] removeObjectForKey:URL];
    }];
    [[ws httpTasks] setObject:task forKey:URL];
    return task ;
}


+ (NSURLSessionTask *)GET:(NSString *)URL
                    params:(NSDictionary *)params
                  progress:(HttpRequestProgress) progress
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailure)failure{
    
    return [YFNetWork GET:URL params:params  progress:progress success:success failure:failure cache:nil];
}

+ (NSURLSessionTask *)GET:(NSString *)URL
                    params:(NSDictionary *)params
                  progress:(HttpRequestProgress) progress
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailure)failure
                     cache:(nullable HttpRequestCache)cache{
    
    return [YFNetWork GET:URL params:params timeIntervarl:30 progress:progress success:success failure:failure cache:cache];
}

+ (NSURLSessionTask *)GET:(NSString *)URL
                    params:(NSDictionary *)params
             timeIntervarl:(NSTimeInterval )timeIntervarl
                  progress:(HttpRequestProgress) progress
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailure)failure
                     cache:(nullable HttpRequestCache)cache{
    //读取缓存
    cache?cache([YFNetWorkingCacheManager getResponseCacheForKey:URL]):nil;
    
    AFHTTPSessionManager *manager = [self sessionManager];
    manager.requestSerializer.timeoutInterval = timeIntervarl ;
    __weak typeof(self) ws = self ;
    NSURLSessionTask *task = [manager GET:URL parameters:params progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success ? success(task ,responseObject) : nil ;
        //对数据进行异步缓存
        cache ? [YFNetWorkingCacheManager saveResponseCache:responseObject forKey:URL] : nil ;
        [[ws httpTasks] removeObjectForKey:URL];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(task,error) : nil ;
        [ws.httpTasks removeObjectForKey:URL];
    }];
    [[self httpTasks] setObject:task forKey:URL];
    return task ;
}

#pragma mark -- lazy
+ (AFHTTPSessionManager *)sessionManager{
    static AFHTTPSessionManager *manager ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        manager.operationQueue.maxConcurrentOperationCount = 5 ;
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 30 ;
               /*! 这里是去掉了键值对里空对象的键值 */
        manager.responseSerializer  = responseSerializer ;
        responseSerializer.removesKeysWithNullValues = YES;
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
      
/*! https 参数配置 */
/*!
 采用默认的defaultPolicy就可以了. AFN默认的securityPolicy就是它, 不必另写代码. AFSecurityPolicy类中会调用苹果security.framework的机制去自行验证本次请求服务端放回的证书是否是经过正规签名.
 */
//        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
//        securityPolicy.allowInvalidCertificates = YES;
//        securityPolicy.validatesDomainName = NO;
//        manager.securityPolicy = securityPolicy;

        //! 自定义的CA证书配置如下：
        //! 自定义security policy, 先前确保你的自定义CA证书已放入工程Bundle
        /*!
         https:api.github.com网址的证书实际上是正规CADigiCert签发的, 这里把Charles的CA根证书导入系统并设为信任后, 把Charles设为该网址的SSL Proxy (相当于"中间人"), 这样通过代理访问服务器返回将是由Charles伪CA签发的证书.
         */
//                NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
//                AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
//                policy.allowInvalidCertificates = YES;
//                manager.securityPolicy = policy;

        //! 如果服务端使用的是正规CA签发的证书, 那么以下几行就可去掉:
//                NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
//                AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
//                policy.allowInvalidCertificates = YES;
//                manager.securityPolicy = policy;
        
    });
    return manager ;
}


+ (NSMutableDictionary *)httpTasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DLog(@"创建任务数组");
        httpTasks = [[NSMutableDictionary alloc] init];
    });
    return httpTasks;
}



#pragma mark - 开始监听网络
- (void)startMonitoringNetwork{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        if (self.netWorkStatusBlock ) {
            self.netWorkStatusBlock(status) ;
        }
        switch (status){
            case AFNetworkReachabilityStatusUnknown:
                DLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                DLog(@"无网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DLog(@"WIFI");
                break;
        }
    }];
    [manager startMonitoring];
}



@end
