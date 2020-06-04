//
//  MainTabBarController.m
//  rehab
//
//  Created by herson on 6/15/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "MainTabBarController.h"
#import "DiscoveryController.h"
#import "GuideView.h"
#import "RehabIndexController.h"
#import "HomeController.h"
#import "HealthController.h"
#import "MeController.h"
#import "ShareUserData.h"
#import <UMMobClick/MobClick.h>

//test
#import "WRBodySelectorController.h"
#import "LoginController.h"
#import "WrNavigationController.h"
//#import "ArticleListController.h"
#import "WRDiscoveryController.h"
#import "MainViewController.h"

#import "ApplyViewController.h"
#import "ChatViewController.h"
#import "UserProfileManager.h"
//#import "ChatDemoHelper.h"
//#import "RedPacketChatViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "WRMyViewController.h"
#import "WrWebViewController.h"
#import "CommunityIndexControler.h"

static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

#if DEMO_CALL == 1
#import <Hyphenate/Hyphenate.h>

@interface MainTabBarController () <UIAlertViewDelegate, EMCallManagerDelegate,UITabBarControllerDelegate,UINavigationControllerDelegate>
#else

@interface MainTabBarController ()<UITabBarControllerDelegate,UINavigationControllerDelegate>
#endif
{
    NSArray *_viewControllers;
    BOOL  _launchCompleted;
    UIBarButtonItem *_addFriendItem;
    EMConnectionState _connectionState;
}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

@implementation MainTabBarController

