//
//  AppDelegate.m
//  rehab
//
//  Created by HX on 16/2/5.
//  Copyright © 2016年 Matech. All rights reserved.
//


#import "AppDelegate.h"
#import "AppDelegate+WR.h"

#import <UMMobClick/MobClick.h>
#import "UMessage.h"


#import "WRUserInfo.h"
#import "ShareUserData.h"

#import "AFNetworking.h"
#import "WRNetworkService.h"
#import "WRBaseRequest.h"
#import "UserViewModel.h"

#import "LaunchView.h"
#import "ZWIntroductionViewController.h"
#import "HomeController.h"
#import "LeftSideController.h"
#import "MainDrawerController.h"
#import "AlarmController.h"
#import "AdvertiseViewController.h"
#import "AdvertiseView.h"

#import "FCAlertView.h"
#import "iVersion.h"

#import "MainTabBarController.h"
#import "GuidIndexViewController.h"
#import "LoginController.h"
#import "WrNavigationController.h"
#import "SmsLoginViewController.h"

#import "IQKeyboardManager.h"
#import "ArticleDetailController.h"
#import "NotNetworkController.h"
#import <YYKit/YYKit.h>
#import "AskIndexController.h"
#import "ArticleDetailController.h"
#import "WRFAQViewModel.h"

//#import "MainViewController.h"
#import "LoginViewController.h"

//#import "AppDelegate+EaseMob.h"
#import "AppDelegate+UMeng.h"
#import "AppDelegate+Parse.h"
//#import "RedPacketUserConfig.h"
#import <UserNotifications/UserNotifications.h>
#import <Fabric/Fabric.h>
#import "AppDelegate+EaseMob.h"
#import <Crashlytics/Crashlytics.h>
//#import <AlipaySDK/AlipaySDK.h>
#import "ChatDemoHelper.h"
#import "WXApi.h"
//#import <AlipaySDK/AlipaySDK.h>
#define ORDER_PAY_NOTIFICATION @"wxpay"
#import "DES3Util.h"
@interface AppDelegate ()<UNUserNotificationCenterDelegate,WXApiDelegate>
@property(nonatomic) LaunchView *launchView;
@end
#define EaseMobAppKey @"1181170615178207#well-health"
@implementation AppDelegate
-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarOrientation:)]){
        SEL selector = NSSelectorFromString(@"setStatusBarOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIApplication instanceMethodSignatureForSelector:selector]];
        UIDeviceOrientation orentation = UIDeviceOrientationPortrait;
        [invocation setSelector:selector];
        [invocation setTarget:[UIApplication sharedApplication]];
        [invocation setArgument:&orentation atIndex:2];
        [invocation invoke];
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    
//    if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarOrientation:)]){
//        SEL selector = NSSelectorFromString(@"setStatusBarOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIApplication instanceMethodSignatureForSelector:selector]];
//        UIDeviceOrientation orentation = UIDeviceOrientationPortrait;
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIApplication sharedApplication]];
//        [invocation setArgument:&orentation atIndex:2];
//        [invocation invoke];
//    }
    
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    }
    
    [Fabric with:@[[Crashlytics class]]];
    [[IQKeyboardManager sharedManager]setEnable:YES  ];
    [DES3Util encryptUseDES:@"1234" key:@"#@#fdsfsd4545&%GFDGDF"];
    
#ifdef REDPACKET_AVALABLE
    /**
     *  TODO: 通过环信的AppKey注册红包
     */
    [[RedPacketUserConfig sharedConfig] configWithAppKey:EaseMobAppKey];
