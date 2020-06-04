//
//  ChallengePlayerController.m
//  rehab
//
//  Created by herson on 8/24/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ChallengeNotifyView.h"
#import "ChallengePlayerController.h"
#import "JCAlertView.h"
#import "MBCircularProgressBarView.h"
#import "MZTimerLabel.h"
#import "RehabPlayerPauseView.h"
#import "SDPhotoBrowser.h"
#import "ShareData.h"
#import "ShareUserData.h"
#import "UIImage+Tint.h"
#import "UserViewModel.h"
#import "WRMediaPlayer.h"
#import "WRToolView.h"
#import "RehabObject.h"
#import <AVFoundation/AVFoundation.h>
#import "CWStarRateView.h"
#import "FCAlertView.h"
#import "ChallengeNotifyController.h"
#import "NetworkNotifier.h"
#import "ShowAlertView.h"
#import <YYKit/YYKit.h>
#define progress_height 8

@interface ChallengePlayerController ()<UIScrollViewDelegate>
{
    WRMediaPlayer *_playerView;
    CGRect _playViewSmallFrame;
    
    BOOL _isManualRotate;
    BOOL _isFullScreenMode;
    UIInterfaceOrientationMask _supportUIInterfaceOrientation;
    
    UIStatusBarStyle oldStatusBarStyle;
    
    NSTimer *_timer;
    
    NSInteger _tickCount;
    
    NSDate *_startDate;
}

@property(nonatomic)BOOL isFinished, pause;

@property(nonatomic, weak) WRTreatRehabStage* stage, *userStage;
@property (nonatomic, strong) NetworkNotifier *networkNotifier;
@property (nonatomic, strong) ChallengeNotifyView *notifyView;

@property(nonatomic)UILabel *titleLabel, *detailLabel, *timerLabel, *centerLabel;
@property(nonatomic)UILabel *totalTimerLabel;
@property(nonatomic)UIImageView *checkImageView, *closeImageView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (assign) BOOL applicationIdleTimerDisabled, isMaxing;

@property(nonatomic)NSInteger currentTimeValue;

@property(nonatomic)AVAudioPlayer *backgroundMusicPlayer;
@property (nonatomic, assign) BOOL isUnlock;
@property (nonatomic, assign) BOOL isWWAN;
@property (nonatomic, assign) BOOL notifyViewHasInit;

@end

@implementation ChallengePlayerController

-(void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
//    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
//    [manager stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForChallengePlayer:_stage.mtWellVideoInfo.videoName duration:duration];
}

-(instancetype)initWithStage:(WRTreatRehabStage*)stage isUnlock:(BOOL)isunlock {
    if (self = [super init]) {
//        self.automaticallyAdjustsScrollViewInsets = NO;
        self.notifyViewHasInit = NO;
        _startDate = [NSDate date];
        _isUnlock = isunlock;
        _tickCount = 5;
        __weak __typeof(self)weakself = self;
        self.stage = stage;
        self.userStage = [[ShareUserData userData] getUserStageByVideoId:self.stage.videoId];
//        self.networkNotifier = [[NetworkNotifier alloc] initWithController:self];
//        self.networkNotifier.continueBlock = ^(NSInteger index){
//            if (index == 1) {
//                [weakself exit];
//            }
//        };
        _isManualRotate = NO;
        _isFullScreenMode = NO;
        _supportUIInterfaceOrientation = UIInterfaceOrientationMaskAll;

        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
 
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [self.view addGestureRecognizer:recognizer];
 
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back_black"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedBarButtomItem:)];
        self.navigationItem.leftBarButtonItem = item;
        /*
        UISwipeGestureRecognizer *swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swichController:)];
        //默认是UISwipeGestureRecognizerDirectionRight
        swipe.direction=UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:swipe];
        UISwipeGestureRecognizer *swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swichController:)];
        //默认是UISwipeGestureRecognizerDirectionRight
        swiperight.direction=UISwipeGestureRecognizerDirectionDown;
        [self.view addGestureRecognizer:swiperight];
         */
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor wr_lightGray];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(!self.backgroundMusicPlayer) {
        NSError *error;
        NSURL *backgroundMusicURL;
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *key = @"backgroundMusicName";
        NSString *musicName = [ud objectForKey:key];
        if (musicName && ![musicName isEqualToString:@"bg"]) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDir = [paths objectAtIndex:0];
            NSString *path = [docDir stringByAppendingPathComponent:musicName];
            backgroundMusicURL = [NSURL fileURLWithPath:path];
        } else {
            backgroundMusicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bg" ofType:@"mp3"]];
        }
        
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
        self.backgroundMusicPlayer.numberOfLoops = -1;
        [self.backgroundMusicPlayer prepareToPlay];
        //            [self.backgroundMusicPlayer setVolume:0.05];
       // _currentVolume = self.backgroundMusicPlayer.volume;
        
    }
    [self.backgroundMusicPlayer play];

