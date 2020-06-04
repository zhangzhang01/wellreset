//
//  WRApp.m
//  rehab
//
//  Created by Matech on 3/17/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRApp.h"
#import "WRUserInfo.h"
#import <YYKit/YYKit.h>
const CFAbsoluteTime WRAssessAutoTime = 6;
const NSUInteger WRSmsCodeTime = 90;
const double WRAssessExcellentMultiple = 110;
const double WRAssessMaxValue = 150;
const int WRComplainTextMaxLength = 300;
const int WRComplainTextMinLength = 10;
const int WRAskTextMaxLength = 500;

#if IPAD
NSString *WRAppId = @"1109966957";
#else
NSString *WRAppId = @"1103664892";
#endif

#if IPAD
NSString *UMAppKey = @"5809d9f9a32511309e0039bc";
#else
NSString *UMAppKey = @"5762599867e58ef29400206e";
#endif

NSString *WechatAppID = @"wx00ea0a14fe2e31fd";
NSString *WechatAppKey = @"0285489d85896375509404de9f8c2070";
NSString *RedirectUrl = @"http://www.umeng.com/social";
NSString *QQAppID = @"1105378576";
NSString *QQAppKey = @"YvmEBsP5GAAekIaK";

@implementation WRApp

+(id)appCache {
    static YYCache *cache = nil;
    NSString *name = @"WELLAppCache";
    if ([[WRUserInfo selfInfo] isLogged]) {
        name = [NSString stringWithFormat:@"%@=%@", name, [WRUserInfo selfInfo].userId];
    }
    
    do {
        if (cache && [cache.name isEqualToString:name]) {
            break;
        }
        
        cache = [[YYCache alloc] initWithName:name];
        NSLog(@"New YYCache %@", name);
        
    } while (NO);
    return cache;
}

+(NSString*)cachePath {
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [cacPath objectAtIndex:0];
}

+(NSString*)APIFilePath {
    return [[WRApp cachePath] stringByAppendingPathComponent:@"api.plist"];
}

+(void)saveAPI:(NSDictionary*)dict {
    NSString *filePath = [WRApp APIFilePath];
    [dict writeToFile:filePath atomically:YES];
}

+(NSDictionary*)getAPI {
    return [NSDictionary dictionaryWithPlistData:[NSData dataWithContentsOfFile:[WRApp APIFilePath]]];
}

+(NSString *)shortTime:(NSString *)timeString {
    if (timeString.length >= 18 ) {
        timeString = [timeString substringWithRange:NSMakeRange(5, 11)];
    }
    return timeString;
}

+(NSString *)genderDescription:(NSInteger)gender {
    switch (gender) {
        case GenderMale:
            return NSLocalizedString(@"男", nil);
            
        case GenderFemale:
            return NSLocalizedString(@"女", nil);
            
        default:
            return NSLocalizedString(@"未知", nil);
    }
}
@end
