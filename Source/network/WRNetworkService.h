//
//  WRNetworkService.h
//  rehab
//
//  Created by Matech on 3/3/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, WRURLType)
{
    urlAgreementUrl, urlPhysioDescriptionUrl, urlComplain, urlGetSmsCode , urlPiwik,
    
    urlUserRegister, urlUserLogin, urlUserResetPassword, urlUserSaveToken,
    urlUserModifyBasicInfo, urlUserHome, urlUserAskExpert, urlUserSyncData, urlUserGetReply,
    
    urlUserGetWell, urlUserGetAssessDetail, urlUserGetProTreatDetail,
    urlUserGetAssess, urlUserGetProTreat,
    
    urlGetExpertList, urlGetFAQList, urlGetNewsList,
    
    urlGetAssessProjects, urlGetAssessProjectQuestions, urlUserAssessSubmit,
    
    urlGetTreatDiseaseList, urlGetTreatRehab, urlUserCheckTreatRehab, urlUserTreatRepeatRehab,
    
    urlGetChroRehab,
    
    urlGetProTreatSpecialtyList, urlGetProTreatDiseaseList, urlGetProTreatQuestions, urlUserProTreatSubmit, urlUserProTreatRepeatRehab,
    
    urlUserOperation, urlUserAuthor, urlUserCheckProTreatRehab, urlUserFavorList, urlUserGetProTreatFeedbackList, urlUserSubmitProTreatFeedback,
    
    urlPreventIndex,urlTreatIndex,urlDiscoveryIndex,
    
    urlAd, urlGetAssessResultAdvice, urlUserBindPhone,
    
    urlUserPerson, urlUserUnlockAdd, urlUserUnlockIndex, urlShareLogo, urlWechat, urlShareApp,urlGetShareDetail,
    
    urlSearch, urlGetDiseaseFAQ, urlUpload, urlBgMusic,
    
    urlGetPrevention, urlGetPermissions, urlAskIndexData, urlUserAskData, urlSearchIndexData, urlUserStageFavorList, urlGetUpgradeRules, urlGetList, urlIAPOrderProduct, urlUserInfo, urlGetChallengeShareInfo , getDailyByDay ,
    getDailyByWeek , getDailyByMonth , getDailyAll , getDaily ,
    getCommentList , urlAddComment , urlDeleComment ,urlGetCase
    , urlDeleteRehab ,urlEditRehab , getShareList2 , urlSaveShare ,
    urlGetRehabProbt , urlAddVote , getReplyDetail , addReplyComment , getRemin ,addFeedBackResult , getHealthStageList,getProductList,doOrder,doPay,getOrderList,getOrderDetail,getAlreadyOrderProducts,getRegistResult,getuuid,Uploadcircles,updatetext,getBanner,getcircles,getapple,getcode,getsmscode2,userRehabList,submitSelfRehab,selfRehabDetail
    
    ,comBanner,comCircleList,ComArticle,comments,saveComment,circleDetail,releaseArticle,chooseCircleOrTopic,removeComment,removeArticle,upvote,notifyList,removeNotify,Cirupload,joinCircle,uploadImg,
    getQuestionnairJOA,getQuestionnairODI,isTrueSpan,submitGrade,getGredeStatement,overall,
    
    
};

typedef NS_ENUM(NSInteger, WRNetworkError)
{
    WRNetworkErrorUnknown = -1,
    WRNetworkErrorNone = 0,
    WRNetworkErrorNeedUpdate = 1000,
    WRNetworkErrorFetchAPI
};


typedef NS_ENUM(NSInteger, WRUploadType)
{
    WRUploadTypeUserHead,
    WRUploadTypeUserDisease,
    WRUploadTypeFeedback
};

@interface WRNetworkService : NSObject

@property(nonatomic) BOOL isConnected;

+(instancetype)defaultService;

+(NSString*)getDomain;
+(NSString*)getEntryURLString;
+(NSString*)getFormatURLString:(WRURLType)type;
-(void)fetchInterfaceWithCompletion:(void(^)(NSError * error))completion;
+(void)fillPostParam:(NSMutableDictionary*)param;
/**页面计算*/
+(void)pwiki:(NSString*)category;

@end
