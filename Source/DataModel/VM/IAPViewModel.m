//
//  IAPViewModel.m
//  rehab
//
//  Created by yefangyang on 2017/1/4.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "IAPViewModel.h"

@implementation IAPViewModel

+ (void)testIAPWithsn:(NSString *)sn productId:(NSString *)productId receipt:(NSString *)receipt completion:(void (^)(NSError *, id))completion{
    NSString *formatString = [WRNetworkService getFormatURLString:urlIAPOrderProduct];
    NSString *strUrl = [NSString stringWithFormat:formatString, sn, productId, receipt];
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
            
//            NSDictionary *dict = parser.resultObject;
//            proTreatReha = [[WRRehab alloc] initWithDictionary:dict];
            
            error = nil;
            
        } while (NO);
        if (completion) {
            completion(error, proTreatReha);
        }
    }];
}





+ (void)SureIAPWithurl:(NSString *)url orderId:(NSString *)orderId receipt:(NSString *)receipt completion:(void (^)(NSError *, id))completion{
    NSString *formatString = [WRNetworkService getFormatURLString:getapple];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@", formatString];
    
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    dic[@"url"] = url;
    dic[@"code"] = receipt;
    dic[@"orderId"] = orderId;
    [WRNetworkService fillPostParam:dic];
    
    [WRBaseRequest post:formatString params:dic result:^(id responseObject, NSError *error) {
      
        
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
            
            //            NSDictionary *dict = parser.resultObject;
            //            proTreatReha = [[WRRehab alloc] initWithDictionary:dict];
            
            error = nil;
            
        } while (NO);
        if (completion) {
            completion(error, proTreatReha);
        }
    }];
}


@end
