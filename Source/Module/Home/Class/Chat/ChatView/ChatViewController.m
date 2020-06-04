/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ChatViewController.h"

#import "ChatroomDetailViewController.h"
#import "UserProfileViewController.h"
#import "UserProfileManager.h"
#import "ContactListSelectViewController.h"
#import "ChatDemoHelper.h"
#import "EMChooseViewController.h"
#import "ContactSelectionViewController.h"
#import "EMGroupInfoViewController.h"
#import "JCAlertView.h"
#import "PayImViewModel.h"
#import "AskImIndexController.h"
@interface ChatViewController ()<UIAlertViewDelegate,EMClientDelegate, EMChooseViewDelegate>
{
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    UIMenuItem *_transpondMenuItem;
}

@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic) NSMutableDictionary *emotionDic;
@property (nonatomic, copy) EaseSelectAtTargetCallback selectedCallback;
@property BOOL shownoti;
@property PayImViewModel* viewModel;
@property UIButton* goim;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.showRefreshHeader = YES;
    self.delegate = self;
    self.dataSource = self;
    self.viewModel = [PayImViewModel new];
    [self _setupBarButtonItem];
    [self createBackBarButtonItem];
    self.title = @"专家咨询";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteAllMessages:) name:KNOTIFICATIONNAME_DELETEALLMESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitChat) name:@"ExitChat" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    
    
    
    
    
    
    
}
-(void)showNoti
{
    _shownoti = YES;
    NSInteger year,month,day,hour,min,sec,week;
    NSString *weekStr=nil;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:now];
    year = [comps year];
    week = [comps weekday];
    month = [comps month];
    day = [comps day];
    hour = [comps hour];
    min = [comps minute];
    sec = [comps second];
    
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSInteger str = [[ud objectForKey:@"hasshowIMNoti"] integerValue];
    
    BOOL intime = false;
    if (hour>10&&hour<12) {
        intime =YES;
    }
    if (hour>14&&hour<17) {
        intime =YES;
    }
    
    
#ifndef debug
    str = 0;
//    intime =YES;
#endif
    if(str!=1)
    {
        UIView* showview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 282, 0)];
        showview.backgroundColor = [UIColor whiteColor];
        showview.layer.cornerRadius =4;
        UILabel* title = [UILabel new];
        title.y = 20;
        title.text = @"您已成功开通咨询服务";
        title.font = [UIFont systemFontOfSize:18];
        title.textColor = [UIColor wr_titleTextColor];
        [title sizeToFit];
        title.centerX = showview.width*1.0/2;
        [showview addSubview:title];
        
        UIView* line = [[UIView alloc]initWithFrame:CGRectMake(27, title.bottom+20, showview.width-27*2, 0.5)];
        line.backgroundColor = [UIColor wr_lineColor];
        [showview addSubview:line];
        
        UILabel* title1 = [UILabel new];
        
        title1.y = 25+line.bottom;
        title1.text = @"WELL健康乐意为您效劳";
        title1.width = showview.width-27*2;
        title1.numberOfLines = 0;
        title1.font = [UIFont boldSystemFontOfSize:15];
        title1.textColor = [UIColor colorWithHexString:@"333333"];
        title1.textAlignment = NSTextAlignmentCenter;
        [title1 sizeToFit];
        title1.centerX =showview.width*1.0/2;
        [showview addSubview:title1];
//        if (week!=1&&week!=7&&intime) {
//            title1.text = @"您已经开始开始通过文字或者语音的方式向专家提问了~";
//            title1.textColor = [UIColor wr_themeColor];
//            [title1 sizeToFit];
//        }
        
//        line = [[UIView alloc]initWithFrame:CGRectMake(27, title1.bottom+25, showview.width-27*2, 0.5)];
//        line.backgroundColor = [UIColor wr_lineColor];
//        [showview addSubview:line];
        
        
        
        UILabel* title2 = [UILabel new];
        title2.x = 27;
        title2.y = 20+title1.bottom;
        title2.text = @"我们的服务时间是：\n周一至五\n上午10:00-12:00，下午2:00-5:00\n您可发送文字或图片或语音咨询专家";
        title2.width = showview.width-27*2;
        title2.numberOfLines = 0;
        title2.font = [UIFont systemFontOfSize:11];
        title2.textColor = [UIColor wr_titleTextColor];
