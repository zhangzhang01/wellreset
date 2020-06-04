//
//  ChallengePlayerController.h
//  rehab
//
//  Created by herson on 8/24/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface ChallengePlayerController : WRViewController

-(instancetype)initWithStage:(WRTreatRehabStage*)stage isUnlock:(BOOL)isunlock;

@property(nonatomic, copy) void(^completion)(BOOL flag);
@property WRTreatRehabStageVideo * video;
@property UIImage * head;
@end