#endif
    
    _connectionState = EMConnectionConnected;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        [[UINavigationBar appearance] setBarTintColor:RGBACOLOR(30, 167, 252, 1)];
        [[UINavigationBar appearance] setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:RGBACOLOR(245, 245, 245, 1), NSForegroundColorAttributeName, [UIFont fontWithName:@ "HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    }
    
    
    // 环信UIdemo中有用到友盟统计crash，您的项目中不需要添加，可忽略此处。
//    [self setupUMeng];
    
    // 环信UIdemo中有用到Parse，您的项目中不需要添加，可忽略此处。
    //[self parseApplication:application didFinishLaunchingWithOptions:launchOptions];
    
//#warning Init SDK，detail in AppDelegate+EaseMob.m
//#warning SDK注册 APNS文件的名字, 需要与后台上传证书时的名字一一对应
//    NSString *apnsCertName = nil;
//#if DEBUG
//    apnsCertName = @"aps_dev";
//#else
//    apnsCertName = @"aps";
//#endif
//
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//  NSString *appkey = [ud stringForKey:@"identifier_appkey"];
//    if (!appkey) {
//        appkey = EaseMobAppKey;
//        [ud setObject:appkey forKey:@"identifier_appkey"];
//    }
//
//    [self easemobApplication:application
//didFinishLaunchingWithOptions:launchOptions
//                      appkey:appkey
//                apnsCertName:apnsCertName
//                 otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
//
//
//    [iVersion sharedInstance].appStoreID = [WRAppId unsignedIntegerValue];

    [self initUPushWithLaunchOptions:launchOptions];
    
    [self initUI:application];
    [self initNotification:application];
    [self initShareSDK];
    [self initMobClick];
    
    
    NSString *key = @"lastAppDate";
    NSDate *date = [ud objectForKey:key];
    if (date && [date timeIntervalSinceNow] < -1*60) {
        [WRBaseRequest clearCache];
        NSLog(@"clear network cache");
    }
    [ud setObject:date forKey:key];
    
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    [selfInfo restore];
    if([[WRUserInfo selfInfo] isLogged]) {
        [MobClick profileSignInWithPUID:[WRUserInfo selfInfo].userId];
    }
    
    [self fetchApi];
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    
    return YES;
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSDate* date = notification.date;
    
    //1. 处理通知
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    NSMutableArray* arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"noti"]];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if (userInfo) {
        NSDictionary* aps = userInfo[@"aps"];
//        NSDictionary* alart = aps[@"alert"];
        if (aps) {
            if ([userInfo[@"type"]isEqualToString:@"ask"]) {
              dic[@"type"] = @"ask";
                NSDictionary* alart = aps[@"alert"];
                if (alart&&[alart isKindOfClass:[NSDictionary class]]) {
                    dic[@"title"] = alart[@"title"];
                    dic[@"subtitle"] = alart[@"subtitle"];
                    dic[@"body"] = alart[@"body"];
                    
                    dic[@"time"] = [formatter stringFromDate:date];
                }
                [arr addObject:dic];
            }
            else if ([userInfo[@"type"] isEqualToString:@"article"]||[userInfo[@"type"] isEqualToString:@"text"])
            {
                dic[@"type"] = @"article";
                dic[@"imageUrl"] = userInfo[@"imageUrl"];
                dic[@"article_uuid"] = userInfo[@"article_uuid"];
                dic[@"isOpen"] = [NSNumber numberWithBool:NO];
                
                NSDictionary* alart = aps[@"alert"];
                if (alart&&[alart isKindOfClass:[NSDictionary class]]) {
                    dic[@"title"] = alart[@"title"];
                    dic[@"subtitle"] = alart[@"subtitle"];
                    dic[@"body"] = alart[@"body"];
                    dic[@"time"] = [formatter stringFromDate:date];
                    
                }
                [arr addObject:dic];

            }
        }
    }
    
    [def setObject:arr forKey:@"noti"];
    
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    
}




