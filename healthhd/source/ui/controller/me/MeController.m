//
//  MeController.m
//  rehab
//
//  Created by 何寻 on 8/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "MeController.h"
#import "SettingController.h"
#import "ShareData.h"
#import "ShareUserData.h"
#import "BaseCell.h"
#import "UserViewModel.h"
#import "WRProgressViewController.h"
#import "CategoryView.h"
#import "AlarmController.h"
#import "FavorListController.h"
#import "RehabPlayerController.h"
#import "UMSocial.h"
#import "ChallengePlayerController.h"
#import "WRRefreshHeader.h"
#import "ChallengeVideoCell.h"

@interface MeController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) UILabel *titleLabel, *nameLabel, *treatCountLabel, *completeTreatCountLabel, *totalTimeLabel, *totalDayLabel;
@property(nonatomic) UIImageView *headImageView;
@property(nonatomic) UIView *titleBarView;

@property(nonatomic) UIImageView *blurImageView;
@property(nonatomic) CategoryView *categoryView;
@property(nonatomic) UIView *sectionHeaderView, *topBgView, *redView;

@property(nonatomic) WRTreatRehabStage *currentVideo;

@property(nonatomic)BOOL flag;

@end

@implementation MeController
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init {
    if (self = [super initWithStyle:UITableViewStylePlain])
    {
        self.view.backgroundColor = [UIColor wr_lightWhite];
        self.tableView.rowHeight = [ChallengeVideoCell defaultHeightForTableView:self.tableView];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorColor = [UIColor wr_lightGray];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.tableHeaderView = [self createTableHeaderView];
        self.tableView.showsVerticalScrollIndicator = NO;
        
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        UIView *view = [[UIView alloc] initWithFrame:self.tableView.bounds];
        view.backgroundColor = [UIColor wr_themeColor];
        view.frame = CGRectMake(0, -1*self.tableView.height, self.tableView.width, self.tableView.height);
        [self.tableView addSubview:view];
        self.topBgView = view;
        
        __weak __typeof(self) weakSelf = self;
        self.tableView.mj_header = [WRRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf fetchData];
        }];
    
        [self.tableView sendSubviewToBack:self.topBgView];
        [self updateUserInfo];
        
       [ @[WRUpdateSelfInfoNotification] enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(notificationHandler:) name:obj object:nil];
        }];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkAlarm];
}

#pragma mark - UITableView DataSource & Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    __block NSInteger count = 0;
    [[ShareData data].challengeGroupArray enumerateObjectsUsingBlock:^(ChallengeGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count += obj.videos.count;
    }];
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.sectionHeaderView) {
        self.sectionHeaderView = [self createSectionHeaderView:tableView];
    }
    return self.sectionHeaderView.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionHeaderView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WRCellIdentifier];
    if (!cell) {
        cell = [[ChallengeVideoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:WRCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    WRTreatRehabStage *video = [self userVideoForIndexPath:indexPath];
    NSInteger timeValue = video.userValue;
    
    UIColor *textColor = [UIColor blackColor];
    NSArray *challengeVideoArray = [ShareUserData userData].challengeVideoArray;
    NSString *text = @"";
    for(WRTreatRehabStage *obj in challengeVideoArray)
    {
        if ([obj.videoId isEqualToString:video.videoId]) {
            timeValue = obj.userValue;
            if (timeValue >= obj.refValue) {
                textColor = [UIColor wr_themeColor];
                text = NSLocalizedString(@"达标", nil);
            } else {
                textColor = [UIColor orangeColor];
                text = NSLocalizedString(@"未达标", nil);
            }
            break;
        }
    }
    
    BOOL unlocked = [self videoIsUnlocked:video];
    
    ChallengeVideoCell *baseCell = (ChallengeVideoCell*)cell;
    baseCell.textLabel.text = video.mtWellVideoInfo.videoName;
    
    baseCell.detailTextLabel.textColor = textColor;
    baseCell.stateLabel.textColor = textColor;
    
    baseCell.detailTextLabel.hidden = !unlocked;
    baseCell.stateLabel.hidden = baseCell.detailTextLabel.hidden;
    baseCell.lockImageView.hidden = !baseCell.detailTextLabel.hidden;
    
    CGFloat value = (CGFloat)(video.difficulty%5)/5;
    if (video.difficulty == 5) {
        value = 1;
    }
    baseCell.rateView.scorePercent = value;
    
    NSString *time = [Utility formatTimeSeconds:timeValue];
    baseCell.detailTextLabel.text = time;
    baseCell.stateLabel.text = text;
    
    [baseCell.imageView setImageWithUrlString:video.mtWellVideoInfo.thumbnailUrl holder:@"well_default_video"];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRTreatRehabStage *stage = [self userVideoForIndexPath:indexPath];
    [self challengeVideo:stage];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    CGFloat dy = (y - self.tableView.tableHeaderView.height);
    CGFloat alpha = dy/self.sectionHeaderView.height;
    if (alpha < 0) {
        alpha = 1;
    } else {
        alpha = 1 - MIN(1, alpha);
    }
    
    self.sectionHeaderView.alpha = alpha;
}

#pragma mark - Handler
-(void)notificationHandler:(NSNotification*)notification
{
    if([notification.name isEqualToString:WRUpdateSelfInfoNotification])
    {
        [self updateUserInfo];
    }
}

-(void)actionOnCategoryAtIndex:(NSInteger)index title:(NSString*)title
{
    if (index == 3 || index == 0 || [self checkUserLogState:nil]) {
        UIViewController *viewController = nil;
        switch (index) {
            case 0:
                viewController = [[AlarmController alloc] init];
                break;
                
            case 3:
            {
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
                break;
            }
                
            case 1:
                viewController = [[WRProgressViewController alloc] init];
                break;
                
            case 2:
                viewController = [[FavorListController alloc] initWithStyle:UITableViewStylePlain];
                break;
                
            default:
                break;
        }
        if (viewController != nil) {
            if (viewController) {
                WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];
                [[self.class root] presentViewController:nav animated:YES completion:nil];
                viewController.title = title;
            }
        }
    }
}

-(IBAction)onClickedSettingButton:(UIButton*)sender {
    SettingController *viewController = [[SettingController alloc] init];
    WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];
    [[self.class root] presentViewController:nav animated:YES completion:nil];
}


