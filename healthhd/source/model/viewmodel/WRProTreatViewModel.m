//
//  WRProTreatViewModel.m
//  rehab
//
//  Created by Matech on 3/14/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRProTreatViewModel.h"
#import "WRTreat.h"
#import "ShareData.h"
#import "ShareUserData.h"

@implementation WRProTreatViewModel

-(void)fetchQuestionsWithCompletion:(void (^)(NSError *, id))completion specialtyId:(NSString *)specialtyId diseaseId:(NSString*)diseaseId stage:(NSUInteger)stage
{
    __weak __typeof(self) weakSelf = self;
    NSString *formatString = [WRNetworkService getFormatURLString:urlGetProTreatQuestions];
    NSString *strUrl = [NSString stringWithFormat:formatString, specialtyId, diseaseId, stage];
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        id rehab = nil;
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
            
            weakSelf.questionArray = [NSMutableArray array];
            weakSelf.userAnswerArray = [NSMutableArray array];
            
            NSDictionary *resultDict = parser.resultObject;
            weakSelf.indexId = resultDict[@"indexId"];
            NSArray *array = resultDict[@"records"];
            NSString *type = resultDict[@"type"];
            if ([type isEqualToString:@"rehab"])
            {
                if(array.count > 0)
                {
                    NSDictionary *dict = array.firstObject;
                    rehab = [[WRRehab alloc] initWithDictionary:dict];
                }
            }
            else
            {
                for(NSDictionary *dict in array)
                {
                    WRProTreatQuestion *question = [[WRProTreatQuestion alloc] initWithDictionary:dict];
                    [weakSelf.questionArray addObject:question];
                    [weakSelf.userAnswerArray addObject:@""];
                }
            }
            error = nil;
        } while (NO);
        
        if (completion)
        {
            completion(error, rehab);
        }
    }];
}

-(void)getProTreatRehabWithCompletion:(void (^)(NSError *, id))completion
                      stage:(NSUInteger)stage
                  diseaseId:(NSString *)diseaseId
                specialtyId:(NSString*)specialtyId
{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];

    dataDict[@"indexId"] = self.indexId;
    dataDict[@"diseaseId"] = diseaseId;
    dataDict[@"specialtyId"] = specialtyId;
    dataDict[@"stage"] = @(stage);
    
    NSMutableArray *infoArray = [NSMutableArray array];
    NSUInteger index = 0;
    for(index = 0; index < self.questionArray.count; index++) {
        WRProTreatQuestion *question = self.questionArray[index];
        NSString *answerId = self.userAnswerArray[index];
        if ([Utility IsEmptyString:answerId]) {
            continue;
        }
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"questionId"] = question.indexId;
        dict[@"answerId"] = answerId;
        [infoArray addObject:dict];
    }
    dataDict[@"info"] = infoArray;
    [WRNetworkService fillPostParam:dataDict];
    
    NSString *json = [dataDict jsonStringEncoded];
    if (json) {
        NSDictionary *params = @{@"data":json};
        NSString *urlString = [WRNetworkService getFormatURLString:urlUserProTreatSubmit];
        [WRBaseRequest post:urlString params:params result:^(id responseObject, NSError *error) {
            NSString *errorString = nil;
            WRRehab *rehab = nil;
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
                
                NSDictionary *resultDict = parser.resultObject;
                if([resultDict isKindOfClass:[NSDictionary class]])
                {
                    //NSInteger level = [resultDict[@"healthState"] integerValue];
                    //NSString *desc = resultDict[@"healthDesc"];
                    NSDictionary *rehabDict = resultDict[@"rehab"];
                    rehab = [[WRRehab alloc] initWithDictionary:rehabDict];
                    [rehab.disease setIsProTreat:YES];
                }
                else
                {
                    break;
                }
                
                if (rehab) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:WRReloadRehabNotification object:nil];
                }
                
                error = nil;
            } while (NO);
            if (completion) {
                completion(error, rehab);
            }
        } timeoutInterval:20];
    }
}

-(void)setAnswer:(NSString *)answer index:(NSUInteger)index {
    self.userAnswerArray[index] = [answer copy];
}


