//
//  WRNewsListViewModel.m
//  rehab
//
//  Created by 何寻 on 6/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRNewsListViewModel.h"

@implementation WRNewsListViewModel

-(instancetype)init {
    if(self = [super init]){
    }
    return self;
}

-(void)fetchNewsListWithTypeId:(NSString*)typeId completion:(ViewModeLoadCompleteBlock)block {
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlGetNewsList];
    
    NSUInteger offset = _pageNO*_pageSize;
    NSString *strUrl = [NSString stringWithFormat:formatUrl, typeId, offset, _pageSize];
    
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
            

            NSArray *array = parser.resultObject;
            for(NSDictionary *obj in array)
            {
                WRArticle *object = [[WRArticle alloc] initWithDictionary:obj];
                [weakSelf.dataArray addObject:object];
            }
            if(array.count != _pageSize)
            {
                weakSelf.isLastPage = YES;
            }
            if(array.count > 0)
            {
                _pageNO++;
            }
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];
}

@end
