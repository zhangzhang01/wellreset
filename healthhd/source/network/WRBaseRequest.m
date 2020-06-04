//
//  WRBaseRequest.m
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "WRBaseRequest.h"
#import "AFNetworking.h"

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

+(void)post:(NSString *)strUrl params:(NSDictionary *)params result:(void (^)(id, NSError *))completion {
    [[self class] post:strUrl params:params result:completion timeoutInterval:10];
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
        manager.requestSerializer.timeoutInterval = 10.f;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
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