//
//  HomeController.m
//  rehab
//
//  Created by herson on 8/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "HomeController.h"

#import "ShareData.h"
#import "ShareUserData.h"
#import "UserViewModel.h"
#import "ProTreatViewModel.h"

#import "HomeButton.h"
#import "MTMissionHeadButton.h"

#import "RehabController.h"

#import "TreatDiseaseSelectorController.h"
#import "PreventIndexController.h"
#import "DiscoveryController.h"
#import "SearchViewController.h"
#import "SettingController.h"
#import "ChallengeController.h"

#import "ProgressController.h"
#import "FavorIndexController.h"
#import "AlarmController.h"
#import "WELLController.h"
#import "UserBasicInfoController.h"
#import "AskIndexController.h"
#import <MMDrawerController/MMDrawerController.h>
#import <UMMobClick/MobClick.h>
#import "IAPViewController.h"

#import "GuideView.h"

#define RR 180

#define ARCButtonTag 1000

@interface HomeController ()<CAAnimationDelegate>
{
    WRUserInfo *_userInfo;
    BOOL _hasShowMainIcons;
}

@property(nonatomic, assign) BOOL loadedData;

@property(nonatomic) NSMutableArray<UIView*> *reservedViewsArray;
@property(nonatomic) NSMutableDictionary *notifyFrameDict;

@property(nonatomic) UIScrollView *scrollView, *subPageScroll;
@property(nonatomic) UIImageView *headImageView;

@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UILabel *rehabLabel;

@end

@implementation HomeController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init
{
    if (self = [super init])
    {
     
        
        _hasShowMainIcons = NO;
        _userInfo = [[WRUserInfo alloc] initWithDictionary:[[WRUserInfo selfInfo] convertDictionary]];
        
        _notifyFrameDict = [NSMutableDictionary dictionary];
        
        __weak __typeof(self) weakSelf = self;
        [@[WRReloadRehabNotification, WRUpdateSelfInfoNotification] enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(notificationHandler:) name:obj object:nil];
        }];
        
        self.clickedEvent = ^(UIView *sender) {
            [weakSelf onClickedSidebarButton:sender];
        };
        
        [@[WRLogInNotification, WRLogOffNotification] enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:obj object:nil];
        }];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.layer.contents = (id)[UIImage imageNamed:@"main_bg"].CGImage;
    self.title = NSLocalizedString(@"WELL健康", nil);
    
    self.buttonArray = [NSMutableArray array];
    _reservedViewsArray = [NSMutableArray array];
    
    UIImage *image = [UIImage imageNamed:@"left_side_icon"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickedLeftBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = rightItem;
    self.backButton = button;
    
    rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.headImageView];
    self.navigationItem.rightBarButtonItem = rightItem;
    

//    [self fetchData];
//    [self fetchFirstData];
    [self updateSelfInfo];
    
    NSLog(@"[ShareUserData userData].rehabCount%ld",[ShareUserData userData].rehabCount);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSInteger collectionCount = [ShareUserData userData].userPermissions.collection;
    NSLog(@"collectionCount%ld",(long)collectionCount);
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    [bar lt_setBackgroundColor:[UIColor clearColor]];

    if (!_hasShowMainIcons) {
        [self createMainIconsWithAnimation];
    }
    

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_hasShowMainIcons) {
        _hasShowMainIcons = YES;
        
        [self showAnimation];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar lt_reset];
}

#pragma mark - getter & setter
-(UIImageView *)headImageView {
    if (!_headImageView) {
        __weak __typeof(self) weakSelf = self;
        UIImage *defaultHeadImage = [WRUIConfig defaultHeadImage];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:defaultHeadImage];
        imageView.frame = CGRectMake(0, 0, 32, 32);
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imageView.width/2;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1.f;
        imageView.userInteractionEnabled = YES;
        [imageView bk_whenTapped:^{
            [weakSelf onClickedRightBarButtonItem:imageView];
        }];
        _headImageView = imageView;
        
        
    }
    return _headImageView;
}

#pragma mark - CAAnimation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSNumber *number = [anim valueForKeyPath:@"index"];
    int index = number.intValue;
    UIButton *button = self.buttonArray[index];
    
    button.frame = button.layer.presentationLayer.frame;

    self.notifyFrameDict[@(index)] = [NSValue valueWithCGRect:CGRectMake(button.left - (button.height - button.width)/2, button.top, button.height, button.height)];
    if (self.notifyFrameDict.count == 7) {
        [self showGuideView];
    }
}

