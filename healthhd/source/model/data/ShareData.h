//
//  ShareData.h
//  rehab
//
//  Created by 何寻 on 8/17/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRObject.h"
#import "Challenge.h"

@interface ShareData : NSObject

+(instancetype)data;

@property(nonatomic)NSArray<NSString*> *bodyCodeArray, *bodyCodeDescArray;

@property(nonatomic) NSArray<WRArticle*> *discoveryBannerArray;
@property(nonatomic) NSArray<WRCategory*> *categoryArray;

@property(nonatomic) NSArray<WRBannerInfo*> *bannerArray;
@property (nonatomic) NSArray<WRRehabDisease*> *treatDisease, *recommendTreat;
@property (nonatomic) NSArray<WRRehabDisease*> *proTreatDisease;

@property(nonatomic) NSArray<ChallengeGroup*> *challengeGroupArray;

-(NSString*)descFromBodyCode:(NSString*)code;

-(WRTreatRehabStage*)getStageWithVideoId:(NSString*)indexId;

@end