//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
    
    
    
    self.navigationItem.title = self.stage.mtWellVideoInfo.videoName;
    
    self.applicationIdleTimerDisabled = [UIApplication sharedApplication].isIdleTimerDisabled;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    oldStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (!self.titleLabel) {
//        UIColor *gradientStartColor = [UIColor colorWithHexString:@"73bbef"];
//        UIColor *gradientEndColor = [UIColor wr_themeColor];
//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
//        gradientLayer.bounds = self.view.bounds;
//        gradientLayer.frame = self.view.bounds;
//        gradientLayer.colors = @[(id)gradientStartColor.CGColor, (id)gradientEndColor.CGColor];
//        gradientLayer.startPoint = CGPointMake(0.0, 0.0);
//        gradientLayer.endPoint = CGPointMake(1, 1);
//        [self.view.layer insertSublayer:gradientLayer atIndex:0];
        
        [self layoutWithStage:self.stage];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"well_icon_faq"] forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(onClickedFaqItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *faqItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = faqItem;
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = self.applicationIdleTimerDisabled;
    [self.backgroundMusicPlayer stop];
    self.backgroundMusicPlayer = nil;
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle = oldStatusBarStyle;
}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleDefault;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(BOOL)prefersStatusBarHidden {
//    return YES;
//}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    BOOL isFullScreen = (self.view.bounds.size.width > self.view.bounds.size.height);
    _playerView.frame = isFullScreen ? self.view.bounds : _playViewSmallFrame;
    self.closeImageView.hidden = isFullScreen;
    self.closeImageView.hidden = YES;
    _playerView.backButton.hidden = !isFullScreen;
    _playerView.disableOnTouch = !isFullScreen;
}

#pragma mark - Getter&Setter

#pragma mark - handler
-(IBAction)onClickedFaqItem:(UIBarButtonItem*)sender
{
//    ChallengeNotifyController *viewController = [[ChallengeNotifyController alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
//    viewController.title = self.stage.mtWellVideoInfo.videoName;
//    viewController.data = self.stage;
    
    NSArray *array = @[self.stage.harm, self.stage.explanation];
    ShowAlertView *notifyView = [[ShowAlertView alloc] initWithFrame:self.navigationController.view.bounds title:self.stage.mtWellVideoInfo.videoName titleArray:array];
    [Utility viewAddToSuperViewWithAnimation:notifyView superView:self.navigationController.view completion:^{
        
    }];
}

- (IBAction)onClickedBarButtomItem:(UIBarButtonItem *)sender
{
    [self exit];
}

