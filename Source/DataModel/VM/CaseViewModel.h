//
//  CaseViewModel.h
//  rehab
//
//  Created by yongen zhou on 2017/3/18.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseListViewModel.h"

@interface CaseViewModel : WRBaseListViewModel
@property (nonatomic, strong) NSMutableArray *caseArray;

-(void)fetchCasesWithCompletion:(void(^)(NSError* error))completion;
@end