#pragma mark -
-(WRTreatRehabStage*)userVideoForIndexPath:(NSIndexPath*)indexPath {
    NSInteger count = 0;
    for(NSInteger index = 0; index < [ShareData data].challengeGroupArray.count; index++)
    {
        ChallengeGroup *group = [ShareData data].challengeGroupArray[index];
        for(NSInteger j = 0; j < group.videos.count; j++)
        {
            if (count == indexPath.row) {
                return group.videos[j];
            }
            count++;
        }
    }
    return nil;
}

-(BOOL)videoIsUnlocked:(WRTreatRehabStage*)video
{
    if (video.videoId == nil) {
        return NO;
    }
    
    ChallengeGroup *group = nil;
    for(ChallengeGroup *object in [ShareData data].challengeGroupArray)
    {
        for(WRTreatRehabStage *stage in object.videos)
        {
            if ([stage.videoId isEqualToString:video.videoId]) {
                group = object;
                break;
            }
        }
        if (group) {
            break;
        }
    }
    
    if (group)
    {
        if (group.level == 0) {
            return YES;
        }
        
        if ([[WRUserInfo selfInfo] isLogged])
        {
            ChallengeGroup *parentGroup = nil;
            for(ChallengeGroup *obj in [ShareData data].challengeGroupArray)
            {
                if([obj.uuid isEqualToString:group.parentId])
                {
                    parentGroup = obj;
                    break;
                }
            }
            
            if (!parentGroup) {
                return YES;
            }
            
            BOOL unlock = YES;
            for(WRTreatRehabStage *obj in parentGroup.videos)
            {
                //视频找到 且值不小于参考值
                WRTreatRehabStage *video = [[ShareUserData userData] getUserStageByVideoId:obj.videoId];
                BOOL flag =  (video && video.userValue >= video.refValue);
                
                if (!flag) {
                    unlock = NO;
                    break;
                }
            }
            return unlock;
        }
    }
    
    return NO;
}

-(void)updateHeadImage {
    BOOL defaultHeadImageFlag = YES;
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    if ([selfInfo isLogged]) {
        if (![Utility IsEmptyString:selfInfo.headImageUrl]) {
            defaultHeadImageFlag = NO;
            [self.headImageView setImageWithUrlString:selfInfo.headImageUrl holderImage:[WRUIConfig defaultHeadImage]];
            [self.blurImageView setImageWithUrlString:selfInfo.headImageUrl holderImage:[WRUIConfig defaultHeadImage]];
            [NSThread detachNewThreadSelector:@selector(downloadSelfHeadImage) toTarget:self withObject:nil];
        }
    }
    if (defaultHeadImageFlag) {
        self.headImageView.image = [WRUIConfig defaultHeadImage];
        self.blurImageView.image = self.headImageView.image;
        self.topBgView.backgroundColor = [Utility mostColor:self.headImageView.image];
    }
}