-(IBAction)onClickedPlayerResizeButton:(UIButton*)sender {
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = (orientation == UIDeviceOrientationPortrait) ? UIInterfaceOrientationLandscapeLeft : UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

-(IBAction)onClickedPlayerBackButton:(UIButton*)sender {
    if (CGRectEqualToRect(_playerView.frame, _playViewSmallFrame)) {
        self.pause = YES;
    } else {
        [_playerView.resizeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)handleSwipeFrom:(UIGestureRecognizer*)recognizer
{
    [self exit];
}

#pragma mark - orientation changed
- (void)orientationChange:(id)sender
{
    @synchronized (self) {
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        if (orientation == UIDeviceOrientationLandscapeRight ||orientation == UIDeviceOrientationLandscapeLeft)
        {
            self.isMaxing = YES;
//            [UIApplication sharedApplication].statusBarHidden = YES;
            _playerView.frame = [UIScreen mainScreen].bounds;
            _playerView.resizeButton.selected = YES;
        }
        else if (orientation == UIDeviceOrientationPortrait)
        {
//            [UIApplication sharedApplication].statusBarHidden = NO;
            _playerView.frame = _playViewSmallFrame;
            _playerView.resizeButton.selected = NO;
        }
        else if (orientation == UIDeviceOrientationUnknown)
        {
            if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
            {
                [UIApplication sharedApplication].statusBarHidden = NO;
                _playerView.frame = _playViewSmallFrame;
                _playerView.resizeButton.selected = NO;
            }
        }
        else if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationPortraitUpsideDown) {
            return;
        }
    }
}

-(void)layoutWithRotation
{
    //[_playerView resetLayout:_isFullScreenMode isDone:NO];
    if( _isFullScreenMode )
    {
        CGRect rcScreen = [UIScreen mainScreen].bounds;
        if(rcScreen.size.width < rcScreen.size.height)
        {
            rcScreen = CGRectMake(0, 0, rcScreen.size.height, rcScreen.size.width);
        }
        _playerView.frame = CGRectMake(0, 0, rcScreen.size.width, rcScreen.size.height);
    }
    else
    {
        _playerView.frame = _playViewSmallFrame;
    }
    //[_playerView resetLayout:_isFullScreenMode isDone:YES];
}

-(void)switchInterfaceOrientationAnimated:(BOOL)flag
{
    if(YES)
    {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
            int val = UIInterfaceOrientationIsPortrait(orientation)?UIInterfaceOrientationLandscapeRight:UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }
    else
    {
        _isManualRotate = YES;
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        if(UIInterfaceOrientationIsLandscape(orientation))
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
        }
        else
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
        }
    }
}

#pragma mark - getter & setter
-(void)setPause:(BOOL)pause
{
    _pause = pause;
    
    if (_pause) {
        self.checkImageView.highlighted = YES;
        __weak __typeof(self) weakSelf = self;
        
       FCAlertView *alert = [[FCAlertView alloc] init];
        [alert showAlertInView:self withTitle:NSLocalizedString(@"提示", nil) withSubtitle:NSLocalizedString(@"测试还没完成，确定要退出吗?", nil) withCustomImage:nil withDoneButtonTitle:NSLocalizedString(@"取消", nil) andButtons:nil];
        [alert addButton:NSLocalizedString(@"退出", nil) withActionBlock:^{
            if (weakSelf.completion) {
                weakSelf.completion(NO);
            }
            [weakSelf exit];
        }];
        alert.colorScheme = [UIColor wr_themeColor];
        [_playerView pause];

//        [JCAlertView showTwoButtonsWithTitle:NSLocalizedString(@"提示", nil) Message:NSLocalizedString(@"测试还没完成，确定要退出吗?", nil) ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:NSLocalizedString(@"取消", nil) Click:nil ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:NSLocalizedString(@"退出", nil) Click:^{
//            if (weakSelf.completion) {
//                weakSelf.completion(NO);
//            }
//            [weakSelf exit];
//        }];
    }
    else
    {
        self.checkImageView.highlighted = NO;
    }
}

-(void)setCurrentTimeValue:(NSInteger)currentTimeValue
{
    _currentTimeValue = currentTimeValue;
    self.totalTimerLabel.text = [Utility formatTimeSeconds:currentTimeValue];
}

#pragma mark - control functions
-(void)layoutWithStage:(WRTreatRehabStage*)stage {
    __weak __typeof(self) weakSelf = self;
    BOOL iPad = [WRUIConfig IsHDApp];

    
    UIFont *subTitleFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_labelFont];
    UIFont *bigFont = iPad ? [UIFont wr_bigFont] : [UIFont wr_bigFont];
    
    UIView *container = self.scrollView;
    CGRect frame = container.bounds;
    CGFloat offset = WRUIOffset, x = 0, y, cx = 0, cy = 0;

    CGSize size;
    
    if (!_closeImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_close"]];
        imageView.hidden = YES;
        imageView.userInteractionEnabled = YES;
        imageView.hidden = YES;
        [self.view addSubview:imageView];
        self.closeImageView = imageView;
        [imageView bk_whenTapped:^{
            [weakSelf exit];
        }];
    }
    

