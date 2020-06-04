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
#import "WRProTreat.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CommonFunBlock)();
typedef void(^ViewModeLoadCompleteBlock)(NSError* error);

@interface WRViewModel : NSObject

@property(nonatomic, copy, nullable)CommonFunBlock loadingBlock;
@property(nonatomic, copy, nullable)CommonFunBlock loadedBlock;
@property(nonatomic, copy, nullable)ViewModeLoadCompleteBlock loadDataCompleteBlock;

+(nonnull NSError*)defaultError:(nonnull NSString*)domain;
+(nonnull NSError*)defaultNetworkError;

+(void)requestSmsCodeWithPhone:(NSString*)phone type:(NSString*)typeString completion:(void(^)(NSError*))completion;

+(void)loginWithAccount:(NSString*)account password:(NSString*)password type:(NSString*)typeString completion:(void(^)(NSError* error))completion;

+(void)registerWithPhone:(NSString*)phone email:(NSString*)email password:(NSString*)password smsCode:(NSString*)smsCode inviteCode:(NSString*)code completion:(void(^)(NSError* error))completion;

+(void)resetPasswordWithEmail:(NSString *)email phone:(NSString *)phone smsCode:(NSString *)smsCode password:(NSString*)password completion:(void(^)(NSError* error))completion;

//type login or bind
+(void)userAuthorWithParams:(NSDictionary *)params type:(NSString*)type completion:(void(^)(NSError* error))completion;

+(void)complain:(NSString*)content completion:(void(^)(NSError* error))completion;

+(void)modifySelfBasicInfo:(NSDictionary*)params completion:(void(^)(NSError* error))completion;

+(void)operationWithType:(const NSString*)type
                 indexId:(NSString*)indexId
                    flag:(BOOL)flag
             contentType:(const NSString*)contentType
              completion:(void(^)(NSError* error))completion;


+(void)userHomeWithCompletion:(void(^)(NSError* error, id resultObject))completion apnsUUID:(NSString*)uuid;

+(void)userGetFavorListWithCompletion:(void (^)(NSError * _Nullable, id _Nullable))completion;
+(void)userBindPhone:(NSString*)phone code:(NSString*)code completion:(void (^)(NSError * _Nonnull))completion;

+(void)getDiscoveryIndexData:(void (^)(NSError * _Nonnull))completion;

@end

NS_ASSUME_NONNULL_END