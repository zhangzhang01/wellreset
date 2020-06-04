//
//  WRViewModel.m
//
//
//  Created by Matech on 16/2/17.
//  Copyright © 2016年 X.H. All rights reserved.
//

#import "WRViewModel.h"
#import "WRUserInfo.h"
#import "WRTreat.h"
#import "SVProgressHUD.h"
#import <UMMobClick/MobClick.h>
#import "WRObject.h"
#import "ShareData.h"
#import "ShareUserData.h"

@implementation WRViewModel

-(instancetype)init {
    if(self = [super init]) {
        self.loadingBlock = ^() {
            [SVProgressHUD show] ;
        };
        
        self.loadedBlock = ^() {
            [SVProgressHUD dismiss];
        };
    }
    return self;
}

+(NSError *)defaultError:(NSString *)domain {
    return [NSError errorWithDomain:domain code:-1 userInfo:nil];
}

+(NSError *)defaultNetworkError {
    return [NSError errorWithDomain:NSLocalizedString(@"请求失败,请检测网络后重试", nil) code:-1 userInfo:nil];
}

#pragma mark - Common
+(void)requestSmsCodeWithPhone:(NSString*)phone type:(NSString*)typeString completion:(void(^)(NSError* error))completion {
    NSString *formatString = [WRNetworkService getFormatURLString:urlGetSmsCode];
    NSString *strUrl = [NSString stringWithFormat:formatString, phone, typeString];
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        do {
            if(error)
            {
                error = [self defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                if (parser.errorCode == -1) {
                    errorString = NSLocalizedString(@"获取验证码失败", nil);
                } else {
                    errorString = parser.errorString;
                }
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

#pragma mark - User Manage
+(void)loginWithAccount:(NSString*)account password:(NSString*)password type:(nonnull NSString *)typeString completion:(void(^)(NSError* error))completion {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString* sysVersion = [[UIDevice currentDevice] systemVersion];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [userDefaults objectForKey:@"uuid"];
    if(!uuid)
    {
        uuid = [[[NSProcessInfo processInfo] globallyUniqueString] stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [userDefaults setObject:uuid forKey:@"uuid"];
    }
    NSString *encryptPassword = password;
    if (![typeString isEqualToString:@"smsCode"]) {
        encryptPassword = [Utility MD5Encrypt:password];
    }
    NSString *formatString = [WRNetworkService getFormatURLString:urlUserLogin];
    NSString *strUrl = [NSString stringWithFormat:formatString, account, encryptPassword,  typeString, 1, version, sysVersion, uuid];
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
       
         NSString *errorString = nil;
         do {
             if(error)
             {
                 error = [self defaultNetworkError];
                 break;
             }
             
             WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
             if(!parser.isSuccess)
             {
                 errorString = parser.errorString;
                 error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                 break;
             }
             
             NSDictionary* dcResult  = parser.resultObject;
             [[WRUserInfo selfInfo] fromDict:dcResult];
             [[WRUserInfo selfInfo] save];
             [MobClick profileSignInWithPUID:[WRUserInfo selfInfo].userId];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:WRLogInNotification object:nil];
             error = nil;
         } while (NO);
         if (completion) {
             completion(error);
         }
     }];
}

+(void)registerWithPhone:(NSString*)phone email:(NSString*)email password:(NSString*)password smsCode:(NSString*)smsCode inviteCode:(NSString*)code  completion:(void(^)(NSError* error))completion {
    NSString *encryptPassword = [Utility MD5Encrypt:password];
    NSString *formatString = [WRNetworkService getFormatURLString:urlUserRegister];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{@"password":encryptPassword, @"code":smsCode}];
    if (phone) {
        [params setObject:phone forKey:@"phone"];
        if (code.length > 0) {
            [params setObject:code forKey:@"inviteCode"];
        }
    }
    if (email) {
        [params setObject:email forKey:@"email"];
    }
    [WRNetworkService fillPostParam:params];
    
    NSString *strUrl = formatString;
    [WRBaseRequest post:strUrl params:params result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        do {
            if(error)
            {
                error = [self defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

+(void)resetPasswordWithEmail:(NSString *)email phone:(NSString *)phone smsCode:(NSString *)smsCode password:(NSString*)password completion:(void(^)(NSError* error))completion {
    NSString *account = email;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ([Utility IsEmptyString:account]) {
        account = phone;
        params[@"password"] = [password md5String];
        params[@"code"] = smsCode;
    }
    
    if ([Utility IsEmptyString:account]) {
        return;
    }
    params[@"account"] = account;
    [WRNetworkService fillPostParam:params];
    
    NSString *urlString = [WRNetworkService getFormatURLString:urlUserResetPassword];
    [WRBaseRequest post:urlString params:params result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        do {
            if(error)
            {
                error = [self defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                if (parser.errorCode == -1 || [Utility IsEmptyString:errorString]) {
                    errorString = NSLocalizedString(@"密码重置失败", nil);
                }
                error = [NSError errorWithDomain:errorString code:parser.errorCode userInfo:nil];
                break;
            }
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

+(void)userAuthorWithParams:(NSDictionary *)params type:(NSString *)type completion:(void (^)(NSError * _Nonnull))completion {

    NSString *urlString = [WRNetworkService getFormatURLString:urlUserAuthor];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    [WRNetworkService fillPostParam:dict];
    
    [WRBaseRequest post:urlString params:dict result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        do {
            if(error)
            {
                error = [self defaultNetworkError];
                break;
            }
  
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
        
            if ([type isEqualToString:@"login"]) {
                NSDictionary* dcResult  = parser.resultObject;
                if ([dcResult isKindOfClass:[NSDictionary class]]) {
                    [[WRUserInfo selfInfo] fromDict:dcResult];
                    [[WRUserInfo selfInfo] save];
                    [MobClick profileSignInWithPUID:[WRUserInfo selfInfo].userId];
                    [[NSNotificationCenter defaultCenter] postNotificationName:WRLogInNotification object:nil];
                }
            }
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

#pragma mark -
+(void)complain:(NSString *)content completion:(void (^)(NSError * _Nonnull))completion {
    
    NSString *formatString = [WRNetworkService getFormatURLString:urlComplain];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{@"content":content}];
    [WRNetworkService fillPostParam:params];
    
    NSString *strUrl = formatString;
    [WRBaseRequest post:strUrl params:params result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        do {
            if(error)
            {
                error = [self defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

+(void)modifySelfBasicInfo:(NSDictionary*)params completion:(void (^)(NSError * _Nonnull))completion {
    
    NSString *formatString = [WRNetworkService getFormatURLString:urlUserModifyBasicInfo];
    NSMutableDictionary *postParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [WRNetworkService fillPostParam:postParams];
    
    NSString *strUrl = formatString;
    [WRBaseRequest post:strUrl params:postParams result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        do {
            if(error)
            {
                error = [self defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            [[WRUserInfo selfInfo] fromDict:postParams];
            [[WRUserInfo selfInfo] save];
            
            error = nil;
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

+(void)operationWithType:(const NSString *)type indexId:(NSString *)indexId flag:(BOOL)flag contentType:(const NSString *)contentType completion:(void (^)(NSError * _Nonnull))completion
{
    NSString *format = [WRNetworkService getFormatURLString:urlUserOperation];
    NSString *urlString = [NSString stringWithFormat:format, type, flag?WROperationManageTypeAdd:WROperationManageTypeDelete, contentType, indexId];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        do {
            if(error)
            {
                error = [self defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            error = nil;
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

+(void)userHomeWithCompletion:(void (^)(NSError * _Nonnull, id _Nonnull))completion apnsUUID:(NSString*)uuid{
    NSString *format = [WRNetworkService getFormatURLString:urlUserHome];
    NSString *urlString = [NSString stringWithFormat:format, uuid];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        id resultObject = nil;
        NSInteger errorCode = -1;
        do {
            if(error)
            {
                error = [self defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorCode = parser.errorCode;
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:errorCode userInfo:nil];
                break;
            }
            resultObject = parser.resultObject;
            
            NSDictionary *dict = resultObject;
            NSArray *array = dict[@"commonDiseases"];
            if (array.count > 0) {
                [[ShareUserData userData].commonDiseases removeAllObjects];
                [array enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    WRCommonDisease *disease = [[WRCommonDisease alloc] initWithDictionary:obj];
                    [[ShareUserData userData].commonDiseases addObject:disease];
                }];
            }
            
            array = dict[@"diseasesFiles"];
            if (array.count > 0) {
                [[ShareUserData userData].diseasePhotoArray removeAllObjects];
                [array enumerateObjectsUsingBlock:^(NSDictionary*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *imageUrl = obj[@"imgUrl"];
                    [[ShareUserData userData].diseasePhotoArray addObject:imageUrl];
                }];
            }
            
            error = nil;
        } while (NO);
        
        if (completion) {
            completion(error, resultObject);
        }
    }];
}

+(void)userGetFavorListWithCompletion:(void (^)(NSError * _Nullable, id _Nullable))completion {
    NSString *urlString = [WRNetworkService getFormatURLString:urlUserFavorList];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        id resultObject = nil;
        do {
            if(error)
            {
                error = [self defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            NSArray *array = parser.resultObject;
            if (array.count > 0) {
                NSMutableArray *itemArray = [NSMutableArray array];
                for (NSDictionary *dict in array) {
                    id object = nil;
                    if ([dict[@"type"] isEqualToString:@"article"]) {
                        object = [[WRArticle alloc] initWithDictionary:dict];
                    } else if ([dict[@"type"] isEqualToString:@"treat"]) {
                        object = [[WRRehabDisease alloc] initWithDictionary:dict];
                    }
                    if (object != nil) {
                        [itemArray addObject:object];
                    }
                }
                resultObject = itemArray;
            }
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error, resultObject);
        }
    }];
}

+(void)userBindPhone:(NSString*)phone code:(NSString*)code completion:(void (^)(NSError * _Nonnull))completion {
    NSString *urlString = [NSString stringWithFormat:[WRNetworkService getFormatURLString:urlUserBindPhone], phone, code];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        do {
            if(error)
            {
                error = [self defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            error = nil;
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

+(void)getDiscoveryIndexData:(void (^)(NSError * _Nonnull))completion
{
    NSString *urlString = [WRNetworkService getFormatURLString:urlDiscoveryIndex];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error)
    {
        NSString *errorString = nil;
        do {
            if(error)
            {
                error = [self defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            NSMutableArray *dataArray = [NSMutableArray array];
            NSDictionary *dict = parser.resultObject;
            NSArray *array = dict[@"banner"];
            for(NSDictionary *dict in array) {
                WRArticle *object = [[WRArticle alloc] initWithDictionary:dict];
                [dataArray addObject:object];
            }
            [ShareData data].discoveryBannerArray = dataArray;
            
            dataArray = [NSMutableArray array];
            array = dict[@"category"];
            for(NSDictionary *dict in array) {
                WRCategory *object = [[WRCategory alloc] initWithDictionary:dict];
                [dataArray addObject:object];
            }
            [ShareData data].categoryArray = dataArray;
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

@end