//    y = _closeImageView.bottom + offset;
//    cy = frame.size.height - 2.2*y;
//    if ([UIScreen mainScreen].scale >= 3) {
//        cy -= 0.5 * y;
//    }
    
//    x = 0;
//    y = offset;
//    cx = frame.size.width;
//    cy = frame.size.height;
    
//    UIVisualEffectView *panel = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
//    //panel.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    panel.backgroundColor = [UIColor whiteColor];
//    panel.layer.masksToBounds = YES;
//    panel.layer.cornerRadius = 5;
//    [self.view addSubview:panel];
    
    if (!_playerView)
    {
//        y = panel.top - offset;
        y = 64;
        if (IPHONE_X) {
            y=64+30;
        }
        x = 0;
        cx = frame.size.width - 2*x;
        cy = 9*cx/16;
        WRMediaPlayer *player = [[WRMediaPlayer alloc] initWithFrame:CGRectMake(x, y, cx, cy) style:WRMediaPlayerStyleDefault];
        player.isLoop = YES;
        player.hideControls = YES;
        player.backgroundColor = [UIColor darkGrayColor];
        [player.resizeButton addTarget:self action:@selector(onClickedPlayerResizeButton:) forControlEvents:UIControlEventTouchUpInside];
        [player.backButton addTarget:self action:@selector(onClickedPlayerBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:player];
        
        _playViewSmallFrame = player.frame;
        _playerView = player;
//        _playerView.layer.masksToBounds = YES;
//        _playerView.layer.cornerRadius = 5;
    }
    
    x = _playerView.left + offset;
    y = _playerView.bottom + offset;
    if ([UIScreen mainScreen].scale >= 3) {
        y += 2*offset;
    }
    cx = _playerView.width/2;
    UILabel *label;
    if (!self.titleLabel)
    {
        label = [[UILabel alloc] init];
        label.textColor = [UIColor darkGrayColor];
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.frame = CGRectMake(x, y, cx, 0);
        label.font = [subTitleFont fontWithBold];
        label.text = stage.mtWellVideoInfo.videoName;
        size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        label.frame = [Utility resizeRect:label.frame cx:-1 height:size.height];
        [container addSubview:label];
        self.titleLabel = label;
    }
    self.titleLabel.text = stage.mtWellVideoInfo.videoName;
    
    y =self.titleLabel.bottom + offset;
    x = self.titleLabel.left;
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 0, 0)];
    label.textColor = [UIColor darkGrayColor];
    label.font = subTitleFont;
    label.text = NSLocalizedString(@"难度系数：", nil);;
    [label sizeToFit];
    label.frame = [Utility resizeRect:label.frame cx:label.width height:label.height];
    [container addSubview:label];
    cx = 120;
    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, cx, label.height) numberOfStars:5];
    
