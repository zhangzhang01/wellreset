//
//  WRProTreatQuestionController.h
//  rehab
//
//  Created by Matech on 3/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRBaseViewController.h"
#import "WRProTreatViewModel.h"

@interface WRProTreatQuestionController : WRViewController

@property(nonatomic, weak) WRRehabDisease *proTreatDisease;

- (instancetype)initWithProTreatViewModel:(id)viewModel proTreatDisease:(id)proTreatDisease;
@property(nonatomic) NSUInteger stage;

@end
