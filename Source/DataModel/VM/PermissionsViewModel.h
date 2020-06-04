//
//  PermissionsViewModel.h
//  rehab
//
//  Created by 何寻 on 2016/11/24.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRBaseListViewModel.h"

@interface PermissionsViewModel : WRBaseListViewModel

@property (nonatomic, strong) NSArray *ruleArray;

-(void)fetchAllPermissionsWithCompletion:(void(^)(NSError* error))completion;
-(void)fetchAllLevelRuleWithCompletion:(void(^)(NSError* error))completion;
@end
