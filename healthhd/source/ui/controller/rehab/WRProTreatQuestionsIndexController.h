//
//  WRProTreatQuestionsIndexController.h
//  rehab
//
//  Created by Matech on 3/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRBannerViewController.h"
#import "WRProTreatViewModel.h"

@interface WRProTreatQuestionsIndexController : WRBannerViewController

-(instancetype)initWithProTreatViewModel:(WRProTreatViewModel*)viewModel proTreatDisease:(id)disease;
@property(nonatomic) NSUInteger stage;

@end