//        title2.textAlignment = NSTextAlignmentCenter;
        
        [showview addSubview:title2];
        [title2 setWr_AttributedWithColorRange:NSMakeRange(0, 9) Color:[UIColor wr_titleTextColor] FontRange:NSMakeRange(0, 9) Font:[UIFont boldSystemFontOfSize:13] InitTitle:title2.text];
        
        [title2 sizeToFit];
        
        
        
        UILabel* title3 = [UILabel new];
        title3.x = 27;
        title3.y = 20+title2.bottom;
        title3.text = @"服务时间内：\n您可在聊天页直接咨询，专家会在1小时内响应您";
        title3.width = showview.width-27*2;
        title3.numberOfLines = 0;
        title3.font = [UIFont systemFontOfSize:11];
        title3.textColor = [UIColor wr_titleTextColor];
        //        title2.textAlignment = NSTextAlignmentCenter;
        
        [showview addSubview:title3];
        [title3 setWr_AttributedWithColorRange:NSMakeRange(0, 6) Color:[UIColor wr_titleTextColor] FontRange:NSMakeRange(0, 6) Font:[UIFont boldSystemFontOfSize:13] InitTitle:title3.text];
        
        [title3 sizeToFit];
        
        UILabel* title4 = [UILabel new];
        title4.x = 27;
        title4.y = 20+title3.bottom;
        title4.text = @"服务时间外：\n请在聊天页留下问题和适合您咨询的时间专家确认后会主动联系您";
        title4.width = showview.width-27*2;
        title4.numberOfLines = 0;
        title4.font = [UIFont systemFontOfSize:11];
        title4.textColor = [UIColor wr_titleTextColor];
        //        title2.textAlignment = NSTextAlignmentCenter;
        
        [showview addSubview:title4];
        [title4 setWr_AttributedWithColorRange:NSMakeRange(0, 6) Color:[UIColor wr_titleTextColor] FontRange:NSMakeRange(0, 6) Font:[UIFont boldSystemFontOfSize:13] InitTitle:title4.text];
        [title4 sizeToFit];
        
        UILabel* title5 = [UILabel new];
        title5.x = 27;
        title5.y = 20+title4.bottom;
        title5.text = @"注意：\n专家可能无法在服务时间外及时响应您的咨询请您谅解";
        title5.width = showview.width-27*2;
        title5.numberOfLines = 0;
        title5.font = [UIFont systemFontOfSize:10];
        title5.textColor = [UIColor wr_detailTextColor];
        //        title2.textAlignment = NSTextAlignmentCenter;
        [title5 sizeToFit];
        [showview addSubview:title5];
        
        
        
        
