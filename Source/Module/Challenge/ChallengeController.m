//
//  ChallengeController.m
//  rehab
//
//  Created by yefangyang on 2016/9/27.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "ChallengeController.h"
#import "SettingController.h"
#import "ShareData.h"
#import "ShareUserData.h"
#import "BaseCell.h"
#import "UserViewModel.h"
#import "ProgressController.h"
#import "CategoryView.h"
#import "AlarmController.h"
#import "FavorListController.h"
#import "RehabPlayerController.h"

#import "ChallengePlayerController.h"
#import "WRRefreshHeader.h"
#import "ChallengeVideoCell.h"
#import "NetworkNotifier.h"

@interface ChallengeController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic) UILabel *titleLabel, *nameLabel, *treatCountLabel, *completeTreatCountLabel, *totalTimeLabel, *totalDayLabel;
@property(nonatomic) UIImageView *headImageView;
@property(nonatomic) UIView *titleBarView;

@property(nonatomic) UIImageView *blurImageView;
@property(nonatomic) CategoryView *categoryView;
@property(nonatomic) UIView *sectionHeaderView, *topBgView, *redView;
@property(nonatomic) NSMutableArray* arr;
@property(nonatomic) WRTreatRehabStage *currentVideo;
@property(nonatomic) UIImageView* image;

@property(nonatomic)BOOL flag;
@property(nonatomic) NetworkNotifier* networkNotifier;
//@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ChallengeController
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 创建tableView
- (UITableView *)tableView
{
    if (!_tableView) {
//        UIImage *image = [self bannerPlaceHolderImage];
        CGRect bounds = self.view.bounds;
//        CGFloat height = bounds.size.width*image.size.height/image.size.width;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
//        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(height + _topContentInset, 0, 0, 0);
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView = tableView;
    }
    return _tableView;
}

-(instancetype)init {
    if (self = [super init])
    {
//         [self.topImageView setImageWithUrlString:@"" holder:@"well_default_video"];
//        self.topImageView.image = [UIImage imageNamed:@"bg_banner_challenge"];
        
//        self.view.backgroundColor = [UIColor wr_lightWhite];
//         CGFloat offset = WRUIOffset,  x, y, cx, cy;
//        CGRect frame = self.view.bounds;
//        UIImage *holderImage = [UIImage imageNamed:@"well_default_video"];
//        cx = frame.size.width, cy = cx*holderImage.size.height/holderImage.size.width;
//        UIImageView *bannerImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cx, cy)];
//        bannerImageView.image = holderImage;
//        [self.view addSubview:bannerImageView];
//        y = cy;
//        x = 0;
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(x, y, self.view.width, self.view.height - cy)];
//        [self.view addSubview:tableView];
//        self.tableView = tableView;
//        self.tableView.delegate = self;
//        self.tableView.dataSource = self;
        self.tableView.rowHeight = [ChallengeVideoCell defaultHeightForTableView:self.tableView];
//        self.tableView.backgroundColor = [UIColor clearColor];

        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.showsVerticalScrollIndicator = NO;
        
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        __weak __typeof(self) weakSelf = self;
//        self.tableView.mj_header = [WRRefreshHeader headerWithRefreshingBlock:^{
//            [weakSelf fetchData];
//        }];
//        [self.tableView.mj_header beginRefreshing];
        
        [@[WRLogOffNotification, WRLogInNotification] enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(fetchData) name:obj object:nil];
        }];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.shouldBounce = YES;
    self.arr = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _alphaMemory = 0;
    [self createBackBarButtonItem];
//    UIImage *image = [self bannerPlaceHolderImage];
//    CGRect frame = self.tableView.bounds;
//    _topContentInset = frame.size.width*image.size.height/image.size.width;
    
    [self.view addSubview:self.tableView];
//    [self createScaleImageView];
  self.arr=  [self fetcharr];
    [self.tableView reloadData];
    self.title = NSLocalizedString(@"挑战自我", nil);
    [WRNetworkService pwiki:@"挑战自我"];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchData];
    
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
//    if (_alphaMemory == 0) {
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    }
//    else {
//        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    }
}


//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    if (self.alphaBlock) {
//        self.alphaBlock(_alphaMemory);
//    }
//    
//    if (_alphaMemory < 1) {
//        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
//        /*
//         [UIView animateWithDuration:0.15 animations:^{
//         [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
//         //            self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//         }];
//         */
//    }
//}


#pragma mark - UITableView DataSource & Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    __block NSInteger count = 0;
    [[ShareData data].challengeGroupArray enumerateObjectsUsingBlock:^(ChallengeGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count += obj.videos.count;
    }];
    return count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%d",(int)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ChallengeVideoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    WRTreatRehabStage *video = self.arr[indexPath.row];
    NSInteger timeValue = video.userValue;
    
