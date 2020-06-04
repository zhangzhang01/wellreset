//
//  UMengUtils.h
//  rehab
//
//  Created by 何寻 on 8/2/16.
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
    
    UMengEventMe
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

@end