//        if (week!=1&&week!=7&&intime) {
//            
//            
//            title2.text = @"注意:\n如果在非服务时间咨询,专家可能无法即时回复您的提问。\n\n您可以:\n1.先在咨询页中发送您的提问,专家将会尽快为您解答。\n2.发送一个时间预约专家,专家确认后将会主动联系您。";
//            [title2 sizeToFit];
//            
//        }
        
        line = [[UIView alloc]initWithFrame:CGRectMake(27, title5.bottom+20, showview.width-27*2, 0.5)];
        line.backgroundColor = [UIColor wr_lineColor];
        [showview addSubview:line];
        
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, line.bottom, showview.width, 55)];
        [btn setTitle:@"确定" forState:0];
        [btn setTitleColor:[UIColor wr_themeColor] forState:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [showview addSubview:btn ];
        
        
        
        showview.height = btn.bottom;
        
        
        JCAlertView* al = [[JCAlertView alloc]initWithCustomView:showview dismissWhenTouchedBackground:YES];
        [al show];
        
        [btn bk_whenTapped:^{
            [al dismissWithCompletion:^{
                [ud setObject:@"1" forKey:@"hasshowIMNoti"];
            }];
        }];
        
        
    }
    NSLog(@"现在是:%ld年%ld月%ld日 %ld时%ld分%ld秒  %@",(long)year,(long)month,(long)day,(long)hour,(long)min,(long)sec,weekStr);
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if (self.conversation.type == EMConversationTypeChatRoom) {
        //退出聊天室，删除会话
        if (self.isJoinedChatroom) {
            NSString *chatter = [self.conversation.conversationId copy];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                [[EMClient sharedClient].roomManager leaveChatroom:chatter error:&error];
                if (error !=nil) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Leave chatroom '%@' failed [%@]", chatter, error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    });
                }
            });
        }
        else {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:YES completion:nil];
        }
    }
    
    [[EMClient sharedClient] removeDelegate:self];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSInteger str = [[ud objectForKey:@"hasshowIMNoti"] integerValue];

    if (str!=1&&!_shownoti) {
        [self showNoti];
    }
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.hideBottom) {
        [self.chatToolbar setHidden:YES];
        if (!self.goim) {
            UIButton* gobuy = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height-50-64, ScreenW, 50)];
            gobuy.backgroundColor = [UIColor colorWithHexString:@"4fd8ff"];
            [gobuy setTitle:@"查看咨询服务" forState:0];
            [gobuy setTitleColor:[UIColor whiteColor] forState:0];
            gobuy.titleLabel.font = [UIFont boldSystemFontOfSize:18];
           // [self.view addSubview:gobuy];
            [gobuy bk_whenTapped:^{
                AskImIndexController* vc = [AskImIndexController new];
                
                [self.navigationController pushViewController:vc animated:YES];
            }];
            self.goim = gobuy;
        }
        

        
    }
    self.navigationController.navigationBar.barTintColor = [UIColor wr_themeColor];
    
    if (self.conversation.type == EMConversationTypeGroupChat) {
        NSDictionary *ext = self.conversation.ext;
        if ([[ext objectForKey:@"subject"] length])
        {
            self.title = [ext objectForKey:@"subject"];
        }
        
        if (ext && ext[kHaveUnreadAtMessage] != nil)
        {
            NSMutableDictionary *newExt = [ext mutableCopy];
            [newExt removeObjectForKey:kHaveUnreadAtMessage];
            self.conversation.ext = newExt;
        }
    }
    if ([WRUserInfo selfInfo].userId&&[[EMClient sharedClient] currentUsername]&&[WRUserInfo selfInfo].name) {
        EMMessage* em = [EaseSDKHelper sendCmdMessage:@"userid" to:@"rudy123" messageType:EMChatTypeChat messageExt:@{@"userid":[WRUserInfo selfInfo].userId,@"hxid":[[EMClient sharedClient] currentUsername],@"username":[WRUserInfo selfInfo].name} cmdParams:nil];
        
        [[EMClient sharedClient].chatManager sendMessage:em progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
            
            
        }];

    }
    }

- (void)sendTextMessage:(NSString *)text withExt:(NSDictionary*)ext
{
 
    [super sendTextMessage:text withExt:ext];
    
    
    if ([WRUserInfo selfInfo].userId&&[[EMClient sharedClient] currentUsername]&&[WRUserInfo selfInfo].name) {
        EMMessage* em = [EaseSDKHelper sendCmdMessage:@"userid" to:@"rudy123" messageType:EMChatTypeChat messageExt:@{@"userid":[WRUserInfo selfInfo].userId,@"hxid":[[EMClient sharedClient] currentUsername],@"username":[WRUserInfo selfInfo].name} cmdParams:nil];
        
        [[EMClient sharedClient].chatManager sendMessage:em progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
            
            
        }];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    
}

#pragma mark - setup subviews