#pragma mark - UI
-(void)createMainIconsWithAnimation
{
    NSArray *imageArray = @[@"home_icon_rehab",@"home_icon_prevent", @"home_icon_discovery", @"home_icon_challenge", @"home_icon_ask", @"home_icon_search", @"home_icon_wellhealth"];
    
    NSArray *titleArray = @[NSLocalizedString(@"康复", nil),NSLocalizedString(@"预防", nil),NSLocalizedString(@"发现", nil),NSLocalizedString(@"挑战", nil), NSLocalizedString(@"问答", nil), NSLocalizedString(@"搜索", nil),NSLocalizedString(@"WELL", nil)];
    
    CGFloat cx = 0, cy, originX = 0;
    //CGFloat offset = WRUIOffset;
    for (int i = 0; i < imageArray.count; i++)
    {
        UIImage *image = [UIImage imageNamed:imageArray[i]];
        
        cx = image.size.width;
        cy = image.size.height + 30;
        if (i == (imageArray.count - 1)) {
            cx += 2*WRUIOffset;
        }
        
        if (originX == 0) {
            originX = cx;
        }
        
        ImageTitleButton *button = [[ImageTitleButton alloc] initWithFrame:CGRectMake(-originX, self.view.height/2, cx, cy)];
        //button.backgroundColor = [UIColor orangeColor];
        button.tag = ARCButtonTag + i;
        [button setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont wr_detailFont];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onClickedArcButton:) forControlEvents:UIControlEventTouchUpInside];
        //button.radius = self.view.width *3/4;
        //button.amount = imageArray.count;
        //button.index = i;
        [self.view addSubview:button];
        
        [self.buttonArray addObject:button];
    }
}

-(void)showAnimation
{
    CGPoint originPoint = CGPointMake(30, self.view.center.y + 40);
    
    CGFloat endAnglePos = - M_PI/2 + M_PI/12;
    
    CGFloat startAnglePos = M_PI/2 + M_PI/8;
    
    //CGFloat arcAngle = (startAnglePos - endAnglePos) / (2self.buttonArray.count);
    
    CGFloat angles[] = {0, M_PI/7, M_PI/8, M_PI/8, M_PI/8, M_PI/9, M_PI/10};
//    CGFloat radiusOffset[] = { 30, 50, 60, 60, 65, 65, 60};
    NSArray *radiusOffset = @[@(30), @(50), @(60), @(60), @(65), @(65), @(60)];
    CGFloat startAngle = startAnglePos;
    CGFloat endAngle = endAnglePos;
    CGFloat radius = RR;
    if ([UIScreen mainScreen].scale == 2.0 && [UIScreen mainScreen].bounds.size.width > 320) {
        radius = RR + 30;
        radiusOffset = @[@(30), @(50), @(65), @(78), @(82), @(80), @(75)];
    } else if (iPhone6PlusBigMode) {
        radius = RR + 30;
        radiusOffset = @[@(30), @(50), @(65), @(78), @(82), @(80), @(75)];
    } else if ([UIScreen mainScreen].scale == 3.0){
        radius = (radius + 30) * 1.1;
        radiusOffset = @[@(30), @(55), @(75), @(90), @(95), @(95), @(90)];
    }
    for(NSInteger index = 0; index < self.buttonArray.count; index++)
    {
        CGFloat arcAngle = angles[index];
        
        UIView *view = self.buttonArray[index];
        
        startAngle += arcAngle;
        endAngle += arcAngle;

        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:originPoint radius:(radius + [radiusOffset[index] floatValue]) startAngle:startAngle endAngle:endAngle clockwise:NO];
        
        CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        keyFrameAnimation.duration = 1.0;
        keyFrameAnimation.path = bezierPath.CGPath;
        keyFrameAnimation.fillMode = kCAFillModeForwards;
        keyFrameAnimation.removedOnCompletion = NO;
        keyFrameAnimation.delegate = self;
        [keyFrameAnimation setValue:@(index) forKey:@"index"];
        [view.layer addAnimation:keyFrameAnimation forKey:@"movingAnimation"];
    }
}

