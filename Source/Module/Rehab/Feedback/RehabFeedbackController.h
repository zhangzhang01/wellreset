//
//  RehabFeedbackController.h
//  rehab
//
//  Created by Matech on 4/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRBaseViewController.h"
#import "RehabObject.h"
@interface RehabFeedbackController : WRScrollViewController

@property(nonatomic, copy) void(^completion)();

-(instancetype)initWithQuestions:(NSArray*)questionArray proTreatRehabId:(NSString*)indexId finishedState:(ProTreatFinishedState)state ;
@property WRRehab* rehab;

@end
