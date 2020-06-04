//
//  WRViewModel+Common.m
//  rehab
//
//  Created by herson on 2016/11/18.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRViewModel+Common.h"

@implementation WRViewModel(Common)

+(NSString*)operationTypeToString:(OperationType)type
{
    NSString *typeString = @"";
    switch (type) {
        case OperationTypeNotification:
            typeString = @"notification";
            break;
            
        case OperationTypeFavor:
            typeString = @"favor";
            break;
            
        case OperationTypeUserCommonDisease:
            typeString = @"userCommonDisease";
            break;
            
        case OperationTypeUserDiseasePhoto:
            typeString = @"diseases";
            break;

        case OperationTypeProTreatArticle:
            typeString = @"wechat";
            break;
            
        default:
            break;
    }
    return typeString;
}


+(NSString*)operationActionTypeToString:(OperationActionType)type
{
    NSString *typeString = @"";
    switch (type) {
        case OperationActionTypeAdd:
            typeString = @"add";
            break;
            
        case OperationActionTypeDelete:
            typeString = @"delete";
            break;
            
        default:
            break;
    }
    return typeString;
}

+(NSString*)operationContentTypeToString:(OperationContentType)type
{
    NSString *typeString = @"";
    switch (type) {
        case OperationContentTypeTreat:
            typeString = @"treat";
            break;
            
        case OperationContentTypeArticle:
            typeString = @"article";
            break;
            
        case OperationContentTypeTreatStage:
            typeString = @"treatStage";
            break;
            
        case OperationContentTypeProTreatStage:
            typeString = @"proTreatStage";
            break;
            
        case OperationContentTypeStage:
            typeString = @"Stage";
            break;
            
        default:
            break;
    }
    return typeString;
}


+(void)operationWithType:(OperationType)type indexId:(NSString *)indexId actionType:(OperationActionType)actionType contentType:(OperationContentType)contentType completion:(void (^)(NSError * _Nonnull))completion
{
    NSString *format = [WRNetworkService getFormatURLString:urlUserOperation];
    NSString *urlString = [NSString stringWithFormat:format, [self operationTypeToString:type], [self operationActionTypeToString:actionType], [self operationContentTypeToString:contentType], indexId];
    
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

+(void)userGetCollectionListWithCompletion:(void (^)(NSError * _Nullable, id _Nullable))completion type:(OperationContentType)type
{
    NSString *formatString = [WRNetworkService getFormatURLString:(type == OperationContentTypeArticle ? urlUserFavorList : urlUserStageFavorList)];
    NSString *urlString = [NSString stringWithFormat:formatString, [self operationContentTypeToString:type]];
    
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
                for (NSDictionary *dict in array)
                {
                    id object = nil;
                    if ([dict[@"type"] isEqualToString:@"article"])
                    {
                        object = [[WRArticle alloc] initWithDictionary:dict];
                    }
                    else if ([dict[@"type"] isEqualToString:@"treat"])
                    {
                        object = [[WRRehabDisease alloc] initWithDictionary:dict];
                    }
                    else
                    {
                        object = [[FavorContent alloc] initWithDictionary:dict];
                    }
                    
                    if (object != nil)
                    {
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

@end