- (void)_setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    backButton.accessibilityIdentifier = @"back";
    [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    //单聊
    if (self.conversation.type == EMConversationTypeChat) {
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        clearButton.accessibilityIdentifier = @"clear_message";
        [clearButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(deleteAllMessages:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    }
    else{//群聊
        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        detailButton.accessibilityIdentifier = @"detail";
        [detailButton setImage:[UIImage imageNamed:@"group_detail"] forState:UIControlStateNormal];
        [detailButton addTarget:self action:@selector(showGroupDetailAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex != buttonIndex) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        
        [self.tableView reloadData];
    }
}

#pragma mark - EaseMessageViewControllerDelegate

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   canLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)messageViewController:(EaseMessageViewController *)viewController
   didLongPressRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.dataArray objectAtIndex:indexPath.row];
    if (![object isKindOfClass:[NSString class]]) {
        EaseMessageCell *cell = (EaseMessageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell becomeFirstResponder];
        self.menuIndexPath = indexPath;
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.model.bodyType];
    }
    return YES;
}

- (void)messageViewController:(EaseMessageViewController *)viewController
   didSelectAvatarMessageModel:(id<IMessageModel>)messageModel
{
    UserProfileViewController *userprofile = [[UserProfileViewController alloc] initWithUsername:messageModel.message.from];
    [self.navigationController pushViewController:userprofile animated:YES];
}

- (void)messageViewController:(EaseMessageViewController *)viewController
               selectAtTarget:(EaseSelectAtTargetCallback)selectedCallback
{
    _selectedCallback = selectedCallback;
    EMGroup *chatGroup = nil;
    NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
    for (EMGroup *group in groupArray) {
        if ([group.groupId isEqualToString:self.conversation.conversationId]) {
            chatGroup = group;
            break;
        }
    }
    
    if (chatGroup == nil) {
        chatGroup = [EMGroup groupWithId:self.conversation.conversationId];
    }
    
    if (chatGroup) {
        if (!chatGroup.occupants) {
            __weak ChatViewController* weakSelf = self;
            [self showHudInView:self.view hint:@"Fetching group members..."];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                EMError *error = nil;
                EMGroup *group = [[EMClient sharedClient].groupManager getGroupSpecificationFromServerWithId:chatGroup.groupId error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    __strong ChatViewController *strongSelf = weakSelf;
                    if (strongSelf) {
                        [strongSelf hideHud];
                        if (error) {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Fetching group members failed [%@]", error.errorDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        }
                        else {
                            NSMutableArray *members = [group.occupants mutableCopy];
                            NSString *loginUser = [EMClient sharedClient].currentUsername;
                            if (loginUser) {
                                [members removeObject:loginUser];
                            }
                            if (![members count]) {
                                if (strongSelf.selectedCallback) {
                                    strongSelf.selectedCallback(nil);
                                }
                                return;
                            }
                            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
                            selectController.mulChoice = NO;
                            selectController.delegate = self;
                            [self.navigationController pushViewController:selectController animated:YES];
                        }
                    }
                });
            });
        }
        else {
            NSMutableArray *members = [chatGroup.occupants mutableCopy];
            NSString *loginUser = [EMClient sharedClient].currentUsername;
            if (loginUser) {
                [members removeObject:loginUser];
            }
            if (![members count]) {
                if (_selectedCallback) {
                    _selectedCallback(nil);
                }
                return;
            }
            ContactSelectionViewController *selectController = [[ContactSelectionViewController alloc] initWithContacts:members];
            selectController.mulChoice = NO;
            selectController.delegate = self;
            [self.navigationController pushViewController:selectController animated:YES];
        }
    }
}

#pragma mark - EaseMessageViewControllerDataSource

- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
//    if (profileEntity) {
    
    if ([model.nickname isEqualToString:@"rudy123"]) {
        model.avatarImage = [WRUIConfig defaultHeadImage];
        model.nickname = @"WELL健康专家";
    }
    else
    {
        model.avatarURLPath = [WRUserInfo selfInfo].headImageUrl;
        model.nickname = [WRUserInfo selfInfo].name;
    }
    
    
    model.failImageName = @"imageDownloadFail";
    return model;
}