-(void)downloadSelfHeadImage
{
    __weak __typeof(self) weakSelf = self;
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:selfInfo.headImageUrl]]];
    if (!image)
    {
        image = [WRUIConfig defaultHeadImage];
    }
    UIColor *color = [Utility mostColor:image];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        weakSelf.topBgView.backgroundColor = color;
    }];
}

-(UIImageView*)blurImageView {
    if (_blurImageView == nil) {
        UIImageView *blurImageView = [[UIImageView alloc] initWithFrame:self.titleBarView.bounds];
        blurImageView.contentMode = UIViewContentModeScaleAspectFill;
        blurImageView.clipsToBounds = YES;
        
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.frame = blurImageView.bounds;
        [blurImageView addSubview:visualEffectView];
        [self.titleBarView addSubview:blurImageView];
        _blurImageView = blurImageView;
    }
    return _blurImageView;
}

-(void)updateUserInfo {
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    [self updateHeadImage];
    if ([selfInfo  isLogged])
    {
        NSString *name = selfInfo.name;
        if ([Utility IsEmptyString:name]) {
            name = NSLocalizedString(@"没有填写昵称", nil);
        }
        self.nameLabel.text = name;
    }
    else
    {
        self.nameLabel.text = NSLocalizedString(@"点击登录", nil);
    }
}

