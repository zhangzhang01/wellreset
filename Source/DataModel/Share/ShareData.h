//
//  ShareData.h
//  rehab
//
//  Created by herson on 8/17/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRObject.h"
#import "Challenge.h"

@interface ShareData : NSObject

+(instancetype)data;
@property(nonatomic)NSString* shareIP;
@property(nonatomic)NSArray<NSString*> *bodyCodeArray, *bodyCodeDescArray;

@property(nonatomic) NSArray<WRArticle*> *discoveryBannerArray;
@property(nonatomic) NSArray<WRCategory*> *categoryArray;

@property(nonatomic) NSArray<WRBannerInfo*> *bannerArray;
@property(nonatomic) NSArray<WRBannerInfo*> *IndexArray;
@property (nonatomic) NSArray<WRRehabDisease*> *treatDisease, *recommendTreat;
@property (nonatomic) NSArray<WRRehabDisease*> *proTreatDisease;

@property(nonatomic) NSArray<ChallengeGroup*> *challengeGroupArray;
@property(nonatomic) NSArray<WRTreatclass*> *treatclassArry;
-(NSString*)descFromBodyCode:(NSString*)code;

-(WRTreatRehabStage*)getStageWithVideoId:(NSString*)indexId;

@end
