//
//  QuestionController.h
//  rehab
//
//  Created by Matech on 3/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRBaseViewController.h"
#import "ProTreatViewModel.h"



@interface QuestionController : WRViewController

@property(nonatomic, weak) WRRehabDisease *proTreatDisease;

- (instancetype)initWithProTreatViewModel:(id)viewModel proTreatDisease:(id)proTreatDisease style:(QuestionControllerStyle)style;
@property(nonatomic) NSUInteger stage;
@property(nonatomic) BOOL newquestion;

@end
