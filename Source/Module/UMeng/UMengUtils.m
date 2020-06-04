//
//  UMengUtils.m
//  rehab
//
//  Created by herson on 8/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "UMengUtils.h"
#import <UMMobClick/MobClick.h>
#import <UShareUI/UShareUI.h>
@implementation UMengUtils

+(NSString*)nameForEvent:(UMengEvent)event
{
    NSString *name = @"";
    switch (event) {
        case UMengEventBind: {
            name = @"bind";
            break;
        }
        case UMengEventAlarm: {
            name = @"alarm";
            break;
        }
        case UMengEventAssess: {
            name = @"assess";
            break;
        }
        case UMengEventPrevent: {
            name = @"prevent";
            break;
        }
        case UMengEventArticle: {
            name = @"article";
            break;
        }
            
        case UMengEventArticleCategory:
        {
            name = @"article_category";
            break;
        }
        case UMengEventBannerHome: {
            name = @"banner_home";
            break;
        }
        case UMengEventBannerDiscovery: {
            name = @"banner_discovery";
            break;
        }
        case UMengEventStage: {
            name = @"stage";
            break;
        }
        case UMengEventStageImage: {
            name = @"stage_image";
            break;
        }
        case UMengEventProTreat: {
            name = @"protreat";
            break;
        }
        case UMengEventProTreatRehab:
        {
            name = @"protreat_rehab";
            break;
        }
        case UMengEventMain: {
            name = @"main";
            break;
        }
        case UMengEventTreat: {
            name = @"treat";
            break;
        }
            
        case UMengEventMe:
        {
            name = @"me";
            break;
        }
            
        case UMengEventTreatDiseaseSelector:
        {
            name = @"treat_disease_selector";
            break;
        }
            
        case UMengEventArticleRecommend:
        {
            name = @"article_recommend";
            break;
        }
            
        case UMengEventExpertList:
        {
            name = @"expert_list";
            break;
        }
            
        case UMengEventExpertDetail:
        {
            name = @"expert_detail";
            break;
        }
            
        case UMengEventSearch:
        {
            name = @"search";
            break;
        }
            
        case UMengEventMeRehab:
        {
            name = @"me_rehab";
            break;
        }
            
        case UMengEventMeFavor:
        {
            name = @"me_favor";
            break;
        }
            
        case UMengEventMeChallenge:
        {
            name = @"me_challenge";
            break;
        }
            
        case UMengEventChallengeExercise:
        {
            name = @"challenge_exercise";
            break;
        }
            
        case UMengEventRehab:
        {
            name = @"rehab";
            break;
        }
            
        case UMengEventRehabExercise:
        {
            name = @"rehab_exercise";
            break;
        }
            
        case UMengEventRehabFaq:
        {
            name = @"rehab_faq";
            break;
        }
            
        case UMengEventRehabUsers:
        {
            name = @"rehab_users";
            break;
        }
            
        case UMengEventRehabOrbit:
        {
            name = @"rehab_orbit";
            break;
        }
            
        case UMengEventRehabDiseaseSelector:
        {
            name = @"rehab_disease_selector";
            break;
        }
            
        case UMengEventRehabDiseaseSelect:
        {
            name = @"rehab_disease_select";
            break;
        }
            
        case UMengEventRehabShare:
        {
            name = @"rehab_share";
            break;
        }
            
        case UMengEventRehabState:
        {
            name = @"rehab_state";
            break;
        }
            
        case UMengEventRehabUserOrbit:
        {
            name = @"rehab_user_orbit";
            break;
        }
            
        case UMengEventRehabArticle:
        {
            name = @"rehab_article";
            break;
        }
            
        case UMengEventRehabAssess:
        {
            name = @"rehab_assess";
            break;
        }
            
        case UMengEventRehabBegin:
        {
            name = @"rehab_begin";
            break;
        }
            
        case UMengEventRehabEnd:
        {
            name = @"rehab_end";
            break;
        }
            
        case UMengEventRehabAirplay:
        {
            name = @"rehab_airplay";
            break;
        }
            
        case UMengEventRehabBgmusic:
        {
            name = @"rehab_bgmusic";
            break;
        }
            
        case UMengEventPreventCategory:
        {
            name = @"prevent_category";
            break;
        }
            
        case UMengEventPreventVideo:
        {
            name = @"prevent_video";
            break;
        }
            
        case UMengEventPreventVideoPlayer:
        {
            name = @"prevent_video_player";
            break;
        }
            
        case UMengEventPreventVideoThumb:
        {
            name = @"prevent_video_thumb";
            break;
        }
            
        case UMengEventDiscover:
        {
            name = @"discover";
            break;
        }
            
        case UMengEventDiscoverCategory:
        {
            name = @"discover_category";
            break;
        }
            
        case UMengEventDiscoverRecommendArticle:
        {
            name = @"discover_recommend_article";
            break;
        }
            
        case UMengEventDiscoverCategoryCategory:
        {
            name = @"discover_category_category";
            break;
        }
            
        case UMengEventChallenge:
        {
            name = @"challenge";
            break;
        }
            
        case UMengEventChallengePlayer:
        {
            name = @"challenge_player";
            break;
        }
            
        case UMengEventChallengePlayerStart:
        {
            name = @"challenge_player_start";
            break;
        }
            
        case UMengEventChallengePlayerEnd:
        {
            name = @"challenge_player_end";
            break;
        }
            
        case UMengEventChallengePlayerRepeat:
        {
            name = @"challenge_player_repeat";
            break;
        }
            
        case UMengEventAsk:
        {
            name = @"ask";
            break;
        }
            
        case UMengEventAskUserSolution:
        {
            name = @"ask_user_solution";
            break;
        }
            
        case UMengEventAskAdd:
        {
            name = @"ask_add";
            break;
        }
            
        case UMengEventSearchHot:
        {
            name = @"search_hot";
            break;
        }
            
        case UMengEventSearchCommon:
        {
            name = @"search_common";
            break;
        }
            
        case UMengEventWell:
        {
            name = @"well";
            break;
        }
            
        case UMengEventWellExpert:
        {
            name = @"well_expert";
            break;
        }
            
        case UMengEventWellFaq:
        {
            name = @"well_faq";
            break;
        }
            
        case UMengEventMeHome:
        {
            name = @"me_home";
            break;
        }
            
        case UMengEventMeModify:
        {
            name = @"me_modify";
            break;
        }
            
        case UMengEventMeLevel:
        {
            name = @"me_level";
            break;
        }
            
        case UMengEventSide:
        {
            name = @"side";
            break;
        }
            
        case UMengEventSideRehabs:
        {
            name = @"side_rehabs";
            break;
        }
            
        case UMengEventSideFavors:
        {
            name = @"side_favors";
            break;
        }
            
        case UMengEventSideAlarm:
        {
            name = @"side_alarm";
            break;
        }
            
        case UMengEventSideSetting:
        {
            name = @"side_setting";
            break;
        }
            
        case UMengEventAlarmAdd:
        {
            name = @"alarm_add";
            break;
        }
    }
    return name;
}