-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    [self easemobApplication:[UIApplication sharedApplication] didReceiveRemoteNotification:userInfo];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        NSDate* date = response.notification.date;
        
        //1. 处理通知
        NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
        NSMutableArray* arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"noti"]];
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        
        
        NSMutableDictionary* dic = [NSMutableDictionary dictionary];
        if (userInfo) {
            NSDictionary* aps = userInfo[@"aps"];
            //        NSDictionary* alart = aps[@"alert"];
            if (aps) {
                if ([userInfo[@"type"]isEqualToString:@"ask"]) {
                    dic[@"type"] = @"ask";
                    NSDictionary* alart = aps[@"alert"];
                    if (alart&&[alart isKindOfClass:[NSDictionary class]]) {
                        dic[@"title"] = alart[@"title"];
                        dic[@"subtitle"] = alart[@"subtitle"];
                        dic[@"body"] = alart[@"body"];
                        
                        dic[@"time"] = [formatter stringFromDate:date];
                        UITabBarController* tabbar = self.window.rootViewController;
                        if ([tabbar isKindOfClass:[MainTabBarController class]]) {
                            UINavigationController* navi  = tabbar.viewControllers[tabbar.selectedIndex];
                            AskIndexController* aks = [AskIndexController new];
                            aks.index = 1;
                            aks.hidesBottomBarWhenPushed=YES;
                            [navi pushViewController:aks animated:YES];
                        }
                        
                    }
                    [arr addObject:dic];
                }
                else if ([userInfo[@"type"] isEqualToString:@"article"]||[userInfo[@"type"] isEqualToString:@"text"])
                {
                    dic[@"type"] = @"article";
                    dic[@"imageUrl"] = userInfo[@"imageUrl"];
                    dic[@"article_uuid"] = userInfo[@"article_uuid"];
                    dic[@"isOpen"] = [NSNumber numberWithBool:YES];
                    
                    NSDictionary* alart = aps[@"alert"];
                    if (alart&&[alart isKindOfClass:[NSDictionary class]]) {
                        dic[@"title"] = alart[@"title"];
                        dic[@"subtitle"] = alart[@"subtitle"];
                        dic[@"body"] = alart[@"body"];
                        dic[@"time"] = [formatter stringFromDate:date];
                        
                    }
                    if (dic[@"article_uuid"]) {
                        [WRFAQViewModel userGetFavorStateWithArticleId:dic[@"article_uuid"] completion:^(NSError *error, WRArticle *article) {
                            UITabBarController* tabbar = self.window.rootViewController;
                            if ([tabbar isKindOfClass:[MainTabBarController class]]) {
                            UINavigationController* navi  = tabbar.viewControllers[tabbar.selectedIndex];
                            ArticleDetailController* art = [ArticleDetailController new];
                            art.hidesBottomBarWhenPushed = YES;
                            art.currentNews = article;
                            [navi pushViewController:art animated:YES];
                            [arr addObject:dic];
                            }
                        }];
                        
                    }
                   
                    
                }
            }
        }
        
        [def setObject:arr forKey:@"noti"];

        
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
    [self userHome:NO];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   // [UMSocialSnsService applicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* deviceTokenString = [deviceToken description];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@">" withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:@"uuid"];
    NSLog(@"device token %@", deviceTokenString);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        
        if ([url.host isEqualToString:@"safepay"]) {
            //跳转支付宝钱包进行支付，处理支付结果
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//            }];
        }
       else  if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
            return [WXApi handleOpenURL:url delegate:self];
        }else if ([sourceApplication isEqualToString:@"com.alipay.safepayclient"]) {
//            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//                NSLog(@"result = %@",resultDic);
//
//            }];
            return YES;
        }
        else
        {
           return  [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
            
        }
        return YES;
    }
    
    
    
    return result;
}

