//
//  ProTreatViewModel.m
//  rehab
//
//  Created by Matech on 3/14/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "ProTreatViewModel.h"
#import "RehabObject.h"
#import "ShareData.h"
#import "ShareUserData.h"
#import <YYKit/YYKit.h>
@implementation ProTreatViewModel

-(void)fetchQuestionsWithCompletion:(void (^)(NSError *, id))completion specialtyId:(NSString *)specialtyId diseaseId:(NSString*)diseaseId stage:(NSUInteger)stage indexId:(NSString *)indexId upgrde:(NSString *)upgrade
{
    __weak __typeof(self) weakSelf = self;
    NSString *formatString = [WRNetworkService getFormatURLString:urlGetProTreatQuestions];
    NSString *strUrl = [NSString stringWithFormat:formatString, specialtyId, diseaseId, stage, indexId,upgrade];
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
                if (parser.errorCode == -1) {
                    errorString = NSLocalizedString(@"加载数据失败", nil);
                } else {
                    errorString = parser.errorString;
                }
//                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            weakSelf.questionArray = [NSMutableArray array];
            weakSelf.userAnswerArray = [NSMutableArray array];
            
            NSDictionary *resultDict = parser.resultObject;
            weakSelf.indexId = resultDict[@"indexId"];
            NSArray *array = resultDict[@"records"];
            NSString *type = resultDict[@"type"];
            weakSelf.desc = resultDict[@"description"];
            weakSelf.Ttitle = resultDict[@"title"];
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
-(void)userGetProTreatStageWithCompletion:(void (^)(NSError * _Nonnull, id _Nonnull))completion
{
    NSString *formatString = [WRNetworkService getFormatURLString:getHealthStageList];
    
    [WRBaseRequest request:formatString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
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
            
            NSArray *dict = parser.resultObject;
            if ([dict isKindOfClass:[NSArray class]]) {
                if (dict.count>0) {
                    self.UserHealthStage = [[WRTestInfo alloc]initWithDictionary:dict[0]];
                }
                if(dict.count>1)
                {
                    NSMutableArray* last = [NSMutableArray array];
                    for (NSDictionary* info in dict) {
                        WRTestInfo* test = [[WRTestInfo alloc]initWithDictionary:info];
                        [last addObject:test];
                    }
                    [last removeObjectAtIndex:0];
                    self.lastarry = last;
                }
                
            }
            
            error = nil;
            
        } while (NO);
        if (completion) {
            completion(error, proTreatReha);
        }
    }];
}

-(void)getProTreatRehabWithCompletion:(void (^)(NSError *, id, NSInteger, NSString*))completion
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
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"data":json}];
        params[@"stringRank"] = dataDict[@"stringRank"];
        params[@"timeIntervalStr"] = dataDict[@"timeIntervalStr"];
        params[@"sign"] = dataDict[@"sign"];
        NSString *urlString = [WRNetworkService getFormatURLString:urlUserProTreatSubmit];
       // [WRNetworkService fillPostParam:params];
        [WRBaseRequest post:urlString params:params result:^(id responseObject, NSError *error) {
            NSString *errorString = nil;
            WRRehab *rehab = nil;
 
            NSInteger state = DiagnosticResultWeak;
            NSString *stateDescription = @"";
            
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
                NSLog(@"%@",resultDict);
                if([resultDict isKindOfClass:[NSDictionary class]])
                {
                    state = [resultDict[@"healthState"] integerValue];
                    stateDescription = resultDict[@"healthDesc"];
                    NSDictionary *rehabDict = resultDict[@"rehab"];
                    rehab = [[WRRehab alloc] initWithDictionary:rehabDict];
                    [rehab.disease setIsProTreat:YES];
                    
                    if ([resultDict[@"UserHealthStage"] isKindOfClass:[NSDictionary class]]) {
                        self.UserHealthStage = [[WRTestInfo alloc]initWithDictionary:resultDict[@"UserHealthStage"]];
                    }
                    if([resultDict[@"lastUserHealthStage"] isKindOfClass:[NSArray class]])
                    {
                        NSArray * arr =resultDict[@"lastUserHealthStage"];
                        NSMutableArray* last = [NSMutableArray array];
                        for (NSDictionary* info in arr) {
                            WRTestInfo* test = [[WRTestInfo alloc]initWithDictionary:info];
                            [last addObject:test];
                        }
                        self.lastarry = last;
                                        
                                        
                    }
                    
                }
                else
                {
                    
                    
                    
                    break;
                }
                
                error = nil;
            } while (NO);
            if (completion) {
                completion(error, rehab, state, stateDescription);
            }
        } timeoutInterval:20];
    }
}