- (NSArray*)emotionFormessageViewController:(EaseMessageViewController *)viewController
{
    NSMutableArray *emotions = [NSMutableArray array];
    for (NSString *name in [EaseEmoji allEmoji]) {
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:name emotionThumbnail:name emotionOriginal:name emotionOriginalURL:@"" emotionType:EMEmotionDefault];
        [emotions addObject:emotion];
    }
    EaseEmotion *temp = [emotions objectAtIndex:0];
    EaseEmotionManager *managerDefault = [[EaseEmotionManager alloc] initWithType:EMEmotionDefault emotionRow:3 emotionCol:7 emotions:emotions tagImage:[UIImage imageNamed:temp.emotionId]];
    
    NSMutableArray *emotionGifs = [NSMutableArray array];
    _emotionDic = [NSMutableDictionary dictionary];
    NSArray *names = @[@"icon_002",@"icon_007",@"icon_010",@"icon_012",@"icon_013",@"icon_018",@"icon_019",@"icon_020",@"icon_021",@"icon_022",@"icon_024",@"icon_027",@"icon_029",@"icon_030",@"icon_035",@"icon_040"];
    int index = 0;
    for (NSString *name in names) {
        index++;
        EaseEmotion *emotion = [[EaseEmotion alloc] initWithName:[NSString stringWithFormat:@"[示例%d]",index] emotionId:[NSString stringWithFormat:@"em%d",(1000 + index)] emotionThumbnail:[NSString stringWithFormat:@"%@_cover",name] emotionOriginal:[NSString stringWithFormat:@"%@",name] emotionOriginalURL:@"" emotionType:EMEmotionGif];
        [emotionGifs addObject:emotion];
        [_emotionDic setObject:emotion forKey:[NSString stringWithFormat:@"em%d",(1000 + index)]];
    }
    EaseEmotionManager *managerGif= [[EaseEmotionManager alloc] initWithType:EMEmotionGif emotionRow:2 emotionCol:4 emotions:emotionGifs tagImage:[UIImage imageNamed:@"icon_002_cover"]];
    
    return @[managerDefault,managerGif];
}

- (BOOL)isEmotionMessageFormessageViewController:(EaseMessageViewController *)viewController
                                    messageModel:(id<IMessageModel>)messageModel
{
    BOOL flag = NO;
    if ([messageModel.message.ext objectForKey:MESSAGE_ATTR_IS_BIG_EXPRESSION]) {
        return YES;
    }
    return flag;
}

- (EaseEmotion*)emotionURLFormessageViewController:(EaseMessageViewController *)viewController
                                      messageModel:(id<IMessageModel>)messageModel
{
    NSString *emotionId = [messageModel.message.ext objectForKey:MESSAGE_ATTR_EXPRESSION_ID];
    EaseEmotion *emotion = [_emotionDic objectForKey:emotionId];
    if (emotion == nil) {
        emotion = [[EaseEmotion alloc] initWithName:@"" emotionId:emotionId emotionThumbnail:@"" emotionOriginal:@"" emotionOriginalURL:@"" emotionType:EMEmotionGif];
    }
    return emotion;
}

- (NSDictionary*)emotionExtFormessageViewController:(EaseMessageViewController *)viewController
                                        easeEmotion:(EaseEmotion*)easeEmotion
{
    return @{MESSAGE_ATTR_EXPRESSION_ID:easeEmotion.emotionId,MESSAGE_ATTR_IS_BIG_EXPRESSION:@(YES)};
}

- (void)messageViewControllerMarkAllMessagesAsRead:(EaseMessageViewController *)viewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

#pragma mark - EaseMob

#pragma mark - EMClientDelegate

- (void)userAccountDidLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userAccountDidRemoveFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)userDidForbidByServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - action

