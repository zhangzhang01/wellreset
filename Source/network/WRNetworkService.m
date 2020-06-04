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

//sha1加密
#define TOKEN @"well@health-cn.*(yanfa)^-!N0"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

#import "ShareData.h"
#import <YYKit/YYKit.h>
static NSString *  stringTime ;
static NSString *  stringRank ;
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
                      @"agreementUrl",  @"physioDescriptionUrl", @"complain", @"getSmsCode", @"piwik",
                      
                      @"userRegister", @"userLogin", @"userResetPassword", @"userSaveToken",
                      @"userModifyBasicInfo", @"userHome", @"userAskExpert", @"userSyncData",@"userGetReply",
                      
                      @"userGetWell", @"userGetWellAssInfo", @"getProTreatRehabilitation",
                      @"userGetAssessWell", @"userGetProWell",
                      
                      @"getExpertList", @"getFAQList", @"getShareList",
                      
                      @"getAssessProjects", @"getAssessProjectQuestions", @"userAssessSubmit",
                      
                      @"getTreatDiseaseList", @"getTreatRehab", @"usersubmitReabiliRecordV4", @"repeatTreatRehab",
                      
                      @"getChroRehab",
                      
                      @"getProTreatSpecialtyList", @"getProTreatDiseaseList", @"getProTreatQuestions",  @"userProTreatSubmitV3", @"userProTreatRepeatRehab",
                      
                      @"userOp", @"userAuthor", @"checkedDate", @"userGetCollectList", @"feedbackList", @"feedback",
                      
                      @"preventionIndex", @"treatIndex", @"discoveryIndex",
                      
                      @"ad", @"getChroDiseaseList", @"userBindPhone",
                      
                      @"userPerson", @"userUnlockAdd", @"userUnlockIndex", @"shareLogo", @"wechat", @"shareAppUrl",@"getShareDetail",
                      
                      @"searchContent", @"getDiseaseFAQ", @"upload", @"bgMusic",
                      
                      @"getPrevention", @"getPermissions", @"getReplyListDataV5", @"expertgetUserReply", @"searchIndexData", @"userGetCollectList2", @"getUpgradeRules", @"getList", @"IAPOrderProduct", @"userInfo",@"getChallengeShareInfo",@"dailyDay",@"dailyWeek",@"dailyMonth",@"dailyAll",@"userDaily",@"getCommentList",@"addComment",@"delComment",@"getAllCase",@"userdelet",@"setSortIndex"
                      , @"getShareList2" , @"saveShare" ,@"rehabPromt" ,@"expertaddUpvote" , @"expertgetReplyDetail" , @"expertaddReplyComment" , @"userAskData" , @"addFeedBackResult" , @"getHealthStageList",@"getProductList",@"doOrder",@"doPay",@"getOrderList",@"getOrderDetail",@"getAlreadyOrderProducts",@"getRegistResult",
                      @"getuuid",@"Uploadcircles",@"updatetext",@"getbanner",@"getmycircles",@"applepay",@"getValidateCode",@"getSmsCode2",@"userRehabList",@"submitSelfRehab",@"selfRehabDetail"
                      
                      ,@"banner",@"circleList",@"article",@"comments",@"saveComment",@"circleDetail",@"releaseArticle",@"chooseCircleOrTopic",@"removeComment",@"removeArticle",@"upvote",@"notifyList",@"removeNotify",@"uploadImg",@"joinCircle",@"uploadImg",@"getQuestionnairJOA",@"getQuestionnairODI",@"isTrueSpan",@"submitGrade",@"getGredeStatement",@"overall"
                      
                      
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
     // server = @"http://10.0.0.123:8088/well-api/api.action";
     // server = @"http://120.76.159.146:8888/well-v4/api.action";
      //  server = @"https://www.well-health.cn/well-v5.2.1/api.action";
        //正式环境
      server = @"https://www.well-health.cn/well-api/api.action";
        //测试环境
