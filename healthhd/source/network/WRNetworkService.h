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
    urlAgreementUrl, urlPhysioDescriptionUrl, urlUploadHeadImage, urlComplain, urlGetSmsCode , urlPiwik,
    
    urlUserRegister, urlUserLogin, urlUserResetPassword, urlUserSaveToken, urlUserModifyBasicInfo, urlUserHome, urlUserAskExpert, urlUserSyncData, urlUserGetReply,
    
    urlUserGetWell, urlUserGetAssessDetail, urlUserGetProTreatDetail, urlUserGetAssess, urlUserGetProTreat,
    
    urlGetExpertList, urlGetFAQList, urlGetNewsList,
    
    urlGetAssessProjects, urlGetAssessProjectQuestions, urlUserAssessSubmit,
    
    urlGetTreatDiseaseList, urlGetTreatRehab, urlUserCheckTreatRehab, urlUserTreatRepeatRehab,
    
    urlGetChroRehab,
    
    urlGetProTreatSpecialtyList, urlGetProTreatDiseaseList, urlGetProTreatQuestions, urlUserProTreatSubmit, urlUserProTreatRepeatRehab,
    
    urlUserOperation, urlUserAuthor, urlUserCheckProTreatRehab, urlUserFavorList, urlUserGetProTreatFeedbackList, urlUserSubmitProTreatFeedback,
    
    urlPreventIndex,urlTreatIndex,urlDiscoveryIndex,
    
    urlAd, urlGetAssessResultAdvice, urlUserUploadFile, urlUserBindPhone,
    
    urlUserPerson, urlUserUnlockAdd, urlUserUnlockIndex, urlShareLogo, urlWechat, urlShareApp, urlUserPutQuestion
};

typedef NS_ENUM(NSInteger, WRNetworkError)
{
    WRNetworkErrorUnknown = -1,
    WRNetworkErrorNone = 0,
    WRNetworkErrorNeedUpdate = 1000,
    WRNetworkErrorFetchAPI
};

extern const NSString * WROperationTypeLike;
extern const NSString * WROperationTypeShare;
extern const NSString * WROperationTypeRead;
extern const NSString * WROperationTypeNotification;
extern const NSString * WROperationTypeFavor;
extern const NSString * WROperationTypeUserCommonDisease;
extern const NSString * WROperationTypeUserDiseasePhoto;
extern const NSString * WROperationTypeCustom;

extern const NSString * WRContentTypeTreat;
extern const NSString * WRContentTypeArticle;

extern const NSString * WROperationManageTypeAdd;
extern const NSString * WROperationManageTypeDelete;

@interface WRNetworkService : NSObject

@property(nonatomic) BOOL isConnected;

+(instancetype)defaultService;

+(NSString*)getDomain;
+(NSString*)getEntryURLString;
+(NSString*)getFormatURLString:(WRURLType)type;
-(void)fetchInterfaceWithCompletion:(void(^)(NSError * error))completion;
+(void)fillPostParam:(NSMutableDictionary*)param;
+(void)pwiki:(NSString*)category;

@end
