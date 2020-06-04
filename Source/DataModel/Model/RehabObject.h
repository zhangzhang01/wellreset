//
//  RehabObject.h
//  rehab
//
//  Created by herson on 16/9/16.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WRUserInfo.h"

typedef NS_ENUM(NSInteger, ProTreatQuestionType) {
    ProTreatQuestionTypeSingleSelection,
    ProTreatQuestionTypeMultiSelection,
    ProTreatQuestionTypeValue,
    ProTreatQuestionTypeFlowImage,
    ProTreatQuestionTypeGif,
    ProTreatQuestionTypeGifNotimer
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

//诊断结果
typedef NS_ENUM(NSInteger,  DiagnosticResult) {
    DiagnosticResultWell, //良好
    DiagnosticResultWeak, //弱
    DiagnosticResultWorse //弱爆了
};

@interface ChargeInfo : WRObject
@property (nonatomic, strong) NSString *chargeNo;
@property(nonatomic) NSInteger state;
@end

@interface ProductInfo : WRObject
@property (nonatomic, strong) NSString *name, *content, *sn, *beginTime, *endTime;
@property(nonatomic) NSInteger money;
@end

//定制疾病，快速和定制均使用
@interface WRRehabDisease : NSObject

@property(nonatomic, copy) NSString *indexId, *specialtyId, *bannerImageUrl, *bannerImageUrl2,
*diseaseName, *diseaseDetail, *imageUrl, *bodyCode, *userStatus, *parentId, *specialty , *diseaeType , *classifyId;
@property(nonatomic) NSInteger state, count, clicks, difficulty,duration;
@property(nonatomic)BOOL isProTreat, order;
@property (nonatomic, strong) ChargeInfo *chargeInfo;
@property (nonatomic, strong) ProductInfo *productInfo;
-(BOOL)isPro;

@end

//疾病分类
@interface WRTreatclass : WRObject
@property(nonatomic)NSString* classifyType , *classifyName ,*uuid;
@property(nonatomic)NSInteger sort;
@end


//定制康复疾病科目
@interface WRProTreatSpecialty : WRObject
@property(nonatomic)DiseaseState state;
@end

//定制康复问卷问题选项
@interface WRProTreatAnswer : WRObject
@property(nonatomic) NSString *questionId, *answer , *img , *angle , *desc;
@property(nonatomic) ProTreatAnswerType type;
-(instancetype)initWithDictionary:(NSDictionary *)dc;
@end

//定制康复问卷问题
@interface WRProTreatQuestion : WRObject
@property(nonatomic, copy) NSString *question, *videoUrl, *oldRehabAnswers;
@property(nonatomic) NSArray *answers;
@property(nonatomic) NSInteger rejectAnswerCount, minValue, maxValue ;
@property(nonatomic) ProTreatQuestionType answerType;
@property(nonatomic) ProTreatQuestionSpecialType specialState;
@property(nonatomic) ProTreatQuestionRejectType rejectType;
@property(nonatomic) NSString* desc;
@property(nonatomic) NSString* imageId;
-(instancetype)initWithDictionary:(NSDictionary *)dc;
@end

@interface WRAssess : NSObject
@property(nonatomic, copy) NSString *content, *imageUrl;
@end

#pragma mark - ProTreat Rehab
//方案
@interface WRRehab : NSObject
@property(nonatomic, assign) NSUInteger isFinished, count, isTimeout;
@property(nonatomic) BOOL isSelfRehab;
@property(nonatomic, assign) NSUInteger keepCount; //持续天数
@property(nonatomic, assign) NSUInteger totalCount; //累计天数
@property(nonatomic) NSUInteger duration,size;
@property(nonatomic) NSUInteger sortindex;
@property(nonatomic, copy) NSString *indexId, *createTime, *currentTime, *content, *shareUrl, *userSurvey , * lastSportTime, *rehabType , *name;
@property(nonatomic) NSArray *stageSet, *checkedDate , *stageSetCounts;
@property(nonatomic) NSArray<WRFAQ*> *faq;
@property(nonatomic) WRRehabDisease *disease;
@property(nonatomic) BOOL state;
@property(nonatomic)NSInteger reviewCount;

@property(nonatomic) BOOL favor;
@property(nonatomic) BOOL hasPermission;
@property(nonatomic) NSArray<WRArticle*> *relate;
@property(nonatomic) NSArray<WRUserInfo*> *users;
@property(nonatomic) NSArray<WRAssess*> *assess;
@property(nonatomic) NSDictionary* operation;


@end

//康复反馈
@interface WRProTreatRehabFeedbackQuestion : WRObject
@property(nonatomic, copy) NSString *diseaseId, *question;
@property(nonatomic) NSInteger type, maxValue, minValue;
@end

//视频缩略图
@interface WRTreatRehabStageVideoTherbligImage : WRObject
@end

//肌肉图
@interface MuscleDiagram : WRObject
@property(nonatomic, copy) NSString *muscle, *advantages, *disadvantage;
@property(nonatomic,) NSArray<NSString *> *images;
@end

//步骤
@interface WRTreatRehabStageVideo : WRObject
@property(nonatomic, copy) NSString *videoUrl, *gifUrl, *thumbnailUrl, *videoName, *notice, *attention, *createTime,*name;
@property(nonatomic) NSArray<WRTreatRehabStageVideoTherbligImage*>* images;
@property(nonatomic) NSArray<WRObject*> *attributes;




@property(nonatomic) NSInteger duration, time, difficulty ,size , videoDuration;
@property(nonatomic) MuscleDiagram *muscle;
@end

//步骤
@interface WRTreatRehabStage : WRObject
@property(nonatomic, assign) NSUInteger time, repeatCount, stage, difficulty, refValue, userValue,duration2;
@property(nonatomic, copy) NSString *content, *refUnit, *videoId, *explanation, *harm;
@property(nonatomic) NSInteger videoType;
@property(nonatomic) NSInteger repeat;
@property(nonatomic) NSString* audioUrl;
@property(nonatomic) BOOL favor;
@property(nonatomic) NSArray<WRTreatRehabStageVideo *>*videos;
@property(nonatomic) WRTreatRehabStageVideo *mtWellVideoInfo;
@property(nonatomic) BOOL endready;
@property(nonatomic) NSString* type;
@end

@interface WRDownRehab : WRObject
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* indexid;
@property (nonatomic) NSArray* downlist;
@property (nonatomic) NSUInteger size;
@end