+(void)careForEvent:(UMengEvent)event params:(NSDictionary*)params
{
    [MobClick event:[self nameForEvent:event] attributes:params];
}

+(void)careForEvent:(UMengEvent)event params:(NSDictionary*)params duration:(int)duration
{
    [MobClick event:[self nameForEvent:event] attributes:params durations:duration] ;
}

#pragma mark -
+(void)careForMainWithIndex:(NSInteger)index
{
    [UMengUtils careForEvent:UMengEventMain params:@{@"index":[@(index) stringValue]}];
}

+(void)careForAlarmWithCount:(NSInteger)count
{
    [UMengUtils careForEvent:UMengEventAlarm params:@{@"count":[@(count) stringValue]}];
}

+(void)careForBannerHome:(NSString*)name
{
    [UMengUtils careForEvent:UMengEventBannerHome params:@{@"name":name}];
}

+(void)careForBannerDiscovery:(NSString*)name
{
    [UMengUtils careForEvent:UMengEventBannerDiscovery params:@{@"name":name}];
}

+(void)careForAssess:(NSString *)name step:(NSInteger)step state:(NSInteger)state advice:(NSInteger)advice
{
    NSDictionary *params = @{
                             @"name":name,
                             @"index":[@(step) stringValue],
                             @"state":[@(state) stringValue],
                             @"advice":[@(advice) stringValue],
                             };
    [UMengUtils careForEvent:UMengEventAssess params:params];
}

