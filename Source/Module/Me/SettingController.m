//
//  SettingController.m
//  rehab
//
//  Created by herson on 8/20/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "AboutController.h"
#import "AlarmController.h"
#import "BaseCell.h"
#import "BindClientViewController.h"
#import "DiseaseSelectorController.h"
#import "FavorListController.h"
#import "FeedbackController.h"
#import "GuideView.h"
#import "MeCategoryCell.h"
#import "MeSubSettingController.h"
#import "NotificationController.h"
#import "ProtocolController.h"
#import "SettingController.h"
#import "UIFont+WR.h"
#import "UserBasicInfoController.h"
#import "WRNetworkService.h"
#import "ProgressController.h"
#import "WRSelfInfoPanelView.h"
#import "SyncController.h"

#import "WRViewModel+Common.h"

#import <StoreKit/StoreKit.h>
#import <UMMobClick/MobClick.h>

#import <YYKit/YYKit.h>
typedef NS_ENUM(NSInteger, Tag){
    
    TagBindClient,

    TagSync,
    TagNotification,
    TagSetting,
    
    TapAppStore,
    TagImprove,
    TagContact,
    TagAgreenment,
    TagShare
};

//NSString *kAlarmFlagKey = @"rehabAlarm";

@interface SettingController ()<SKStoreProductViewControllerDelegate, UIActionSheetDelegate>
{
    NSArray *_itemsArray, *_iconsArray, *_tagArray;
    BOOL _flag;
}
@end

@implementation SettingController