//    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, cx, cy) numberOfStars:5 backgroundImage:[UIImage imageNamed:@"nav_transparent"] foregroundImage:[UIImage imageNamed:@"b27_icon_star_yellow"]];
    
    float value = (float)(self.stage.difficulty%5)/5;
    if (self.stage.difficulty == 5) {
        value = 1;
    }
    starRateView.scorePercent = value;
    starRateView.allowIncompleteStar = NO;
    starRateView.hasAnimation = NO;
    starRateView.userInteractionEnabled = NO;
    y = label.centerY - starRateView.height/2;
    starRateView.frame = CGRectMake(label.right + offset, y, starRateView.width, starRateView.height);
    [container addSubview:starRateView];
    
    y = label.bottom + offset;
    x = _playerView.left + offset;
    cx = _playerView.width;
    label = [[UILabel alloc] init];
    label.textColor =  self.titleLabel.textColor;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.frame = CGRectMake(x, y, cx, 0);
    label.font = self.titleLabel.font;
    label.textAlignment = NSTextAlignmentRight;
    label.text = [NSString stringWithFormat:@"%@  %@%@", NSLocalizedString(@"挑战目标", nil), [@(stage.refValue) stringValue], stage.refUnit];;
    size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = CGRectMake(x, y, size.width, size.height);
    [container addSubview:label];
    y = label.bottom + offset;
    
    /*
    x = offset;
    label = [[UILabel alloc] init];
    label.text = NSLocalizedString(@"难度 ", nil);
    label.font = [UIFont wr_textFont];
    label.textColor = [UIColor lightGrayColor];
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:x y:y];
    [container addSubview:label];
    
    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 0, 80, 22) numberOfStars:5 backgroundImage:[UIImage imageNamed:@"nav_transparent"] foregroundImage:[UIImage imageNamed:@"b27_icon_star_yellow"]];
    
    float value = (float)(self.stage.difficulty%5)/5;
    if (self.stage.difficulty == 5) {
        value = 1;
    }
    starRateView.scorePercent = value;
    starRateView.allowIncompleteStar = NO;
    starRateView.hasAnimation = NO;
    starRateView.userInteractionEnabled = NO;
    starRateView.frame = CGRectMake(label.right + 3, y - 2, starRateView.width, starRateView.height);
    [container addSubview:starRateView];
    y = label.bottom + offset;
    */
    label = [[UILabel alloc] init];
    label.textColor = [UIColor wr_faqContentColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.frame = CGRectMake(x, y, cx, 0);
    label.font = [UIFont wr_smallFont];
    label.text = NSLocalizedString(@"要点:", nil);
    size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = [Utility resizeRect:label.frame cx:size.width height:size.height];
    [container addSubview:label];
    x = label.right + 3;
    cx = _playerView.right - offset - x;
    
    label = [[UILabel alloc] init];
    label.textColor = [UIColor wr_faqContentColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.frame = CGRectMake(x, y, cx, 0);
    label.font = [UIFont wr_smallFont];
    label.text = stage.mtWellVideoInfo.detail;
    label.textAlignment = NSTextAlignmentLeft;
    label.numberOfLines = 0;
    size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = [Utility resizeRect:label.frame cx:-1 height:size.height];
    [container addSubview:label];
    y = label.bottom + offset;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(_playerView.left, y, _playerView.width, 1)];
    line.backgroundColor = [UIColor wr_lightWhite];
    [container addSubview:line];
    y = line.bottom + offset;
    
    if (!self.totalTimerLabel)
    {
        cy = 60, cx = 200, x = container.width/2 - cx/2;
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.textColor = [UIColor blackColor];
        label.font = bigFont;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @" ";
        CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        label.frame = [Utility resizeRect:label.frame cx:-1 height:size.height];
        [container addSubview:label];
        self.totalTimerLabel = label;
        
        
        y = label.bottom + offset/2;
    }
    
    if (!self.detailLabel)
    {
        x = offset;
        cx = frame.size.width - 2*x;
        label = [[UILabel alloc] init];
        label.textColor = [UIColor lightGrayColor];
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.frame = CGRectMake(x, y, cx, 0);
        label.font = subTitleFont;
        if (IPONE5) {
            label.font = [UIFont systemFontOfSize:13];
            
        }
        label.text = @" ";
        label.textAlignment = NSTextAlignmentCenter;
        CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        label.frame = [Utility resizeRect:label.frame cx:-1 height:size.height];
        [container addSubview:label];
        self.timerLabel = label;
        
    }
    y = self.timerLabel.bottom + offset;
    
    if (!self.centerLabel) {
        UIImage *image;
        image = [UIImage imageNamed:@"big_pause"];
        cx = image.size.width;
        cy = cx;
        if (!self.isUnlock) {
            image = [UIImage imageNamed:@"well_time_state_lock"];
        }

        x = (frame.size.width - cx)/2;
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
//        label.text = [@(_tickCount) stringValue];
        label.font = [[UIFont wr_titleFont] fontWithBold];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor wr_themeColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = label.width/2;
        label.layer.masksToBounds = YES;
        label.userInteractionEnabled = YES;
        [container addSubview:label];
        self.centerLabel = label;
        [self.centerLabel bk_whenTapped:^{
            [weakSelf play];
            [UMengUtils careForChallengePlayerStart:self.stage.mtWellVideoInfo.videoName];
            /*
            __block GFWaterView *waterView = [[GFWaterView alloc]initWithFrame:CGRectMake(100, 100, 200, 200)];
            waterView.center = self.centerLabel.center;
            waterView.backgroundColor = [UIColor clearColor];
            [container insertSubview:waterView belowSubview:self.centerLabel];
            
            [UIView animateWithDuration:2 animations:^{
                waterView.transform = CGAffineTransformScale(waterView.transform, 2, 2);
                waterView.alpha = 0;
            } completion:^(BOOL finished) {
                [waterView removeFromSuperview];
            }];
             */
        }];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        if (self.isUnlock) {
            imageView.hidden = YES;
            self.centerLabel.text = NSLocalizedString(@"开始", nil);
        }
        imageView.highlightedImage = [UIImage imageNamed:@"com_white_play"];
        imageView.userInteractionEnabled = YES;
        [container addSubview:imageView];
        imageView.center = self.centerLabel.center;
        self.checkImageView = imageView;
        
        [imageView bk_whenTapped:^{
            if (self.isUnlock) {
                if (!weakSelf.pause) {
                    [weakSelf finish];
                    [UMengUtils careForChallengePlayerEnd:weakSelf.stage.mtWellVideoInfo.videoName];
                } else {
                    weakSelf.pause = NO;
                    [_playerView start];
                    [UMengUtils careForChallengePlayerStart:self.stage.mtWellVideoInfo.videoName];
                }
            } else {
                [weakSelf play];
            }
          
        }];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.centerLabel.bottom + offset);
        cx = self.centerLabel.width*1.5;
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cx, cx)];
        maskView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        maskView.layer.masksToBounds = YES;
        maskView.layer.cornerRadius = cx/2;