+(void)careForProTreat:(NSString *)name step:(NSInteger)step state:(NSInteger)state
{
    NSDictionary *params = @{
                             @"name":name,
                             @"step":[@(step) stringValue],
                             @"state":[@(state) stringValue],
                             };
    [UMengUtils careForEvent:UMengEventProTreat params:params];
}


+(void)careForTreat:(NSString *)name type:(NSString *)type duration:(int)duration
{
    NSDictionary *params = @{@"name":name,@"type":type};
    [UMengUtils careForEvent:UMengEventTreat params:params duration:(int)duration];
}

+(void)careForStage:(NSString *)name duration:(int)duration
{
    [UMengUtils careForEvent:UMengEventStage params:@{@"name":name} duration:duration];
}

+(void)careForStageVideoImage:(NSString *)name
{
    [UMengUtils careForEvent:UMengEventStageImage params:@{@"name":name}];
}

+(void)careForArticle:(NSString *)name duration:(int)duration
{
    [UMengUtils careForEvent:UMengEventArticle params:@{@"name":name} duration:duration];
}

+(void)careForArticleCategory:(NSString *)name duration:(int)duration
{
    [UMengUtils careForEvent:UMengEventArticleCategory params:@{@"name":name} duration:duration];
}

+(void)careForBindWithType:(NSString *)type;
{
    [UMengUtils careForEvent:UMengEventBind params:@{@"type":type}];
}

+(void)careForMeWithType:(NSString *)type duration:(int)duration
{
    [UMengUtils careForEvent:UMengEventMe params:@{@"type":type} duration:duration];
}



+(void)careForTreatDiseaseSelector
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventTreatDiseaseSelector params:params];
}

+(void)careForArticleRecommend:(NSString *)name
{
    NSDictionary *params = @{@"name":name};
    [UMengUtils careForEvent: UMengEventArticleRecommend params:params];
}

+(void)careForExpertList
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventExpertList params:params];
}

+(void)careForExpertDetail:(NSString *)name duration:(int)duration
{
    NSDictionary *params = @{@"name":name};
    [UMengUtils careForEvent:UMengEventExpertDetail params:params duration:duration];
}

+(void)careForSearch
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventSearch params:params];
}

+(void)careForMeRehab
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent: UMengEventMeRehab params:params];
}

+(void)careForMeFavor
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventMeFavor params:params];
}

+(void)careForMeChallenge
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventMeChallenge params:params];
}

+(void)careForChallengeExercise:(NSString *)name duration:(int)duration
{
    NSDictionary *params = @{@"name":name};
    [UMengUtils careForEvent:UMengEventChallengeExercise params:params duration:duration];
}

+(void)careForRehab:(NSString *)name
{
    
}

+(void)careForRehabExercise:(NSString *)name duration:(int)duration
{
    NSDictionary *params = @{@"name":name};
    [UMengUtils careForEvent:UMengEventRehabExercise params:params duration:duration];
}

+(void)careForRehabFaq:(NSString *)name duration:(int)duration
{
    NSDictionary *params = @{@"diseaseName":name};
    [UMengUtils careForEvent:UMengEventRehabFaq params:params duration:duration];
}