//      server = @"http://120.25.227.88:9911/youth/print/api";
//     server = @"http://192.168.1.210:9011/youth/print/api";
//      server = @"http://10.0.0.66/mtWell/api.action";
//      server = @"http://mhc20150413.xicp.net:14702/mtWell/api.action";
   //   server = @"http://192.168.11.63:8080/well-api/api.action";
      //server = @"http://172.20.10.3:8063/well-api/api.action";
     // server = @"http://120.76.159.146:8080/well-test/api.action";
     //   server = @"http://192.168.11.81:8080/well-api/well-api/api.action";
      //server = @"http://192.168.11.174:8080/well-api/well-api/api.action";
     // server = @"http://120.76.159.146:9966/well-dingdan/api.action";
    //   server = @"http://192.168.11.55:8080/well-api/api.action";
       //  server = @"https://www.well-health.cn/well-test/api.action";
    }
    return server;
}

+ (NSString *)generateTradeNO
{
    static int kNumber = 6;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    sourceStr=[sourceStr lowercaseString];
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+(NSString*)SHA1
{
    //获取时间戳
    NSDate* dat = [NSDate date];
    long time;
    time=[dat timeIntervalSince1970];
    NSString* timeIntervalStr=[NSString stringWithFormat:@"%lu",time];
    stringTime=timeIntervalStr;
    stringRank=[WRNetworkService generateTradeNO];
    NSArray* arr=@[[NSString stringWithFormat:@"token=%@",TOKEN],[NSString stringWithFormat:@"timeIntervalStr=%@",timeIntervalStr],[NSString stringWithFormat:@"stringRank=%@",stringRank]];
    
    NSArray* sortRe=[arr sortedArrayUsingSelector:@selector(compare:)];
    
    NSString* sortStr=[sortRe componentsJoinedByString:@"&"];
    
    const char *cstr = [sortStr cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:sortStr.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

+(NSInteger)timeInterval
{
    NSDate* dat = [NSDate date];
    long time;
    time=[dat timeIntervalSince1970];
    
    
    return time;
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
    NSString* Signstr = [WRNetworkService SHA1];
    return [NSString stringWithFormat:@"%@?clientType=%@&version=%@&deviceType=%d&stringRank=%@&timeIntervalStr=%@&sign=%@",  [self.class getDomain], strApp, strAppVersion, (int)deviceType,stringRank,stringTime,Signstr];

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
    [ShareData data].shareIP = dcInterface[@"httpAddr"];
    NSLog(@"debug ==%@",string);
    if(string)
    {
        NSString *paramsString = @"";
        NSString *pageString = @"offset=%d&pagesize=%d";
        switch (type) {
                
            case urlGetSmsCode:
                paramsString = @"phone=%@&type=%@&validateCodeId=%@&validateCode=%@";
                break;
            case getsmscode2:
                paramsString = @"phone=%@&type=%@&validateCodeId=%@&validateCode=%@";
                break;

                
            case urlUserLogin:
                paramsString = @"account=%@&password=%@&type=%@";
                break;
                
            case urlGetExpertList:
            case urlUserInfo:
            {
                break;
            }
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
                    
            case overall:
            {
               paramsString = @"userId=%@&type=%@&pageOne=%@&pageRow=%@";
               break;
            }
            case getQuestionnairJOA:
               {
                   paramsString = @"userId=%@";
                   break;
               }
            case getQuestionnairODI:
            {
                paramsString = @"userId=%@";
                break;
            }
            case isTrueSpan:
           {
               paramsString = @"userId=%@";
               break;
           }
            case submitGrade:
           {
//                paramsString = @"extra=%@";
               break;
           }
            case getGredeStatement:
           {
               paramsString = @"partCode=%@&userId=%@";
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
            case urlGetChallengeShareInfo:
            {
                paramsString = @"videoId=%@&time=%@";
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
            {
                paramsString = @"diseaseId=%@";
                break;
            }
            case urlUserGetProTreatDetail:
            {
                paramsString = @"diseaseId=%@&childSpecialtyId=%@";
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
                paramsString = @"specialtyId=%@&diseaseId=%@&stage=%d&indexId=%@&upgrade=%@";
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
                paramsString = @"diseaseId=%@&type=%@";
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
                
            case urlGetShareDetail:{
                paramsString = @"uuid=%@";
                break;
            }
                
                /*
                 case urlSearch:
                 {
                 paramsString = @"keywords=%@";
                 break;
                 }
                 */
                
            case urlGetDiseaseFAQ:
            {
                paramsString = @"diseaseId=%@&type=%d";
                break;
            }
                
            case urlUpload:
            {
                paramsString = @"type=%@";
                break;
            }
                case urlIAPOrderProduct:
            {
                paramsString = @"sn=%@&productId=%@&receipt=%@";
                break;
            }
                
            case urlUserFavorList:
            case urlUserStageFavorList:
            {
                paramsString = @"contentType=%@";
                break;
            }
            case urlGetPermissions:
            {
                paramsString = @"userid=%@&date=%@&page=%@&size=%@";
                break;
            }
            case getDailyByDay:
            {
                paramsString = @"userid=%@&date=%@&page=%ld&size=%ld";
                break;
            }
            case getDailyByWeek:
            {
                paramsString = @"userid=%@&date=%@&page=%ld&size=%ld";
                break;
            }
            case getDailyByMonth:
            {
                paramsString = @"userid=%@&date=%@&page=%ld&size=%ld";
                break;
            }
            case getDailyAll:
            {
               paramsString =  @"page=%ld&size=%ld";
            }
                break;
            case getDaily:
                break;
            case getCommentList:
            {
                paramsString = @"wechatId=%@&page=%ld&size=%ld";
                break;
            }
            
            case urlDeleComment:
            {
                paramsString = @"uuid=%@";
                break;
            }
            case urlDeleteRehab:
            {
                paramsString = @"rehabId=%@";
                break;
            }
            case urlEditRehab:
            {
               paramsString = @"rehabIdData=%@";
                break;
            }
            case urlSaveShare:
            {
                paramsString = @"contentType=%@";
                break;
            }
            case urlAddVote:
            {
                paramsString = @"replyId=%@";
                break;
            }
            case getReplyDetail:
            {
                paramsString = @"replyId=%@";
                break;
            }
           case doOrder:
            {
                paramsString = @"productId=%@";
                break;
            }
            case doPay:
            {
                paramsString = @"orderId=%@&payType=%@";
                break;
            }
            case getOrderDetail:
            {
                paramsString = @"orderId=%@";
                break;
            }
            case getcode:
            {
                paramsString = @"phone=%@&type=%@";
                break;
            }
            case ComArticle:
            {
                paramsString = @"sort=%@&page=%d&rows=%d&circleId=%@&isown=%@&articleId=%@";
                break;
            }
            case urlAskIndexData:
            {
                paramsString = @"page=%d&pageSize=%d";
                break;
            }
                
            case comments:
            {
                paramsString = @"sort=%@&articleId=%@";
                break;
            }
            case circleDetail:
            {
                paramsString = @"circleId=%@";
                break;
            }
            case removeArticle:
            {
                paramsString = @"uuid=%@";
                break;
            }
            case removeComment:
            {
                paramsString = @"uuid=%@";
                break;
            }
            case removeNotify:
            {
                paramsString = @"uuid=%@";
                break;
            }
            
            case joinCircle:
            {
                paramsString = @"circleId=%@&isJoin=%@";
                break;
            }
            case upvote:
            {
                paramsString = @"circleId=%@";
                break;
            }
                break;
            default:
                break;
        }
       
        switch (type) {
            case releaseArticle:
            case saveComment:
            case urlGetList:
            case urlGetUpgradeRules:
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
            case urlSearch:
            case urlBgMusic:
//            case urlGetPermissions:
            case urlUserAskExpert:
            case urlAddComment:
            case updatetext:
            case uploadImg:
            case isTrueSpan:
            case submitGrade:
            case getGredeStatement:
            case getQuestionnairJOA:
            case getQuestionnairODI:
            case overall:
                
                
                
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
                NSString* Signstr = [WRNetworkService SHA1];
                NSString *commonParamsString = [NSString stringWithFormat:@"clientType=%@&version=%@&deviceType=%d&stringRank=%@&timeIntervalStr=%@&sign=%@",  strApp, strAppVersion, (int)deviceType,stringRank,stringTime,Signstr];
                
                if (paramsString.length > 0) {
                    paramsString = [commonParamsString stringByAppendingFormat:@"&%@", paramsString];
                } else {
                    paramsString = commonParamsString;
                }
                
                NSMutableString *userParams = [NSMutableString stringWithString:@""];
                WRUserInfo *selfInfo = [WRUserInfo selfInfo];
                if (![Utility IsEmptyString:selfInfo.userId]) {
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
    __weak __typeof(self) weakSelf = self;
    NSString *entryUrlString = [self.class getEntryURLString];
    //[WRBaseRequest request:entryUrlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
    [WRBaseRequest syncRequest:entryUrlString shouldUseCache:NO result:^(id responseObject, NSError *error){
        if (!error)
        {
            WRJsonParser *parser = [WRJsonParser ParserFromString:responseObject];
            NSDictionary *interfaces = parser.resultObject;
            if( parser.isSuccess)
            {
                if (interfaces)
                {
                    [weakSelf initAllInterface:interfaces];
                }
                
                NSString *key = [WRUIConfig IsHDApp] ? @"iPad" : @"iPhone";
                NSDictionary *dict = interfaces[key];
                if (dict)
                {
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
                NSMutableDictionary* circle_protocol = interfaces[@"circle_protocol"];
                if(circle_protocol)
                {
                    AppDelegate* app = [UIApplication sharedApplication].delegate;
                    app.circle_protocol = circle_protocol;
                    
                }
            }
            
            if (error) {
                NSLog(@"%@ Get interface error code %ld %@", entryUrlString, (long)parser.errorCode, parser.errorString);
            }
            
        }
        
        if (error)
        {
            NSLog(@"Get interface error will use old data description %@", error.description);
            
            NSDictionary *apiDict = [WRApp getAPI];
            [_WANInterfaceURLData setDictionary:apiDict];
            if (_WANInterfaceURLData.count == 0)
            {
                error = [[NSError alloc] initWithDomain:entryUrlString code:WRNetworkErrorFetchAPI userInfo:nil];
            }
            else
            {
                weakSelf.isConnected  = YES;
            }
        }
        else
        {
            weakSelf.isConnected  = YES;
            [WRApp saveAPI:_WANInterfaceURLData];
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
        if (![Utility IsEmptyString:selfInfo.token]) {
            param[@"token"] = selfInfo.token;
        }
    };
    
    DeviceType deviceType = IPAD_DEVICE ? DeviceTypeiPad : DeviceTypeiPhone;
    NSString *strApp = [WRUIConfig IsHDApp] ? @"iPad" : @"iPhone";
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *sign = [WRNetworkService SHA1];
        if(strAppVersion.length <= 0)
    {
        strAppVersion = @"1.0";
    }
    param[@"clientType"] = strApp;
    param[@"version"] = strAppVersion;
    param[@"deviceType"] = @(deviceType);
    param[@"stringRank"] = stringRank;
    param[@"timeIntervalStr"] = stringTime;
    param[@"sign"] = sign;
    
    
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
    
#if !DEBUG
    [MobClick event:@"wellnavigatepage" attributes:@{@"name":category} ];
#endif
}

@end