//    UIColor *textColor = [UIColor blackColor];
    NSArray *challengeVideoArray = [ShareUserData userData].challengeVideoArray;
//    BOOL isExit = NO;
    BOOL isOK = NO;
    BOOL isFine = NO;
    for(WRTreatRehabStage *obj in challengeVideoArray)
    {
        if ([obj.videoId isEqualToString:video.videoId]) {
            timeValue = obj.userValue;
            if (timeValue >= obj.refValue) {
                isOK = YES;
            } else {
            }
            if (obj.refValue < 60) {
                if (timeValue >= obj.refValue * 1.2) {
                    isFine = YES;
                }
            } else {
                if (timeValue >= obj.refValue * 1.1) {
                    isFine = YES;
                }
            }
            break;
        }
    }
    
    BOOL unlocked = [self videoIsUnlocked:video];
//    if (timeValue > 0 && !unlocked) {
//        isExit = YES;
//    }
    NSString *time = [NSString stringWithFormat:@"%@", [Utility formatTimeSeconds:timeValue]];
    ChallengeVideoCell *baseCell = (ChallengeVideoCell*)cell;
    baseCell.labelText.text = video.mtWellVideoInfo.videoName;
    baseCell.stateImageView.hidden = !unlocked || [time isEqualToString:@"00:00"];
    //        baseCell.labelDetailText.textColor = textColor;
    //        baseCell.stateLabel.textColor = textColor;

    if (isOK) {
        baseCell.stateImageView.image = [UIImage imageNamed:@"well_challenge_pass"];
    }
    if (isFine) {
        baseCell.stateImageView.image = [UIImage imageNamed:@"well_challenge_fine"];
    }
    baseCell.labelDetailText.hidden = !unlocked;
    //        baseCell.stateLabel.hidden = baseCell.labelDetailText.hidden;
    baseCell.coverView.hidden = !baseCell.labelDetailText.hidden;
    baseCell.lockImageView.hidden = !baseCell.labelDetailText.hidden;
    
    CGFloat value = (CGFloat)(video.difficulty%5)/5;
    if (video.difficulty == 5) {
        value = 1;
    }
    baseCell.rateView.scorePercent = value;
    

    baseCell.labelDetailText.text = time;
    //        baseCell.stateLabel.text = text;
    
    [baseCell.iconImageView setImageWithUrlString:video.mtWellVideoInfo.thumbnailUrl holder:@"well_default_video"];
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
    WRTreatRehabStage *stage = self.arr[indexPath.row];
//    self.video  =  [self userVideoForIndexPath:indexPath];
    ChallengeVideoCell *baseCell = (ChallengeVideoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    self.image = baseCell.iconImageView.image;
    
    
    
    [self challengeVideo:stage];
    
    
    
//    [UMengUtils careForMeChallenge:stage.mtWellVideoInfo.name];
}

//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat offsetY = scrollView.contentOffset.y + _tableView.contentInset.top;//注意
//    if (self.shouldBounce) {
//        if (offsetY < 0) {
//            _topImageView.transform = CGAffineTransformMakeScale(1 + offsetY/(-500), 1 + offsetY/(-500));
//        }
//        CGRect frame = _topImageView.frame;
//        frame.origin.y = 0;
//        _topImageView.frame = frame;
//    }
//    
//    UIImageView *barImageView = self.navigationController.navigationBar.subviews.firstObject;
//    barImageView.alpha = (scrollView.contentOffset.y + 64)/64;
//    UIColor *textColor;
//    if (barImageView.alpha < 0.1) {
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        textColor = [UIColor whiteColor];
//    }
//    else {
//        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//        textColor = [UIColor blackColor];
//    }
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor, NSFontAttributeName:[UIFont systemFontOfSize:19]}];
//}

#pragma mark - 设置分割线顶头
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

//-(UIImage *)bannerPlaceHolderImage {
//    return [UIImage imageNamed:@"bg_banner_challenge"];
//}


//- (void)createScaleImageView
//{
//    UIImage *image = [self bannerPlaceHolderImage];
//    CGRect frame = self.tableView.bounds;
//    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width*image.size.height/image.size.width)];
//    _topImageView.backgroundColor = [UIColor whiteColor];
//    _topImageView.image = image;
//    [self.view insertSubview:_topImageView belowSubview:_tableView];
//}

#pragma mark - Handler
//-(void)notificationHandler:(NSNotification*)notification
//{
//    if([notification.name isEqualToString:WRUpdateSelfInfoNotification])
//    {
//        [self updateUserInfo];
//    }
//}

