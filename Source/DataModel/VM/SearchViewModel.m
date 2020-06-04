//
//  SearchViewModel.m
//  rehab
//
//  Created by herson on 2016/10/7.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "SearchViewModel.h"

@implementation SearchViewModel

-(BOOL)isEmpty
{
    BOOL flag = NO;
    do {
        if (self.treatDiseases.count > 0) {
            break;
        }
        if (self.proTreatDiseases.count > 0) {
            break;
        }
        if (self.articles.count > 0) {
            break;
        }
        flag = YES;
    } while (NO);
    return flag;
}

+(void)searchKeywords:(NSString *)keywords completion:(void (^)(NSError * _Nullable, SearchViewModel * _Nullable))completion
{
    NSString *formatString = [WRNetworkService getFormatURLString:urlSearch];
    NSString *strUrl = [NSString stringWithFormat:formatString, keywords];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keywords"] = keywords;
    [WRNetworkService fillPostParam:params];
    [WRBaseRequest post:strUrl params:params result:^(id responseObject, NSError *error) {
        SearchViewModel * strongSelf = [[SearchViewModel alloc] init];
        
        NSString *errorString = nil;
        do {
            if(error)
            {
                error = [WRViewModel defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            if ([parser.resultObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = parser.resultObject;
                
                NSArray *array = dict[@"treatDiseases"];
                NSMutableArray *data = [NSMutableArray array];
                if (array.count > 0) {
                    for(NSDictionary *obj in array)
                    {
                        WRRehabDisease *disease = [[WRRehabDisease alloc] initWithDictionary:obj];
                        [data addObject:disease];
                    }
                }
                strongSelf.treatDiseases = data;
                
                array = dict[@"proTreatDiseases"];
                data = [NSMutableArray array];
                if (array.count > 0) {
                    for(NSDictionary *obj in array)
                    {
                        WRRehabDisease *disease = [[WRRehabDisease alloc] initWithDictionary:obj];
                        [disease setIsProTreat:YES];
                        [data addObject:disease];
                    }
                }
                strongSelf.proTreatDiseases = data;
                
                array = dict[@"articles"];
                data = [NSMutableArray array];
                if (array.count > 0) {
                    for(NSDictionary *obj in array)
                    {
                        WRArticle *article = [[WRArticle alloc] initWithDictionary:obj];
                        [data addObject:article];
                    }
                }
                strongSelf.articles = data;
            }
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error, strongSelf);
        }
    }];
}

- (void)searchHotWordWithCompletion:(void (^)(NSError *error))completion
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlSearchIndexData];
    NSString *strUrl = formatUrl;
    
    __weak __typeof(self) weakSelf = self;
    [WRBaseRequest request:strUrl shouldUseCache:YES result:^(id responseObject, NSError *error) {
        do {
            if(error)
            {
                break;
            }
            
            error = [[NSError alloc] initWithDomain:strUrl code:-1 userInfo:nil];
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                break;
            }
            
            NSArray *hotArray = parser.resultObject[@"hotKey"];
            
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSDictionary *obj in hotArray)
            {
                WRHotWord *object = [[WRHotWord alloc] initWithDictionary:obj];
                [dataArray addObject:object];
            }
            weakSelf.hotWords = dataArray;
            error = nil;
            
        } while (NO);
        
        if (completion) {
            completion(error);
        }
    }];
}


@end
