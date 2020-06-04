//
//  WRBaseListViewModel.m
//
//
//  Created by Matech on 16/2/18.
//  Copyright © 2016年 X.H. All rights reserved.
//

#import "WRBaseListViewModel.h"

@implementation WRBaseListViewModel

-(void)clearData {
    [self.dataArray removeAllObjects];
    self.isLastPage = NO;
    _pageNO = 0;
}

-(instancetype)init {
    if(self = [super init]) {
        _pageNO = 0;
        _pageSize =  20;
        _dataArray = [NSMutableArray array];
        self.isLastPage = NO;
    }
    return self;
}

-(void)fetchDataWithBlock:(ViewModeLoadCompleteBlock)block {
    
}

- (void)fetchDataWithCompletion:(ViewModeLoadCompleteBlock)completion urlString:(NSString *)urlString templateBlock:(NSObject* (^)(id objectOffArray))block useCache:(BOOL)flag{
    __weak __typeof(self) weakSelf = self;
    [WRBaseRequest request:urlString shouldUseCache:flag result:^(id responseObject, NSError *error) {
        do {
            if(error)
            {
                break;
            }
            
            error = [[NSError alloc] initWithDomain:urlString code:-1 userInfo:nil];
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                break;
            }
            
            NSArray *newsArray = parser.resultObject;
            for(NSDictionary *dict in newsArray)
            {
                if (block) {
                    NSObject *obj = block(dict);
                    if (obj) {
                        [weakSelf.dataArray addObject:obj];
                    }
                }
            }
            if(newsArray.count != _pageSize)
            {
                weakSelf.isLastPage = YES;
            }
            if(newsArray.count > 0)
            {
                _pageNO++;
            }
            error = nil;
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}

-(void)deleteObjectWithIndex:(NSUInteger)index completeBlock:(ViewModeLoadCompleteBlock)block {
    
}

@end
