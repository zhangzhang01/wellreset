//
//  WRNetworkService.m
//  rehab
//
//  Created by Matech on 3/3/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRNetworkService.h"
#import "WRJsonParser.h"
#import "WRUserInfo.h"
#import "WRUIConfig.h"
#import "WRApp.h"
#import "WRBaseRequest.h"
#import <UMMobClick/MobClick.h>

const NSString * WROperationTypeLike = @"like";
const NSString * WROperationTypeShare = @"share";
const NSString * WROperationTypeRead = @"read";
const NSString * WROperationTypeNotification = @"notification";
const NSString * WROperationTypeFavor = @"favor";
const NSString * WROperationTypeUserCommonDisease = @"userCommonDisease";
const NSString * WROperationTypeUserDiseasePhoto = @"diseases";
const NSString * WROperationTypeCustom = @"custom";

const NSString * WRContentTypeTreat = @"treat";
const NSString * WRContentTypeArticle = @"article";

const NSString * WROperationManageTypeAdd = @"add";
const NSString * WROperationManageTypeDelete = @"delete";

@interface WRNetworkService()
{
    NSMutableDictionary *_WANInterfaceURLData;
    NSArray *_keyArray;
}
@end


@implementation WRNetworkService

#pragma mark - Static funtion
+(instancetype)defaultService
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        _keyArray = @[
                      @"agreementUrl",  @"physioDescriptionUrl", @"uploadHeadImageUrl", @"complain", @"getSmsCode", @"piwik",
                      
                      @"userRegister", @"userLogin", @"userResetPassword", @"userSaveToken", @"userModifyBasicInfo", @"userHome", @"userAskExpert", @"userSyncData",@"userGetReply",
                      
                      @"userGetWell", @"userGetWellAssInfo", @"getProTreatRehabilitation", @"userGetAssessWell", @"userGetProWell",
                      
                      @"getExpertList", @"getFAQList", @"getShareList",
                      
                      @"getAssessProjects", @"getAssessProjectQuestions", @"userAssessSubmit",
                      
                      @"getTreatDiseaseList", @"getTreatRehab", @"userTreatCheckedDate", @"repeatTreatRehab",
                      
                      @"getChroRehab",
                      
                      @"getProTreatSpecialtyList", @"getProTreatDiseaseList", @"getProTreatQuestions",  @"userProTreatSubmitV3", @"userProTreatRepeatRehab",
                      
                      @"userOp", @"userAuthor", @"checkedDate", @"userGetCollectList", @"feedbackList", @"feedback",
                      
                      @"preventionIndex", @"treatIndex", @"discoveryIndex",
                      
                      @"ad", @"getChroDiseaseList", @"uploadFile", @"userBindPhone",
                      
                      @"userPerson", @"userUnlockAdd", @"userUnlockIndex", @"shareLogo", @"wechat", @"shareAppUrl"
                      ];
        
        _WANInterfaceURLData = [NSMutableDictionary dictionaryWithDictionary:[WRApp getAPI]];
    }
    return self;
}


