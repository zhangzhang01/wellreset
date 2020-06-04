//
//  RehabPlayerController.m
//  rehab
//
//  Created by 何寻 on 8/20/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "RehabPlayerController.h"
#import "WRTreat.h"
#import "WRMediaPlayer.h"
#import "SDPhotoBrowser.h"
#import "WRToolView.h"
#import "WRTreat.h"
#import "MBCircularProgressBarView.h"
#import "UIImage+Tint.h"
#import "MZTimerLabel.h"
#import "RehabPlayerPauseView.h"
#import "FCAlertView.h"
#import <AVFoundation/AVFoundation.h>

#define progress_height 8

@interface RehabPlayerController ()
{
    WRMediaPlayer *_playerView;
    CGRect _playViewSmallFrame;
    
    BOOL _isManualRotate;
    BOOL _isFullScreenMode;
    UIInterfaceOrientationMask _supportUIInterfaceOrientation;
    
    NSDate *_startDate;
    
    NSMutableArray *_progressViewArray;
    NSTimer *_timer;
    float _currentVolume;
}

@property(nonatomic)BOOL isFinished, isStarted;

@property(nonatomic, weak) WRTreatRehabStageVideo* video;
@property(nonatomic) NSArray<WRTreatRehabStageVideo *>* videoSets;

@property(nonatomic)UILabel *titleLabel, *detailLabel, *timerLabel, *centerLabel;
@property(nonatomic)MZTimerLabel *totalTimerLabel;
@property(nonatomic)MBCircularProgressBarView *progressBarView;
@property(nonatomic)UIButton *previousButton, *nextButton, *controlButton, *muteButton;
@property(nonatomic)RehabPlayerPauseView *pauseView;

@property (assign) BOOL applicationIdleTimerDisabled, isMaxing;
@property (nonatomic, assign) NSUInteger currentIndex;

@property(nonatomic)NSInteger currentTotalTime, currentTimeValue;

@property(nonatomic)AVAudioPlayer *backgroundMusicPlayer;

@end

@implementation RehabPlayerController

