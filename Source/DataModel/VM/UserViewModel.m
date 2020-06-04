//
//  UserViewModel.m
//  rehab
//
//  Created by herson on 8/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "UserViewModel.h"
#import "ShareUserData.h"
#import "ShareData.h"
#import "RehabObject.h"
#import <YYKit/YYKit.h>
@implementation UserViewModel

+(void)fetchPersonDataWithCompletion:(void (^)(NSError *))completion
{
    NSString *urlString = [WRNetworkService getFormatURLString:urlUserPerson];
    
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
            
            NSString* fdateStr = [responseObject jsonStringEncoded];
            
             [[NSUserDefaults standardUserDefaults]setObject:fdateStr forKey:@"firstData"];
            
            
            
            
            
            NSDictionary *dict = parser.resultObject;
            ShareUserData *userData = [ShareUserData userData];
            [userData fromDictionary:dict];
            
            NSArray *array = dict[@"treatDiseases"];
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRRehabDisease *diseae  = [[WRRehabDisease alloc] initWithDictionary:itemDict];
                [dataArray addObject:diseae];
            }
            [ShareData data].treatDisease = dataArray;
            
            array = dict[@"proTratDiseases"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRRehabDisease *diseae  = [[WRRehabDisease alloc] initWithDictionary:itemDict];
                [diseae setIsProTreat:YES];
                [dataArray addObject:diseae];
            }
            [ShareData data].proTreatDisease = dataArray;
            
            array = dict[@"treat"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRRehab *rehab  = [[WRRehab alloc] initWithDictionary:itemDict];
                [dataArray addObject:rehab];
            }
            [ShareUserData userData].treatRehab = dataArray;
            
            array = dict[@"proTreat"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRRehab *rehab  = [[WRRehab alloc] initWithDictionary:itemDict];
                [rehab.disease setIsProTreat:YES];
                [dataArray addObject:rehab];
            }
            [ShareUserData userData].proTreatRehab = dataArray;
            
            array = dict[@"classifies"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *dict in array) {
                WRTreatclass *object = [[WRTreatclass alloc] initWithDictionary:dict];
                [dataArray addObject:object];
            }
            [ShareData data].treatclassArry = dataArray;

            
            array = dict[@"recommendTreat"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRRehabDisease *diseae  = [[WRRehabDisease alloc] initWithDictionary:itemDict];
                [dataArray addObject:diseae];
            }
            [ShareData data].recommendTreat = dataArray;
            
            array = dict[@"banner"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRBannerInfo *object  = [[WRBannerInfo alloc] initWithDictionary:itemDict];
                [dataArray addObject:object];
            }
            [ShareData data].bannerArray = dataArray;
            
            
            array = dict[@"wechatShare"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRArticle *object  = [[WRArticle alloc] initWithDictionary:itemDict];
                object.uuid = itemDict[@"id"];
                object.imageUrl  = itemDict[@"imageurl"];
                object.contentUrl = itemDict[@"content_url"];
                [dataArray addObject:object];
                
            }
            [ShareUserData userData].wechatShareList = dataArray;
            
            NSArray* dic = dict[@"selfRehab"];
            if (dic.count>0) {
                
                WRRehab *rehab  = [[WRRehab alloc] initWithDictionary:dic[0]];
                [ShareUserData userData].selfrehab = rehab;
            }
            
            error = nil;
    
        } while (NO);
        
        if (completion) {
            completion(error);
        }
    }];
}
+(void)fetchPersonFDataWithCompletion:(void (^)(NSError *))completion
{
    NSString* fdateStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"firstData"];
    NSDictionary*responseObject = [fdateStr jsonValueDecoded];
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
    
            
            NSDictionary *dict = parser.resultObject;
            ShareUserData *userData = [ShareUserData userData];
            [userData fromDictionary:dict];
            
            NSArray *array = dict[@"treatDiseases"];
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRRehabDisease *diseae  = [[WRRehabDisease alloc] initWithDictionary:itemDict];
                [dataArray addObject:diseae];
            }
            [ShareData data].treatDisease = dataArray;
            
            array = dict[@"proTratDiseases"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRRehabDisease *diseae  = [[WRRehabDisease alloc] initWithDictionary:itemDict];
                [diseae setIsProTreat:YES];
                [dataArray addObject:diseae];
            }
            [ShareData data].proTreatDisease = dataArray;
    
            array = dict[@"classifies"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *dict in array) {
            WRTreatclass *object = [[WRTreatclass alloc] initWithDictionary:dict];
            [dataArray addObject:object];
            }
            [ShareData data].treatclassArry = dataArray;
            
            array = dict[@"treat"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRRehab *rehab  = [[WRRehab alloc] initWithDictionary:itemDict];
                [dataArray addObject:rehab];
            }
            [ShareUserData userData].treatRehab = dataArray;
            
            array = dict[@"proTreat"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRRehab *rehab  = [[WRRehab alloc] initWithDictionary:itemDict];
                [rehab.disease setIsProTreat:YES];
                [dataArray addObject:rehab];
            }
            [ShareUserData userData].proTreatRehab = dataArray;
            
            array = dict[@"recommendTreat"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRRehabDisease *diseae  = [[WRRehabDisease alloc] initWithDictionary:itemDict];
                [dataArray addObject:diseae];
            }
            [ShareData data].recommendTreat = dataArray;
            
            array = dict[@"banner"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRBannerInfo *object  = [[WRBannerInfo alloc] initWithDictionary:itemDict];
                [dataArray addObject:object];
            }
            [ShareData data].bannerArray = dataArray;
            
            
            array = dict[@"wechatShare"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *itemDict in array)
            {
                WRArticle *object  = [[WRArticle alloc] initWithDictionary:itemDict];
                object.uuid = itemDict[@"id"];
                object.imageUrl  = itemDict[@"imageurl"];
                object.contentUrl = itemDict[@"content_url"];
                [dataArray addObject:object];
                
            }
            [ShareUserData userData].wechatShareList = dataArray;
    NSArray* dic = dict[@"selfRehab"];
    if (dic.count>0) {
        
        WRRehab *rehab  = [[WRRehab alloc] initWithDictionary:dic[0]];
        [ShareUserData userData].selfrehab = rehab;
    }
    
    completion(nil);
    
}






