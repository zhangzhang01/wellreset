//
//  QuestionNewResultController.h
//  rehab
//
//  Created by yongen zhou on 2017/5/10.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"
#import "ProTreatViewModel.h"
@interface QuestionNewResultController : WRViewController
@property NSMutableArray* QusetionArr;
@property(nonatomic)ProTreatViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *answerArray;
@property(nonatomic) WRRehabDisease *proTreatDisease;
@property(nonatomic) NSUInteger stage;
@property(nonatomic) BOOL isnew;

@end
