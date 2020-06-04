//
//  ExpertViewModel.h
//  rehab
//
//  Created by yefangyang on 2016/10/10.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRViewModel.h"
#import "RehabObject.h"

@interface ExpertViewModel : WRViewModel

@property (nonatomic, strong) NSArray<WRExpert*> *expertArray, *expertList;

-(void)fetchExpertsWithCompletion:(void (^)(NSError *error))completion;

-(void)fetchExpertListWithCompletion:(void (^)(NSError *error))completion;
@end
