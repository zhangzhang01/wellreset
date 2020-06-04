//
//  WRTreat.h
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "WRObject.h"
#import "WRUserInfo.h"

@interface WRTreatRehabStageVideoTherbligImage : WRObject
@end

@interface WRTreatRehabStageVideo : WRObject
@property(nonatomic, copy) NSString *videoUrl, *thumbnailUrl, *videoName, *notice, *attention, *createTime;
@property(nonatomic) NSArray<WRTreatRehabStageVideoTherbligImage*>* images;
@property(nonatomic) NSArray<WRObject*> *attributes;
@property(nonatomic) NSInteger duration, time, difficulty;
@end

@interface WRTreatRehabStage : WRObject
@property(nonatomic, assign) NSUInteger time, repeatCount, stage, difficulty, refValue, userValue;
@property(nonatomic, copy) NSString *content, *refUnit, *videoId;
@property(nonatomic) WRTreatRehabStageVideo *mtWellVideoInfo;
@end


