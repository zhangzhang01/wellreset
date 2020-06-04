//
//  UserViewModel.m
//  rehab
//
//  Created by 何寻 on 8/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "UserViewModel.h"
#import "ShareUserData.h"
#import "ShareData.h"
#import "WRTreat.h"

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
        
            error = nil;
    
        } while (NO);
        
        if (completion) {
            completion(error);
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

+(void)askForRehab:(NSString *)content completion:(void (^)(NSError *))completion
{
    NSString *url = [WRNetworkService getFormatURLString:urlUserPutQuestion];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{@"content":content}];
    [WRNetworkService fillPostParam:params];

    [WRBaseRequest post:url params:params result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
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
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}
@end
