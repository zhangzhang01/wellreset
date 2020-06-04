//
//  ShareUserData.h
//  rehab
//
//  Created by herson on 8/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "RehabObject.h"
#import "RehabObject.h"
#import "WRObject.h"

@interface ShareUserData : NSObject

+(instancetype)userData;

@property(nonatomic)NSInteger rehabCount, joinCount, rehabIsFinishedCount, rehabTime,rehabDays, askExpertRemainCount;

@property(nonatomic)WRUserPermission *userPermissions;

@property (nonatomic) NSMutableArray<WRRehab*> *treatRehab;
@property (nonatomic) NSMutableArray<WRRehab*> *proTreatRehab;
@property (nonatomic) NSMutableArray<WRArticle*> *wechatShareList;
@property (nonatomic) NSMutableArray<WRTreatRehabStage*> *challengeVideoArray;
@property (nonatomic) NSMutableArray<NSString *> *redArticleArray;
@property (nonatomic) NSMutableArray<NSString *> *alarmArray;
@property(nonatomic) NSMutableArray *commonDiseases, *diseasePhotoArray;
@property(nonatomic) WRRehab* selfrehab;

-(void)save;
-(void)restore;
-(void)clear;

-(WRTreatRehabStage*)getUserStageByVideoId:(NSString*)indexId;

-(BOOL)notifyRehab:(WRRehab*)rehab;

@end
