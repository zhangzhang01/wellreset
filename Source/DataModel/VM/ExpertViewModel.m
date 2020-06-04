//
//  ExpertViewModel.m
//  rehab
//
//  Created by yefangyang on 2016/10/10.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "ExpertViewModel.h"

@implementation ExpertViewModel
-(void)fetchExpertsWithCompletion:(void (^)(NSError *error))completion
{
    __weak __typeof(self) weakSelf = self;
    NSString *formatString = [WRNetworkService getFormatURLString:urlGetExpertList];
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
            
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSDictionary *obj in expertArray)
            {
                WRExpert *object = [[WRExpert alloc] initWithDictionary:obj];
                [dataArray addObject:object];
            }
            weakSelf.expertArray = dataArray;
            
            error = nil;
        } while (NO);
        
        if (completion)
        {
            completion(error);
        }
    }];
}

-(void)fetchExpertListWithCompletion:(void (^)(NSError *error))completion
{
    __weak __typeof(self) weakSelf = self;
    NSString *formatString = [WRNetworkService getFormatURLString:urlGetList];
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
            
            NSMutableArray *dataArray = [NSMutableArray array];
            for(NSDictionary *obj in expertArray)
            {
                WRExpert *object = [[WRExpert alloc] initWithDictionary:obj];
                [dataArray addObject:object];
            }
            weakSelf.expertList = dataArray;
            
            error = nil;
        } while (NO);
        
        if (completion)
        {
            completion(error);
        }
    }];
}
@end
