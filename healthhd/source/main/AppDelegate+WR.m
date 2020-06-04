//
//  AppDelegate+WR.m
//  rehab
//
//  Created by 何寻 on 16/4/2.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "AppDelegate+WR.h"
#import "SVProgressHUD.h"
#import "IQKeyboardManager/IQKeyboardManager.h"

#import "UMessage.h"
#import <UMMobClick/MobClick.h>


#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#import "RehabController.h"

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件


@implementation AppDelegate (WR)

-(void)test {
    CGRect rcScreen = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:rcScreen];
    self.window.backgroundColor = [UIColor whiteColor];
    UIViewController *controller = [[UIViewController alloc] init];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
}

-(void)initUI:(UIApplication*)application {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setMinimumDismissTimeInterval:1.3];
    [IQKeyboardManager sharedManager].enable = YES;
    
    UIColor *color = [UIColor wr_themeColor];
    //[UISwitch appearance].tintColor = color;
    [UISlider appearance].tintColor = color;
    [UISegmentedControl appearance].tintColor = color;
    [UIButton appearance].tintColor = color;
    [[UIActivityIndicatorView appearance] setColor:color];
    [[UINavigationBar appearance] setBarTintColor:color];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //[UINavigationBar appearance].translucent = NO;
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor] /*,NSShadowAttributeName:shadow*/}];;
    application.statusBarStyle = UIStatusBarStyleDefault;
    application.statusBarHidden = NO;
    
    CGRect rcScreen = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:rcScreen];
    self.window.backgroundColor = [UIColor whiteColor];
}

-(void)initNotification:(UIApplication*)application {
    // Override point for customization after application launch.
    // iOS 8 Notifications
    UIUserNotificationType userNotificationType = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:userNotificationType categories:nil]];
    [application registerForRemoteNotifications];
}

-(void)initMobClick {
    UMConfigInstance.appKey = UMAppKey;
    [MobClick startWithConfigure:UMConfigInstance];
}

-(void)initUMengShare {
    [UMSocialData setAppKey:UMAppKey];
    [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:RedirectUrl];
    [UMSocialWechatHandler setWXAppId:WechatAppID appSecret:WechatAppKey url:RedirectUrl];
}

-(void)initShareSDK {
    
    [self initUMengShare];
}

-(void)initUPushWithLaunchOptions:(NSDictionary *)launchOptions
{
    [UMessage startWithAppkey:UMAppKey launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
}
@end