#pragma mark - Control Event
- (IBAction)onClickedLeftBarButtonItem:(UIButton *)sender
{
    /*
     __weak __typeof(self)weakself = self;
     [self.view bringSubviewToFront:self.sliderView];
     [UIView animateWithDuration:0.25 animations:^{
     sender.alpha = 0;
     weakself.sliderView.left = self.view.width - weakself.sliderView.width;
     }];
     */
    [UMengUtils careForSide];
    MMDrawerController *drawerController = (MMDrawerController*)[self.class root];
    [drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

- (IBAction)onClickedRightBarButtonItem:(id)sender
{
    if ([self checkUserLogState:nil]) {
        [UMengUtils careForMeHome];
        UIViewController *viewController = [[UserBasicInfoController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (IBAction)onClickedSidebarButton:(UIView *)sender
{
    MMDrawerController *drawerController = (MMDrawerController*)[self.class root];
    [drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        if (sender.tag != 4 && sender.tag != 3) {
            if (![self checkUserLogState:nil]) {
                return;
            }
        }
        switch (sender.tag) {
            case 0:
            {
                [self onClickedRightBarButtonItem:self.headImageView];
                break;
            }
                
            case 1:
            {
                [UMengUtils careForSideRehabs];
                ProgressController *progressController = [[ProgressController alloc] init];
                [self.navigationController pushViewController:progressController animated:YES];
                break;
            }
                
            case 2:
            {
                [UMengUtils careForSideFavors];
                FavorIndexController *favorController = [[FavorIndexController alloc] init];
                [self.navigationController pushViewController:favorController animated:YES];
            }
                break;
                
            case 3:
            {
                [UMengUtils careForSideAlarm];
                AlarmController *alarmController = [[AlarmController alloc] init];
                [self.navigationController pushViewController:alarmController animated:YES];
                break;
            }
                
            case 4:
            {
                [UMengUtils careForSideSetting];
                SettingController *alarmController = [[SettingController alloc] init];
                [self.navigationController pushViewController:alarmController animated:YES];
                break;
            }
                
            default:
                break;
        }
    }];
}

//- (IBAction)onClickedArcButton:(UITapGestureRecognizer *)gesture
- (IBAction)onClickedArcButton:(UIButton *)button
{
    NSLog(@"onClickedArcButton");
    
    NSInteger index = button.tag - ARCButtonTag;
    switch (index) {
        case 0:
        {
            [self showRehabSelector];
//            [UMengUtils careForTreatDiseaseSelector];
            [UMengUtils careForRehabDiseaseSelector];
            break;
        }
            
        case 1:
        {
            [UMengUtils careForPrevent];
            PreventIndexController *viewController = [[PreventIndexController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
            
        case 2:
        {
            DiscoveryController *discoveryController = [[DiscoveryController alloc] init];
            [self.navigationController pushViewController:discoveryController animated:YES];
            break;
            
//            IAPViewController *discoveryController = [[IAPViewController alloc] init];
//            [self.navigationController pushViewController:discoveryController animated:YES];
            break;
        }
            
        case 3:
        {
            [UMengUtils careForChallenge];
            ChallengeController *challengeController = [[ChallengeController alloc] init];
            [self.navigationController pushViewController:challengeController animated:YES];
            break;
        }
            
        case 4:
        {
            if ([self checkUserLogState:nil]) {
                [UMengUtils careForAsk];
                AskIndexController *viewController = [[AskIndexController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            break;
        }
            
        case 5:
        {
            SearchViewController *searchController = [[SearchViewController alloc] init];
//            searchController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:searchController animated:YES];
            break;
        }
            
        case 6:
        {
            [UMengUtils careForWell];
            WELLController *viewController = [[WELLController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            break;
        }
            
        default:
            break;
    }
}



#pragma mark - Handler
//-(void)notificationHandler:(NSNotification*)notification
//{
//    //重新加载个人方案
//    if ([notification.name isEqualToString:WRReloadRehabNotification])
//    {
//        do {
//            NSDictionary *userInfo = notification.userInfo;
//            if (userInfo && [userInfo isKindOfClass:[NSDictionary class]])
//            {
//                WRRehab *rehab = userInfo[@"rehab"];
//                if (rehab) {
//                    BOOL flag = [[ShareUserData userData] notifyRehab:rehab];
//                    if (flag) {
//                        [[NSNotificationCenter defaultCenter] postNotificationName:WRUpdateUserRehabNotification object:nil];
//                    }
//                    break;
//                }
//            }
//            [self reload];
//        }while(false);
//    }
//    else if([notification.name isEqualToString:WRUpdateSelfInfoNotification])
//    {
//        [self updateSelfInfo];
//    }
//}

-(void)notificationHandler:(NSNotification*)notification
{
    if ([notification.name isEqualToString:WRLogInNotification])
    {
        [self userHome];
        [self updateSelfInfo];
        [self fetchData];
//        [self reloadData];
//        [self notifyUserDataChanged];
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
        [self updateSelfInfo];
//        [self fetchData];
        self.rehabLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@""];
//        [self reloadData];
//        [self notifyUserDataChanged];
        NSLog(@"Recv WRLogOffNotification");
    } else if ([notification.name isEqualToString:WRUpdateSelfInfoNotification])
    {
        [self updateSelfInfo];
    }
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

#pragma mark - functions
-(void)updateSelfInfo
{
    [WRUIConfig updateSelfHeadForImageView:self.headImageView];
}

-(void)showRehabSelector
{
#if 0
    ProTreatController *viewController = [[ProTreatController alloc] init];
    UINavigationController *nav = [[WRBaseNavigationController alloc] initWithRootViewController:viewController];
    [[self.class root] presentViewController:nav animated:YES completion:nil];
#else
    if ([self checkUserLogState:nil]) {
        TreatDiseaseSelectorController *viewController = [[TreatDiseaseSelectorController alloc] init];
        //        self.treatController = viewController;
        [self.navigationController pushViewController:viewController animated:YES];
        //        WRBaseNavigationController *nav = [[WRBaseNavigationController alloc] initWithRootViewController:viewController];
        //        [[self.class root] presentViewController:nav animated:YES completion:nil];
    }
#endif
}

#pragma mark - Network
-(void)fetchData {
    if (![[WRUserInfo selfInfo] isLogged]) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    [UserViewModel fetchPersonDataWithCompletion:^(NSError *error) {
        //        [_scrollView.mj_header endRefreshing];
        if (error) {
            //            [weakSelf layout];
        } else {
            weakSelf.loadedData = YES;
            //            [weakSelf layout];
            if (!_rehabLabel) {
                _rehabLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.height/2, 0, 0)];
                [weakSelf.view addSubview:weakSelf.rehabLabel];
                weakSelf.rehabLabel.textColor = [UIColor lightGrayColor];
                weakSelf.rehabLabel.font = [UIFont wr_lightFont];
            }
            NSString *text = [NSString stringWithFormat:@"%ld套方案",(long)[ShareUserData userData].rehabCount];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
            NSDictionary *fontPara = @{NSFontAttributeName:[UIFont wr_largeFont]};
            NSRange range = NSMakeRange(0, [@([ShareUserData userData].rehabCount) stringValue].length);
            [attributedString setAttributes:fontPara range:range];
            weakSelf.rehabLabel.attributedText = attributedString;
            [weakSelf.rehabLabel sizeToFit];
            weakSelf.rehabLabel.frame = [Utility resizeRect:weakSelf.rehabLabel.frame cx:weakSelf.rehabLabel.width height:weakSelf.rehabLabel.height];
            weakSelf.rehabLabel.userInteractionEnabled = YES;
            [weakSelf.rehabLabel bk_whenTapped:^{
                ProgressController *progressController = [[ProgressController alloc] init];
                [weakSelf.navigationController pushViewController:progressController animated:YES];
            }];
            NSLog(@"[ShareUserData userData].rehabCount%ld",[ShareUserData userData].rehabCount);
        }
    }];
}

-(void)reload {
    if ([WRUserInfo selfInfo].isLogged) {
        
    } else {
        self.loadedData = YES;
    }
}

-(void)loadData
{
    
}
#pragma mark - Guide View
static NSString *kGuideVersionKey = @"homeGuide";
-(void)showGuideView
{
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kGuideVersionKey];
    if (lastVersion && lastVersion.floatValue > 0.0) {
        
    } else {
        NSArray* guideTitles = @[
                                 
                                 NSLocalizedString(@"快来定制您专属的运动方案来康复慢病吧！", nil),
                                 NSLocalizedString(@"预防慢病亚健康，从这里开始！", nil),
                                 NSLocalizedString(@"最新最全最专业的运动康复信息都在这里咯！", nil),
                                 NSLocalizedString(@"刷新纪录，挑战自我，测试健康水平！", nil),
                                 NSLocalizedString(@"有问题，问专家。", nil),
                      
                                 NSLocalizedString(@"您的康复方案、收藏和提醒都在这里哦！", nil),
                                 ];
        [[NSUserDefaults standardUserDefaults] setObject:@"1.0" forKey:kGuideVersionKey];
        
        NSMutableArray *rects = [NSMutableArray array];
        for(NSInteger i = 0; i < 5; i++)
        {
            NSValue *value = self.notifyFrameDict[@(i)];
            if (value == nil) {
                value = [NSValue valueWithCGRect:CGRectZero];
            }
            [rects addObject:value];
        }
        GuideView *guide = [GuideView new];
        NSMutableArray *array = [NSMutableArray arrayWithArray:rects];
        [array addObject:[NSValue valueWithCGRect:CGRectMake(0, 20, 50, 44)]];
        UIView *view = [[UIApplication sharedApplication].delegate window].rootViewController.view;
        [guide showInView:view maskFrames:array labels:guideTitles];
    }
}
@end
