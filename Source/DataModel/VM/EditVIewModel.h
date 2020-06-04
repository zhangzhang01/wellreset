//
//  EditVIewModel.h
//  rehab
//
//  Created by yongen zhou on 2017/3/19.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRViewModel.h"

@interface EditVIewModel : WRViewModel
-(void)fetchEditRehabWithMap:(NSString*)Map  completion:(ViewModeLoadCompleteBlock)block;
-(void)fetchDeleRehabWithRehabid:(NSString*)Rehabid  completion:(ViewModeLoadCompleteBlock)block;
@end
