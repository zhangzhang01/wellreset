//
//  QuestionareIndexController.h
//  rehab
//
//  Created by Matech on 3/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRBannerViewController.h"
#import "ProTreatViewModel.h"

@interface QuestionareIndexController : WRBannerViewController

-(instancetype)initWithProTreatViewModel:(ProTreatViewModel*)viewModel proTreatDisease:(id)disease style:(QuestionControllerStyle)style;
@property(nonatomic) NSUInteger stage;
@property BOOL isnew;

@end
