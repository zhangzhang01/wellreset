//
//  UMengUtils.m
//  rehab
//
//  Created by 何寻 on 8/2/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "UMengUtils.h"
#import <UMMobClick/MobClick.h>
#import "UMSocial.h"

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

+(void)shareWebWithTitle:(NSString*)title detail:(NSString*)detail url:(NSString*)url image:(UIImage*)image viewController:(UIViewController*)viewController
{
    UMSocialQQData *qqData = [UMSocialData defaultData].extConfig.qqData;                // qq url
    qqData.url = url;
    qqData.title = title;
    
    UMSocialWechatSessionData *wechatSessionData = [UMSocialData defaultData].extConfig.wechatSessionData;
    wechatSessionData.url = url;
    wechatSessionData.title = title;
    
    UMSocialWechatTimelineData *wechatTimelineData = [UMSocialData defaultData].extConfig.wechatTimelineData;
    wechatTimelineData.url = url;
    wechatTimelineData.title = title;
    
    [UMSocialSnsService presentSnsIconSheetView:viewController
                                         appKey:UMAppKey
                                      shareText:detail
                                     shareImage:image
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ]
                                       delegate:nil];
}
@end