+(void)careForRehabUsers:(NSString *)name
{
    NSDictionary *params = @{@"diseaseName":name};
    [UMengUtils careForEvent:UMengEventRehabUsers params:params];
}

+(void)careForRehabOrbit:(NSString *)name
{
    NSDictionary *params = @{@"name":name};
    [UMengUtils careForEvent:UMengEventRehabOrbit params:params];
}

+(void)shareWebWithTitle:(NSString*)title detail:(NSString*)detail url:(NSString*)url image:(UIImage*)image viewController:(UIViewController*)viewController
{
    
    NSArray *array = @[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ)];
    [UMSocialUIManager setPreDefinePlatforms:array];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:detail thumImage:image];
        shareObject.webpageUrl = url;
        messageObject.shareObject= shareObject;
        
        
        
        [[UMSocialManager defaultManager]  shareToPlatform:platformType messageObject:messageObject currentViewController:viewController completion:^(id data, NSError *error) {
            
        }];
        
        
    }];
    
}



+(void)careForRehabDiseaseSelector
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventRehabDiseaseSelector params:params];
}

+(void)careForRehabDiseaseSelect:(NSString *)name isPro:(NSString *)isPro
{
    NSDictionary *params = @{@"name":name,@"isPro":isPro};
    [UMengUtils careForEvent:UMengEventRehabDiseaseSelect params:params];
    
    
}

+(void)careForRehabShare:(NSString *)name
{
    NSDictionary *params = @{@"diseaseName":name};
    [UMengUtils careForEvent:UMengEventRehabShare params:params];
}

+(void)careForRehabState:(NSString *)name duration:(int)duration
{
    NSDictionary *params = @{@"diseaseName":name};
    [UMengUtils careForEvent:UMengEventRehabState params:params duration:duration];
}

+(void)careForRehabUserOrbit:(NSString *)name
{
    NSDictionary *params = @{@"diseaseName":name};
    [UMengUtils careForEvent:UMengEventRehabUserOrbit params:params];
}

+(void)careForRehabArticle:(NSString *)name articleName:(NSString *)articleName
{
    NSDictionary *params = @{@"diseaseName":name, @"articleName":articleName};
    [UMengUtils careForEvent:UMengEventRehabArticle params:params];
}

+(void)careForRehabAssess:(NSString *)name duration:(int)duration
{
    NSDictionary *params = @{@"diseaseName":name};
    [UMengUtils careForEvent:UMengEventRehabAssess params:params duration:duration];
}

+(void)careForRehabBegin:(NSString *)name
{
    NSDictionary *params = @{@"diseaseName":name};
    [UMengUtils careForEvent:UMengEventRehabBegin params:params];
}


+(void)careForRehabEnd:(NSString *)name
{
    NSDictionary *params = @{@"diseaseName":name};
    [UMengUtils careForEvent:UMengEventRehabEnd params:params];
}

+(void)careForRehabAirplay:(NSString *)name
{
    NSDictionary *params = @{@"diseaseName":name};
    [UMengUtils careForEvent:UMengEventRehabAirplay params:params];
}

+(void)careForRehabBgmusic:(NSString *)name
{
    NSDictionary *params = @{@"musicName":name};
    [UMengUtils careForEvent:UMengEventRehabBgmusic params:params];
}

+(void)careForPreventCategory:(NSString *)name duration:(int)duration
{
//    NSDictionary *params = @{@"category":name};
//    [UMengUtils careForEvent:UMengEventPreventCategory params:params duration:duration];
//}
}

+(void)careForPrevent
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventPrevent params:params];
}

+(void)careForPreventVideo:(NSString *)name
{
    NSDictionary *params = @{@"videoName":name};
    [UMengUtils careForEvent:UMengEventPreventVideo params:params];
}

+(void)careForPreventVideoPlayer:(NSString *)name duration:(int)duration
{
    NSDictionary *params = @{@"videoName":name};
    [UMengUtils careForEvent:UMengEventPreventVideoPlayer params:params duration:duration];
}

