//
//  WRViewModel.m
//
//
//  Created by Matech on 16/2/17.
//  Copyright © 2016年 X.H. All rights reserved.
//

#import "WRViewModel.h"
#import "WRUserInfo.h"
#import "RehabObject.h"
#import "SVProgressHUD.h"
#import <UMMobClick/MobClick.h>
#import "WRObject.h"
#import "ShareData.h"
#import "ShareUserData.h"
#import "UMessage.h"
#import <YYKit/YYKit.h>
#import "WRCircleNews.h"
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
+(void)requestSmsCodeWithPhone:(NSString*)phone type:(NSString*)typeString uuid:(NSString*)uuid code:(NSString*)code completion:(void(^)(NSError* error))completion {
    NSLog(@"debug  = %@,typeString = %@",phone,typeString);
    NSString *formatString = [WRNetworkService getFormatURLString:getsmscode2];
    NSLog(@"debug  = %@",formatString);
    NSString *strUrl = [NSString stringWithFormat:formatString, phone, typeString,uuid,code];
    NSLog(@"debug  = %@",strUrl);
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
+(void)requestavCodeWithPhone:(NSString*)phone type:(NSString*)typeString completion:(void(^)(NSError*eror,NSString* codeAes,NSString* Id))completion
{
    NSLog(@"debug  = %@,typeString = %@",phone,typeString);
    NSString *formatString = [WRNetworkService getFormatURLString:getcode];
    NSLog(@"debug  = %@",formatString);
    NSString *strUrl = [NSString stringWithFormat:formatString, phone, typeString];
    NSLog(@"debug  = %@",strUrl);
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        NSString *codeaes = nil;
        NSString *uuid = nil;
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
            NSDictionary* dic = parser.resultObject;
            codeaes = dic[@"validateCode"];
            uuid = dic[@"validateCodeId"];
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error,codeaes,uuid);
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
    NSLog(@"%@",strUrl);
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
            NSDictionary* ex = responseObject[@"extra"];
            
            NSDictionary* dcResult  = parser.resultObject;
            [[WRUserInfo selfInfo] fromDict:dcResult];
                        if (ex&&[ex isKindOfClass:[NSDictionary class]]) {
                [WRUserInfo selfInfo].isfirst = [ex[@"isFirstLogin"] boolValue];
            }
            
            
            [[WRUserInfo selfInfo] save];
            NSLog(@"%@",[WRUserInfo selfInfo].userId);
            [UMessage addAlias:[WRUserInfo selfInfo].userId type:@"" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                if (error) {
                    
                }
            }];

            NSLog(@"debug   ====== == =%@",[WRUserInfo selfInfo].userId);
            [MobClick profileSignInWithPUID:[WRUserInfo selfInfo].userId];
            
            
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
+(void)getRegeHxcompletion:(void(^)(NSError* error,NSString* account,NSString* password))completion
{
    NSString *formatString = [WRNetworkService getFormatURLString:getRegistResult];
    
    [WRBaseRequest request:formatString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        NSString *account;
        NSString *password;
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
            account = parser.resultObject[@"hxName"];
            password = parser.resultObject[@"hxPassword"];
            
            error = nil;
            
        } while (NO);
        if (completion) {
            completion(error,account,password);
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
                NSLog(@"error.domain%@",error.domain);
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
                    WRUserInfo* user = [WRUserInfo selfInfo];
                    NSDictionary* ex = responseObject[@"extra"];
                    [UMessage addAlias:[WRUserInfo selfInfo].userId type:@"" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                        
                    }];
                   
                    
                    if (ex&&[ex isKindOfClass:[NSDictionary class]]) {
                        [WRUserInfo selfInfo].isfirst = [ex[@"isFirstLogin"] boolValue];
                    }
                    
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
+(void)complain:(NSString *)content imageIds:(NSString*)imageIds completion:(void (^)(NSError * _Nonnull))completion {
    
    NSString *formatString = [WRNetworkService getFormatURLString:urlComplain];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{@"content":content}];
    if (![Utility IsEmptyString:imageIds]) {
        [params addEntriesFromDictionary:@{@"imgIds":imageIds}];
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

+(void)getuuidcompletion:(void (^)(NSError * _Nonnull , NSString* uuid))completion {
    
    NSString *formatString = [WRNetworkService getFormatURLString:getuuid];
    
    
    NSString *strUrl = formatString;
    NSLog(@"%@",strUrl);
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error)  {
        NSString *uuid =nil;
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
            uuid = parser.resultObject[@"uuid"];
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error,uuid);
        }
    }];
}


