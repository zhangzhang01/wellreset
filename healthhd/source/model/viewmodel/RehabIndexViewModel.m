//
//  RehabIndexViewModel.m
//  rehab
//
//  Created by 何寻 on 8/15/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "RehabIndexViewModel.h"

@implementation RehabIndexViewModel

-(void)fetchDataWithCompletion:(void (^)(NSError * _Nullable))completion {
    __weak __typeof(self) weakSelf = self;
    NSString *urlString = [WRNetworkService getFormatURLString:urlTreatIndex];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
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
            NSMutableArray *dataArray = [NSMutableArray array];
            NSArray *array = dict[@"proTreat"];
            for(NSDictionary *dict in array) {
                WRRehabDisease *object = [[WRRehabDisease alloc] initWithDictionary:dict];
                [dataArray addObject:object];
            }
            weakSelf.proTreatDiseaseArray = dataArray;
            
            dataArray = [NSMutableArray array];
            array = dict[@"treat"];
            for(NSDictionary *dict in array) {
                WRRehabDisease *object = [[WRRehabDisease alloc] initWithDictionary:dict];
                [dataArray addObject:object];
            }
            weakSelf.treatDiseaseArray = dataArray;
            
            dataArray = [NSMutableArray array];
            array = dict[@"banner"];
            for(NSDictionary *dict in array) {
                WRBannerInfo *object = [[WRBannerInfo alloc] initWithDictionary:dict];
                [dataArray addObject:object];
            }
            weakSelf.bannerArray = dataArray;
            
            error = nil;
        } while (NO);
        
        if (completion) {
            completion(error);
        }
    }];
}

@end
