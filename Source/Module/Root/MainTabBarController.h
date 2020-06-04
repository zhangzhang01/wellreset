//
//  MainTabBarController.h
//  rehab
//
//  Created by herson on 6/15/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBaseViewController.h"
#import <UserNotifications/UserNotifications.h>

//#import "ConversationListController.h"
//#import "ContactListViewController.h"
@interface MainTabBarController : UITabBarController

//@property (nonatomic, strong) ConversationListController *chatListVC;
//@property (nonatomic, strong) ContactListViewController *contactsVC;
-(void)loadData;
//- (void)jumpToChatList;

//- (void)setupUntreatedApplyCount;

//- (void)setupUnreadMessageCount;

//- (void)networkChanged:(EMConnectionState)connectionState;

//- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

//- (void)didReceiveUserNotification:(UNNotification *)notification;

//- (void)playSoundAndVibration;

//- (void)showNotificationWithMessage:(EMMessage *)message;
@end
