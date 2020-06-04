//
//  WRProTreatQuestionDetailController.h
//  rehab
//
//  Created by yefangyang on 16/9/12.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@class WRProTreatQuestion;
@interface WRProTreatQuestionDetailController : WRViewController

@property(nonatomic, copy) void(^completion)(NSArray<WRProTreatAnswer*> *answers);
- (instancetype)initWithProTreatQuestion:(WRProTreatQuestion *)proTreatQuestion selectedArray:(NSMutableArray *)selectedArray;
@end
