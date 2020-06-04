//
//  AskExpertViewModel.h
//  rehab
//
//  Created by herson on 2016/11/21.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRBaseListViewModel.h"
#import "WRObject.h"
@interface AskExpertViewModel : WRBaseListViewModel

@property(nonatomic)NSInteger remain;

-(void)fetchIndexDatapage:(int)page pageSize:(int)rows WithBlock:(ViewModeLoadCompleteBlock)block;

-(void)fetchIndexDataWithBlock:(ViewModeLoadCompleteBlock)block;

+(void)fetchSelfRemainCountWithCompletion:(void(^)(NSError* error))completion;

+(void)askExpert:(NSString*)content completion:(void(^)(NSError* error))completion;

@end
