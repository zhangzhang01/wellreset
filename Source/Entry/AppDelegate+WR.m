//
//  AppDelegate+WR.m
//  rehab
//
//  Created by herson on 16/4/2.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "AppDelegate+WR.h"
#import "SVProgressHUD.h"
#import "IQKeyboardManager/IQKeyboardManager.h"


#import "CheckPayOrder.h"
#import "UMessage.h"
#import <UMMobClick/MobClick.h>



#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#import "RehabController.h"
#import "CommutiDetailController.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import "WXApi.h"
//新浪微博SDK头文件

#import "ArticleDetailController.h"
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
    [CheckPayOrder checkPayOrder];
    [[[IQKeyboardManager sharedManager] disabledDistanceHandlingClasses] addObject:[ArticleDetailController class]];
    [[[IQKeyboardManager sharedManager] disabledDistanceHandlingClasses] addObject:[CommutiDetailController class]];
    UIColor *color = [UIColor wr_themeColor];
    //[UISwitch appearance].tintColor = color;
    [UISlider appearance].tintColor = color;
    [UISegmentedControl appearance].tintColor = color;
    [UIButton appearance].tintColor = color;
    [[UIActivityIndicatorView appearance] setColor:color];
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
//    [[UINavigationBar appearance] lt_setBackgroundColor:[UIColor wr_rehabBlueColor]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19] /*,NSShadowAttributeName:shadow*/}];;
    application.statusBarStyle = UIStatusBarStyleDefault;
    application.statusBarHidden = NO;
    
    CGRect rcScreen = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:rcScreen];
    self.window.backgroundColor = [UIColor whiteColor];
}

-(void)initNotification:(UIApplication*)application {
    // Override point for customization after application launch.
    // iOS 8 Notifications
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *isCleanAlarm = [ud objectForKey:@"isCleanAlarm"];
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        //注册本地推送
        if (!isCleanAlarm) {
            [ud setObject:@"isFirstLaunch" forKey:@"isCleanAlarm"];
//            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [center removeAllPendingNotificationRequests];
        }
        //监听回调事件
        center.delegate = self;
        //iOS 10 使用以下方法注册，才能得到授权
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {
                                  // Enable or disable features based on authorization.
                              }];
        //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        }];
    } else {
        if (!isCleanAlarm) {
            [ud setObject:@"isFirstLaunch" forKey:@"isCleanAlarm"];
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
        }
        UIUserNotificationType userNotificationType = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:userNotificationType categories:nil]];
        [application registerForRemoteNotifications];
    }
}

-(void)initMobClick {
    UMConfigInstance.appKey = UMAppKey;
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setLogEnabled:YES];
    NSLog(@"%@",[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@".umeng"]);
    
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    
}

-(void)initUMengShare {
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppKey];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WechatAppID appSecret:WechatAppKey redirectURL:RedirectUrl];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppID/*设置QQ平台的appID*/  appSecret:QQAppKey redirectURL:RedirectUrl];
    
   // [UMSocialQQHandler setQQWithAppId:QQAppID appKey:QQAppKey url:RedirectUrl];
   // [UMSocialWechatHandler setWXAppId:WechatAppID appSecret:WechatAppKey url:RedirectUrl];
}

-(void)initShareSDK {
    
    [self initUMengShare];
}

-(void)initUPushWithLaunchOptions:(NSDictionary *)launchOptions
{
    [UMessage startWithAppkey:UMAppKey launchOptions:launchOptions ];
    [UMessage registerForRemoteNotifications];
    
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    //打开日志，方便调试
    [UMessage setLogEnabled:YES];
    
}
+(void)show:(NSString*)str
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = [NSString stringWithFormat:@"%@",str];
    //            hud.yOffsezt=keyWindow.bounds.size.height/2-180;
    hud.margin = 10.f;
    //                hud.yOffset =  [ UIScreen mainScreen ].bounds.size.width*1.0/2;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
}
@end
