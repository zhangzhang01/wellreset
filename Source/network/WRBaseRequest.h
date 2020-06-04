//
//  WRBaseRequest.h
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WRBaseRequest : NSObject

+(void)post:(NSString*)strUrl params:(NSDictionary*)params result:(void (^)(id responseObject, NSError* error))completion;
+(void)postImage:(NSString*)strUrl params:(NSDictionary*)params imageData:(NSData*)imageData result:(void (^)(id responseObject, NSError* error))completion;
+(void)request:(NSString*)url shouldUseCache:(BOOL)shouldUseCache result:(void (^)(id responseObject, NSError* error))completion;
+(void)syncRequest:(NSString*)url shouldUseCache:(BOOL)shouldUseCache result:(void (^)(NSString *responseString, NSError* error))completion;
+(void)clearCache;
+ (AFSecurityPolicy*)customSecurityPolicy;
+(void)post:(NSString*)strUrl params:(NSDictionary*)params result:(void (^)(id responseObject, NSError* error))completion timeoutInterval:(NSTimeInterval)timeoutInterval;


@end
