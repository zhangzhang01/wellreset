//
//  ChallengePlayerController.h
//  rehab
//
//  Created by 何寻 on 8/24/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface ChallengePlayerController : WRViewController

-(instancetype)initWithStage:(WRTreatRehabStage*)stage;

@property(nonatomic, copy) void(^completion)(BOOL flag);

@end
