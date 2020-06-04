//
//  WRViewModel.h
//
//
//  Created by Matech on 16/2/17.
//  Copyright © 2016年 X.H. All rights reserved.
//

#import "WRNetworkService.h"
#import "WRBaseRequest.h"
#import "WRJsonParser.h"
#import "WRObject.h"
#import "WRUserInfo.h"
#import "RehabObject.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CommonFunBlock)();
typedef void(^ViewModeLoadCompleteBlock)(NSError* error);

@interface WRViewModel : NSObject

@property(nonatomic, copy, nullable)CommonFunBlock loadingBlock;
@property(nonatomic, copy, nullable)CommonFunBlock loadedBlock;
@property(nonatomic, copy, nullable)ViewModeLoadCompleteBlock loadDataCompleteBlock;

+(nonnull NSError*)defaultError:(nonnull NSString*)domain;
+(nonnull NSError*)defaultNetworkError;

+(void)requestSmsCodeWithPhone:(NSString*)phone type:(NSString*)typeString uuid:(NSString*)uuid code:(NSString*)code completion:(void(^)(NSError* error))completion ;

+(void)requestavCodeWithPhone:(NSString*)phone type:(NSString*)typeString completion:(void(^)(NSError*eror,NSString* codeAes,NSString* Id))completion;



+(void)loginWithAccount:(NSString*)account password:(NSString*)password type:(NSString*)typeString completion:(void(^)(NSError* error))completion;

+(void)registerWithPhone:(NSString*)phone email:(NSString*)email password:(NSString*)password smsCode:(NSString*)smsCode inviteCode:(NSString*)code completion:(void(^)(NSError* error))completion;

+(void)getRegeHxcompletion:(void(^)(NSError* error,NSString* account,NSString* password))completion;
+(void)resetPasswordWithEmail:(NSString *)email phone:(NSString *)phone smsCode:(NSString *)smsCode password:(NSString*)password completion:(void(^)(NSError* error))completion;

//type login or bind
+(void)userAuthorWithParams:(NSDictionary *)params type:(NSString*)type completion:(void(^)(NSError* error))completion;

+(void)complain:(NSString*)content imageIds:(NSString*)imageIds completion:(void(^)(NSError* error))completion;

+(void)modifySelfBasicInfo:(NSDictionary*)params completion:(void(^)(NSError* error))completion;


+(void)userHomeWithCompletion:(void(^)(NSError* error, id resultObject))completion apnsUUID:(NSString*)uuid;


+(void)userBindPhone:(NSString*)phone code:(NSString*)code completion:(void (^)(NSError * _Nonnull))completion;

+(void)getDiscoveryIndexData:(void (^)(NSError * _Nonnull))completion;

+(void)uptext:(NSString *)content uuid:(NSString*)uuid crid:(NSString*)crid completion:(void (^)(NSError * _Nonnull))completion ;
+(void)getuuidcompletion:(void (^)(NSError * _Nonnull , NSString* uuid))completion;

+(void)getBannerCompletion:(void (^)(NSError * _Nonnull ))completion;
+(void)getCirclesCompletion:(void (^)(NSError * _Nonnull ,NSArray*  crArry))completion;
+(void)uptext:(NSString *)content imageUrls:(NSString*)imageUrls crid:(NSString*)crid completion:(void (^)(NSError * _Nonnull))completion;


@end

NS_ASSUME_NONNULL_END
