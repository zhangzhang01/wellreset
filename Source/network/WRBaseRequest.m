//
//  WRBaseRequest.m
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "WRBaseRequest.h"
#import "AFNetworking.h"
#import <YYKit/YYKit.h>
@interface WRBaseRequest ()
{
    NSInteger _tag;
    NSURLConnection *_urlConnection;
}
@end

@implementation WRBaseRequest

+(YYMemoryCache*)networkCache {
    static YYMemoryCache* cache = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        cache = [[YYMemoryCache alloc] init];
    });
    return cache;
}

+(void)clearCache
{
    [[self networkCache] removeAllObjects];
}

+(void)post:(NSString*)strUrl params:(NSDictionary*)params result:(void (^)(id, NSError *))completion timeoutInterval:(NSTimeInterval)timeoutInterval
{
    NSLog(@"POST %@", strUrl);
    NSLog(@"Params %@", params.description);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:strUrl parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(completion)
        {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        if(completion)
        {
            completion(nil, error);
        }
    }];
     
    /*
    NSURLSessionDataTask *task = [manager POST:strUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(completion)
        {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.localizedDescription);
        if(completion)
        {
            completion(nil, error);
        }
    }];
    [task resume];
    */
}


+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server2" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
   
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    // 是否在证书域字段中验证域名
    
    manager.securityPolicy = securityPolicy;
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

+(void)post:(NSString *)strUrl params:(NSDictionary *)params result:(void (^)(id, NSError *))completion {
    [[self class] post:strUrl params:params result:completion timeoutInterval:30];
}

+(void)postImage:(NSString *)strUrl params:(NSDictionary *)params imageData:(NSData *)imageData result:(void (^)(id, NSError *))completion
{
    if([strUrl rangeOfString:@"piwik"].location == NSNotFound) {
        NSLog(@"POST image %@", strUrl);
    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    [manager setSecurityPolicy:[WRBaseRequest customSecurityPolicy]];
    NSURLSessionDataTask *task = [manager POST:strUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"image.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(completion)
        {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if([strUrl rangeOfString:@"piwik"].location == NSNotFound) {
            NSLog(@"%@", error.localizedDescription);
        }
        
        if(completion)
        {
            completion(nil, error);
        }
    }];
    [task resume];
}


+(void)request:(NSString *)url shouldUseCache:(BOOL)shouldUseCache result:(void (^)(id, NSError *))completion
{
    if([url rangeOfString:@"piwik"].location == NSNotFound) {
        NSLog(@"GET %@", url);
    }
#if DEBUG
    shouldUseCache = NO;
#endif
    NSObject *rspData = nil;
    if(shouldUseCache)
    {
        rspData = (NSObject*)[[WRBaseRequest networkCache] objectForKey:url];
    }
    if(rspData)
    {
        NSLog(@"HTTP GET from cache");
        completion(rspData, nil);
    }
    else
    {
        NSString *strUrl = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 30.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
         [manager setSecurityPolicy:[WRBaseRequest customSecurityPolicy]];
        
        NSURLSessionDataTask *task = [manager GET:strUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [[WRBaseRequest networkCache] setObject:responseObject forKey:url];
            if(completion)
            {
                completion(responseObject, nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if(completion)
            {
                if([url rangeOfString:@"piwik"].location == NSNotFound) {
                    NSLog(@"%@ %@", url, [error localizedDescription]);
                }
                NSError *networkError = [NSError errorWithDomain:NSLocalizedString(@"请求失败", nil) code:-1 userInfo:nil];
                completion(nil, networkError);
            }
        }];
        [task resume];
    }
}


+(void)syncRequest:(NSString*)url shouldUseCache:(BOOL)shouldUseCache result:(void (^)(NSString *, NSError *))completion
{
    NSLog(@"syncRequest %@", url);
    NSString *strData = nil;
    if(shouldUseCache)
    {
        strData = (NSString*)[[WRBaseRequest networkCache] objectForKey:url];
    }
    if(strData)
    {
        completion(strData, nil);
    }
    else
    {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
        NSError *error = nil;
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if(received)
        {
            NSString *strResponse = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
            NSLog(@"%@", strResponse);
            if (shouldUseCache) {
                [[WRBaseRequest networkCache] setObject:strResponse forKey:url];
            }
            if(completion)
            {
                completion(strResponse, nil);
            }
        }
        else
        {
            if(!error)
            {
                error = [NSError errorWithDomain:@"未知错误" code:-1 userInfo:nil];
            }
            if(completion)
            {
                completion(nil, error);
            }
        }
    }
}
@end
