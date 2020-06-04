//
//  PreventViewModel.m
//  rehab
//
//  Created by herson on 2016/11/16.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "PreventViewModel.h"
#import "WRJsonParser.h"
#import "WRNetworkService.h"
#import "WRBaseRequest.h"

@implementation PreventViewModel

-(instancetype)init {
    if (self = [super init]) {
        _scenes = [NSMutableArray array];
    }
    return self;
}

-(void)fetchDataWithCompletion:(void (^)(NSError*))completion {
    NSString *formatUrl = [WRNetworkService getFormatURLString:urlGetPrevention];
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
            
            NSArray *newsArray = parser.resultObject;
            if ([newsArray isKindOfClass:[NSArray class]])
            {
                if (newsArray.count > 0) {
                    [weakSelf.scenes removeAllObjects];
                    
                    for(NSDictionary *obj in newsArray)
                    {
                        WRScene *scene = [[WRScene alloc] initWithDictionary:obj];
                        [weakSelf.scenes addObject:scene];
                    }
                }
            }
            
            error = nil;
            
        } while (NO);
        
        if (completion) {
            completion(error);
        }
    }];
}
@end