+(void)uptext:(NSString *)content uuid:(NSString*)uuid crid:(NSString*)crid completion:(void (^)(NSError * _Nonnull))completion {
    
    NSString *formatString = [WRNetworkService getFormatURLString:updatetext];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{@"text":content}];
    [params addEntriesFromDictionary:@{@"uuid":uuid}];
    if (crid) {
    [params addEntriesFromDictionary:@{@"circleId1":crid}];
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

+(void)uptext:(NSString *)content imageUrls:(NSString*)imageUrls crid:(NSString*)crid completion:(void (^)(NSError * _Nonnull))completion {
    
    NSString *formatString = [WRNetworkService getFormatURLString:releaseArticle];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{@"text":content}];

    if(crid) {
        NSArray* ar = @[crid];
        [params addEntriesFromDictionary:@{@"circleIds":ar[0]}];
    }else{
        
     [params addEntriesFromDictionary:@{@"circleIds":@""}];
    }
    if(imageUrls)
    {
        [params addEntriesFromDictionary:@{@"imageUrls":imageUrls}];
    }else
    {
       [params addEntriesFromDictionary:@{@"imageUrls":@""}];
    
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

/***
 ***     用户程序 挂起恢复用户数据 必须调用
 ***/
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
         NSDictionary *info = dict[@"userInfo"];
            if (info) {
                WRUserInfo* info =    [WRUserInfo selfInfo];
                [info fromDict:dict];
                [[WRUserInfo selfInfo]save];
            }
            
            
            
            NSDictionary *value = dict[@"userPermissions"];
            if (value) {
                [ShareUserData userData].userPermissions = [[WRUserPermission alloc] initWithDictionary:value];
            }
            NSDictionary *first = dict[@"loginInfo"];
            if([first[@"firstOpen"] boolValue])
            {
                [AppDelegate show:[NSString stringWithFormat:@"今天连续登陆第%@天，获得%@经验",first[@"days"],first[@"integral"]]];
            }
            
            
            resultObject = [[WRCircleNews alloc]initWithDictionary:dict[@"active"]];
            
            
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
    NSString *formatString = [WRNetworkService getFormatURLString:overall];
    NSString *urlString = [NSString stringWithFormat:formatString,[WRUserInfo selfInfo].userId,@"",@"10",@"1",@"1"];
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
             
             //更新后的版本
          NSMutableArray *dataArray = [NSMutableArray array];
          NSArray *array = parser.extraObject;
//             for(NSDictionary *dict in array) {
//                 WRArticle *object = [[WRArticle alloc] initWithDictionary:dict];
//                 [dataArray addObject:object];
//             }
//             [ShareData data].discoveryBannerArray = dataArray;

          dataArray = [NSMutableArray array];
          array = parser.extraObject;
          for(NSDictionary *dict in array) {
              WRCategory *object = [[WRCategory alloc] initWithDictionary:dict];
              for (NSDictionary *dic in object.wt) {
                  WRArticle *object2 = [[WRArticle alloc] initWithDictionary:dic];
                  [object.wtArray addObject:object2];
              }



              [dataArray addObject:object];

          }

          [ShareData data].categoryArray = dataArray;
              NSLog(@"====%@",[ShareData data].categoryArray);
          error = nil;
                          //以前版本
//                          NSMutableArray *dataArray = [NSMutableArray array];
//                                      NSArray *array = parser.resultObject;
//                                      for(NSDictionary *dict in array) {
//                                          WRArticle *object = [[WRArticle alloc] initWithDictionary:dict];
//                                          [dataArray addObject:object];
//                                      }
//                                      [ShareData data].discoveryBannerArray = dataArray;
//
//                                      dataArray = [NSMutableArray array];
//                                      array = parser.extraObject[@"category"];
//                                      for(NSDictionary *dict in array) {
//                                          WRCategory *object = [[WRCategory alloc] initWithDictionary:dict];
//                                          [dataArray addObject:object];
//                                      }
//                                      [ShareData data].categoryArray = dataArray;
//
//                                      error = nil;
         } while (NO);
         if (completion) {
             completion(error);
         }
     }];
}
+(void)getBannerCompletion:(void (^)(NSError * _Nonnull ))completion
{
    NSString *formatString = [WRNetworkService getFormatURLString:getBanner];
    NSString *urlString = [NSString stringWithFormat:@"%@", formatString];
    
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
             
             NSDictionary *dict = parser.resultObject;
             if ([dict[@"banner"]isKindOfClass:[NSArray class]]) {
                 NSArray *array = dict[@"banner"];
                 NSMutableArray *dataArray = [NSMutableArray array];
                 for(NSDictionary *itemDict in array)
                 {
                     WRBannerInfo *object  = [[WRBannerInfo alloc] initWithDictionary:itemDict];
                     [dataArray addObject:object];
                 }
                 [ShareData data].bannerArray = dataArray;
                 
                 dataArray = [NSMutableArray array];
                 array = dict[@"indexbanner"];
                 for(NSDictionary *itemDict in array)
                 {
                     WRBannerInfo *object  = [[WRBannerInfo alloc] initWithDictionary:itemDict];
                     
                     [dataArray addObject:object];
                 }
                 [ShareData data].IndexArray = dataArray;
                 
                 error = nil;
             }
             
         } while (NO);
         if (completion) {
             completion(error);
         }
     }];

}

+(void)getCirclesCompletion:(void (^)(NSError * _Nonnull ,NSArray*  crArry))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:getcircles]];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        NSArray* circles ;
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
            
            if([parser.resultObject isKindOfClass:[NSArray class]])
            {
                circles = parser.resultObject;
            }
            error= nil;
            
        } while (NO);
        if (completion) {
            completion(error,circles);
        }
    }];

}

@end