-(void)dealloc {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(instancetype)initWithVideoSets:(NSArray<WRTreatRehabStageVideo *> *)videoSets type:(RehabPlayerControllerType)type {
    if (self = [super init]) {
        self.type = type;
        _startDate = [NSDate date];
        _progressViewArray = [NSMutableArray array];
        
        self.videoSets = videoSets;
        if (videoSets.count > 0) {
            self.video = videoSets.firstObject;
        }
        
        _isManualRotate = NO;
        _isFullScreenMode = NO;
        _supportUIInterfaceOrientation = UIInterfaceOrientationMaskAll;
        
        //方向变化通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [self.view addGestureRecognizer:recognizer];
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
    
    if (!self.titleLabel) {
        self.currentIndex = 0;
        
        if(!self.backgroundMusicPlayer) {
            NSError *error;
            NSURL *backgroundMusicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bg" ofType:@"mp3"]];
            self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
            self.backgroundMusicPlayer.numberOfLoops = -1;
            [self.backgroundMusicPlayer prepareToPlay];
            _currentVolume = self.backgroundMusicPlayer.volume;
        }
        [self.backgroundMusicPlayer play];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [UIApplication sharedApplication].idleTimerDisabled = self.applicationIdleTimerDisabled;
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    return UIDeviceOrientationIsLandscape(orientation);
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
    [self setNeedsStatusBarAppearanceUpdate];
    return YES;
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //NSLog(@"self view frame %@, bounds %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.view.bounds));
    if (self.view.bounds.size.width > self.view.bounds.size.height) {
        _playerView.frame = self.view.bounds;
    } else {
        _playerView.frame = _playViewSmallFrame;
    }
}

#pragma mark - handler
-(IBAction)onClickedArrowButton:(UIButton*)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
        [self alertForExit];
    } else {
        [_playerView.resizeButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

-(IBAction)onClickedPreviousButton:(UIButton*)sender {
    if (self.isStarted) {
        self.currentIndex--;
        [_playerView start];
    }
}

-(IBAction)onClickedNextButton:(UIButton*)sender {
    if (self.isStarted) {
        self.currentIndex++;
        [_playerView start];
    }
}

-(IBAction)onClickedMuteButton:(UIButton*)sender
{
    sender.selected = !sender.selected;
    self.backgroundMusicPlayer.volume = sender.selected ? 0 : _currentVolume;
}

-(void)handleSwipeFrom:(UIGestureRecognizer*)recognizer
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - control functions
-(void)layoutWithStage:(WRTreatRehabStageVideo*)stage {
    BOOL iPad = [WRUIConfig IsHDApp];
    
    UIFont *subTitleFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_labelFont];
    UIFont *bigFont = iPad ? [UIFont wr_bigFont] : [UIFont wr_bigFont];
    
    UIView *container = self.view;
    CGRect frame = container.bounds;
    CGFloat offset = WRUIOffset, x = 0, y, cx = 0, cy = 0;
    
    __weak __typeof(self) weakSelf = self;
    if (!_playerView)
    {
        y = WRStatusBarHeight;
        x = 0;
        cx = frame.size.width - 2*x;
        cy = 9*cx/16;
        WRMediaPlayer *player = [[WRMediaPlayer alloc] initWithFrame:CGRectMake(x, y, cx, cy) style:WRMediaPlayerStyleDefault];
        player.backgroundColor = [UIColor darkGrayColor];
        [player.resizeButton addTarget:self action:@selector(onClickedPlayerResizeButton:) forControlEvents:UIControlEventTouchUpInside];
        [player.backButton addTarget:self action:@selector(onClickedPlayerBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:player];

        _playViewSmallFrame = player.frame;
        _playerView = player;
    }
    
    y = _playerView.bottom + 2*offset;
    cx = frame.size.width*3/4;
    x = (frame.size.width - cx)/2;
    UILabel *label;
    if (!self.titleLabel)
    {
        label = [[UILabel alloc] init];
        label.textColor = [UIColor darkGrayColor];
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.frame = CGRectMake(x, y, cx, 0);
        label.font = subTitleFont;
        label.text = stage.videoName;
        label.textAlignment = NSTextAlignmentCenter;
        CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        label.frame = [Utility resizeRect:label.frame cx:-1 height:size.height];
        [container addSubview:label];
        self.titleLabel = label;
    }
    
    if (!self.muteButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"well_icon_music"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"well_icon_music_off"] forState:UIControlStateSelected];
        [button sizeToFit];
        x = frame.size.width - offset - button.width;
        y = _playerView.bottom + offset;
        button.frame = [Utility moveRect:button.frame x:x y:y];
        [button addTarget:self action:@selector(onClickedMuteButton:) forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:button];
        self.muteButton = button;
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%d/%d %@", (int)self.currentIndex + 1, (int)self.videoSets.count, stage.videoName];
    y = self.titleLabel.bottom + 4*offset;
    
    if (!self.timerLabel)
    {
        x = container.width - self.muteButton.left;
        cx = frame.size.width - 2*x;
        label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.frame = CGRectMake(x, y, cx, 0);
        label.font = bigFont;
        label.text = @"00/00";
        label.textAlignment = NSTextAlignmentCenter;
        CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        label.frame = [Utility resizeRect:label.frame cx:-1 height:size.height];
        [container addSubview:label];
        self.timerLabel = label;
    }
    self.timerLabel.text = @"00/00";
    y = self.timerLabel.bottom + 4*offset;
    
    if (!self.progressBarView)
    {
        cx = 100, cy = cx;
        MBCircularProgressBarView *bar = [[MBCircularProgressBarView alloc] initWithFrame:CGRectMake(0, 0, cx, cy)];
        bar.backgroundColor = [UIColor whiteColor];
        bar.progressAngle = 100;
        bar.progressLineWidth = 3;
        bar.progressStrokeColor = [UIColor wr_themeColor];
        bar.progressColor = bar.progressStrokeColor;
        bar.showValueString = NO;
        [container addSubview:bar];
        bar.center = CGPointMake(frame.size.width/2, y + cy/2);
        self.progressBarView = bar;
        
        UIImage *image = [UIImage imageNamed:@"rehab_player_previous"];
        cx = image.size.width, cy = image.size.height;
        x = bar.left - cx - 2*offset;
        y = bar.centerY - cy/2;
        UIImage *disableImage = [UIImage imageNamed:@"rehab_player_previous_disable"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:disableImage forState:UIControlStateDisabled];
        [button addTarget:self action:@selector(onClickedPreviousButton:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(x, y, cx, cy);
        [container addSubview:button];
        self.previousButton = button;
        
        image = [UIImage imageNamed:@"rehab_player_next"];
        disableImage = [UIImage imageNamed:@"rehab_player_next_disable"];
        x = bar.right + 2*offset;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:disableImage forState:UIControlStateDisabled];
        button.frame = CGRectMake(x, y, cx, cy);
        [button addTarget:self action:@selector(onClickedNextButton:) forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:button];
        self.nextButton = button;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        image = [UIImage imageNamed:@"big_play"];
        [button setImage:image forState:UIControlStateNormal];
        image = [UIImage imageNamed:@"big_pause"];
        [button setImage:image forState:UIControlStateSelected];
        [button sizeToFit];
        button.layer.cornerRadius = button.width/2;
        [container addSubview:button];
        button.center = self.progressBarView.center;
        [button bk_addEventHandler:^(UIButton* sender) {
            if (sender.selected) {
                sender.selected = NO;
                [weakSelf showPauseView];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        self.controlButton = button;
    }
    
    if (!self.centerLabel) {
        cx  = 90;
        cy = cx;
        x = (frame.size.width - cx)/2;
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.center = self.controlButton.center;
//        label.text = [@(_tickCount) stringValue];
        label.font = [UIFont wr_bigTitleFont];
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
            weakSelf.centerLabel.hidden = YES;
        }];
    }
    
    cy = progress_height;
    x = 0;
    y = frame.size.height - cy;
    if (_progressViewArray.count == 0)
    {
        NSInteger count = self.videoSets.count;
        if (count  > 0)
        {
            NSInteger totalTimeSeconds = 0;
            for(NSInteger index = 0; index < count; index++)
            {
                WRTreatRehabStageVideo *obj = self.videoSets[index];
                if(obj.duration == 0)
                {
                    obj.duration = 30;
                }
                totalTimeSeconds += obj.duration ;
            }
            
            CGFloat dis = 2;
            CGFloat totalWidth = frame.size.width - (count - 1)*dis;
            UIImage *progressImage = [Utility createImageWithColor:[UIColor wr_themeColor] size:CGSizeMake(1, cy)];
            UIImage *trackImage = [Utility createImageWithColor:[UIColor lightGrayColor] size:CGSizeMake(1, cy)];
            
            for(NSInteger index = 0; index < count; index++)
            {
                WRTreatRehabStageVideo *obj = self.videoSets[index];
                cx = totalWidth*obj.duration/totalTimeSeconds;
                UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
                CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
                progressView.transform = transform;
                progressView.progressImage = progressImage;
                progressView.trackImage = trackImage;
                [_progressViewArray addObject:progressView];
                [container addSubview:progressView];
                x = progressView.right + dis;
            }
        }
    }
    
    if (!self.totalTimerLabel)
    {
        cy = 30, cx = 75, x = container.width - cx - offset, y -= (cy + 15);
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.textColor = [UIColor lightGrayColor];
        [container addSubview:label];
        
        MZTimerLabel *totalTimerLabel = [[MZTimerLabel alloc] initWithLabel:label];
        self.totalTimerLabel = totalTimerLabel;
        [self.totalTimerLabel start];
    }
    
    [_playerView stop];
    if (_playerView)
    {
        [self.view bringSubviewToFront:_playerView];
        if (![Utility IsEmptyString:stage.videoUrl])
        {
             [_playerView setContent:[NSURL URLWithString:stage.videoUrl] autoStart:NO];
        }
    }
    
    if (self.videoSets.count == 1)
    {
        self.previousButton.hidden = YES;
        self.nextButton.hidden = YES;
    }
}

-(void)showPauseView
{
    __weak __typeof(self) weakSelf = self;
    
    if (!_pauseView) {
        RehabPlayerPauseViewType type = RehabPlayerPauseViewTypeRehab;
        RehabPlayerPauseView *view = [[RehabPlayerPauseView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - progress_height) type:type];
        [view bk_whenTouches:1 tapped:1 handler:^{
            weakSelf.controlButton.selected = YES;
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.pauseView.alpha = 0;
            } completion:^(BOOL finished) {
                weakSelf.pauseView.hidden = YES;
            }];
        }];
        [view.controlButton bk_addEventHandler:^(id sender) {
            weakSelf.controlButton.selected = YES;
            [_playerView start];
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.pauseView.alpha = 0;
            } completion:^(BOOL finished) {
                weakSelf.pauseView.hidden = YES;
            }];
        } forControlEvents:UIControlEventTouchUpInside];
        view.hidden = YES;
        [self.view addSubview:view];
        self.pauseView = view;
    }
    
    [self.pauseView.imageView setImageWithUrlString:self.video.thumbnailUrl holder:@"well_default_video"];
    self.pauseView.titleLabel.text = self.video.videoName;
    
    [self.pauseView show];
    
    [_playerView pause];
}

-(void)setCurrentIndex:(NSUInteger)currentIndex
{
    _currentIndex = currentIndex;
    self.video = self.videoSets[_currentIndex];
    self.currentTotalTime = self.video.duration;
    self.currentTimeValue = 0;
    [self layoutWithStage:self.video];
    
    [self updatePreviousAndNextControl];
    
    for(NSInteger index = 0; index < _progressViewArray.count; index++)
    {
        UIProgressView *progressView = _progressViewArray[index];
        if (index >= _currentIndex) {
            progressView.progress = 0;
        } else {
            progressView.progress = 1;
        }
    }
}

-(void)play
{
    self.isStarted = YES;
    [self updatePreviousAndNextControl];
    
    self.currentTotalTime = self.video.duration;
    if (self.currentTotalTime <= 0)
    {
        if (self.currentTimeValue >= self.currentTotalTime)
        {
            
            if (self.currentIndex < (self.videoSets.count - 1))
            {
                self.currentIndex++;
            }
        }
        
    } else {
        self.currentTimeValue = 0;
        
        self.progressBarView.value = (self.currentTimeValue*100)/self.currentTotalTime;
        
        self.controlButton.selected = YES;
        
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerProc) userInfo:nil repeats:YES];
            [_timer fire];
        }
    }
    [_playerView start];
}

