//
//  AppDelegate+AppDelegate_WR.h
//  rehab
//
//  Created by 何寻 on 16/4/2.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (WR)

-(void)test;

-(void)initUI:(UIApplication*)application;
-(void)initNotification:(UIApplication*)application;
-(void)initShareSDK;
-(void)initMobClick;
-(void)initUPushWithLaunchOptions:(NSDictionary *)launchOptions;

@end
