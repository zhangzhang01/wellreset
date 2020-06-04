//
//  WRProTreat.h
//  rehab
//
//  Created by Matech on 3/17/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRObject.h"

typedef NS_ENUM(NSInteger, ProTreatQuestionType) {
    ProTreatQuestionTypeSingleSelection,
    ProTreatQuestionTypeMultiSelection,
    ProTreatQuestionTypeValue
};

typedef NS_ENUM(NSInteger, ProTreatQuestionSpecialType) {
    ProTreatQuestionSpecialTypeDefault,
    ProTreatQuestionSpecialTypePain
};

typedef NS_ENUM(NSInteger, ProTreatQuestionRejectType) {
    ProTreatQuestionRejectTypeNone = 0,
    ProTreatQuestionRejectTypeYES
};

typedef NS_ENUM(NSInteger, DiseaseState) {
    DiseaseStateDisable = -1,
    DiseaseStateCommon = 0,
    DiseaseStateComming
};

typedef NS_ENUM(NSInteger, ProTreatFinishedState) {
    ProTreatFinishedStateFinished = 0,
    ProTreatFinishedStateUnFinish
};

typedef NS_ENUM(NSInteger, ProTreatAnswerType) {
    ProTreatAnswerTypeDefault = 0,
    ProTreatAnswerTypeExclusive
};



///
@interface WRProTreatSpecialty : WRObject
@property(nonatomic)DiseaseState state;
@end

@interface WRProTreatAnswer : WRObject
@property(nonatomic) NSString *questionId, *answer;
@property(nonatomic) ProTreatAnswerType type;
@end

@interface WRProTreatQuestion : WRObject
@property(nonatomic, copy) NSString *question, *videoUrl;
@property(nonatomic) NSArray *answers;
@property(nonatomic) NSInteger rejectAnswerCount, minValue, maxValue;
@property(nonatomic) ProTreatQuestionType answerType;
@property(nonatomic) ProTreatQuestionSpecialType specialState;
@property(nonatomic) ProTreatQuestionRejectType rejectType;
@end

#pragma mark - ProTreat Rehab
@interface WRRehab : NSObject
@property(nonatomic, assign) NSUInteger isFinished, count, isTimeout;
@property(nonatomic, assign) NSUInteger keepCount; //持续天数
@property(nonatomic, assign) NSUInteger totalCount; //累计天数
@property(nonatomic, copy) NSString *indexId, *createTime, *currentTime, *content, *shareUrl;
@property(nonatomic) NSArray *stageSet, *checkedDate;
@property(nonatomic) WRRehabDisease *disease;

@property(nonatomic)NSInteger reviewCount;

@property(nonatomic) BOOL favor;
@property(nonatomic) NSArray<WRArticle*> *relate;
@property (nonatomic) NSArray<WRUserInfo*> *users;

@end

@interface WRProTreatRehabFeedbackQuestion : WRObject
@property(nonatomic, copy) NSString *diseaseId, *question;
@property(nonatomic) NSInteger type, maxValue, minValue;
@end