-(void)setAnswer:(NSString *)answer index:(NSUInteger)index {
    self.userAnswerArray[index] = [answer copy];
}

+(void)userGetProTreatDetailWithData:(WRRehab*)rehab completion:(void (^)(NSError * _Nonnull, id _Nonnull))completion {
    NSString *format = [WRNetworkService getFormatURLString:urlUserGetProTreatDetail];
    NSString* spid =@"" ;
    if ([rehab.disease.diseaseName isEqualToString:@"颈椎"]) {
    spid = @"163f89eb-15ae-4f7e-900a-decfb279c4ab";
        
    }
    else if([rehab.disease.diseaseName isEqualToString:@"腰部"])
    {
        spid = @"d9d7dcf5-225c-433d-b515-dfe46c39d8d4";
    }
    else if([rehab.disease.diseaseName isEqualToString:@"肩背部"])
    {
        spid = @"226919fb-c63a-4fe0-bb2e-2cf2b17405ed";
    }
    NSString *urlString = [NSString stringWithFormat:format, rehab.disease.indexId,spid];
    NSLog(@"----------9999%@",urlString);
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



+(void)userCheckRehab:(NSString *)rehabId state:(NSInteger)state interver:(NSInteger)interver completion:(void (^)(NSError * _Nonnull, id _Nonnull))completion {
    NSString *format = [WRNetworkService getFormatURLString:urlUserCheckProTreatRehab];
    NSString *urlString = [NSString stringWithFormat:format, rehabId, interver,  state];
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

+(void)userGetProTreatFeedbackQuestionsWithDiseaseId:(NSString *)diseaseId isPro:(BOOL)isPro completion:(nonnull void (^)(NSError * _Nonnull, id _Nonnull))completion{
    NSString *format = [WRNetworkService getFormatURLString:urlUserGetProTreatFeedbackList];
    NSString *urlString = [NSString stringWithFormat:format, diseaseId, isPro?@"proTreat":@"treat"];
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
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"data":json}];
        params[@"stringRank"] = dataDict[@"stringRank"];
        params[@"timeIntervalStr"] = dataDict[@"timeIntervalStr"];
        params[@"sign"] = dataDict[@"sign"];

        [WRNetworkService fillPostParam:params];
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
+(void)userProTreatSubmitNewFeedbackWithCompletion:(void (^)(NSError * _Nullable))completion answers:(NSArray *)answersDict pain:(NSString *)pain rehabid:(NSString *)rehabid {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    dataDict[@"op"] = answersDict;
    dataDict[@"degree"] = pain;
    dataDict[@"rehabType"] = @"1";
    dataDict[@"rehabId"] = rehabid;
    [WRNetworkService fillPostParam:dataDict];
    
    NSString *json = [dataDict jsonStringEncoded];
    if (json) {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"data":json}];
        params[@"stringRank"] = dataDict[@"stringRank"];
        params[@"timeIntervalStr"] = dataDict[@"timeIntervalStr"];
        params[@"sign"] = dataDict[@"sign"];
        
        [WRNetworkService fillPostParam:params];
        NSString *urlString = [WRNetworkService getFormatURLString:addFeedBackResult];
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
                    [object.disease setIsProTreat:YES];
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



+(void)userGetCustomTreatWithCompletion:(void (^)(NSError * _Nonnull, id _Nonnull))completion {
    NSString *urlString = [WRNetworkService getFormatURLString:selfRehabDetail];
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
            if (dict.count==0)
            {
                break;
            }
            
            WRRehab *object = [[WRRehab alloc] initWithDictionary:dict];
            resultObject = object;
            error = nil;
        } while (NO);
        if (completion) {
            completion(error, resultObject);
        }
    }];
}

+(void)userGetTreatWithdate:(NSString*)data indexid:(NSString*)indexid Completion:(void (^)(NSError * _Nonnull, id _Nonnull))completion
{
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    
    dataDict[@"indexId"] = indexid;
    dataDict[@"data"] = data;
    
    
    
   // [WRNetworkService fillPostParam:dataDict];
        NSString *urlString = [WRNetworkService getFormatURLString:submitSelfRehab];
        
        [WRBaseRequest post:urlString params:dataDict result:^(id responseObject, NSError *error) {
            NSString *errorString = nil;
            WRRehab *rehab = nil;
            
            NSInteger state = DiagnosticResultWeak;
            NSString *stateDescription = @"";
            
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
                WRRehab *object = [[WRRehab alloc] initWithDictionary:resultDict];
                rehab = object;
                
                error = nil;
            } while (NO);
            if (completion) {
                completion(error,rehab );
            }
        } timeoutInterval:20];
    
    
    
}

@end
