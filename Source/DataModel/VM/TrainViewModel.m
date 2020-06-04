//
//  TrainViewModel.m
//  rehab
//
//  Created by yongen zhou on 2017/3/14.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "TrainViewModel.h"
#import "ShareUserData.h"
#import "WRObject.h"
@implementation TrainViewModel
-(instancetype)init {
    if(self = [super init]){
    }
    return self;
}
-(void)fetchTrainListWithDay:(NSString*)Day completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:getDailyByDay];
    NSUInteger offset = _pageSize*_pageNO;
    NSString * strUrl = [NSString stringWithFormat:formatUrl,[WRUserInfo selfInfo].userId,Day,_pageNO,_pageSize];
    
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
            
            
            NSDictionary* daydic = parser.resultObject[@"userDailyDay"];
            
            NSArray* chardata = daydic[@"days"];
            NSLog(@"debug666 == %@",chardata);
            NSMutableArray* arry = [NSMutableArray array];
            for(NSDictionary *dic in chardata)
            {
                WRTrainChartData * charData = [[WRTrainChartData alloc]initWithDictionary:dic];
                [arry addObject:charData];
                
            }
            weakSelf.chartArry = arry;
            
            NSArray* triandata = daydic[@"detail"];
            
               self.DataDic = [NSMutableDictionary dictionary];
            
            
            NSMutableArray* traindayArr = [NSMutableArray array];
            for(NSDictionary *dic in triandata)
            {
                WRTrainData * TrainData = [[WRTrainData alloc]initWithDictionary:dic];
                [traindayArr addObject:TrainData];
               
                
            }
            [self.DataDic setObject:traindayArr forKey:Day];
            weakSelf.chartArry = arry;
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];

    
    
    
}
-(void)fetchTrainListWithWeek:(NSString*)Week completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:getDailyByWeek];
    NSUInteger offset = _pageSize*_pageNO;
    NSString * strUrl = [NSString stringWithFormat:formatUrl,[WRUserInfo selfInfo].userId,Week,_pageNO,_pageSize];
    
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
            
            
            NSDictionary* daydic = parser.resultObject[@"userDailyWeek"];
            
            NSArray* chardata = daydic[@"weeks"];
            NSLog(@"debug == %@",chardata);
            NSMutableArray* arry = [NSMutableArray array];
            for(NSDictionary *dic in chardata)
            {
                WRTrainChartData * charData = [[WRTrainChartData alloc]initWithDictionary:dic];
                [arry addObject:charData];
                
            }
            weakSelf.chartArry = arry;
            
            NSArray* triandata = daydic[@"detail"];
            
                self.DataDic = [NSMutableDictionary dictionary];
            
            
            NSMutableArray* traindayArr = [NSMutableArray array];
            NSString* date =@"" ;
            for(NSDictionary *dic in triandata)
            {
                WRTrainData * TrainData = [[WRTrainData alloc]initWithDictionary:dic];
                if ([TrainData.date isEqualToString:date]) {
                    [traindayArr addObject:TrainData];
                    
                }
                else
                {
                    if (![date isEqualToString:@""]) {
                        [self.DataDic setObject:traindayArr.copy forKey:date];
                    }
                    [traindayArr removeAllObjects];
                    date = TrainData.date;
                    [traindayArr addObject:TrainData ];
                    
                }
                
                
            }
            
                [self.DataDic setObject:traindayArr.copy forKey:date];
            
            
            weakSelf.chartArry = arry;
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];

    
    
    
    
}
-(void)fetchTrainListWithMonth:(NSString*)Moth completion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:getDailyByMonth];
    NSUInteger offset = _pageSize*_pageNO;
    NSString * strUrl = [NSString stringWithFormat:formatUrl,[WRUserInfo selfInfo].userId,Moth,_pageNO,_pageSize];
    
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
            
            
            NSDictionary* daydic = parser.resultObject[@"userDailyMonth"];
            
            NSArray* chardata = daydic[@"months"];
            NSLog(@"debug == %@",chardata);
            NSMutableArray* arry = [NSMutableArray array];
            for(NSDictionary *dic in chardata)
            {
                WRTrainChartData * charData = [[WRTrainChartData alloc]initWithDictionary:dic];
                [arry addObject:charData];
                
            }
            weakSelf.chartArry = arry;
            
            NSArray* triandata = daydic[@"detail"];
            
            self.DataDic = [NSMutableDictionary dictionary];
            
            
            NSMutableArray* traindayArr = [NSMutableArray array];
            NSString* date =@"" ;
            for(NSDictionary *dic in triandata)
            {
                WRTrainData * TrainData = [[WRTrainData alloc]initWithDictionary:dic];
                if ([TrainData.date isEqualToString:date]) {
                    [traindayArr addObject:TrainData];
                    
                }
                else
                {
                    if (![date isEqualToString:@""]) {
                        [self.DataDic setObject:traindayArr.copy forKey:date];
                    }
                    
                    [traindayArr removeAllObjects];
                    date = TrainData.date;
                    [traindayArr addObject:TrainData ];
                    
                }
                
                
            }
           
                [self.DataDic setObject:traindayArr.copy forKey:date];
            
            weakSelf.chartArry = arry;
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];

}

-(void)fetchTrainListcompletion:(ViewModeLoadCompleteBlock)block
{
    NSString *formatUrl = [WRNetworkService getFormatURLString:getDailyAll];
    NSString * strUrl = [NSString stringWithFormat:formatUrl,_pageNO,_pageSize];
    
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
            
            
            NSDictionary* daydic = parser.resultObject[@"userDailyAll"];
            
            NSArray* chardata = daydic[@"days"];
            NSLog(@"debug == %@",chardata);
            NSMutableArray* arry = [NSMutableArray array];
            WRTrainChartData * charData = [WRTrainChartData new];
            charData.day = daydic[@"days"] ;
            charData.trainTime =[daydic[@"minutes"] intValue]/60;
            charData.trainCount = [daydic[@"count"] intValue];
            [arry addObject:charData];
            weakSelf.chartArry = arry;
            
            NSArray* triandata = daydic[@"detail"];
            self.DataDic = [NSMutableDictionary dictionary];
            
            
            NSMutableArray* traindayArr = [NSMutableArray array];
            NSString* date =@"" ;
            for(NSDictionary *dic in triandata)
            {
                WRTrainData * TrainData = [[WRTrainData alloc]initWithDictionary:dic];
                if ([TrainData.date isEqualToString:date]) {
                    [traindayArr addObject:TrainData];
                    
                }
                else
                {
                    if (![date isEqualToString:@""]) {
                        [self.DataDic setObject:traindayArr.copy forKey:date];
                    }
                    
                    [traindayArr removeAllObjects];
                    date = TrainData.date;
                    [traindayArr addObject:TrainData ];
                    
                }
                
                
            }
            
            [self.DataDic setObject:traindayArr.copy forKey:date];//            [self.DataDic setObject:traindayArr forKey:@"all"];
            weakSelf.chartArry = arry;
            
            
            error = nil;
            
        } while (NO);
        if (block) {
            block(error);
        }
    }];

    
    
}


@end
