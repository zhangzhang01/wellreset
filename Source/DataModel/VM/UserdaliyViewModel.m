//
//  UserdaliyViewModel.m
//  rehab
//
//  Created by yongen zhou on 2017/3/15.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "UserdaliyViewModel.h"

@implementation UserdaliyViewModel
-(void)fetchUserdaliyWithCompletion:(void (^)(NSError*))completion
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:getDaily];
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
            NSDictionary* dict = parser.resultObject[@"userDaily"];
            self.myDaliy = [[WRDaliy alloc]initWithDictionary:dict];
            
            
            
            error = nil;
            
        } while (NO);
        
        if (completion) {
            completion(error);
        }
    }];

}
@end
