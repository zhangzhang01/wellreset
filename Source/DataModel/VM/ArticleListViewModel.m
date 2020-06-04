//
//  ArticleListViewModel.m
//  rehab
//
//  Created by herson on 6/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ArticleListViewModel.h"

@implementation ArticleListViewModel

-(instancetype)init {
    if(self = [super init]){
    }
    return self;
}

-(void)fetchNewsListWithTypeId:(NSString*)typeId completion:(ViewModeLoadCompleteBlock)block {
    
//     NSString *urlString = @"http://192.168.0.163:9027/youth/discover/overall?userId=ceeff4e3-f342-4f56-b45c-f660651b121e&type= &pageOne=1&pageRow=10";
    NSString *formatUrl = [WRNetworkService getFormatURLString:overall];
    NSUInteger offset = self.pageNOPublic*_pageNO;
    NSString *urlString = [NSString stringWithFormat:formatUrl,[WRUserInfo selfInfo].userId,typeId,@"1",@"100"];
//    NSString *strUrl = [NSString stringWithFormat:formatUrl, typeId, offset, self.pageNOPublic];
//    NSLog(@"%@==debug",strUrl);
    __weak __typeof(self) weakSelf = self;
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
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
            

            NSDictionary *dic = parser.resultObject;
            if (self.pageNOPublic==2) {
                [weakSelf.dataArray removeAllObjects ];
            }
            NSArray *blockArray = dic[@"list"];
            for(NSDictionary *obj in blockArray)
            {
                WRArticle *object = [[WRArticle alloc] initWithDictionary:obj];
                               
                               [weakSelf.dataArray addObject:object];
                
               
            }
            if (self.pageNOPublic!=2&&weakSelf.dataArray.count==2) {
                block(error);
            }
//            if(array.count != _pageSize&&self.pageNOPublic!=2)
//            {
//                weakSelf.isLastPage = YES;
//            }
//            if(array.count > 0&&self.pageNOPublic!=2)
//            {
//                _pageNO++;
//            }
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];
}

-(void)fetchNewsIndexcompletion:(ViewModeLoadCompleteBlock)block {
//    NSString *formatUrl = [WRNetworkService getFormatURLString:getShareList2];
    
     NSString *formatUrl = [WRNetworkService getFormatURLString:overall];
       NSUInteger offset = self.pageNOPublic*_pageNO;
       NSString *urlString = [NSString stringWithFormat:formatUrl,[WRUserInfo selfInfo].userId,@"",@"1",@"100"];
    
    __weak __typeof(self) weakSelf = self;
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
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
            
            
            NSArray *array = parser.resultObject;
            if (self.pageNOPublic==2) {
                [weakSelf.dataArray removeAllObjects ];
            }
            for(NSDictionary *obj in array)
            {
                WRArticle *object = [[WRArticle alloc] initWithDictionary:obj];
                
                [weakSelf.dataArray addObject:object];
                
                
            }
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];
}



@end
