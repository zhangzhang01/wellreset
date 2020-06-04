//
//  CaseViewModel.m
//  rehab
//
//  Created by yongen zhou on 2017/3/18.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "CaseViewModel.h"

@implementation CaseViewModel

-(instancetype)init
{
    if (self=[super init]) {
        self.caseArray = [NSMutableArray  array];
    }
    return self;
}

-(void)fetchCasesWithCompletion:(void(^)(NSError* error))completion
{

    NSString *formatString = [WRNetworkService getFormatURLString:urlGetCase];
    NSString *strUrl = [NSString stringWithFormat:@"%@", formatString];
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
            for (NSDictionary* dic in parser.resultObject) {
                WRcase* cas = [[WRcase alloc]initWithDictionary:dic];
                [self.caseArray addObject:cas];
            }
            
            
            
            //            NSDictionary *dict = parser.resultObject;
            //            proTreatReha = [[WRRehab alloc] initWithDictionary:dict];
            
            error = nil;
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];

    
    
    
}
@end