+(void)userGetProTreatDetailWithData:(WRRehab*)rehab completion:(void (^)(NSError * _Nonnull, id _Nonnull))completion {
    NSString *format = [WRNetworkService getFormatURLString:urlUserGetProTreatDetail];
    NSString *urlString = [NSString stringWithFormat:format, rehab.disease.indexId];
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

+(void)userCheckRehab:(NSString *)rehabId state:(NSInteger)state completion:(void (^)(NSError * _Nonnull, id _Nonnull))completion {
    NSString *format = [WRNetworkService getFormatURLString:urlUserCheckProTreatRehab];
    NSString *urlString = [NSString stringWithFormat:format, rehabId, 0,  state];
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

+(void)userGetProTreatFeedbackQuestionsWithDiseaseId:(NSString *)diseaseId completion:(nonnull void (^)(NSError * _Nonnull, id _Nonnull))completion{
    NSString *format = [WRNetworkService getFormatURLString:urlUserGetProTreatFeedbackList];
    NSString *urlString = [NSString stringWithFormat:format, diseaseId];
    [WRBaseRequest request:urlString shouldUseCache:YES result:^(id responseObject, NSError *error) {
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
            
            NSArray *array = parser.resultObject;
            if([array isKindOfClass:[NSArray class]])
            {
                NSMutableArray *dataArray = [NSMutableArray array];
                for(NSDictionary *dict in array) {
                    WRProTreatRehabFeedbackQuestion *question = [[WRProTreatRehabFeedbackQuestion alloc] initWithDictionary:dict];
                    [dataArray addObject:question];
                }
                resultObject = dataArray;
            }
            error = nil;
        } while (NO);
        if (completion) {
            completion(error, resultObject);
        }
    }];
}

+(void)userProTreatSubmitFeedbackWithCompletion:(void (^)(NSError * _Nullable))completion answers:(NSDictionary *)answersDict proTreatRehabId:(NSString *)indexId {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    dataDict[@"rehabilitationId"] = indexId;
    
    NSMutableArray *infoArray = [NSMutableArray array];
    [answersDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSDictionary *item = @{@"feebackId":key, @"value":obj};
        [infoArray addObject:item];
    }];
    dataDict[@"info"] = infoArray;
    [WRNetworkService fillPostParam:dataDict];
    
    NSString *json = [dataDict jsonStringEncoded];
    if (json) {
        NSDictionary *params = @{@"data":json};
        NSString *urlString = [WRNetworkService getFormatURLString:urlUserSubmitProTreatFeedback];
        [WRBaseRequest post:urlString params:params result:^(id responseObject, NSError *error) {
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
}

+(void)repeatProTreatRehabWithDiseaseId:(NSString *)diseaseId completion:(void (^)(NSError *, id))completion{
    NSString *formatString = [WRNetworkService getFormatURLString:urlUserProTreatRepeatRehab];
    NSString *strUrl = [NSString stringWithFormat:formatString, diseaseId];
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        id proTreatReha = nil;
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
            
            NSDictionary *dict = parser.resultObject;
            proTreatReha = [[WRRehab alloc] initWithDictionary:dict];
            
            error = nil;
            
        } while (NO);
        if (completion) {
            completion(error, proTreatReha);
        }
    }];
}

+(void)userGetWellWithCompletion:(void (^)(NSError * _Nonnull))completion {
    NSString *urlString = [WRNetworkService getFormatURLString:urlUserGetWell];
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
            
            NSArray *array;
            array = dict[@"proList"];
            if (array.count > 0) {
                NSMutableArray *dataArray = [NSMutableArray array];
                for (NSDictionary *dict in array) {
                    WRRehab *object = [[WRRehab alloc] initWithDictionary:dict];
                    [dataArray addObject:object];
                }
                [ShareUserData userData].proTreatRehab = dataArray;
            }
            
            array = dict[@"treatList"];
            if (array.count > 0) {
                NSMutableArray *dataArray = [NSMutableArray array];
                for (NSDictionary *dict in array) {
                    WRRehab *object = [[WRRehab alloc] initWithDictionary:dict];
                    [dataArray addObject:object];
                }
                [ShareUserData userData].treatRehab = dataArray;
            }
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

+(void)userGetProTreatWithCompletion:(void (^)(NSError * _Nonnull, id _Nonnull))completion {
    NSString *urlString = [WRNetworkService getFormatURLString:urlUserGetProTreat];
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
            
            NSDictionary *dict = parser.resultObject;
            NSArray *array = dict[@"proList"];
            if (array.count > 0) {
                NSMutableArray *itemArray = [NSMutableArray array];
                for (NSDictionary *dict in array) {
                    WRRehab *object = [[WRRehab alloc] initWithDictionary:dict];
                    [itemArray addObject:object];
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

@end
