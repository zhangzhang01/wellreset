//
//  WRFAQViewModel.m
//  rehab
//
//  Created by Matech on 3/10/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRFAQViewModel.h"

@implementation WRFAQViewModel

-(instancetype)init {
    if(self = [super init]){
    }
    return self;
}

-(void)fetchDataWithBlock:(ViewModeLoadCompleteBlock)block keyword:(NSString *)keyword {
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlGetFAQList];
    
    NSUInteger offset = _pageNO*_pageSize;
    NSString *strUrl = [NSString stringWithFormat:formatUrl,  offset, _pageSize];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"keyWords"] = keyword;
    [WRNetworkService fillPostParam:params];
    
    __weak __typeof(self) weakSelf = self;
    [WRBaseRequest post:strUrl params:params result:^(id responseObject, NSError *error) {
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
                WRFAQ *object = [[WRFAQ alloc] initWithDictionary:obj];
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

@end