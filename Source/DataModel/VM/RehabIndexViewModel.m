//
//  RehabIndexViewModel.m
//  rehab
//
//  Created by herson on 8/15/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "RehabIndexViewModel.h"
#import "ShareData.h"
@implementation RehabIndexViewModel

-(void)fetchDataWithCompletion:(void (^)(NSError * _Nullable))completion {
    __weak __typeof(self) weakSelf = self;
    NSString *urlString = [WRNetworkService getFormatURLString:urlUserPerson];
    [WRBaseRequest request:urlString shouldUseCache:YES result:^(id responseObject, NSError *error) {
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
            ShareData* data = [ShareData data];
            NSDictionary *dict = parser.resultObject;
            NSMutableArray *dataArray = [NSMutableArray array];
            NSArray *array = dict[@"proTratDiseases"];
            for(NSDictionary *dict in array) {
                WRRehabDisease *object = [[WRRehabDisease alloc] initWithDictionary:dict];
                [object setIsProTreat:YES];
                [dataArray addObject:object];
            }
            weakSelf.proTreatDiseaseArray = dataArray;
            data.proTreatDisease = dataArray;
            
            dataArray = [NSMutableArray array];
            array = dict[@"treatDiseases"];
            for(NSDictionary *dict in array) {
                WRRehabDisease *object = [[WRRehabDisease alloc] initWithDictionary:dict];
                [dataArray addObject:object];
            }
            weakSelf.treatDiseaseArray = dataArray;
            data.treatDisease = dataArray;
            
            dataArray = [NSMutableArray array];
            array = dict[@"classifies"];
            for(NSDictionary *dict in array) {
                WRTreatclass *object = [[WRTreatclass alloc] initWithDictionary:dict];
                [dataArray addObject:object];
            }
            data.treatclassArry = dataArray;
            
            
            error = nil;
        } while (NO);
        
        if (completion) {
            completion(error);
        }
    }];
}

@end
