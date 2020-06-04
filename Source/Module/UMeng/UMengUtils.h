//
//  UMengUtils.h
//  rehab
//
//  Created by herson on 8/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UMengEvent)
{
    UMengEventAlarm,
    UMengEventArticle,
    UMengEventArticleCategory,
    UMengEventAssess,
    
    UMengEventBannerDiscovery,
    UMengEventBannerHome,
    UMengEventBind,
    
    UMengEventMain,
    UMengEventPrevent,
    
    UMengEventProTreat,
    UMengEventProTreatRehab,
    
    UMengEventStage,
    UMengEventStageImage,
    
    UMengEventTreat,
    
    UMengEventMe,
    
    UMengEventTreatDiseaseSelector,
    UMengEventArticleRecommend,
    UMengEventExpertList,
    UMengEventExpertDetail,
    UMengEventSearch,
    UMengEventMeRehab,
    UMengEventMeFavor,
    UMengEventMeChallenge,
    UMengEventChallengeExercise,
    UMengEventRehab,
    UMengEventRehabExercise,
    UMengEventRehabFaq,
    UMengEventRehabUsers,
    UMengEventRehabOrbit,
    
    UMengEventRehabDiseaseSelector,
    UMengEventRehabDiseaseSelect,
    
    UMengEventRehabShare,
    UMengEventRehabState,
    UMengEventRehabUserOrbit,
    UMengEventRehabArticle,
    UMengEventRehabAssess,
    UMengEventRehabBegin,
    UMengEventRehabEnd,
    UMengEventRehabAirplay,
    UMengEventRehabBgmusic,
    
    UMengEventPreventCategory,
    UMengEventPreventVideo,
    UMengEventPreventVideoPlayer,
    UMengEventPreventVideoThumb,
    
    UMengEventDiscover,
    UMengEventDiscoverCategory,
    UMengEventDiscoverRecommendArticle,
    UMengEventDiscoverCategoryCategory,
    
    UMengEventChallenge,
    UMengEventChallengePlayer,
    UMengEventChallengePlayerStart,
    UMengEventChallengePlayerEnd,
    UMengEventChallengePlayerRepeat,
    
    UMengEventAsk,
    UMengEventAskUserSolution,
    UMengEventAskAdd,
    
    UMengEventSearchHot,
    UMengEventSearchCommon,
    
    UMengEventWell,
    UMengEventWellExpert,
    UMengEventWellFaq,
    
    UMengEventMeHome,
    UMengEventMeModify,
    UMengEventMeLevel,
    
    UMengEventSide,
    UMengEventSideRehabs,
    UMengEventSideFavors,
    UMengEventSideAlarm,
    UMengEventSideSetting,
    UMengEventAlarmAdd
};

@interface UMengUtils : NSObject

//+(void)careForEvent:(UMengEvent)event params:(NSDictionary*)params;

+(void)careForMainWithIndex:(NSInteger)index;
+(void)careForAlarmWithCount:(NSInteger)count;

+(void)careForBannerHome:(NSString*)name;
+(void)careForBannerDiscovery:(NSString*)name;

+(void)careForAssess:(NSString*)name step:(NSInteger)step state:(NSInteger)state advice:(NSInteger)advice;

+(void)careForProTreat:(NSString*)name step:(NSInteger)step state:(NSInteger)state;

+(void)careForTreat:(NSString *)name type:(NSString *)type duration:(int)duration;

+(void)careForStage:(NSString *)name duration:(int)duration;
+(void)careForStageVideoImage:(NSString *)name;

+(void)careForArticle:(NSString *)name duration:(int)duration;
+(void)careForArticleCategory:(NSString *)name duration:(int)duration;

+(void)careForBindWithType:(NSString *)type;

+(void)careForMeWithType:(NSString *)type duration:(int)duration;

+(void)shareWebWithTitle:(NSString*)title detail:(NSString*)detail url:(NSString*)url image:(UIImage*)image viewController:(UIViewController*)viewController;

+(void)careForTreatDiseaseSelector;

+(void)careForArticleRecommend:(NSString *)name;

+(void)careForExpertList;

+(void)careForExpertDetail:(NSString *)name duration:(int)duration;

+(void)careForSearch;

+(void)careForMeRehab;

+(void)careForMeFavor;

+(void)careForMeChallenge;

+(void)careForChallengeExercise:(NSString *)name duration:(int)duration;

+(void)careForRehab:(NSString *)name;

+(void)careForRehabExercise:(NSString *)name duration:(int)duration;

+(void)careForRehabFaq:(NSString *)name duration:(int)duration;

+(void)careForRehabUsers:(NSString *)name;

+(void)careForRehabOrbit:(NSString *)name;

+(void)careForRehabDiseaseSelector;
+(void)careForRehabDiseaseSelect:(NSString *)name isPro:(NSString *)isPro;

+(void)careForRehabShare:(NSString *)name;
+(void)careForRehabState:(NSString *)name duration:(int)duration;
+(void)careForRehabUserOrbit:(NSString *)name;
+(void)careForRehabArticle:(NSString *)name articleName:(NSString *)articleName;
+(void)careForRehabAssess:(NSString *)name duration:(int)duration;
+(void)careForRehabBegin:(NSString *)name;
+(void)careForRehabEnd:(NSString *)name;
+(void)careForRehabAirplay:(NSString *)name;
+(void)careForRehabBgmusic:(NSString *)name;

+(void)careForPrevent;
+(void)careForPreventCategory:(NSString *)name duration:(int)duration;
+(void)careForPreventVideo:(NSString *)name;
+(void)careForPreventVideoPlayer:(NSString *)name duration:(int)duration;
+(void)careForPreventVideoThumb:(NSString *)name;

+(void)careForDiscover;
+(void)careForDiscoverCategory:(NSString *)name duration:(int)duration;
+(void)careForDiscoverRecommendArticle:(NSString *)name;
+(void)careForDiscoverCategoryCategory:(NSString *)name duration:(int)duration;

+(void)careForChallenge;
+(void)careForChallengePlayer:(NSString *)name duration:(int)duration;
+(void)careForChallengePlayerStart:(NSString *)name;
+(void)careForChallengePlayerEnd:(NSString *)name;
+(void)careForChallengePlayerRepeat:(NSString *)name;

+(void)careForAsk;
+(void)careForAskUserSolution;
+(void)careForAskAdd;

+(void)careForSearchHot:(NSString *)name;
+(void)careForSearchCommon:(NSString *)name;

+(void)careForWell;
+(void)careForWellExpert:(NSString *)name;
+(void)careForWellFaq:(NSString *)name;

+(void)careForMeHome;
+(void)careForMeModify:(NSString *)name;
+(void)careForMeLevel:(NSString *)name;

+(void)careForSide;
+(void)careForSideRehabs;
+(void)careForSideFavors;
+(void)careForSideAlarm;
+(void)careForSideSetting;
+(void)careForAlarmAdd:(NSString *)name;
@end
