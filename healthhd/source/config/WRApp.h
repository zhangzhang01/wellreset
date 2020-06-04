//
//  WRApp.h
//  rehab
//
//  Created by Matech on 3/17/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceType) {
    DeviceTypeUnknown,
    DeviceTypeiPhone,
    DeviceTypeiPad,
    DeviceTypeAndroidPhone,
    DeviceTypeAndroidPad
};

typedef NS_ENUM(NSInteger, Gender) {
    GenderUnknown,
    GenderMale,
    GenderFemale,
};

typedef NS_ENUM(NSInteger, BannerActionType) {
    BannerActionTypeUnknown,
    BannerActionTypeAssess,
    BannerActionTypeMuscle,
    BannerActionTypeTreat,
    BannerActionTypeProTreat,
    BannerActionTypeArticle
};

typedef NS_ENUM(NSInteger, WRErrorCode) {
    WRErrorCodeUnknown = -1,
    WRErrorCodeSuccess,
    WRErrorCodeWrongUser = 11
};

extern const CFAbsoluteTime WRAssessAutoTime;
extern const NSUInteger WRSmsCodeTime;
extern const double WRAssessExcellentMultiple;
extern const double WRAssessMaxValue;
extern const int WRComplainTextMaxLength;
extern const int WRComplainTextMinLength;
extern NSString* WRAppId;

extern NSString *UMAppKey;

extern NSString *WechatAppID;
extern NSString *WechatAppKey;
extern NSString *RedirectUrl;
extern NSString *QQAppID;
extern NSString *QQAppKey;

@interface WRApp : NSObject

+(id)appCache;

+(void)saveAPI:(NSDictionary*)dict;
+(NSDictionary*)getAPI;

+(NSString*)shortTime:(NSString*)timeString;

+(NSString*)genderDescription:(NSInteger)gender;

@end
