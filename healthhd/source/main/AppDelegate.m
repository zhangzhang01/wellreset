//
//  AppDelegate.m
//  rehab
//
//  Created by HX on 16/2/5.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "AFNetworking.h"
#import "AppDelegate.h"
#import "AppDelegate+WR.h"
#import "LaunchView.h"
#import "WRNetworkService.h"
#import "ZWIntroductionViewController.h"
#import "WRUserInfo.h"
#import "MainTabbarController.h"
#import <UMMobClick/MobClick.h>
#import "UMessage.h"
#import "WRBaseRequest.h"
#import "UMSocial.h"

#import "LoginController.h"
#import "WRNetworkService.h"

@interface AppDelegate ()

@property(nonatomic) LaunchView *launchView;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self initUPushWithLaunchOptions:launchOptions];
    
    [self initUI:application];
    //[self initNotification:application];
    [self initShareSDK];
    [self initMobClick];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
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

    [self entry];
    return YES;
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UMSocialSnsService applicationDidBecomeActive];
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

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
    }
    return result;
}

-(BOOL)application:(UIApplication*)app
           openURL:(NSURL*)url
           options:(NSDictionary<NSString*,id>*)option
{
    
    return [UMSocialSnsService handleOpenURL:url];
}

#pragma mark -
-(void)showMainViewController {
#if 0
    LoginController *mainViewController = [[LoginController alloc] init];
    UINavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:mainViewController];
    mainViewController.navigationController.navigationBarHidden = YES;
    self.window.rootViewController = nav;
#else
    MainTabBarController *tabbarController = [[MainTabBarController alloc] init];
    self.window.rootViewController = tabbarController;
#endif
    [self.window makeKeyAndVisible];
    LaunchView *launchView = [[LaunchView alloc] initWithFrame:self.window.frame];
    [self.window addSubview:launchView];
    launchView.completion = ^() {
        [tabbarController loadData];
    };
     [launchView start];
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
        NSArray *backgroundImageNames = @[@"intro_1", @"intro_2", @"intro_3", @"intro_4"];
        NSMutableArray *paths = [NSMutableArray new];
        for (NSString *imageName in backgroundImageNames) {
            [paths addObject:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
        }
        ZWIntroductionViewController *viewController = [[ZWIntroductionViewController alloc] initWithCoverImageNames:paths
                                                                                                backgroundImageNames:paths];
        __weak __typeof(self) weakSelf = self;
        viewController.didSelectedEnter = ^() {
            [[NSUserDefaults standardUserDefaults] setFloat:currentIntroVersion forKey:key];
            [weakSelf showMainViewController];
        };
        self.window.rootViewController = viewController;
        [self.window makeKeyAndVisible];
    }
}

#pragma mark - IBAction
-(IBAction)onClickedIntroEnterButton:(id)sender {
    [self showMainViewController];
}

@end