+(void)fetchExpereseDataWithCompletion:(void(^)(NSError*error, BOOL isChange))completion
{
    NSString *urlString = [WRNetworkService getFormatURLString:urlUserInfo];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        BOOL isChange = NO;
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
            NSNumber *intExperise, *amountExperise;
            amountExperise = dict[@"nextLevelNeedIntegral"];
            
            NSDictionary *user = dict[@"userInfo"];
            intExperise = user[@"integral"];
            
            if ([intExperise integerValue]!=[WRUserInfo selfInfo].integral || [amountExperise integerValue]!=[WRUserInfo selfInfo].nextLevel) {
                isChange = YES;
                [WRUserInfo selfInfo].nextLevel = [amountExperise integerValue];
                [WRUserInfo selfInfo].level = [dict[@"level"] integerValue];
//                [[WRUserInfo selfInfo] fromDict:dict[@"userInfo"]];
                [WRUserInfo selfInfo].integral = [intExperise integerValue];
                [[WRUserInfo selfInfo] save];
            }
            error = nil;
            
        } while (NO);
        
        if (completion) {
            completion(error, isChange);
        }
    }];

}

+(void)fetchLockDataWithCompletion:(void (^)(NSError *))completion
{
    NSString *urlString = [WRNetworkService getFormatURLString:urlUserUnlockIndex];
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
            
            NSDictionary *dict = parser.resultObject;
            
            NSArray *array = dict[@"userVideos"];
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSDictionary *dictionary in array)
            {
                WRTreatRehabStage *object = [[WRTreatRehabStage alloc] initWithDictionary:dictionary];
                [dataArray addObject:object];
            }
            [ShareUserData userData].challengeVideoArray = dataArray;
            
            array = dict[@"groups"];
            dataArray = [NSMutableArray array];
            for(NSDictionary *dictionary in array)
            {
                ChallengeGroup *object = [[ChallengeGroup alloc] initWithDictionary:dictionary];
                [dataArray addObject:object];
            }
            [ShareData data].challengeGroupArray = dataArray;
            
            error = nil;
        } while (NO);
        
        if (completion) {
            completion(error);
        }
    }];
}

