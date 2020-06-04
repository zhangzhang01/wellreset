//
//  WRScene.h
//  rehab
//
//  Created by herson on 2016/11/16.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRObject.h"

@class WRTreatRehabStageVideo;

@interface WRScene : WRObject

@property(nonatomic) NSArray<WRTreatRehabStageVideo*>* videos;
@property(nonatomic) NSString* attachfilepath;
@end
