//
//  ShareUserData.h
//  rehab
//
//  Created by 何寻 on 8/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRTreat.h"
#import "WRProTreat.h"
#import "WRObject.h"

@interface ShareUserData : NSObject

+(instancetype)userData;

@property(nonatomic)NSInteger rehabCount, joinCount, rehabIsFinishedCount, rehabTime,rehabDays;

@property (nonatomic) NSArray<WRRehab*> *treatRehab;
@property (nonatomic) NSArray<WRRehab*> *proTreatRehab;

@property (nonatomic) NSMutableArray<WRTreatRehabStage*> *challengeVideoArray;
@property (nonatomic) NSMutableArray<NSString *> *redArticleArray;
@property(nonatomic) NSMutableArray *commonDiseases, *diseasePhotoArray;

-(void)save;
-(void)restore;
-(void)clear;

-(WRTreatRehabStage*)getUserStageByVideoId:(NSString*)indexId;

@end
