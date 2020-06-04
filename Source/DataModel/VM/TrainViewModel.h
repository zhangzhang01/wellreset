//
//  TrainViewModel.h
//  rehab
//
//  Created by yongen zhou on 2017/3/14.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseListViewModel.h"

@interface TrainViewModel : WRBaseListViewModel
@property(nonatomic) NSMutableDictionary * DataDic;
@property(nonatomic) NSMutableArray * chartArry;
-(void)fetchTrainListWithDay:(NSString*)Day completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchTrainListWithWeek:(NSString*)Week completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchTrainListWithMonth:(NSString*)Moth completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchTrainListcompletion:(ViewModeLoadCompleteBlock)block;
@end