-(BOOL)application:(UIApplication*)app
           openURL:(NSURL*)url
           options:(NSDictionary<NSString*,id>*)option
{
    if ([option[@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.tencent.xin"]) {
        [[UMSocialManager defaultManager] handleOpenURL:url];
        return [WXApi handleOpenURL:url delegate:self];;
    }else if ([option[@"UIApplicationOpenURLOptionsSourceApplicationKey"] isEqualToString:@"com.alipay.iphoneclient"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//            NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:resultDic[@"resultStatus"]];
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//        }];
        return YES;
    }
    else
    {
        [[UMSocialManager defaultManager] handleOpenURL:url];
        
    }
    return YES;
    
    
    
}

#pragma mark -
-(void)showIntroduction
{
    NSArray *backgroundImageNames = @[@"in_1", @"in_2", @"in_3", @"in_4"];
    NSMutableArray *paths = [NSMutableArray new];
    
    for (NSString *imageName in backgroundImageNames) {
        NSLog(@"%@",[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]);
        [paths addObject:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
    }
    ZWIntroductionViewController *viewController = [[ZWIntroductionViewController alloc] initWithCoverImageNames:paths
                                                                                            backgroundImageNames:paths];
    __weak __typeof(self) weakSelf = self;
    viewController.didSelectedEnter = ^() {
        
        [weakSelf showMainViewController];
        
    };
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
}

-(void)showMainViewController {
//#if 0
//    AlarmController *mainViewController = [[AlarmController alloc] init];
//    UINavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:mainViewController];
//    mainViewController.navigationController.navigationBarHidden = YES;
//    self.window.rootViewController = nav;
//#else
    
        MainTabBarController *tabbarController = [[MainTabBarController alloc] init];
    self.window.rootViewController = tabbarController;
//    UIImage *defaultHeadImage = [WRUIConfig defaultHeadImage];
//    CGFloat leftSideWidth = defaultHeadImage.size.width*2;
//    HomeController *homeController = [[HomeController alloc] init];
//    UINavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:homeController];
//    
//    LeftSideController * leftDrawer = [[LeftSideController alloc] initWithSideWidth:leftSideWidth];
//    leftDrawer.clickedEvent = homeController.clickedEvent;
//    
//    MMDrawerController * drawerController = [[MainDrawerController alloc]
//                                             initWithCenterViewController:nav
//                                             leftDrawerViewController:leftDrawer
//                                             rightDrawerViewController:nil];
//    drawerController.view.backgroundColor = [UIColor whiteColor];
//    
//    //4、设置打开/关闭抽屉的手势
//    drawerController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
//    drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeTapCenterView;
//    //5、设置左右两边抽屉显示的多少
//    drawerController.maximumLeftDrawerWidth = leftSideWidth;
//    drawerController.maximumRightDrawerWidth = leftSideWidth;
//    
    
    NSString *adUrl = [WRNetworkService getFormatURLString:urlAd];
  //  adUrl = @"http://g.hiphotos.baidu.com/zhidao/pic/item/f2deb48f8c5494ee665ec00f29f5e0fe99257eac.jpg";
//    NSLog(@"adUrl%@",adUrl);
    BOOL flag = ![Utility IsEmptyString:adUrl];
    //    UIImageView *imageView = nil;
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
//    selfInfo.isLogged&&!flag
    if (selfInfo.isLogged) {
        AdvertiseViewController * adviewcontroller = [[AdvertiseViewController  alloc]initWithImageUrl:adUrl];
        self.window.rootViewController = adviewcontroller ;
        //        [self.window makeKeyAndVisible];
        [adviewcontroller.advertiseView startplayAdvertisingView:^(AdvertiseView * adverview) {
            // 更换根控制器
            self.window.rootViewController = tabbarController;
            
        }];
        
    } else {
        SmsLoginViewController* login = [SmsLoginViewController new];
        WrNavigationController * navi = [[WrNavigationController alloc]initWithRootViewController:login];
        self.window.rootViewController = navi;
        [tabbarController presentViewController:navi animated:NO completion:^{
            
        }];
       
        
        
    }
    
    
    

    [self.window makeKeyAndVisible];
    //[homeController showAnimation];
//    if ([tabbarController isKindOfClass:[MainTabBarController class]]) {
//        [ChatDemoHelper shareHelper].mainVC = tabbarController;
//        //    UIViewController* vc  = [ChatDemoHelper shareHelper].mainVC;
//        [[ChatDemoHelper shareHelper] asyncGroupFromServer];
//        [[ChatDemoHelper shareHelper] asyncConversationFromDB];
//        [[ChatDemoHelper shareHelper] asyncPushOptions];
//    }
    
    
    /*
     LaunchView *launchView = [[LaunchView alloc] initWithFrame:self.window.frame];
     [self.window addSubview:launchView];
     launchView.completion = ^() {
     [homeController showAnimation];
     };
     [launchView start];
     */
    [self userHome:YES];
}
-(void)onResp:(BaseResp*)resp{
    
    
    NSLog(@"resp----%@",resp);
    NSString* strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString* strTitle = [NSString stringWithFormat:@"支付结果"];
    if ([resp isKindOfClass:[PayResp class]]){
        //        PayResp*response=(PayResp*)resp;
        switch (resp.errCode) {
            case WXSuccess:
            {
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                UINavigationController* curren=[self getCurrentVC];
                
                NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
                break;
                
            default:
                
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:@"fail"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
        }
    }
    else if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            self.code=code;
            NSNotification *notification = [NSNotification notificationWithName:@"wxlogin" object:@"yes"];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //    [alert show];
}




- (UINavigationController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UINavigationController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

-(void)entry {
    const float currentIntroVersion = 1.1;
    NSString * key = @"intro";
    NSString *introVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (introVersion && introVersion.floatValue >= currentIntroVersion)
    {
        [self showMainViewController];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setFloat:currentIntroVersion forKey:key];
        [self showIntroduction];
    }
    
    
//    [[NSUserDefaults standardUserDefaults] setFloat:currentIntroVersion forKey:key];
//            [self showIntroduction];
}

#pragma mark - IBAction
-(IBAction)onClickedIntroEnterButton:(id)sender {
    [self showMainViewController];
}

#pragma mark - network
-(void)userHome:(BOOL)force
{
    if ([[WRUserInfo selfInfo] isLogged])
    {
        NSDate *lastUserHomeDate = [UserProfile defaultProfile].lastUserHomeDate;
        NSDate *nowDate = [NSDate date];
        if (!force && [nowDate timeIntervalSinceDate:lastUserHomeDate] < (3600)) {
            return;
        }
        
        NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        if(uuid == nil)
        {
            uuid = @"";
        }
        [WRViewModel userHomeWithCompletion:^(NSError * _Nonnull error, id  _Nonnull resultObject) {
            if (error) {
                if (error.code == WRErrorCodeWrongUser) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:WRLogOffNotification object:nil];
                    NSLog(@"User validate error, log off");
                }
            }
            else
            {
                [UserProfile defaultProfile].lastUserHomeDate = nowDate;
                NSLog(@"======= User Home success");
            }
        } apnsUUID:uuid];
    }
}

-(void)fetchApi
{
    NSDate *date = [NSDate date];
    
    __weak __typeof(self) weakSelf = self;
    [[WRNetworkService defaultService] fetchInterfaceWithCompletion:^(NSError *error) {
        do {
            
            if (error.code == -1009 ) {
                NotNetworkController* novc = [NotNetworkController new];
                UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:novc];
                
                weakSelf.window.rootViewController = navi;
                novc.didSelectedBack = ^() {
                    
                    [weakSelf entry];
                    
                    
                    
                };
                [weakSelf.window makeKeyAndVisible];
            }else
            {
                [weakSelf entry];
            }
            
            
            if (error)
            {
                if (error.code == WRNetworkErrorNeedUpdate)
                {
                    NSString *updateUrl = error.userInfo[@"download"];
                    if (![Utility IsEmptyString:updateUrl])
                    {
                        NSLog(@"need update %@", updateUrl);
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            [weakSelf alertForUpgrade:updateUrl];
                        }];
                        return;
                    }
                }
            }
            
            NSDate *nowDate = [NSDate date];
            NSTimeInterval interval = [nowDate timeIntervalSinceDate:date];
            if (interval < 2) {
                [NSThread sleepForTimeInterval:(2 - interval)];
            }
            
            
            
            
        } while (NO);
    }];
}


-(void)alertForUpgrade:(NSString*)urlString
{
    //    [JCAlertView showOneButtonWithTitle:NSLocalizedString(@"提示", nil) Message:NSLocalizedString(@"版本太旧，需要升级至最新版本才能继续使用", nil) ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:NSLocalizedString(@"立即升级", nil) Click:^{
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    //    }];
    
    FCAlertView *alert = [[FCAlertView alloc] init];
    [alert showAlertInView:nil withTitle:NSLocalizedString(@"提示", nil) withSubtitle:NSLocalizedString(@"版本太旧，需要升级至最新版本才能继续使用", nil) withCustomImage:nil withDoneButtonTitle:nil andButtons:nil];
    [alert addButton:NSLocalizedString(@"立即升级", nil) withActionBlock:^{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }];
    alert.hideDoneButton = YES;
    alert.colorScheme = [UIColor wr_themeColor];

}
//




@end
