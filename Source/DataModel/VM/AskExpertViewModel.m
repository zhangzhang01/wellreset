//
//  AskExpertViewModel.m
//  rehab
//
//  Created by herson on 2016/11/21.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "AskExpertViewModel.h"
#import "ShareUserData.h"

@implementation AskExpertViewModel
-(instancetype)init {
    if(self = [super init]){
    }
    return self;
}

-(void)fetchDataWithBlock:(ViewModeLoadCompleteBlock)block {
    
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlUserAskData];
    
    NSUInteger offset = _pageNO*_pageSize;
    NSString *strUrl = [NSString stringWithFormat:formatUrl,  offset, _pageSize];
    
    __weak __typeof(self) weakSelf = self;
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
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
            
            NSArray *newsArray = parser.resultObject;
            for(NSDictionary *obj in newsArray)
            {
                WRExpertReply *object = [[WRExpertReply alloc] initWithDictionary:obj];
                NSDictionary* info = obj [@"askInfo"];
                if ([info isKindOfClass:[NSDictionary class]]) {
                    object.userName = info[@"userName"];
                    object.headImage = info[@"headImageUrl"];
                }
                [weakSelf.dataArray addObject:object];
            }
            if(newsArray.count != _pageSize)
            {
                weakSelf.isLastPage = YES;
            }
            if(newsArray.count > 0)
            {
                _pageNO++;
            }
            weakSelf.isLastPage = YES;
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];
}

-(void)fetchIndexDatapage:(int)page pageSize:(int)rows WithBlock:(ViewModeLoadCompleteBlock)block {
    
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlAskIndexData];
    
    NSUInteger offset = _pageNO*_pageSize;
    NSString *strUrl = [NSString stringWithFormat:formatUrl,page,rows];
    
    __weak __typeof(self) weakSelf = self;
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
        do {
            if(error)
            {
                break;
            }
//            NSLog(@"%@",responseObject);
            error = [[NSError alloc] initWithDomain:strUrl code:-1 userInfo:nil];
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                break;
            }
            
            NSArray *newsArray = parser.resultObject;
           NSMutableArray* arry = [NSMutableArray array];
            for(NSDictionary *obj in newsArray)
            {
                WRExpertReply *object = [[WRExpertReply alloc] initWithDictionary:obj];
                NSDictionary* info = obj [@"askInfo"];
                if ([info isKindOfClass:[NSDictionary class]]) {
                    object.userName = info[@"userName"];
                    object.headImage = info[@"headImageUrl"];
                }
                
                [arry addObject:object];
            }
            weakSelf.dataArray = arry;
//            if(newsArray.count != _pageSize)
//            {
//                weakSelf.isLastPage = YES;
//            }
//            if(newsArray.count > 0)
//            {
//                _pageNO++;
//            }
//            weakSelf.isLastPage = YES;
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];
}

+(void)fetchSelfRemainCountWithCompletion:(void (^)(NSError *))completion
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:getRemin];
    
    NSString *strUrl = formatUrl;
    
    [WRBaseRequest request:strUrl shouldUseCache:NO result:^(id responseObject, NSError *error) {
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

            [ShareUserData userData].askExpertRemainCount = [[parser.resultObject objectForKey:@"remain"] integerValue];
            
            error = nil;
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

+(void)askExpert:(NSString *)content completion:(void (^)(NSError * _Nonnull))completion {
    
    NSString *formatString = [WRNetworkService getFormatURLString:urlUserAskExpert];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:@{@"content":content}];
    [WRNetworkService fillPostParam:params];
    
    NSString *strUrl = formatString;
    [WRBaseRequest post:strUrl params:params result:^(id responseObject, NSError *error) {
        NSString *errorString = nil;
        do {
            if(error)
            {
                error = [self defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            error = nil;
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

@end