//        [container insertSubview:maskView belowSubview:panel];
        maskView.center = self.centerLabel.center;
        
        cx = self.centerLabel.width*1.25;
        maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cx, cx)];
        maskView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75];
        maskView.layer.masksToBounds = YES;
        maskView.layer.cornerRadius = cx/2;
//        [container insertSubview:maskView belowSubview:panel];
        maskView.center = self.centerLabel.center;
    }
    
    [_playerView stop];
    if (_playerView)
    {
        [self.view bringSubviewToFront:_playerView];
        if (![Utility IsEmptyString:stage.mtWellVideoInfo.videoUrl])
        {
            [_playerView setContent:[NSURL URLWithString:stage.mtWellVideoInfo.videoUrl] autoStart:NO];
        }
    }
    [self.view bringSubviewToFront:self.closeImageView];
}

-(void)play
{
//    __weak __typeof(self)weakself = self;
    if (self.isUnlock) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerProc) userInfo:nil repeats:YES];
        }
        self.centerLabel.userInteractionEnabled = NO;
        self.checkImageView.hidden = YES;
        _tickCount = 6;
        self.pause = NO;
        
        self.currentTimeValue = 0;
        [_timer fire];
    } else {
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"完成前面动作的达标任务就能解锁啦", nil)];
    }
    
}

-(void)timerProc
{
    if (self.pause) {
        return;
    }
    
    _tickCount--;
    if (_tickCount == 0)
    {
        _tickCount = -1;
        //[_timer invalidate];
        [_playerView start];
        self.centerLabel.text = @"";
        self.checkImageView.hidden = NO;
        
        self.currentTimeValue = 0;
        //[self.totalTimerLabel reset];
        //[self.totalTimerLabel start];
    }
    else
    {
        if(_tickCount > 0)
        {
            self.centerLabel.text = [@(_tickCount) stringValue];
        }
        else
        {
            self.currentTimeValue++;
        }
        
        
        UIColor *color = [UIColor darkGrayColor];
        NSString *text;
        if (self.userStage && self.userStage.userValue > 0) {
            NSTimeInterval val = self.currentTimeValue;
            if (val > self.userStage.userValue) {
                NSString *value = [Utility formatTimeSeconds:val];
                text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"新纪录", nil), value];
                color = [UIColor wr_themeColor];
            } else {
                NSString *value = [Utility formatTimeSeconds:self.userStage.userValue];
                text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"历史最高纪录", nil), value];
                color = [UIColor orangeColor];
            }
        } else {
            text = [NSString stringWithFormat:@"%@:%@%@", NSLocalizedString(@"挑战目标", nil), [@(self.stage.refValue) stringValue], self.stage.refUnit];
        }
        self.timerLabel.text = text;
        self.timerLabel.textColor = color;
    }
}

