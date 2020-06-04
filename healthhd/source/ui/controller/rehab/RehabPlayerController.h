//
//  RehabPlayerController.h
//  rehab
//
//  Created by 何寻 on 8/20/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBaseViewController.h"
#import "WRTreat.h"

typedef NS_ENUM(NSInteger, RehabPlayerControllerType)
{
    RehabPlayerControllerTypeTreat,
    RehabPlayerControllerTypeProTreat,
};

@interface RehabPlayerController : WRViewController

@property(nonatomic)RehabPlayerControllerType type;

-(instancetype)initWithVideoSets:(NSArray<WRTreatRehabStageVideo*>*)videoSets type:(RehabPlayerControllerType)type;

@property(nonatomic, copy)void(^completionBlock)(NSTimeInterval countTime);

@end