+(void)fetchChallengeInfoDataWithVideoId:(NSString *)videoId time:(NSNumber *)time Completion:(void(^)(NSError *error, NSNumber *value ,NSString *shareUrl))completion
{
    NSString *format = [WRNetworkService getFormatURLString:urlGetChallengeShareInfo];
    NSString *urlString = [NSString stringWithFormat:format, videoId, time];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        NSNumber *value = @(0);
        NSString *shareUrl = @"";
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
//
//            NSArray *array = dict[@"userVideos"];
//            NSMutableArray *dataArray = [NSMutableArray array];
//            for(NSDictionary *dictionary in array)
//            {
//                WRTreatRehabStage *object = [[WRTreatRehabStage alloc] initWithDictionary:dictionary];
//                [dataArray addObject:object];
//            }
//            [ShareUserData userData].challengeVideoArray = dataArray;
//            
//            array = dict[@"groups"];
//            dataArray = [NSMutableArray array];
//            for(NSDictionary *dictionary in array)
//            {
//                ChallengeGroup *object = [[ChallengeGroup alloc] initWithDictionary:dictionary];
//                [dataArray addObject:object];
//            }
//            [ShareData data].challengeGroupArray = dataArray;
//
            NSNumber *beyond, *participateNum;
            beyond = dict[@"beyondNum"];
            participateNum = dict[@"participateNum"];
            NSInteger num = (float)[beyond integerValue]/[participateNum integerValue] * 100;
            value = @(num);
//            NSLog(@"num%d",num);
            shareUrl = dict[@"shareUrl"];
            NSLog(@"shareUrl%@",shareUrl);
            error = nil;
        } while (NO);
        
        if (completion) {
            completion(error,value,shareUrl);
        }
    }];
}

+(void)checkRehabWidthIndexId:(NSString *)rehabIndexId sportTimeSeconds:(NSUInteger)sportTime isProTreat:(BOOL)isProTreat completion:(void (^)(NSError *, id))completion{
    NSString *format = [WRNetworkService getFormatURLString:isProTreat?urlUserCheckProTreatRehab:urlUserCheckTreatRehab];
    NSString *urlString = [NSString stringWithFormat:format, rehabIndexId, sportTime, 0];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        id resultObject = nil;
        do {
            if(error)
            {
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            resultObject = parser.resultObject;
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error, resultObject);
        }
    }];
}

+(void)recordChallengeVideo:(NSString *)videoIndexId sportTimeSeconds:(NSUInteger)sportTime completion:(void (^)(NSError *, id))completion{
    NSString *format = [WRNetworkService getFormatURLString:urlUserUnlockAdd];
    NSString *urlString = [NSString stringWithFormat:format, videoIndexId, [@(sportTime) stringValue]];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        id resultObject = nil;
        do {
            if(error)
            {
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            resultObject = parser.resultObject;
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error, resultObject);
        }
    }];
}
+(void)fetchSaveShareType:(NSString *)shareType  completion:(void (^)(NSError *, id))completion
{
    NSString *format = [WRNetworkService getFormatURLString:urlSaveShare];
    NSString *urlString = [NSString stringWithFormat:format, shareType];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        id resultObject = nil;
        do {
            if(error)
            {
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            resultObject = parser.resultObject;
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error, resultObject);
        }
    }];

}


@end
