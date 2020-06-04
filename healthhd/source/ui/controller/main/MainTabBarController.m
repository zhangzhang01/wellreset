//
//  MainTabBarController.m
//  rehab
//
//  Created by 何寻 on 6/15/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "MainTabBarController.h"
#import "DiscoveryController.h"
#import "GuideView.h"
#import "RehabIndexController.h"
#import "HomeController.h"
#import "MeController.h"
#import "ShareUserData.h"
#import <UMMobClick/MobClick.h>

@interface MainTabBarController ()<UITabBarControllerDelegate>
{
    NSArray *_viewControllers;
    BOOL  _launchCompleted;
}

@end

@implementation MainTabBarController

-(instancetype)init {
    if (self = [super init]) {
        self.tabBar.tintColor = [UIColor wr_themeColor];
        self.delegate = self;
        
        NSArray *classArray = @[ [HomeController class], [RehabIndexController class], [DiscoveryController class], [MeController class]];
        NSArray *titleArray = @[NSLocalizedString(@"WELL", nil), NSLocalizedString(@"康复", nil),  NSLocalizedString(@"发现", nil), NSLocalizedString(@"我", nil)];
        NSArray *imageArray = @[@"main_tab_rehab", @"main_tab_prevent",  @"main_tab_relate", @"main_tab_me"];
        
        NSMutableArray *viewControlArray = [NSMutableArray array];
        NSMutableArray *childViewControllers = [NSMutableArray array];
        for (int index = 0; index < classArray.count; index++)
        {
            Class class = [classArray objectAtIndex:index];
            UIViewController *vc = [[class alloc] init];
            NSString *imageName = [imageArray objectAtIndex:index];
            UIImage *image = [UIImage imageNamed:imageName];
            UIImage *focusImage = [UIImage imageNamed:[imageName stringByAppendingString:@"_focus"]];
            NSString *title = [titleArray objectAtIndex:index];
            UINavigationController *nvc = [[WRBaseNavigationController alloc] initWithRootViewController:vc];
            if(index == 0 || index == (classArray.count - 1))
            {
                vc.edgesForExtendedLayout = UIRectEdgeNone;
                vc.navigationController.navigationBarHidden = YES;
                nvc.delegate = (id)vc;
            }
            vc.title = title;
            UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:image selectedImage:focusImage];
            tabBarItem.tag = index;
            nvc.tabBarItem = tabBarItem;
            
            [viewControlArray addObject:nvc];
            [childViewControllers addObject:vc];
        }
        self.viewControllers = viewControlArray;
        _viewControllers = childViewControllers;
        
        [@[WRLogInNotification, WRLogOffNotification] enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:obj object:nil];
        }];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden
{
    return !_launchCompleted;
}

#pragma mark - UITabBarControllerDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index = item.tag;
    [UMengUtils careForMainWithIndex:index];
}

#pragma mark - Handler
-(void)notificationHandler:(NSNotification*)notification
{
    if ([notification.name isEqualToString:WRLogInNotification])
    {
        [self userHome];
        [self reloadData];
        [self notifyUserDataChanged];
        NSLog(@"Recv WRLogInNotification");
    }
    else if([notification.name isEqualToString:WRLogOffNotification])
    {
        /**
         *  非法用户 清除其登录信息
         */
        [MobClick profileSignOff];
        [[WRUserInfo selfInfo] clear];
        [[ShareUserData userData] clear];
        
        [self reloadData];
        [self notifyUserDataChanged];
        NSLog(@"Recv WRLogOffNotification");
    }
}

-(void)notifyUserDataChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WRUpdateSelfInfoNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:WRReloadRehabNotification object:nil];
}

#pragma mark -
-(void)loadData
{
    _launchCompleted = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self userHome];

    [self reloadData];
    
    RehabIndexController *rahabIndexController = _viewControllers[1];
    [rahabIndexController fetchData];
}

-(void)reloadData
{
    HomeController *homeController = _viewControllers.firstObject;
    [homeController loadData];
    
    MeController *meController = _viewControllers.lastObject;
    [meController fetchData];
}


-(void)userHome
{
    if ([[WRUserInfo selfInfo] isLogged])
    {
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
        } apnsUUID:uuid];
    }
}
@end