-(void)timerProc
{
    do{
        if (!self.controlButton.selected)
        {
            break;
        }
        
        self.currentTimeValue++;
        if (self.currentTimeValue > self.currentTotalTime)
        {
            if (self.currentIndex < (self.videoSets.count - 1))
            {
                self.currentIndex++;
            }
            else
            {
                self.isFinished = YES;
                self.nextButton.enabled = NO;
                self.previousButton.enabled = NO;
                self.controlButton.enabled = NO;
            }
            return;
        }
        
        [self updateControls];
        
    }while (false);

    /*
    __weak __typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf timerProc];
    });
     */
}

-(void)updateControls
{
    self.timerLabel.text = [NSString stringWithFormat:@"%@/%@", [Utility formatTimeSeconds:self.currentTimeValue],[Utility formatTimeSeconds:self.currentTotalTime]];
    
    UIProgressView *progressView = _progressViewArray[self.currentIndex];
    progressView.progress = ((float)self.currentTimeValue/self.currentTotalTime);
    
    if (self.currentTimeValue == 0) {
        self.progressBarView.value = 0;
    } else {
        [self.progressBarView setValue:(self.currentTimeValue*100)/self.currentTotalTime animateWithDuration:self.currentTimeValue/100];
    }
}

-(void)alertForExit
{
    if (self.isFinished)
    {
        [self.totalTimerLabel pause];
        NSTimeInterval interval = [self.totalTimerLabel getTimeCounted];

        [_playerView stop];
        _pauseView = nil;
        
        [self.backgroundMusicPlayer stop];
        self.backgroundMusicPlayer = nil;
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            if (self.completionBlock)
            {
                self.completionBlock(interval);
            }
        }];
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        
        FCAlertView *alert = [[FCAlertView alloc] init];
        [alert addButton:NSLocalizedString(@"确定", nil) withActionBlock:^{
            weakSelf.isFinished = YES;
            [weakSelf alertForExit];
        }];
        alert.colorScheme = [UIColor wr_themeColor];
        [alert showAlertInView:self withTitle:NSLocalizedString(@"提示", nil) withSubtitle:NSLocalizedString(@"康复运动尚未完成，是否要停止？", nil) withCustomImage:nil withDoneButtonTitle:NSLocalizedString(@"取消", nil) andButtons:nil];
        
        
//        [JCAlertView showTwoButtonsWithTitle:NSLocalizedString(@"提示", nil) Message:NSLocalizedString(@"康复运动尚未完成，是否要停止？", nil) ButtonType:JCAlertViewButtonTypeWarn ButtonTitle:NSLocalizedString(@"确定", nil) Click:^{
//            weakSelf.isFinished = YES;
//            [weakSelf alertForExit];
//        } ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:NSLocalizedString(@"取消", nil) Click:nil];
    }
}

-(void)updatePreviousAndNextControl
{
    self.previousButton.enabled = (self.currentIndex > 0) && (self.videoSets.count > 1) && self.isStarted;
    self.nextButton.enabled = (self.currentIndex < (self.videoSets.count - 1) && (self.videoSets.count > 1))&& self.isStarted;
}

@end
