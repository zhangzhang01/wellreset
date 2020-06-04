

//
//  EditVIewModel.m
//  rehab
//
//  Created by yongen zhou on 2017/3/19.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "EditVIewModel.h"

@implementation EditVIewModel
-(void)fetchEditRehabWithMap:(NSString*)Map  completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlEditRehab];
    
    NSString * strUrl = [NSString stringWithFormat:formatUrl,Map];
    
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
            
            
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];

}
-(void)fetchDeleRehabWithRehabid:(NSString*)Rehabid  completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlDeleteRehab];
    
    NSString * strUrl = [NSString stringWithFormat:formatUrl,Rehabid];
    
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
            
            
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];

}
@end
