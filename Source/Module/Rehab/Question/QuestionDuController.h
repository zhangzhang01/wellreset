//
//  QuestionDuController.h
//  rehab
//
//  Created by yongen zhou on 2017/8/15.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"
#import "ProTreatViewModel.h"
@interface QuestionDuController : WRViewController
@property NSMutableArray* QusetionArr;
@property (nonatomic, strong) NSMutableArray *answerArray;
//@property (nonatomic)NSMutableArray * answerIds;
@property NSInteger index;
@property BOOL isfinish;
@property(nonatomic)ProTreatViewModel *viewModel;
@property(nonatomic) WRRehabDisease *proTreatDisease;
@property(nonatomic) NSUInteger stage;
@property(nonatomic) BOOL isnew;
@end
