//
//  UserdaliyViewModel.h
//  rehab
//
//  Created by yongen zhou on 2017/3/15.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRViewModel.h"

@interface UserdaliyViewModel : WRViewModel
@property(nonatomic)WRDaliy* myDaliy;

-(void)fetchUserdaliyWithCompletion:(void (^)(NSError*))completion;
@end
