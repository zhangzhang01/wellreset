//
//  Challenge.h
//  rehab
//
//  Created by 何寻 on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRObject.h"
#import "WRTreat.h"

@interface ChallengeGroup : NSObject

@property(nonatomic, copy) NSString *uuid, *name, *parentId;
@property(nonatomic) NSInteger level, time;
@property(nonatomic) NSArray<WRTreatRehabStage*> *videos;
@property(nonatomic) BOOL isLocked;

@end