-(void)finish
{
    [_playerView pause];
    [_timer invalidate];
    self.notifyViewHasInit = YES;
    NSTimeInterval interval = self.currentTimeValue;
    __weak __typeof(self)weakself = self;
    [SVProgressHUD showWithStatus:nil];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [UserViewModel fetchChallengeInfoDataWithVideoId:self.stage.videoId time:@(self.currentTimeValue) Completion:^(NSError *error, NSNumber *value, NSString *shareUrl) {
        [SVProgressHUD dismiss];
        if (error) {
            [Utility retryAlertWithViewController:weakself.navigationController title:NSLocalizedString(@"获取数据失败", nil) completion:^{
                [weakself finish];
            }];
        } else {
            ChallengeNotifyView *notifyView = [[ChallengeNotifyView alloc] initWithFrame:weakself.view.bounds isExcellent:(interval > weakself.stage.refValue) viewController:weakself shareUrl:(NSString *)shareUrl];
            notifyView.videoId = self.stage.videoId;
            notifyView.time = self.currentTimeValue;
            notifyView.head = self.head;
            weakself.notifyView = notifyView;
            NSString *text;
            if (interval < weakself.stage.refValue) {
                text = weakself.stage.mtWellVideoInfo.videoName;
            } else {
                text = [NSString stringWithFormat:@"%@%@!", NSLocalizedString(@"恭喜你完成了", nil),weakself.stage.mtWellVideoInfo.videoName];
            }
            notifyView.titleLabel.text = text;
            NSString *formattedDuration = [Utility formatTimeSeconds:interval];
            
            notifyView.detailLabel.text = [NSString stringWithFormat:@"共坚持了%@，战胜了%@%%的人", formattedDuration,[value stringValue]];
            notifyView.shareSuccessBlock = ^{
                NSLog(@"分享成功");
            };
            notifyView.click = ^(NSInteger index){
                // 0 为再来一次
                [weakself recordWithTime:interval shouldExit:(index != 0)];
                
                if (index == 0) {
                    weakself.notifyViewHasInit = NO;
                    [weakself play];
                    [UMengUtils careForChallengePlayerRepeat:weakself.stage.mtWellVideoInfo.videoName];
                    
                }
            };
            [Utility viewAddToSuperViewWithAnimation:notifyView superView:weakself.navigationController.view completion:nil];
        }
    }];
    
    
}


-(void)exit
{
    [_timer invalidate];
    [_playerView stop];
    _playerView = nil;
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)recordWithTime:(NSTimeInterval)time shouldExit:(BOOL)flag
{
    __weak __typeof(self) weakSelf = self;
    [UserViewModel recordChallengeVideo:self.stage.videoId sportTimeSeconds:time completion:^(NSError *error, id object) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if(error) {
            
        } else {
            [strongSelf updateSelfChallengeVideoTime:time];
        }
        if (flag) {
            [strongSelf exit];
        }
    }];
}

-(void)updateSelfChallengeVideoTime:(NSTimeInterval)time
{
    WRTreatRehabStage *userStage = self.userStage;
    if (userStage == nil)
    {
        WRTreatRehabStage *obj = [[ShareData data] getStageWithVideoId:self.stage.videoId];
        if (obj)
        {
            NSDictionary *dict = [obj convertDictionary];
            userStage = [[WRTreatRehabStage alloc] initWithDictionary:dict];
            [[ShareUserData userData].challengeVideoArray addObject:userStage];
        }
    }
    BOOL shouldUpdate = NO;
    if (userStage)
    {
        if (userStage.userValue < time) {
            userStage.userValue = time;
            shouldUpdate = YES;
        }
    }
    if (self.completion) {
        self.completion(shouldUpdate);
    }
}

@end

