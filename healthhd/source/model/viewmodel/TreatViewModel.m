//
//  TreatViewModel.m
//  rehab
//
//  Created by 何寻 on 9/1/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "TreatViewModel.h"

@implementation TreatViewModel


+(void)getTreatRehabDetail:(NSString *)indexId completion:(void (^)(NSError *, id))completion {
    NSString *format = [WRNetworkService getFormatURLString:urlGetTreatRehab];
    NSString *urlString = [NSString stringWithFormat:format, indexId];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        id object = nil;
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
            object = [[WRRehab alloc] initWithDictionary:dict];
            error = nil;
        } while (NO);
        if (completion) {
            completion(error, object);
        }
    }];
}


+(void)getChoTreatRehabDetail:(NSString *)indexId completion:(void (^)(NSError * _Nonnull, id _Nonnull))completion {
    NSString *format = [WRNetworkService getFormatURLString:urlGetChroRehab];
    NSString *urlString = [NSString stringWithFormat:format, indexId];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        id object = nil;
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
            object = [[WRRehab alloc] initWithDictionary:dict];
            error = nil;
        } while (NO);
        if (completion) {
            completion(error, object);
        }
    }];
}

+(void)likeTreatRehab:(NSString *)indexId flag:(BOOL)flag completion:(void (^)(NSError *))completion {
    [WRViewModel operationWithType:WROperationTypeFavor indexId:indexId flag:flag contentType:WRContentTypeTreat completion:completion];
}


+(void)repeatTreatRehabWithDiseaseId:(NSString *)diseaseId completion:(void (^)(NSError *, id))completion{
    NSString *formatString = [WRNetworkService getFormatURLString:urlUserTreatRepeatRehab];
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

@end
