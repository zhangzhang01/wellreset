//
//  ChallengePlayerController.m
//  rehab
//
//  Created by 何寻 on 8/24/16.
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
#import "WRTreat.h"
#import <AVFoundation/AVFoundation.h>
#import "CWStarRateView.h"
#import "FCAlertView.h"

#define progress_height 8

@interface ChallengePlayerController ()
{
    WRMediaPlayer *_playerView;
    CGRect _playViewSmallFrame;
    
    BOOL _isManualRotate;
    BOOL _isFullScreenMode;
    UIInterfaceOrientationMask _supportUIInterfaceOrientation;
    
    UIStatusBarStyle oldStatusBarStyle;
    
    NSTimer *_timer;
    
    NSInteger _tickCount;
}

@property(nonatomic)BOOL isFinished, pause;

@property(nonatomic, weak) WRTreatRehabStage* stage, *userStage;

@property(nonatomic)UILabel *titleLabel, *detailLabel, *timerLabel, *centerLabel;
@property(nonatomic)UILabel *totalTimerLabel;
@property(nonatomic)UIImageView *checkImageView;

@property (assign) BOOL applicationIdleTimerDisabled, isMaxing;

@property(nonatomic)NSInteger currentTimeValue;

@property(nonatomic)AVAudioPlayer *backgroundMusicPlayer;

@end

@implementation ChallengePlayerController

-(void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(instancetype)initWithStage:(WRTreatRehabStage*)stage {
    if (self = [super init]) {
        _tickCount = 5;
        
        self.stage = stage;
        self.userStage = [[ShareUserData userData] getUserStageByVideoId:self.stage.videoId];
        
        _isManualRotate = NO;
        _isFullScreenMode = NO;
        _supportUIInterfaceOrientation = UIInterfaceOrientationMaskAll;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        /*
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [self.view addGestureRecognizer:recognizer];
         */
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.applicationIdleTimerDisabled = [UIApplication sharedApplication].isIdleTimerDisabled;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    oldStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (!self.titleLabel) {
        [self layoutWithStage:self.stage];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = self.applicationIdleTimerDisabled;
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = oldStatusBarStyle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _supportUIInterfaceOrientation;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

-(BOOL)shouldAutorotate
{
    return YES;
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.view.bounds.size.width > self.view.bounds.size.height)
    {
        _playerView.frame = self.view.bounds;
    }
    else
    {
        _playerView.frame = _playViewSmallFrame;
    }
}

#pragma mark - handler
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
            [UIApplication sharedApplication].statusBarHidden = YES;
            _playerView.frame = [UIScreen mainScreen].bounds;
            _playerView.resizeButton.selected = YES;
        }
        else if (orientation == UIDeviceOrientationPortrait)
        {
            [UIApplication sharedApplication].statusBarHidden = NO;
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
    BOOL iPad = [WRUIConfig IsHDApp];
    
    UIFont *subTitleFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_labelFont];
    UIFont *bigFont = iPad ? [UIFont wr_bigFont] : [UIFont wr_bigFont];
    
    UIView *container = self.view;
    CGRect frame = container.bounds;
    CGFloat offset = WRUIOffset, x = 0, y = x, cx = 0, cy = 0;
    CGSize size;
    
    if (!_playerView)
    {
        x = 0;
        cx = frame.size.width - 2*x;
        cy = 9*cx/16;
        WRMediaPlayer *player = [[WRMediaPlayer alloc] initWithFrame:CGRectMake(x, y, cx, cy) style:WRMediaPlayerStyleDefault];
        player.isLoop = YES;
        player.hideControls = YES;
        player.backgroundColor = [UIColor darkGrayColor];
        [player.resizeButton addTarget:self action:@selector(onClickedPlayerResizeButton:) forControlEvents:UIControlEventTouchUpInside];
        [player.backButton addTarget:self action:@selector(onClickedPlayerBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:player];
        
        _playViewSmallFrame = player.frame;
        _playerView = player;
    }
    
    x = offset;
    y = _playerView.bottom + x;
    cx = (_playerView.width - 2*x)/2;
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
    
    label = [[UILabel alloc] init];
    label.textColor =  self.titleLabel.textColor;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.frame = CGRectMake(x, y, cx, 0);
    label.font = self.titleLabel.font;
    label.textAlignment = NSTextAlignmentRight;
    label.text = [NSString stringWithFormat:@"%@%@%@", NSLocalizedString(@"挑战目标", nil), [@(stage.refValue) stringValue], stage.refUnit];;
    size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = CGRectMake(frame.size.width - offset - size.width, y, size.width, self.titleLabel.height);
    [container addSubview:label];
    y = label.bottom + 3;
    
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
    
    label = [[UILabel alloc] init];
    label.textColor = [UIColor lightGrayColor];
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
    label.textColor = [UIColor lightGrayColor];
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
        
        y = label.bottom + offset;
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
        label.text = @" ";
        label.textAlignment = NSTextAlignmentCenter;
        CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        label.frame = [Utility resizeRect:label.frame cx:-1 height:size.height];
        [container addSubview:label];
        self.timerLabel = label;
    }
    y = self.timerLabel.bottom + 2*offset;
    
    if (!self.centerLabel) {
        UIImage *image = [UIImage imageNamed:@"com_white_gou"];
        cx  = 90;
        cy = cx;
        x = (frame.size.width - cx)/2;
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.text = [@(_tickCount) stringValue];
        label.font = [[UIFont wr_bigFont] fontWithBold];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor wr_themeColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = label.width/2;
        label.layer.masksToBounds = YES;
        label.userInteractionEnabled = YES;
        [container addSubview:label];
        self.centerLabel = label;
        self.centerLabel.text = NSLocalizedString(@"开始", nil);
        __weak __typeof(self) weakSelf = self;
        [self.centerLabel bk_whenTapped:^{
            [weakSelf play];
        }];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.hidden = YES;
        imageView.highlightedImage = [UIImage imageNamed:@"com_white_play"];
        imageView.userInteractionEnabled = YES;
        [container addSubview:imageView];
        imageView.center = label.center;
        self.checkImageView = imageView;
        
        [imageView bk_whenTapped:^{
            if (!weakSelf.pause) {
                [weakSelf finish];
            } else {
                weakSelf.pause = NO;
                [_playerView start];
            }
        }];
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
}

-(void)play
{
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
    //[self.totalTimerLabel reset];
    
    [_timer fire];
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
    
    NSTimeInterval interval = self.currentTimeValue;
    ChallengeNotifyView *notifyView = [[ChallengeNotifyView alloc] initWithFrame:self.view.bounds isExcellent:(interval > self.stage.refValue)];
    
    NSString *text;
    if (interval < self.stage.refValue) {
        text = self.stage.mtWellVideoInfo.videoName;
    } else {
        text = [NSString stringWithFormat:@"%@%@!", NSLocalizedString(@"恭喜你完成了", nil),self.stage.mtWellVideoInfo.videoName];
    }
    notifyView.titleLabel.text = text;
    NSString *formattedDuration = [Utility formatTimeSeconds:interval];
    
    notifyView.detailLabel.text = [NSString stringWithFormat:@"共坚持了%@", formattedDuration];
    __weak __typeof(self) weakSelf = self;
    notifyView.click = ^(NSInteger index){
        // 0 为再来一次
        [weakSelf recordWithTime:interval shouldExit:(index != 0)];
        
        if (index == 0) {
            [weakSelf play];
        }
    };
    [Utility viewAddToSuperViewWithAnimation:notifyView superView:self.view completion:nil];
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

