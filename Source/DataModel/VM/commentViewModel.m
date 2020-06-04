//
//  commentViewModel.m
//  rehab
//
//  Created by yongen zhou on 2017/3/17.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "commentViewModel.h"

@implementation commentViewModel
-(instancetype)init {
    if(self = [super init]){
        self.ListArry = [NSMutableArray array];
    }
    return self;
}
-(void)fetchCommentListWithWechat:(NSString*)Wechat completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:getCommentList];
    NSUInteger offset = _pageSize*_pageNO;
    NSString * strUrl = [NSString stringWithFormat:formatUrl,Wechat,_pageNO,_pageSize];
    
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
            if(!parser.isSuccess)
            {
                break;
            }
            
            
            NSDictionary* dic = parser.resultObject;
            self.totalcount = [dic[@"total"] integerValue] ;
            NSArray* chardata = dic[@"commentList"];
            NSLog(@"debug == %@",chardata);
            self.ListArry = [NSMutableArray array];
            for(NSDictionary *dic in chardata)
            {
                WRComment * chatData = [[WRComment alloc]initWithDictionary:dic];
                NSDictionary* pare = dic[@"parent"];
                if ([pare isKindOfClass:[NSDictionary class]]&&pare.count>0) {
                   WRComment * chid = [[WRComment alloc]initWithDictionary:pare];
                    chatData.chid = chid;
                }
                
                [self.ListArry addObject:chatData];
                
            }
            
                       
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];

}

-(void)fetchAddCommentWithWechat:(NSString*)Wechat context:(NSString*)context completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlAddComment];
    
    NSString * strUrl = [NSString stringWithFormat:formatUrl,Wechat,context];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    dic[@"wechatId"] = Wechat;
    dic[@"context"] = context;
    [WRNetworkService fillPostParam:dic];
    __weak __typeof(self) weakSelf = self;
    
    [WRBaseRequest post:formatUrl params:dic result:^(id responseObject, NSError *error) {
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



-(void)fetchAddchidCommentWithWechat:(NSString*)Wechat uuid:(NSString*)uuid context:(NSString*)context completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlAddComment];
    
    NSString * strUrl = [NSString stringWithFormat:formatUrl,Wechat,context];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    dic[@"wechatId"] = Wechat;
    dic[@"context"] = context;
    dic[@"uuid"] = uuid;
    [WRNetworkService fillPostParam:dic];
    __weak __typeof(self) weakSelf = self;
    
    [WRBaseRequest post:formatUrl params:dic result:^(id responseObject, NSError *error) {
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




-(void)fetchDelCommentWithuuid:(NSString*)uuid completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlDeleComment];
    
    NSString * strUrl = [NSString stringWithFormat:formatUrl,uuid];
    
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