#pragma mark -
-(WRTreatRehabStage*)userVideoForIndexPath:(NSIndexPath*)indexPath {
    NSInteger count = 0;
    
    for(NSInteger index = 0; index < [ShareData data].challengeGroupArray.count; index++)
    {
        NSArray* arr =[ShareData data].challengeGroupArray;
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
-(NSMutableArray*)fetcharr
{
    [self.arr removeAllObjects];
    for(NSInteger index = 0; index < [ShareData data].challengeGroupArray.count; index++)
    {
        NSArray* arr =[ShareData data].challengeGroupArray;
        ChallengeGroup *group = [ShareData data].challengeGroupArray[index];
        
        
           [self.arr addObjectsFromArray:group.videos];
            
        
    }
    NSMutableArray * backarr = [NSMutableArray array];
    [self.arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WRTreatRehabStage* stage = obj;
        
        NSArray *challengeVideoArray = [ShareUserData userData].challengeVideoArray;
        //    BOOL isExit = NO;
        
        for(WRTreatRehabStage *obj in challengeVideoArray)
        {
            if ([obj.videoId isEqualToString:stage.videoId]) {
        
        NSInteger timeValue = obj.userValue;
        NSLog(@"%ld - %ld",timeValue , stage.refValue);
        BOOL back = false;
                timeValue = obj.userValue;
                if (timeValue >= obj.refValue) {
                    back = YES;
                } else {
                }
                if (obj.refValue < 60) {
                    if (timeValue >= obj.refValue * 1.2) {
                        back = YES;
                    }
                } else {
                    if (timeValue >= obj.refValue * 1.1) {
                        back = YES;
                    }
                }
        if (back) {
            if (![backarr containsObject:stage]) {
                [backarr addObject:stage];

            }
            
        }
            }
        }
        
    }];
    for (id object in backarr) {
        if ([self.arr containsObject:object]) {
            [self.arr removeObject:object];
        }
        if (![self.arr containsObject:object]) {
            [self.arr addObject:object];
        }
    }
    return self.arr;
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

- (void)reloadAndScrollTableView
{
    __block NSInteger count = 0;
    [[ShareData data].challengeGroupArray enumerateObjectsUsingBlock:^(ChallengeGroup * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count += obj.videos.count;
    }];
    [self.tableView reloadData];
    BOOL unlocked = YES;
    NSIndexPath *indexPath;
    for (int i = 0; i < count; i++) {
        indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        WRTreatRehabStage *video = self.arr[i];
        
        NSArray *challengeVideoArray = [ShareUserData userData].challengeVideoArray;
        //    BOOL isExit = NO;
        BOOL isOK = NO;
        NSInteger timeValue;
        for(WRTreatRehabStage *obj in challengeVideoArray)
        {
            if ([obj.videoId isEqualToString:video.videoId]) {
                timeValue = obj.userValue;
                if (timeValue >= obj.refValue) {
                    isOK = YES;
                    
                } else {
                }
                break;
            }
        }

        unlocked = [self videoIsUnlocked:video];
        if (unlocked && !isOK) {
            break;
        }
    }
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
}

#pragma mark - Network
-(void)fetchData
{
    __weak __typeof(self) weakSelf = self;
    [UserViewModel fetchLockDataWithCompletion:^(NSError *error) {
//        [weakSelf.tableView.mj_header endRefreshing];
        if (!error) {
            self.arr = [self fetcharr];
            [self.tableView reloadData];
//            [weakSelf.tableView reloadData];
        } else {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
                [weakSelf fetchData];
            }];

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
    
//    if (![self videoIsUnlocked:stage])
//    {
//        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"完成前面动作的达标任务就能解锁啦", nil)];
//    }
//    else
//    {
        self.currentVideo = stage;
    
    
    self.networkNotifier = [[NetworkNotifier alloc] initWithController:self];
    __weak __typeof(self)weakself = self;
    
    self.networkNotifier.continueBlock = ^(NSInteger index){
        if (index == 0) {
            
            ChallengePlayerController *player = [[ChallengePlayerController alloc] initWithStage:stage isUnlock:[weakself videoIsUnlocked:stage]];
            player.head = weakself.image;
            UINavigationController *nav = [[WRBaseNavigationController alloc] initWithRootViewController:player];
            
            player.completion = ^(BOOL flag)
            {
                if (flag) {
                    // [weakSelf reloadAndScrollTableView];
                }
            };
            player.modalPresentationCapturesStatusBarAppearance = YES;
            [[weakself.class root] presentViewController:nav animated:YES completion:nil];
            
        }
        else
        {
            weakself.networkNotifier =nil;
        }
    };
    
    
}

@end