- (instancetype)init {
    if(self = [super initWithStyle:UITableViewStylePlain]){
        _flag = [WRUserInfo selfInfo].notificationFlag;
        self.tableView.tableHeaderView = [[UIView alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createBackBarButtonItem];
    
    [self defaultStyle];
    // Do any additional setup after loading the view.
    [WRNetworkService pwiki:@"消息通知设置"];
    _itemsArray = @[
                    @[NSLocalizedString(@"帐号绑定", nil),NSLocalizedString(@"同步数据", nil)],
                    @[NSLocalizedString(@"自动播放背景音乐", nil),NSLocalizedString(@"向我推送最新康复资讯", nil)],
                    @[NSLocalizedString(@"评价我们", nil), NSLocalizedString(@"意见反馈", nil),NSLocalizedString(@"关于我们", nil),NSLocalizedString(@"用户协议", nil),NSLocalizedString(@"邀请好友", nil)]];
    
    _iconsArray = @[
                    @"well_setting_icon_bind",
                    @"well_setting_icon_notification",
                    @"well_setting_icon_sync",
                    
                    @"well_setting_icon_common",
                    
                    @"well_setting_icon_rate",
                    @"well_setting_icon_improve",
                    @"well_setting_icon_about",
                    @"well_setting_icon_protocol",
                    @"me_share"
                    ];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 44;
    self.tableView.backgroundColor = [UIColor wr_lightGray];
    self.tableView.separatorColor = [UIColor wr_lightGray];
    self.tableView.tableFooterView = [UIView new];
    
    [WRNetworkService pwiki:@"设置"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
    
    self.title = NSLocalizedString(@"设置", nil);
    //self.navigationController.navigationBar.translucent = NO;
    
    /*
     self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
     self.navigationController.navigationBar.tintColor = [UIColor blackColor];
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
     */
    [self createBackBarButtonItem];
}


#pragma mark - UITableView Delegate&Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _itemsArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _itemsArray[section];
    NSInteger count = array.count;
//    if (section == 0 && [WRUIConfig IsHDApp]) {
//        count--;
//    }
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 0 : WRUISectionLineHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = nil;
    if (section > 0) {
        header = [UIView new];
        header.backgroundColor = [UIColor wr_lightWhite];
    }
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = WRCellIdentifier;
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            identifier = @"playBGM";
        } else {
            identifier = @"notification";
        }
    }
    
    NSString *title = [self titleForCell:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont wr_textFont];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = title;
    if (indexPath.section == 1) {
        cell.accessoryView = nil;
        if (indexPath.row == 0 ) {
            UISwitch *switchControl = [[UISwitch alloc] init];
            switchControl.onTintColor = [UIColor wr_rehabBlueColor];
            [switchControl sizeToFit];
            BOOL flag = ![UserProfile defaultProfile].notAutoPlayBgm;
            switchControl.on = flag;
            [switchControl addBlockForControlEvents:UIControlEventValueChanged block:^(id  _Nonnull sender) {
                UISwitch *control = sender;
                [UserProfile defaultProfile].notAutoPlayBgm = !control.on;
            }];
            cell.accessoryView = switchControl;
        } else {
            UISwitch *control = [[UISwitch alloc] init];
            control.onTintColor = [UIColor wr_rehabBlueColor];
            control.on = _flag;
            [control sizeToFit];
            [control addTarget:self action:@selector(onValueChange:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = control;
        }
    }
    return cell;
}


#pragma mark - IBActions
-(IBAction)onValueChange:(UISwitch*)sender {
    _flag = sender.on;
    if (_flag != [WRUserInfo selfInfo].notificationFlag) {
        BOOL flag = _flag;
        [WRViewModel operationWithType:OperationTypeNotification indexId:@"" actionType:_flag?OperationActionTypeAdd:OperationActionTypeDelete contentType:OperationContentTypeUnknown completion:^(NSError * _Nonnull error) {
            if (!error) {
                [WRUserInfo selfInfo].notificationFlag = flag;
                [[WRUserInfo selfInfo] save];
            }
        }];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Tag tag = indexPath.row;
    for(NSInteger i = 0; i < indexPath.section; i++)
    {
        NSArray *array = _itemsArray[i];
        tag += array.count;
    }
    
    switch (tag) {
        case TagBindClient:
        {
            if (![self checkUserLogState:self.navigationController]) {
                return;
            }
        }
            
        default:
            break;
    }
    
    UIViewController *viewController = nil;
    switch (tag) {
        case TagBindClient: {
            viewController = [[BindClientViewController alloc] initWithStyle:UITableViewStylePlain];
            break;
        }
        case TagSync: {
            viewController = [[SyncController alloc] init];
            break;
        }
            //        case TagNotification: {
            //            viewController = [[WRNotificationViewController alloc] init];
            //            break;
            //        }
            
            //        case TagSetting: {
            //            viewController = [[MeSubSettingController alloc] initWithStyle:UITableViewStylePlain];
            //            break;
            //        }
            
//        case TagSync: {
//            viewController = [[SyncController alloc] init];
//            break;
//        }
        case TagShare:{
            NSString *title = NSLocalizedString(@"诚邀您体验WELL健康", nil);
            NSString *detail = NSLocalizedString(@"专业运动康复", nil);
            NSString *targetUrlString = [WRNetworkService getFormatURLString:urlShareApp];
            /*
             NSString *shareLogoUrl = [WRNetworkService getFormatURLString:urlShareLogo];
             [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:shareLogoUrl];
             [UMSocialData defaultData].extConfig.title = NSLocalizedString(@"诚邀您体验WELL健康", nil);
             [UMSocialData defaultData].extConfig.qqData.url = @"http://www.well-health.cn/m";
             [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
             [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.well.health";
             [UMSocialSnsService presentSnsIconSheetView:self
             appKey:UMAppKey
             shareText:NSLocalizedString(@"专业运动康复", nil)
             shareImage:nil
             shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ]
             delegate:nil];
             */
            [UMengUtils shareWebWithTitle:title detail:detail url:targetUrlString image:[UIImage imageNamed:@"logo"] viewController:self];

            break;
        }
        case TapAppStore: {
            [self evaluate];
            break;
        }
        case TagImprove: {
            viewController = [[FeedbackController alloc] init];
            break;
        }
        case TagContact: {
            viewController = [[AboutController alloc] init];
            break;
        }
        case TagAgreenment: {
            viewController = [[ProtocolController alloc] init];
            break;
        }
            
        default:
            break;
    }
    if (viewController) {
        [self.navigationController pushViewController:viewController animated:YES];
        viewController.title = [self titleForCell:indexPath];
    }
}

#pragma mark -
-(NSString*)titleForCell:(NSIndexPath*)indexPath {
    NSArray *array = _itemsArray[indexPath.section];
    return array[indexPath.row];
}

- (void)evaluate{
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/well-jian-kang-yun-dong-chu/id%@?mt=8", WRAppId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

@end
