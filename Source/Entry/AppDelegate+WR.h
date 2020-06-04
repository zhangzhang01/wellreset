//
//  AppDelegate+AppDelegate_WR.h
//  rehab
//
//  Created by herson on 16/4/2.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate (WR)<UNUserNotificationCenterDelegate>


-(void)test;

-(void)initUI:(UIApplication*)application;
-(void)initNotification:(UIApplication*)application;
-(void)initShareSDK;
-(void)initMobClick;
-(void)initUPushWithLaunchOptions:(NSDictionary *)launchOptions;
+(void)show:(NSString*)str;
@end
