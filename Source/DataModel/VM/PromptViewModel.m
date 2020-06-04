//
//  PromptViewModel.m
//  rehab
//
//  Created by yongen zhou on 2017/4/17.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "PromptViewModel.h"

@implementation PromptViewModel
+(void)fetchRehaPromptcompletion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlGetRehabProbt];
    
    NSString * strUrl = [NSString stringWithFormat:@"%@", formatUrl];
    
    __weak __typeof(self) weakSelf = self;
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
        do {
            if(error)
            {
                break;
            }
            
            error = [[NSError alloc] initWithDomain:strUrl code:-1 userInfo:nil];
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            NSLog(@"debugresu == %@",parser.resultObject);
            NSString *errorString = nil;
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            AppDelegate* app = [UIApplication sharedApplication].delegate;
            app.probt = parser.resultObject ;
            
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];
}
@end