- (void)backAction
{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[ChatDemoHelper shareHelper] setChatVC:nil];
    
    if (self.deleteConversationIfNull) {
        //判断当前会话是否为空，若符合则删除该会话
        EMMessage *message = [self.conversation latestMessage];
        if (message == nil) {
            [[EMClient sharedClient].chatManager deleteConversation:self.conversation.conversationId isDeleteMessages:NO completion:nil];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showGroupDetailAction
{
    [self.view endEditing:YES];
    if (self.conversation.type == EMConversationTypeGroupChat) {
        EMGroupInfoViewController *infoController = [[EMGroupInfoViewController alloc] initWithGroupId:self.conversation.conversationId];
        [self.navigationController pushViewController:infoController animated:YES];
    }
    else if (self.conversation.type == EMConversationTypeChatRoom)
    {
        ChatroomDetailViewController *detailController = [[ChatroomDetailViewController alloc] initWithChatroomId:self.conversation.conversationId];
        [self.navigationController pushViewController:detailController animated:YES];
    }
}

- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        BOOL isDelete = [groupId isEqualToString:self.conversation.conversationId];
        if (self.conversation.type != EMConversationTypeChat && isDelete) {
            self.messageTimeIntervalTag = -1;
            [self.conversation deleteAllMessages:nil];
            [self.messsagesSource removeAllObjects];
            [self.dataArray removeAllObjects];
            
            [self.tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else if ([sender isKindOfClass:[UIButton class]]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除聊天记录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }
}

- (void)transpondMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        ContactListSelectViewController *listViewController = [[ContactListSelectViewController alloc] initWithNibName:nil bundle:nil];
        listViewController.messageModel = model;
        [listViewController tableViewDidTriggerHeaderRefresh];
        [self.navigationController pushViewController:listViewController animated:YES];
    }
    self.menuIndexPath = nil;
}

- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        pasteboard.string = model.text;
    }
    
    self.menuIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (self.menuIndexPath && self.menuIndexPath.row > 0) {
        id<IMessageModel> model = [self.dataArray objectAtIndex:self.menuIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:self.menuIndexPath.row];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:self.menuIndexPath, nil];
        
        [self.conversation deleteMessageWithId:model.message.messageId error:nil];
        [self.messsagesSource removeObject:model.message];
        
        if (self.menuIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row - 1)];
            if (self.menuIndexPath.row + 1 < [self.dataArray count]) {
                nextMessage = [self.dataArray objectAtIndex:(self.menuIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:self.menuIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(self.menuIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataArray removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        
        if ([self.dataArray count] == 0) {
            self.messageTimeIntervalTag = -1;
        }
    }
    
    self.menuIndexPath = nil;
}

#pragma mark - notification
- (void)exitChat
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessageToDataSource:message progress:nil];
        [[EMClient sharedClient].chatManager importMessages:@[message] completion:nil];
    }
}

- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isViewDidAppear = NO;
    } else {
        //结束call
        self.isViewDidAppear = YES;
    }
}

#pragma mark - private

- (void)showMenuViewController:(UIView *)showInView
                   andIndexPath:(NSIndexPath *)indexPath
                    messageType:(EMMessageBodyType)messageType
{
    if (self.menuController == nil) {
        self.menuController = [UIMenuController sharedMenuController];
    }
    
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    
    if (_transpondMenuItem == nil) {
        _transpondMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"transpond", @"Transpond") action:@selector(transpondMenuAction:)];
    }
    
    if (messageType == EMMessageBodyTypeText) {
        [self.menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem,_transpondMenuItem]];
    } else if (messageType == EMMessageBodyTypeImage){
        [self.menuController setMenuItems:@[_deleteMenuItem,_transpondMenuItem]];
    } else {
        [self.menuController setMenuItems:@[_deleteMenuItem]];
    }
    [self.menuController setTargetRect:showInView.frame inView:showInView.superview];
    [self.menuController setMenuVisible:YES animated:YES];
}


#pragma mark - EMChooseViewDelegate

- (BOOL)viewController:(EMChooseViewController *)viewController didFinishSelectedSources:(NSArray *)selectedSources
{
    if ([selectedSources count]) {
        EaseAtTarget *target = [[EaseAtTarget alloc] init];
        target.userId = selectedSources.firstObject;
        UserProfileEntity *profileEntity = [[UserProfileManager sharedInstance] getUserProfileByUsername:target.userId];
        if (profileEntity) {
            target.nickname = profileEntity.nickname == nil ? profileEntity.username : profileEntity.nickname;
        }
        if (_selectedCallback) {
            _selectedCallback(target);
        }
    }
    else {
        if (_selectedCallback) {
            _selectedCallback(nil);
        }
    }
    return YES;
}

- (void)viewControllerDidSelectBack:(EMChooseViewController *)viewController
{
    if (_selectedCallback) {
        _selectedCallback(nil);
    }
}

@end