-(UIView*)createTableHeaderView
{
    CGRect frame = self.view.bounds;
    CGFloat offset = WRUIOffset, x, y, cx, cy;
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    container.backgroundColor = [UIColor whiteColor];
    
    cx = container.width;
    cy = cx*9/16;
    UIView *titleBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cx, cy)];
    titleBarView.backgroundColor = [UIColor wr_themeColor];
    [container addSubview:titleBarView];
    self.titleBarView = titleBarView;
    
    __weak __typeof(self) weakSelf = self;
    void (^action)() = ^(){
        if ([weakSelf checkUserLogState:nil]) {
            [weakSelf showSelfInfo];
        }
    };
    
    x = offset;
    y = WRStatusBarHeight + offset;
    UIImageView *imageView = [WRUIConfig createUserHeadImageView];
    imageView.frame = [Utility moveRect:imageView.frame x:x y:y];
    imageView.userInteractionEnabled = YES;
    [imageView bk_whenTapped:action];
    [container addSubview:imageView];
    self.headImageView = imageView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [button setTitle:NSLocalizedString(@"设置", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont wr_smallFont];
    [button addTarget:self action:@selector(onClickedSettingButton:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.left = container.width - offset - button.width;
    button.top = self.headImageView.top;
    [container addSubview:button];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @" ";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.font = [UIFont wr_smallFont];
    [label sizeToFit];
    
    CGFloat offsetTemp = 2;
    y = self.headImageView.centerY - label.height - offsetTemp;
    x = self.headImageView.right + 2*offsetTemp;
    cx = button.left - offsetTemp - x;
    cy = label.height;
    
    label.frame = CGRectMake(x, y, cx, cy);
    label.userInteractionEnabled = YES;
    [label bk_whenTapped:action];
    [container addSubview:label];
    self.nameLabel = label;
    
    y = self.headImageView.centerY + offsetTemp;
    label = [[UILabel alloc] init];
    label.text = NSLocalizedString(@"编辑资料", nil);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont wr_detailFont];
    [label sizeToFit];
    cx = label.size.width + 4*offsetTemp;
    cy = label.height + 2*offsetTemp;
    label.frame = CGRectMake(x, y, cx, cy);
    [label wr_roundBorderWithColor:[UIColor whiteColor]];
    [container addSubview:label];
    label.userInteractionEnabled = YES;
    [label bk_whenTapped:action];
    
    NSArray *titles = @[
                        NSLocalizedString(@"提醒", nil),
                        NSLocalizedString(@"方案", nil),
                        NSLocalizedString(@"收藏", nil),
                        NSLocalizedString(@"分享", nil)
                        ];
    NSArray *imageNameArray = @[@"me_alarm", @"me_rehab", @"me_favor", @"me_share"];
    UIImage *image = [UIImage imageNamed:imageNameArray.firstObject];
    
    CGFloat itemWidth = image.size.width + WRUILittleOffset;
    CGFloat itemHeight = image.size.height + 30 + WRUILittleOffset;
    NSUInteger count = titles.count;
    cx = itemWidth*count + (count + 1)*offset;
    x = container.width - cx;
    y = self.titleBarView.height - itemHeight;
    cy = itemHeight;
    
    CategoryView *categoryView = [[CategoryView alloc] initWithFrame:CGRectMake(x, y, cx, cy) titles:titles icons:imageNameArray itemWidth:itemWidth itemHeight:itemHeight];
    [container addSubview:categoryView];
    categoryView.itemAction = ^(NSUInteger index, NSString *title) {
        [weakSelf actionOnCategoryAtIndex:index title:title];
    };
    self.categoryView = categoryView;
    y = categoryView.bottom;
    
    container.frame = [Utility resizeRect:container.frame cx:-1 height:y];
    return container;
}

-(UIView*)createSectionHeaderView:(UITableView*)tableView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0)];
    view.backgroundColor = [UIColor wr_lightWhite];
    CGFloat offset = WRUIOffset;
    CGFloat x = offset, y = x;
    UILabel *label = [UILabel new];
    label.font = [[UIFont wr_titleFont] fontWithBold];
    label.text = NSLocalizedString(@"挑战自我", nil);
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:x y:y];
    [view addSubview:label];
    
    y = label.bottom + WRUILittleOffset;
    label = [UILabel new];
    label.font = [UIFont wr_smallFont];
    label.textColor = [UIColor lightGrayColor];
    label.text = NSLocalizedString(@"刷新纪录，测试健康水平", nil);
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:x y:y];
    [view addSubview:label];
    
    y = label.bottom + WRUILittleOffset;
    label = [UILabel new];
    label.font = [UIFont wr_smallFont];
    label.textColor = [UIColor lightGrayColor];
    label.text = NSLocalizedString(@"成功达标，开启下阶测试", nil);
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:x y:y];
    [view addSubview:label];
    
    label = [UILabel new];
    label.font = [UIFont wr_smallFont];
    label.textColor = [UIColor lightGrayColor];
    label.text = NSLocalizedString(@"我的成就", nil);
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    CGFloat cx = view.width/3;
    x = view.width - cx;
    label.frame = CGRectMake(x, y, cx, label.height);
    [view addSubview:label];
    
    view.frame = [Utility resizeRect:view.frame cx:-1 height:label.bottom + offset];
    return view;
}

-(void)checkAlarm
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger alarmCount = [ud integerForKey:@"alarmCount"];
//    NSLog(@"alarmCount%d",(int)alarmCount);
    if (alarmCount <= 0) {
        UIButton *button = self.categoryView.subviews.firstObject;
        self.redView.frame = CGRectMake(button.width - self.redView.width - 3, 5, self.redView.width, self.redView.height);
        [button addSubview:self.redView];
        self.redView.hidden = NO;
    } else {
        self.redView.hidden = YES;
    }
}

- (UIView *)redView
{
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
        _redView.backgroundColor = [UIColor redColor];
        _redView.layer.cornerRadius = 4;
        _redView.layer.masksToBounds = YES;
    }
    return _redView;
}

#pragma mark - Network
-(void)fetchData
{
    __weak __typeof(self) weakSelf = self;
    [UserViewModel fetchLockDataWithCompletion:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (!error) {
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark -
-(void)challengeVideo:(WRTreatRehabStage*)stage
{
    if (![self checkUserLogState:nil])
    {
        return;
    }
    
    if (![self videoIsUnlocked:stage])
    {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"完成前面动作的达标任务就能解锁啦", nil)];
    }
    else
    {
        self.currentVideo = stage;
        
        ChallengePlayerController *player = [[ChallengePlayerController alloc] initWithStage:stage];
        __weak __typeof(self) weakSelf = self;
        player.completion = ^(BOOL flag)
        {
            if (flag) {
                [weakSelf.tableView reloadData];
            }
        };
        player.modalPresentationCapturesStatusBarAppearance = YES;
        [[self.class root] presentViewController:player animated:YES completion:nil];
    }
}
@end