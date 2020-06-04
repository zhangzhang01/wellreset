//
//  PermissionsViewModel.m
//  rehab
//
//  Created by 何寻 on 2016/11/24.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "PermissionsViewModel.h"

@implementation PermissionsViewModel

-(void)fetchAllPermissionsWithCompletion:(void(^)(NSError* error))completion
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlGetPermissions];
    
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
            [weakSelf.dataArray removeAllObjects];
            NSArray *newsArray = parser.resultObject[@"levelPermissions"];
            for(NSDictionary *obj in newsArray)
            {
                WRUserPermission *object = [[WRUserPermission alloc] initWithDictionary:obj];
                [weakSelf.dataArray addObject:object];
            }
            
            weakSelf.isLastPage = YES;
            
            error = nil;
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

-(void)fetchAllLevelRuleWithCompletion:(void(^)(NSError* error))completion
{
    __weak __typeof(self) weakSelf = self;
    NSString *formatString = [WRNetworkService getFormatURLString:urlGetUpgradeRules];
    NSString *strUrl = [NSString stringWithFormat:formatString, 0, 20];
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
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
            NSArray *expertArray = parser.resultObject;
            
//            NSMutableArray *dataArray = [NSMutableArray array];
//            for(NSDictionary *obj in expertArray)
//            {
//                WRLevelRule *object = [[WRLevelRule alloc] initWithDictionary:obj];
//                [dataArray addObject:object];
//            }
            weakSelf.ruleArray = expertArray;
            
            error = nil;
        } while (NO);
        
        if (completion)
        {
            completion(error);
        }
    }];
}

@end
