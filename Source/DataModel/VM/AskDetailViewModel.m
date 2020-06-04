//
//  AskDetailViewModel.m
//  rehab
//
//  Created by yongen zhou on 2017/5/4.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "AskDetailViewModel.h"

@implementation AskDetailViewModel
-(void)fetchAddvoteWithReaplyid:(NSString*)Reaplyid  completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlAddVote];
    
    NSString * strUrl = [NSString stringWithFormat:formatUrl,Reaplyid];
    
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

-(void)fetchCommentListWithReply:(NSString*)Reply completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:getReplyDetail];
    NSUInteger offset = 1;
    NSString * strUrl = [NSString stringWithFormat:formatUrl,Reply,1,20];
    
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
            self.isshow = [parser.resultObject[@"isShow"] intValue];
            self.content = parser.resultObject[@"content"];
            self.content1 = parser.resultObject[@"content1"];
            self.content2 = parser.resultObject[@"content2"];
            self.ifUpvoted = [parser.resultObject[@"ifUpvoted"] boolValue];
            self.question = parser.resultObject[@"question"];
            self.totalcount = [dic[@"total"] integerValue] ;
            NSArray* chardata = dic[@"comments"];
            NSLog(@"debug == %@",chardata);
            self.ListArry = [NSMutableArray array];
            for(NSDictionary *dic in chardata)
            {
                WRAskComment * charData = [[WRAskComment alloc]initWithDictionary:dic];
                
                [self.ListArry addObject:charData];
                
            }
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];
    
}

-(void)fetchAddCommentWithReply:(NSString*)reply context:(NSString*)context completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:addReplyComment];
    
    NSString * strUrl = [NSString stringWithFormat:@"%@", formatUrl];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    dic[@"replyId"] = reply;
    dic[@"content"] = context;
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







@end