-(instancetype)init {
    if (self = [super init]) {
        //self.tabBar.barTintColor = [UIColor wr_themeColor];
        
        
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.tabBar.frame;
    
    frame.size.height = 57.5;
    if (IPHONE_X) {
        
        frame.size.height = 57.5+30;
    }else{
        frame.size.height = 57.5;
    }
    
    
    
    frame.origin.y = self.view.frame.size.height - frame.size.height;
    
    self.tabBar.frame = frame;
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.barStyle = UIBarStyleDefault;
    
    //此处需要设置barStyle，否则颜色会分成上下两层
    
}

-(void)viewDidLoad
{
    self.tabBar.tintColor = [UIColor wr_themeColor];
    
    self.delegate = self;
    
    NSArray *classArray = @[ [HealthController class], /*[RehabIndexController class], */[DiscoveryController class],[CommunityIndexControler class],[WRMyViewController class]];
    NSArray *titleArray = @[NSLocalizedString(@"锻炼", nil), /*NSLocalizedString(@"康复", nil), */ NSLocalizedString(@"发现", nil),@"社区", NSLocalizedString(@"我的", nil)];
    NSArray *imageArray = @[@"锻炼灰色", /*@"main_tab_prevent",  */@"圈子",@"发现灰色", @"我的灰色"];
    NSArray *fusimageArray = @[@"锻炼蓝色", /*@"main_tab_prevent",  */  @"圈子-点击状态",@"发现蓝色" ,@"我的蓝色" ];
    NSMutableArray *viewControlArray = [NSMutableArray array];
    NSMutableArray *childViewControllers = [NSMutableArray array];
    for (int index = 0; index < classArray.count; index++)
    {
        Class class = [classArray objectAtIndex:index];
        UIViewController *vc = [[class alloc] init];
        //      if (index ==2) {
        //            WrWebViewController* web  = vc;
        //            web.url = [NSString stringWithFormat:@"http://www.well-health.cn/discuss/index.html?userId=%@",[WRUserInfo selfInfo].userId];
        //           // web.url = [NSString stringWithFormat:@"http://192.168.11.69/discuss1?userId=%@",[WRUserInfo selfInfo].userId];
        //            vc = web;
        //        }
        NSString *imageName = [imageArray objectAtIndex:index];
        UIImage *image = [UIImage imageNamed:imageName];
        UIImage *focusImage =[UIImage imageNamed:[fusimageArray objectAtIndex:index]] ;
        NSString *title = [titleArray objectAtIndex:index];
        
        UIViewController *viewController = nil;
        
        WrNavigationController *navigationController = [[WrNavigationController alloc] initWithRootViewController:vc];
        //                if(index == (classArray.count - 1))
        //                {
        //                    vc.edgesForExtendedLayout = UIRectEdgeNone;
        //                    vc.navigationController.navigationBarHidden = YES;
        //                    navigationController.delegate = (id)vc;
        //                }
        vc.title = title;
        if (index ==0) {
            vc.title = @"WELL健康";
        }
        navigationController.delegate=self;
        
        
        
        
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[focusImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        tabBarItem.tag = index;
        navigationController.tabBarItem = tabBarItem;
        
        [viewControlArray addObject:navigationController];
        [childViewControllers addObject:vc];
    }
    self.viewControllers = viewControlArray;
    _viewControllers = childViewControllers;
    
    [@[WRLogInNotification, WRLogOffNotification] enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:obj object:nil];
    }];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
    static UIViewController *lastController = nil;
    
    //若上个view不为空
    if (lastController != nil)
    {
        //若该实例实现了viewWillDisappear方法，则调用
        if ([lastController respondsToSelector:@selector(viewWillDisappear:)])
        {
            [lastController viewWillDisappear:animated];
        }
    }
    
    //将当前要显示的view设置为lastController，在下次view切换调用本方法时，会执行viewWillDisappear
    lastController = viewController;
    
    [viewController viewWillAppear:animated];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //每次当navigation中的界面切换，设为空。本次赋值只在程序初始化时执行一次
    static UIViewController *lastController = nil;
    
    //若上个view不为空
    if (lastController != nil)
    {
        //若该实例实现了viewWillDisappear方法，则调用
        if ([lastController respondsToSelector:@selector(viewDidAppear:)])
        {
            [lastController viewDidAppear: animated];
        }
    }
    
    //将当前要显示的view设置为lastController，在下次view切换调用本方法时，会执行viewWillDisappear
    lastController = viewController;
    
    [viewController viewDidAppear: animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


-(BOOL)prefersStatusBarHidden
{
    return NO;
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
    
    //    [self userHome];
    
    [self reloadData];
    
    RehabIndexController *rahabIndexController = _viewControllers[1];
    [rahabIndexController fetchData];
}

-(void)reloadData
{
    HealthController *homeController = _viewControllers.firstObject;
    [homeController loadData];
    
    MeController *meController = _viewControllers.lastObject;
    //    [meController fetchData];
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
-(void)viewWillAppear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}
-(void) viewDidAppear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}
-(void) viewWillDisappear:(BOOL)animated
{
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}
-(void) viewDidDisappear:(BOOL)animated
{
    [self.selectedViewController endAppearanceTransition];
}





//-(void)setupUnreadMessageCount
//{
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    NSInteger unreadCount = 0;
//    for (EMConversation *conversation in conversations) {
//        unreadCount += conversation.unreadMessagesCount;
//    }
//    if (_chatListVC) {
//        if (unreadCount > 0) {
//            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _chatListVC.tabBarItem.badgeValue = nil;
//        }
//    }
//
//    UIApplication *application = [UIApplication sharedApplication];
//    [application setApplicationIconBadgeNumber:unreadCount];
//}
//
//- (void)setupUntreatedApplyCount
//{
//    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
//    if (_contactsVC) {
//        if (unreadCount > 0) {
//            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _contactsVC.tabBarItem.badgeValue = nil;
//        }
//    }
//
//    [self.contactsVC reloadApplyView];
//}
//
//- (void)networkChanged:(EMConnectionState)connectionState
//{
//    _connectionState = connectionState;
//    [_chatListVC networkChanged:connectionState];
//}
//
//- (void)playSoundAndVibration{
//    NSTimeInterval timeInterval = [[NSDate date]
//                                   timeIntervalSinceDate:self.lastPlaySoundDate];
//    if (timeInterval < kDefaultPlaySoundInterval) {
//        //如果距离上次响铃和震动时间太短, 则跳过响铃
//        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
//        return;
//    }
//
//    //保存最后一次响铃时间
//    self.lastPlaySoundDate = [NSDate date];
//
//    // 收到消息时，播放音频
//    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
//    // 收到消息时，震动
//    [[EMCDDeviceManager sharedInstance] playVibration];
//}
//
//- (void)showNotificationWithMessage:(EMMessage *)message
//{
//    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
//    NSString *alertBody = nil;
//    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
//        EMMessageBody *messageBody = message.body;
//        NSString *messageStr = nil;
//        switch (messageBody.type) {
//            case EMMessageBodyTypeText:
//            {
//                messageStr = ((EMTextMessageBody *)messageBody).text;
//            }
//                break;
//            case EMMessageBodyTypeImage:
//            {
//                messageStr = NSLocalizedString(@"message.image", @"Image");
//            }
//                break;
//            case EMMessageBodyTypeLocation:
//            {
//                messageStr = NSLocalizedString(@"message.location", @"Location");
//            }
//                break;
//            case EMMessageBodyTypeVoice:
//            {
//                messageStr = NSLocalizedString(@"message.voice", @"Voice");
//            }
//                break;
//            case EMMessageBodyTypeVideo:{
//                messageStr = NSLocalizedString(@"message.video", @"Video");
//            }
//                break;
//            default:
//                break;
//        }
//
//        do {
//            NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
//            if (message.chatType == EMChatTypeGroupChat) {
//                NSDictionary *ext = message.ext;
//                if (ext && ext[kGroupMessageAtList]) {
//                    id target = ext[kGroupMessageAtList];
//                    if ([target isKindOfClass:[NSString class]]) {
//                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
//                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
//                            break;
//                        }
//                    }
//                    else if ([target isKindOfClass:[NSArray class]]) {
//                        NSArray *atTargets = (NSArray*)target;
//                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
//                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
//                            break;
//                        }
//                    }
//                }
//                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
//                for (EMGroup *group in groupArray) {
//                    if ([group.groupId isEqualToString:message.conversationId]) {
//                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
//                        break;
//                    }
//                }
//            }
//            else if (message.chatType == EMChatTypeChatRoom)
//            {
//                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
//                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
//                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
//                if (chatroomName)
//                {
//                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
//                }
//            }
//
//            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
//        } while (0);
//    }
//    else{
//        alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
//    }
//
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
//    BOOL playSound = NO;
//    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
//        self.lastPlaySoundDate = [NSDate date];
//        playSound = YES;
//    }
//
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
//    [userInfo setObject:message.conversationId forKey:kConversationChatter];
//
//    //发送本地推送
//    if (NSClassFromString(@"UNUserNotificationCenter")) {
//        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
//        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//        if (playSound) {
//            content.sound = [UNNotificationSound defaultSound];
//        }
//        content.body =alertBody;
//        content.userInfo = userInfo;
//        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
//        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
//    }
//    else {
//        UILocalNotification *notification = [[UILocalNotification alloc] init];
//        notification.fireDate = [NSDate date]; //触发通知的时间
//        notification.alertBody = alertBody;
//        notification.alertAction = NSLocalizedString(@"open", @"Open");
//        notification.timeZone = [NSTimeZone defaultTimeZone];
//        if (playSound) {
//            notification.soundName = UILocalNotificationDefaultSoundName;
//        }
//        notification.userInfo = userInfo;
//
//        //发送通知
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    }
//}
//
//#pragma mark - 自动登录回调
//
//- (void)willAutoReconnect{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
//    if (showreconnect && [showreconnect boolValue]) {
//        [self hideHud];
//        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
//    }
//}
//
//- (void)didAutoReconnectFinishedWithError:(NSError *)error{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
//    if (showreconnect && [showreconnect boolValue]) {
//        [self hideHud];
//        if (error) {
//            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
//        }else{
//            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
//        }
//    }
//}
//
//#pragma mark - public
//
//- (void)jumpToChatList
//{
//    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//        //        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
//        //        [chatController hideImagePicker];
//    }
//    else if(_chatListVC)
//    {
//        [self.navigationController popToViewController:self animated:NO];
//        [self setSelectedViewController:_chatListVC];
//    }
//}
//
//- (EMConversationType)conversationTypeFromMessageType:(EMChatType)type
//{
//    EMConversationType conversatinType = EMConversationTypeChat;
//    switch (type) {
//        case EMChatTypeChat:
//            conversatinType = EMConversationTypeChat;
//            break;
//        case EMChatTypeGroupChat:
//            conversatinType = EMConversationTypeGroupChat;
//            break;
//        case EMChatTypeChatRoom:
//            conversatinType = EMConversationTypeChatRoom;
//            break;
//        default:
//            break;
//    }
//    return conversatinType;
//}
//
//- (void)didReceiveLocalNotification:(UILocalNotification *)notification
//{
//    NSDictionary *userInfo = notification.userInfo;
//    if (userInfo)
//    {
//        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
//            //            [chatController hideImagePicker];
//        }
//
//        NSArray *viewControllers = self.navigationController.viewControllers;
//        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
//            if (obj != self)
//            {
//                if (![obj isKindOfClass:[ChatViewController class]])
//                {
//                    [self.navigationController popViewControllerAnimated:NO];
//                }
//                else
//                {
//                    NSString *conversationChatter = userInfo[kConversationChatter];
//                    ChatViewController *chatViewController = (ChatViewController *)obj;
//                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
//                    {
//                        [self.navigationController popViewControllerAnimated:NO];
//                        EMChatType messageType = [userInfo[kMessageType] intValue];
//#ifdef REDPACKET_AVALABLE
//                        chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
//#else
//                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
//#endif
//                        [self.navigationController pushViewController:chatViewController animated:NO];
//                    }
//                    *stop= YES;
//                }
//            }
//            else
//            {
//                ChatViewController *chatViewController = nil;
//                NSString *conversationChatter = userInfo[kConversationChatter];
//                EMChatType messageType = [userInfo[kMessageType] intValue];
//#ifdef REDPACKET_AVALABLE
//                chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
//#else
//                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
//#endif
//                [self.navigationController pushViewController:chatViewController animated:NO];
//            }
//        }];
//    }
//    else if (_chatListVC)
//    {
//        [self.navigationController popToViewController:self animated:NO];
//        [self setSelectedViewController:_chatListVC];
//    }
//}
//
//- (void)didReceiveUserNotification:(UNNotification *)notification
//{
//    NSDictionary *userInfo = notification.request.content.userInfo;
//    if (userInfo)
//    {
//        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//            //            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
//            //            [chatController hideImagePicker];
//        }
//
//        NSArray *viewControllers = self.navigationController.viewControllers;
//        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
//            if (obj != self)
//            {
//                if (![obj isKindOfClass:[ChatViewController class]])
//                {
//                    [self.navigationController popViewControllerAnimated:NO];
//                }
//                else
//                {
//                    NSString *conversationChatter = userInfo[kConversationChatter];
//                    ChatViewController *chatViewController = (ChatViewController *)obj;
//                    if (![chatViewController.conversation.conversationId isEqualToString:conversationChatter])
//                    {
//                        [self.navigationController popViewControllerAnimated:NO];
//                        EMChatType messageType = [userInfo[kMessageType] intValue];
//#ifdef REDPACKET_AVALABLE
//                        chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
//#else
//                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
//#endif
//                        [self.navigationController pushViewController:chatViewController animated:NO];
//                    }
//                    *stop= YES;
//                }
//            }
//            else
//            {
//                ChatViewController *chatViewController = nil;
//                NSString *conversationChatter = userInfo[kConversationChatter];
//                EMChatType messageType = [userInfo[kMessageType] intValue];
//#ifdef REDPACKET_AVALABLE
//                chatViewController = [[RedPacketChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
//#else
//                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
//#endif
//                [self.navigationController pushViewController:chatViewController animated:NO];
//            }
//        }];
//    }
//    else if (_chatListVC)
//    {
//        [self.navigationController popToViewController:self animated:NO];
//        [self setSelectedViewController:_chatListVC];
//    }
//}




@end