+(void)careForPreventVideoThumb:(NSString *)name
{
    NSDictionary *params = @{@"videoName":name};
    [UMengUtils careForEvent:UMengEventPreventVideoThumb params:params];
}

+(void)careForDiscover
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventDiscover params:params];
}

+(void)careForDiscoverCategory:(NSString *)name duration:(int)duration
{
    NSDictionary *params = @{@"category":name};
    [UMengUtils careForEvent:UMengEventDiscoverCategory params:params duration:duration];
}

+(void)careForDiscoverRecommendArticle:(NSString *)name
{
    NSDictionary *params = @{@"title":name};
    [UMengUtils careForEvent:UMengEventDiscoverRecommendArticle params:params];
}

+(void)careForDiscoverCategoryCategory:(NSString *)name duration:(int)duration
{
//    NSDictionary *params = @{@"title":name};
//    [UMengUtils careForEvent:UMengEventDiscoverCategoryCategory params:params duration:duration];
}

+(void)careForChallenge
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventChallenge params:params];
}

+(void)careForChallengePlayer:(NSString *)name duration:(int)duration
{
    NSDictionary *params = @{@"videoName":name};
    [UMengUtils careForEvent:UMengEventChallengePlayer params:params duration:duration];
}

+(void)careForChallengePlayerStart:(NSString *)name
{
    NSDictionary *params = @{@"videoName":name};
    [UMengUtils careForEvent:UMengEventChallengePlayerStart params:params];
}

+(void)careForChallengePlayerEnd:(NSString *)name
{
    NSDictionary *params = @{@"videoName":name};
    [UMengUtils careForEvent:UMengEventChallengePlayerEnd params:params];
}

+(void)careForChallengePlayerRepeat:(NSString *)name
{
    NSDictionary *params = @{@"videoName":name};
    [UMengUtils careForEvent:UMengEventChallengePlayerRepeat params:params];
}

+(void)careForAsk
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventAsk params:params];
}

+(void)careForAskUserSolution
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventAskUserSolution params:params];
}

+(void)careForAskAdd
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventAskAdd params:params];
}

+(void)careForSearchHot:(NSString *)name
{
    NSDictionary *params = @{@"keyword":name};
    [UMengUtils careForEvent:UMengEventSearchHot params:params];
}

+(void)careForSearchCommon:(NSString *)name
{
    NSDictionary *params = @{@"keyword":name};
    [UMengUtils careForEvent:UMengEventSearchCommon params:params];
}

+(void)careForWell
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventWell params:params];
}

+(void)careForWellExpert:(NSString *)name
{
    NSDictionary *params = @{@"expert":name};
    [UMengUtils careForEvent:UMengEventWellExpert params:params];
}

+(void)careForWellFaq:(NSString *)name
{
    NSDictionary *params = @{@"question":name};
    [UMengUtils careForEvent:UMengEventWellFaq params:params];
}

+(void)careForMeHome
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventMeHome params:params];
}

+(void)careForMeModify:(NSString *)name
{
    NSDictionary *params = @{@"item":name};
    [UMengUtils careForEvent:UMengEventMeModify params:params];
}

+(void)careForMeLevel:(NSString *)name
{
    NSDictionary *params = @{@"userLevel":name};
    [UMengUtils careForEvent:UMengEventMeLevel params:params];
}

+(void)careForSide
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventSide params:params];
}

+(void)careForSideRehabs
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventSideRehabs params:params];
}

+(void)careForSideFavors
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventSideFavors params:params];
}

+(void)careForSideAlarm
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventSideAlarm params:params];
}

+(void)careForSideSetting
{
    NSDictionary *params = @{};
    [UMengUtils careForEvent:UMengEventSideSetting params:params];
}

+(void)careForAlarmAdd:(NSString *)name
{
NSDictionary *params = @{@"time":name};
[UMengUtils careForEvent:UMengEventAlarmAdd params:params];
}



@end
