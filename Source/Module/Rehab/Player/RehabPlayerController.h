//
//  RehabPlayerController.h
//  rehab
//
//  Created by herson on 8/20/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBaseViewController.h"
#import "RehabObject.h"

typedef NS_ENUM(NSInteger, RehabPlayerControllerType)
{
    RehabPlayerControllerTypeTreat,
    RehabPlayerControllerTypeProTreat,
};

@interface RehabPlayerController : WRViewController

@property(nonatomic)RehabPlayerControllerType type;

-(instancetype)initWithVideoSets:(NSArray<WRTreatRehabStageVideo*>*)videoSets type:(RehabPlayerControllerType)type treat:(NSString *)treatName;

@property(nonatomic, copy)void(^completionBlock)(NSTimeInterval countTime);
@property(nonatomic, copy)void(^completionwithdieaseBlock)(NSTimeInterval countTime,WRRehabDisease* disease);
@property WRRehab* rehab;
@end
