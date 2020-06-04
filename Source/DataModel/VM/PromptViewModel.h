//
//  PromptViewModel.h
//  rehab
//
//  Created by yongen zhou on 2017/4/17.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRViewModel.h"

@interface PromptViewModel : WRViewModel
//@property (nonatomic, strong) NSString *probt;
+(void)fetchRehaPromptcompletion:(ViewModeLoadCompleteBlock)block;
@end