+(NSString *)getDomain
{
    NSString *server = nil;
    server = [[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
    if (!server) {
        server = @"http://api.well-health.cn:8888/well-v3/api.action";
    }
    return server;
}

+ (NSString*)getEntryURLString{
    
    NSString *strAppVersion = @"";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    strAppVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if(strAppVersion.length <= 0)
    {
        strAppVersion = @"1.0.0";
    }
    DeviceType deviceType = IPAD_DEVICE ? DeviceTypeiPad : DeviceTypeiPhone;
    NSString *strApp = [WRUIConfig IsHDApp] ? @"iPad" : @"iPhone";
    return [NSString stringWithFormat:@"%@?clientType=%@&version=%@&deviceType=%d",  [self.class getDomain], strApp, strAppVersion, (int)deviceType];
}

+ (NSString *)getFormatURLString:(WRURLType)type {
    return [[WRNetworkService defaultService] getFormatURLString:type];
}

#pragma mark - Public funtion
- (NSString *)getFormatURLString:(WRURLType)type
{
    NSDictionary *dcInterface = _WANInterfaceURLData;
    NSString *key = [_keyArray objectAtIndex:type];
    NSString* string = [dcInterface objectForKey:key];
    if(string)
    {
        NSString *paramsString = @"";
        NSString *pageString = @"offset=%d&pagesize=%d";
        switch (type) {
                
            case urlGetSmsCode:
                paramsString = @"phone=%@&type=%@";
                break;
                
            case urlUserLogin:
                paramsString = @"account=%@&password=%@&type=%@";
                break;
                
            case urlGetExpertList:
            case urlUserGetReply:
            {
                paramsString = pageString;
                break;
            }
                
            case urlGetNewsList:
            {
                paramsString = [NSString stringWithFormat:@"%@&%@", @"type=%@", pageString];
                break;
            }
                
            case urlGetFAQList:
            {
                //paramsString = @"keyWords=%@";
                break;
            }
                
            case urlGetAssessProjects:
            {
                paramsString = pageString;
                break;
            }
            case urlGetAssessProjectQuestions:
            {
                paramsString = @"indexId=%@";
                break;
            }
                
            case urlGetTreatDiseaseList:
            {
                paramsString = @"codes=%@";
                break;
            }
                
            case urlGetTreatRehab:
            case urlGetChroRehab:
            case urlUserTreatRepeatRehab:
            case urlUserGetProTreatDetail:
            {
                paramsString = @"diseaseId=%@";
                break;
            }
                
            case urlGetProTreatSpecialtyList:
            {
                paramsString = pageString;
                break;
            }
            case urlGetProTreatDiseaseList:
            {
                paramsString = [NSString stringWithFormat:@"%@&%@", @"diseaseId=%@", pageString];
                break;
            }
            case urlGetProTreatQuestions:
            {
                paramsString = @"specialtyId=%@&diseaseId=%@&stage=%d";
                break;
            }
                
            case urlUserHome:
            {
                paramsString = @"uuid=%@";
                break;
            }
                
            case urlUserOperation:
            {
                paramsString = @"type=%@&opType=%@&contentType=%@&uuid=%@";
                break;
            }
                
            case urlUserGetAssessDetail:
            {
                paramsString = @"projectId=%@";
                break;
            }
                
            case urlUserCheckProTreatRehab:
            case urlUserCheckTreatRehab:
            {
                paramsString = @"indexId=%@&sportTime=%d&isFinished=%d";
                break;
            }
                
            case urlUserGetProTreatFeedbackList:
            {
                paramsString = @"diseaseId=%@";
                break;
            }
                
            case urlUserProTreatRepeatRehab:
            {
                paramsString = @"diseaseId=%@";
                break;
            }
                
            case urlGetAssessResultAdvice:
            {
                paramsString = @"projectId=%@";
                break;
            }
            case urlUserBindPhone: {
                paramsString = @"phone=%@&code=%@";
                break;
            }
                
            case urlUserUnlockAdd:
            {
                paramsString = @"videoId=%@&time=%@";
                break;
            }
                
            default:
                break;
        }
        
        switch (type) {
            case urlUserAssessSubmit:
            case urlGetFAQList:
            case urlUserProTreatSubmit:
            case urlUserSubmitProTreatFeedback:
            case urlUserSyncData:
            case urlUserRegister:
            case urlUserResetPassword:
            case urlUserAuthor:
            case urlComplain:
            case urlUserModifyBasicInfo:
            case urlPiwik:
            case urlAd:
            case urlShareLogo:
            case urlWechat:
            case urlShareApp:
            case urlUserPutQuestion:
                break;
                
            default:
            {
                DeviceType deviceType = IPAD_DEVICE ? DeviceTypeiPad : DeviceTypeiPhone;
                NSString *strApp = [WRUIConfig IsHDApp] ? @"iPad" : @"iPhone";
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *strAppVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                if(strAppVersion.length <= 0)
                {
                    strAppVersion = @"1.0.0";
                }
                NSString *commonParamsString = [NSString stringWithFormat:@"clientType=%@&version=%@&deviceType=%d", strApp, strAppVersion, (int)deviceType];
                
                if (paramsString.length > 0) {
                    paramsString = [commonParamsString stringByAppendingFormat:@"&%@", paramsString];
                } else {
                    paramsString = commonParamsString;
                }
                
                NSMutableString *userParams = [NSMutableString stringWithString:@""];
                WRUserInfo *selfInfo = [WRUserInfo selfInfo];
                if ([selfInfo isLogged]) {
                    [userParams appendFormat:@"userId=%@",selfInfo.userId];
                    if (![Utility IsEmptyString:selfInfo.token]) {
                        [userParams appendFormat:@"&token=%@", selfInfo.token];
                    }
                }
                if (![Utility IsEmptyString:userParams]) {
                    paramsString = [paramsString stringByAppendingFormat:@"&%@", userParams];
                }
                break;
            }
        }
        
        if (paramsString.length > 0) {
            string = [string stringByAppendingFormat:@"?%@", paramsString];
        }
    }
    else
    {
        string = @"";
    }
    
    return string;
}


-(void)initAllInterface:(NSDictionary *)data
{
    NSArray *fileNameArray = @[@"wan.plist"];
    NSArray *fromDataArray = @[data];
    NSArray *toDataArray = @[_WANInterfaceURLData];
    NSUInteger count = fileNameArray.count;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    for(NSUInteger index = 0; index < count; index++)
    {
        NSMutableDictionary *fromData = [fromDataArray objectAtIndex:index];
        NSMutableDictionary *toData = [toDataArray objectAtIndex:index];
        
        for(NSString *strKey in fromData.allKeys)
        {
            [toData setObject:[fromData objectForKey:strKey] forKey:strKey];
        }
        
        NSString *strFilePath = [documentPath stringByAppendingPathComponent:[fileNameArray objectAtIndex:index]];
        if([manager fileExistsAtPath:strFilePath])
        {
            [manager removeItemAtPath:strFilePath error:nil];
        }
        
        NSMutableDictionary *newData = [NSMutableDictionary dictionary];
        for(NSString *strKey in fromData.allKeys)
        {
            id item = [fromData objectForKey:strKey];
            if ([item isKindOfClass:[NSString class]]) {
                NSString *strUrl = [fromData objectForKey:strKey];
                if(strUrl)
                {
                    strUrl = [strUrl base64EncodedString];
                    [newData setObject:strUrl forKey:strKey];
                }
            }
        }
        [newData writeToFile:strFilePath atomically:YES];
    }
}


-(void)fetchInterfaceWithCompletion:(void (^)(NSError *))completion
{
    NSString *entryUrlString = [self.class getEntryURLString];
    NSLog(@"%@", entryUrlString);
    [WRBaseRequest request:entryUrlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
        NSDictionary *interfaces = parser.resultObject;
        if( parser.isSuccess)
        {
            if (interfaces) {
                [self initAllInterface:interfaces];
            }
            
            NSString *key = [WRUIConfig IsHDApp] ? @"iPad" : @"iPhone";
            NSDictionary *dict = interfaces[key];
            if (dict) {
                NSString *minVersion = dict[@"minVersion"];
                //NSString *latestVersion = dict[@"latestVersion"];
                //NSString *download = dict[@"download"];
                //NSString *upgrade = dict[@"upgrade"];
                //NSString *update = dict[@"upgrade"];
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *currentVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                if ([minVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending)
                {
                    parser.errorCode = WRNetworkErrorNeedUpdate;
                    error = [[NSError alloc] initWithDomain:entryUrlString code:parser.errorCode userInfo:dict];
                }
            }
        }
        
        if (error)
        {
            NSLog(@"Get interface error will use old data");
            [_WANInterfaceURLData setDictionary:[WRApp getAPI]];
            if (_WANInterfaceURLData.count == 0)
            {
                error = [[NSError alloc] initWithDomain:entryUrlString code:WRNetworkErrorFetchAPI userInfo:nil];
            }
            else
            {
                self.isConnected  = YES;
            }
        }
        else
        {
            self.isConnected  = YES;
            [WRApp saveAPI:_WANInterfaceURLData];
        }
        
        if (error) {
            NSLog(@"%@ Get interface error code %ld %@", entryUrlString, (long)parser.errorCode, parser.errorString);
        }
        
        if(completion)
        {
            completion(error);
        }
    }];
}

+(void)fillPostParam:(NSMutableDictionary *)param
{
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    if([WRUserInfo selfInfo].isLogged) {
        param[@"userId"] = selfInfo.userId;
        if ([Utility IsEmptyString:selfInfo.token]) {
            param[@"token"] = selfInfo.token;
        }
    };
    
    DeviceType deviceType = IPAD_DEVICE ? DeviceTypeiPad : DeviceTypeiPhone;
    NSString *strApp = [WRUIConfig IsHDApp] ? @"iPad" : @"iPhone";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if(strAppVersion.length <= 0)
    {
        strAppVersion = @"1.0";
    }
    param[@"clientType"] = strApp;
    param[@"version"] = strAppVersion;
    param[@"deviceType"] = @(deviceType);
}

+(void)pwiki:(NSString *)category {
    NSString *userId = [WRUserInfo selfInfo].userId;
    if (!userId) {
        userId = @"";
    }
    
    NSString *deviceTypeName = IPAD_DEVICE ? @"iPad" : @"iPhone";
    NSString *formatString = [[self defaultService] getFormatURLString:urlPiwik];
    NSString *url = [NSString stringWithFormat:formatString, category, deviceTypeName];
    url = [url stringByAppendingFormat:@"?action_name=%@&ua=%@&idsite=1&rec=1&_id=1&_idvc=1&cvar=%@",
           category, deviceTypeName, [NSString stringWithFormat:@"{\"3\":[\"用户编号\",\"%@\"],\"4\":[\"设备\",\"%@\"]}", userId, deviceTypeName]];
    [WRBaseRequest request:url shouldUseCache:NO result:^(id responseObject, NSError *error) {
        if (error) {
            //NSLog(@"%@\nPiwik rep error %@", url, error.description);
        }
    }];
    
    [MobClick event:@"wellnavigatepage" attributes:@{@"name":category}];
}

@end
