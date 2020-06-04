//
//  RehabPlayerController.m
//  rehab
//
//  Created by herson on 8/20/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "RehabPlayerController.h"
#import "RehabObject.h"
#import "WRMediaPlayer.h"
#import "SDPhotoBrowser.h"
#import "WRToolView.h"
#import "RehabObject.h"
#import "MBCircularProgressBarView.h"
#import "UIImage+Tint.h"
#import "MZTimerLabel.h"
#import "RehabPlayerPauseView.h"
#import "FCAlertView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ChooseMusicView.h"
#import "ChooseMusicController.h"
#import "NetworkNotifier.h"
#import "JCAlertView.h"
#import "ShareData.h"
#import "ShareUserData.h"
#import "WRDateformatter.h"
#define progress_height 8
#import "UserViewModel.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "RestController.h"
#import "RehabStageView.h"
@interface RehabPlayerController ()
{
    WRMediaPlayer *_playerView;
    CGRect _playViewSmallFrame;
    
    BOOL _isManualRotate;
    BOOL _isFullScreenMode;
    UIInterfaceOrientationMask _supportUIInterfaceOrientation;
    
    NSDate *_startDate;
    
    NSMutableArray *_progressViewArray;
    NSMutableDictionary *_soundIdDict;
    NSTimer *_timer;
    float _currentVolume;
    UIButton *_airplayButtonInMPVolumeView;
    MPVolumeView *_airplayView;
    UIButton *_airplayButton;
    UIButton *_pushVideoButton;
    NSString *_treatName;
    
}

@property(nonatomic)BOOL isFinished, isStarted, isWWAN, isOn;

@property (nonatomic, strong) NetworkNotifier *networkNotifier;

@property(nonatomic, weak) WRTreatRehabStageVideo* video;
@property(nonatomic) NSArray<WRTreatRehabStageVideo *>* videoSets;

@property(nonatomic)UILabel *titleLabel, *detailLabel, *timerLabel, *centerLabel;
@property(nonatomic)MZTimerLabel *totalTimerLabel;
@property(nonatomic)MBCircularProgressBarView *progressBarView;
@property(nonatomic)UIButton *previousButton, *nextButton, *controlButton, *muteButton;
@property(nonatomic)UIImageView *closeImageView;
@property(nonatomic)RehabPlayerPauseView *pauseView;
@property (nonatomic, strong) ChooseMusicView *musicView;

@property (assign) BOOL applicationIdleTimerDisabled, isMaxing;
@property (nonatomic, assign) NSUInteger currentIndex;

@property(nonatomic)NSInteger currentTotalTime, currentTimeValue;

@property(nonatomic)AVAudioPlayer *backgroundMusicPlayer, *soundPlayer;
@property(nonatomic)WRRehabDisease* disease;
@property(nonatomic)UIButton* FullMusic;
@property(nonatomic)UIButton* FullRelease;
@property(nonatomic)UIButton* starBtn;
@property(nonatomic)UILabel* countLabel ,* stageStr;

@property(nonatomic)UIButton* FullShowStage;
@property(nonatomic)UIView* stageView;
@property(nonatomic)MBCircularProgressBarView *fullpro;
@property(nonatomic)UIView* proBac;
@property(nonatomic)CGRect  smPrp;
@property(nonatomic)BOOL canor;
@end

@implementation RehabPlayerController

-(void)dealloc {
  
}
- (BOOL)ifhavedown
{
    NSLog(@"是否已下载、。。。。");
    int i = 0;
    NSMutableArray* arr= [NSMutableArray array];
    arr = [[NSUserDefaults standardUserDefaults]objectForKey:self.rehab.indexId];
    for (NSString* url in  arr) {
        
        
//        NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        // 要检查的文件目录
//        NSString *filePath = url;
        
        NSArray *array = [url componentsSeparatedByString:@"Documents/"];
        //获取沙盒路径 拼接信息生成文件
        NSString *localPath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *newPath = [NSString stringWithFormat:@"%@/%@",localPath2,array[1]];
        
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:newPath]) {
            i++;
        }
        
    }
    
    if (i == arr.count&&arr) {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(instancetype)initWithVideoSets:(NSArray<WRTreatRehabStageVideo *> *)videoSets type:(RehabPlayerControllerType)type treat:(NSString *)treatName{
    if (self = [super init]) {
        __weak __typeof(self)weakself = self;
        self.type = type;
        _treatName = treatName;
        _canor = YES;
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

    }
    return self;
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"alpha"] && object == _airplayButtonInMPVolumeView)
    {
        int alpha = [[change valueForKey:NSKeyValueChangeNewKey] intValue];
        if (alpha == 1) {
            _airplayButton.enabled = YES;
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.applicationIdleTimerDisabled = [UIApplication sharedApplication].isIdleTimerDisabled;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    __weak __typeof(self)weakself = self;
 
    if (![self ifhavedown]) {
        self.networkNotifier = [[NetworkNotifier alloc] initWithController:self];
        self.networkNotifier.continueBlock = ^(NSInteger index){
            if (index == 1) {
                
                [weakself alertForExit];
                
            }
            else
            {
                
            }
        };
    }
    
    
    if (!self.titleLabel) {
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
        topView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:topView];
        /*
         UIColor *gradientStartColor = [UIColor colorWithHexString:@"73bbef"];
         UIColor *gradientEndColor = [UIColor wr_themeColor];
         CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
         gradientLayer.bounds = self.view.bounds;
         gradientLayer.frame = self.view.bounds;
         gradientLayer.colors = @[(id)gradientStartColor.CGColor, (id)gradientEndColor.CGColor];
         gradientLayer.startPoint = CGPointMake(1.0, 1.0);
         gradientLayer.endPoint = CGPointMake(0, 0);
         [self.view.layer insertSublayer:gradientLayer atIndex:0];
         */
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"rehab_player_bg" ofType:@"png"];
        //UIImage *bgImage = [UIImage imageWithContentsOfFile:path];
        //self.view.layer.contents = (id)bgImage.CGImage;
        
//        UIColor *gradientStartColor = [UIColor colorWithHexString:@"73bbef"];
        UIColor *gradientStartColor = [UIColor whiteColor];
        UIColor *gradientEndColor = [UIColor whiteColor];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
        gradientLayer.bounds = self.view.bounds;
        gradientLayer.frame = self.view.bounds;
        gradientLayer.colors = @[(id)gradientStartColor.CGColor, (id)gradientEndColor.CGColor];
        gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        [self.view.layer insertSublayer:gradientLayer atIndex:0];
        
        if (!_closeImageView) {
            __weak __typeof(self) weakSelf = self;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_close"]];
            CGFloat height = 20;
            if (IPHONE_X) {
                height=30;
            }
            imageView.frame = [Utility moveRect:imageView.frame x:-1 y:height];
            imageView.userInteractionEnabled = YES;
            imageView.hidden = YES;
            [self.view addSubview:imageView];
            self.closeImageView = imageView;
            [imageView bk_whenTapped:^{
                [weakSelf alertForExit];
            }];
        }
        
        [self.view bringSubviewToFront:self.closeImageView];
        
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
            _currentVolume = self.backgroundMusicPlayer.volume;
            
        }
        [self.backgroundMusicPlayer play];
        
        self.currentIndex = 0;
    }
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self orientationChange:nil];
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
    return NO;
}


-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return _supportUIInterfaceOrientation;
}

//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}

-(BOOL)shouldAutorotate
{
    if (_pauseView && _pauseView.hidden == NO) {
        return NO;
    } else if (_musicView && _musicView.hidden == NO){
        return NO;
    } else {
        [self setNeedsStatusBarAppearanceUpdate];
        return YES;
    }
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    BOOL isFullScreen = (self.view.bounds.size.width > self.view.bounds.size.height);
    _playerView.frame = isFullScreen ? self.view.bounds : _playViewSmallFrame;
    self.closeImageView.hidden = isFullScreen;
    _playerView.backButton.hidden = !isFullScreen;
    _playerView.disableOnTouch = !isFullScreen;
    
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
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonClickedAction:) object:sender];
        [self performSelector:@selector(buttonClickedAction:) withObject:sender afterDelay:1.0];
        
      
    }
}
-(void)buttonClickedAction:(UIButton *)button
{
    self.currentIndex--;
    [_playerView start];
}
-(IBAction)onClickedNextButton:(UIButton*)sender {
    if (self.isStarted) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonClickedAction2:) object:sender];
        [self performSelector:@selector(buttonClickedAction2:) withObject:sender afterDelay:1.0];
     
    }
}
-(void)buttonClickedAction2:(UIButton *)button
{
    self.currentIndex++;
    [_playerView start];
}
-(IBAction)onClickedMuteButton:(UIButton*)sender
{
    
    //    sender.selected = !sender.selected;
    
    [self showMusicView];
    //    ChooseMusicController *musicController = [[ChooseMusicController alloc] init];
    //    [self presentViewController:musicController animated:YES completion:nil];
}

- (void)showMusicView
{
    __weak __typeof(self)weakself = self;
    
    if (!_musicView) {
        ChooseMusicView *musicView = [[ChooseMusicView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        __weak __typeof(musicView)weakView = musicView;
        self.isOn = musicView.isOn;
        [self.view addSubview:musicView];
        
        [musicView.switchControl addBlockForControlEvents:UIControlEventValueChanged block:^(id  _Nonnull sender) {
            UISwitch *control = sender;
            
            self.isOn = control.on;
            
            weakView.switchLabel.text = control.on?NSLocalizedString(@"背景音乐已打开", nil):NSLocalizedString(@"背景音乐已关闭", nil);
            weakView.musicListView.hidden = control.on?NO:YES;
            weakself.backgroundMusicPlayer.volume = !control.on ? 0 : _currentVolume;
        }];
        musicView.clickedMusicBlock = ^(UIButton *button, NSString *fileName){
            NSString *name = [button titleForState:UIControlStateNormal];
            [UMengUtils careForRehabBgmusic:name];
            if (weakself.backgroundMusicPlayer) {
                [weakself.backgroundMusicPlayer stop];
                weakself.backgroundMusicPlayer = nil;
            }
            NSError *error;
//            NSString *musicName = [button titleForState:UIControlStateNormal];
            //            NSString *musicName =@"bg";
            NSURL *backgroundMusicURL;
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = @"backgroundMusicName";
            if (button.tag == 0) {
                backgroundMusicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bg" ofType:@"mp3"]];
                [ud setObject:@"bg" forKey:key];
            } else {
                [ud setObject:fileName forKey:key];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *docDir = [paths objectAtIndex:0];
//                NSString *path = [[docDir stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"mp3"];
                NSString *path = [docDir stringByAppendingPathComponent:fileName];
                backgroundMusicURL = [NSURL fileURLWithPath:path];
            }
            weakself.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
            weakself.backgroundMusicPlayer.numberOfLoops = -1;
            [weakself.backgroundMusicPlayer prepareToPlay];
//            _currentVolume = weakself.backgroundMusicPlayer.volume;
            weakself.backgroundMusicPlayer.volume = !weakself.isOn ? 0 : _currentVolume;
            [weakself.backgroundMusicPlayer play];
        };
        
        [musicView.closeImageView bk_whenTapped:^{
            [UIView animateWithDuration:0.25 animations:^{
                weakself.musicView.alpha = 0;
            } completion:^(BOOL finished) {
                weakself.muteButton.selected = !weakself.musicView.switchControl.on;
                weakself.musicView.hidden = YES;
            }];
        }];
        self.musicView = musicView;
    }
    self.musicView.switchControl.on = self.isOn;
    [self.musicView show];
}

-(IBAction)onClickedAirplayButton:(UIButton*)sender
{
    //[UMengUtils careForRehabAirplay:_treatName];
    //[_airplayButtonInMPVolumeView sendActionsForControlEvents:UIControlEventTouchUpInside];
   // self.networkNotifier = [[NetworkNotifier alloc] initWithController:self];
    NSMutableArray* list = [NSMutableArray array];
    for (NSString* index in self.rehab.stageSetCounts) {
        [list addObject:self.rehab.stageSet[index.intValue]];
    }
   
    WRTreatRehabStage *stage = list[self.currentIndex];
    UIView *rootView = [UIApplication sharedApplication].keyWindow;
    RehabStageView *stageView = [[RehabStageView alloc] initWithFrame:rootView.bounds treatRehabStage:stage stageSets:list isProTreat:[self.rehab.disease isProTreat] isplaying:YES];
    stageView.frame = CGRectOffset(stageView.frame, 0, rootView.height);
    stageView.isPlaying = YES;
    [_playerView pause];
    __weak __typeof(stageView) weakStageView = stageView;
    stageView.closeEvent = ^(RehabStageView* sender) {
        [UIView animateWithDuration:0.2 animations:^{
            weakStageView.frame = [Utility moveRect:weakStageView.frame x:-1 y:rootView.height];
        } completion:^(BOOL finished) {
            [weakStageView removeFromSuperview];
            if (self.isStarted) {
                [_playerView start];
            }
            
            self.canor = YES;
          //  self.networkNotifier = nil;
            
        }];
    };
    
    [rootView addSubview:stageView];
                [UIView animateWithDuration:0.35 animations:^{
                    stageView.frame = [Utility moveRect:stageView.frame x:-1 y:0];
                } completion:^(BOOL finished) {
                    sender.userInteractionEnabled = YES;
                }];
    
//    self.networkNotifier = [[NetworkNotifier alloc] initWithController:self];
//    __weak __typeof(self)weakself = self;
//
//    self.networkNotifier.continueBlock = ^(NSInteger index){
//        if (index == 0) {
//
//           [rootView addSubview:stageView];
//            [UIView animateWithDuration:0.35 animations:^{
//                stageView.frame = [Utility moveRect:stageView.frame x:-1 y:0];
//            } completion:^(BOOL finished) {
//                sender.userInteractionEnabled = YES;
//            }];
//
//        }
//        else
//        {
//            weakself.networkNotifier =nil;
//        }
//    };
    
    
    
    
    //锚点
    if (self.disease.isProTreat) {
        NSDate *now = [NSDate date];
        int duration = (int)[now timeIntervalSinceDate:_startDate];
        [MobClick event:[NSString stringWithFormat:@"%@dzlb",self.umstr] attributes:nil counter:duration];    }else
        {
            //锚点
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"%@dzlb",self.umstr] attributes:nil counter:duration];
        }


    
    
    
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
        if ((orientation == UIDeviceOrientationLandscapeRight ||orientation == UIDeviceOrientationLandscapeLeft))
        {
            self.isMaxing = YES;
            [UIApplication sharedApplication].statusBarHidden = YES;
            _playerView.frame = [UIScreen mainScreen].bounds;
            _playerView.resizeButton.selected = YES;
            _playerView.hideControls = YES;
            if (!self.FullRelease) {
                UIButton* btn = [UIButton new];
                btn.width = btn.height = 30;
                if (IPHONE_X) {
                     btn.right = self.view.width - 35;
                }else{
                     btn.right = self.view.width - 15;
                    
                }
               
                btn.bottom = self.view.height - 35;
                [btn setImage:[UIImage imageNamed:@"关闭全屏按钮"] forState:0];
                [self.view addSubview:btn];
                [btn bk_whenTapped:^{
                    [self onClickedPlayerResizeButton:btn];
                }];
                self.FullRelease = btn;
            }
            self.FullRelease.hidden = NO;
            
            [self.view bringSubviewToFront:self.FullRelease];
            if (!self.FullMusic) {
             
                UIButton* btn = [UIButton new];
                btn.width = btn.height = 30;
                if (IPHONE_X) {
                    btn.right = self.view.width - 35;
                }else{
                    btn.right = self.view.width - 15;
                    
                }
                
                btn.bottom = self.view.height - 86;
                [btn setImage:[UIImage imageNamed:@"音乐播放"] forState:0];
                [self.view addSubview:btn];
                [btn bk_whenTapped:^{
                    if([btn.imageView.image isEqual:[UIImage imageNamed:@"音乐播放"]])
                    {
                        self.isOn = NO;
                    self.backgroundMusicPlayer.volume = !self.isOn ? 0 : _currentVolume;
                        [btn setImage:[UIImage imageNamed:@"音乐关闭"] forState:0];
                    }
                    else
                    {
                        self.isOn = YES;
                        self.backgroundMusicPlayer.volume = !self.isOn ? 0 : _currentVolume;
                        [btn setImage:[UIImage imageNamed:@"音乐播放"] forState:0];
                    }
                }];
                
                self.FullMusic = btn;
            }
            self.FullMusic.hidden = NO;
            [self.view bringSubviewToFront:self.FullMusic];
        
            if (!self.stageView) {
                UIView* v = [UIView new];
                v.width = 254;
                v.height = 40;
                v.centerX = self.view.width*1.0/2;
                v.bottom = self.view.height - 4;
                v.layer.cornerRadius = 4;
                v.backgroundColor = [[UIColor colorWithHexString:@"454545"] colorWithAlphaComponent:0.5];
                [self.view addSubview:v];
                
                self.stageView = v;
                
                UILabel* stageL = [UILabel new];
                stageL.text = [NSString stringWithFormat:@"%ld/%ld  %@",self.currentIndex,self.videoSets.count,self.video.videoName];
                stageL.font = [UIFont systemFontOfSize:15];
                stageL.textColor = [UIColor whiteColor];
                stageL.x = 28;
                [stageL  sizeToFit];
                stageL.centerY = v.height*1.0/2-4;
                [v addSubview:stageL];
                self.stageStr = stageL;
                
                UIButton* btn = [UIButton new];
                btn.width = btn.height = 20;
                btn.right = v.width - 28;
                btn.centerY = v.height*1.0/2-4;
                [btn setImage:[UIImage imageNamed:@"视频详细信息-（全屏）"] forState:0];
                [btn bk_whenTapped:^{
                    [self onClickedAirplayButton:btn];
                }];
                [v addSubview:btn];
                self.FullShowStage = btn;
            }
            self.stageView.hidden = NO;
            self.stageStr.text = [NSString stringWithFormat:@"%ld/%ld  %@",self.currentIndex+1,self.videoSets.count,self.video.videoName];
            [self.view bringSubviewToFront:self.stageView];
            
            if (!self.starBtn) {
                UIButton* btn = [UIButton new];
                btn.width = btn.height = 64;
                btn.x = 43;
                btn.bottom = self.view.height - 20;
                btn.layer.cornerRadius = 22.5;
                [btn setImage:[UIImage imageNamed:@"全屏播放按钮-1"] forState:0];
                [self.view addSubview:btn];
                [btn bk_whenTapped:^{
                    [self showPauseView];
                }];
                self.starBtn = btn;
                
                //横屏后的播放按钮
                MBCircularProgressBarView *bar = [[MBCircularProgressBarView alloc] initWithFrame:CGRectMake(0, 0, 67, 67)];
                bar.backgroundColor = [UIColor clearColor];
                bar.progressAngle = 100;

                bar.progressLineWidth = 3;
                bar.progressStrokeColor = [UIColor wr_themeColor];
                bar.progressColor = bar.progressStrokeColor;
                bar.showValueString = NO;
                [bar setEmptyLineColor:[UIColor wr_lightGray]];
                [self.view addSubview:bar];
                bar.center = btn.center;
                self.fullpro = bar;
                
                UILabel* countL = [UILabel new];
                countL.text = [NSString stringWithFormat:@"%@/%@", [Utility formatTimeSeconds:self.currentTimeValue],[Utility formatTimeSeconds:self.currentTotalTime]];
                countL.textAlignment = NSTextAlignmentCenter;
                countL.font = [UIFont systemFontOfSize:18];
                countL.textColor = [UIColor colorWithHexString:@"959595"];
                countL.bottom = btn.y -20;
                [countL sizeToFit];
                [self.view addSubview:countL];
                countL.centerX = btn.centerX;
                self.countLabel = countL;
            }
           
            self.starBtn.hidden = NO;
            self.fullpro.hidden = NO;
            [self.view bringSubviewToFront:self.fullpro];
            self.countLabel.hidden = NO;
            self.countLabel.text = [NSString stringWithFormat:@"%@/%@", [Utility formatTimeSeconds:self.currentTimeValue],[Utility formatTimeSeconds:self.currentTotalTime]];
            [self.view bringSubviewToFront:self.countLabel];
            [self.view bringSubviewToFront:self.starBtn];
            
            
            if (self.proBac.y == self.smPrp.origin.y) {
                self.proBac.x = 0;
                self.proBac.y = 0;
                CGFloat k = kScreenHeight*1.0/kScreenWidth;
                self.proBac.transform = CGAffineTransformMakeScale(k, 1);
                self.proBac.x = 0;
                self.proBac.y = 0;
            }
            [self.view bringSubviewToFront:self.proBac];
            
            
            
        }
        else if (orientation == UIDeviceOrientationPortrait)
        {
            [UIApplication sharedApplication].statusBarHidden = NO;
            _playerView.frame = _playViewSmallFrame;
            _playerView.resizeButton.selected = NO;
            _playerView.hideControls = NO;
            
            self.starBtn.hidden = YES;
            self.fullpro.hidden = YES;
            self.countLabel.hidden = YES;
            self.stageView.hidden = YES;
            self.FullMusic.hidden = YES;
            self.FullRelease.hidden = YES;
            if (self.proBac.y != self.smPrp.origin.y) {
                CGFloat k = kScreenWidth*1.0/kScreenHeight;
                self.proBac.transform = CGAffineTransformMakeScale(k, 1);
                CGFloat offset = WRUIOffset, x = 0, y, cx = 0, cy = 0;
                cy = progress_height;
                if (IPHONE_X) {
                    cy = progress_height + 20;
                }
                y = SCREEN_HEIGHT - cy;
                self.proBac.frame = CGRectMake(0, y, ScreenW, cy);
                self.proBac.frame = self.smPrp;
            }
            
            
            
        }
        else if (orientation == UIDeviceOrientationUnknown)
        {
            if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
            {
                [UIApplication sharedApplication].statusBarHidden = NO;
                _playerView.frame = _playViewSmallFrame;
                _playerView.resizeButton.selected = NO;
                _playerView.hideControls = NO;
                
                self.starBtn.hidden = YES;
                self.fullpro.hidden = YES;
                self.countLabel.hidden = YES;
                self.stageView.hidden = YES;
                self.FullMusic.hidden = YES;
                self.FullRelease.hidden = YES;
                if (self.proBac.y != self.smPrp.origin.y) {
                    CGFloat k = kScreenWidth*1.0/kScreenHeight;
                    self.proBac.transform = CGAffineTransformMakeScale(k, 1);
                    self.proBac.frame = self.smPrp;
                }
            }
        }
        else if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationPortraitUpsideDown) {
            return;
        }
    }
}

#pragma mark - layout functions
-(void)layoutWithStage:(WRTreatRehabStageVideo*)stage {
    BOOL iPad = [WRUIConfig IsHDApp];
    
    
    UIFont *subTitleFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_labelFont];
    UIFont *bigFont = iPad ? [UIFont wr_bigFont] : [UIFont wr_bigFont];
    
    UIView *container = self.view;
    CGRect frame = container.bounds;
    CGFloat offset = WRUIOffset, x = 0, y, cx = 0, cy = 0;
    
    __weak __typeof(self) weakSelf = self;
    BOOL flag = NO;
    if (!_playerView)
    {
        flag = YES;
        y = WRStatusBarHeight;
        if (IPHONE_X) {
            y =WRStatusBarHeight+10;
        }
        x = 0;
        cx = frame.size.width - 2*x;
        cy = 9*cx/16;
        
        WRMediaPlayer *player = [[WRMediaPlayer alloc] initWithFrame:CGRectMake(x, y, cx, cy) style:WRMediaPlayerStyleDefault];
        player.stateButton.hidden = YES;
        player.videoSlider.hidden = YES;
        player.timeLabel.hidden = YES;
        player.videoProgress.hidden = YES;
        player.backgroundColor = [UIColor darkGrayColor];
        [player.resizeButton addTarget:self action:@selector(onClickedPlayerResizeButton:) forControlEvents:UIControlEventTouchUpInside];
        [player.backButton addTarget:self action:@selector(onClickedPlayerBackButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:player];
        
        _playViewSmallFrame = player.frame;
        _playerView = player;
    }
    
    if (!_airplayView) {
        NSArray *imageArray = @[@"视频详细信息"];
        NSArray *focusImageArray = @[@"视频详细信息"];
        NSArray *disableImageArray = @[ @"视频详细信息"];
        
        y = _playerView.bottom + offset;
        UIImage* image = PNG_IMAGE_NAMED(imageArray.firstObject);
        cx = image.size.width, cy = image.size.height, x = WRUIOffset, offset = 1;
        
        for (NSUInteger index = 0; index < imageArray.count; index++)
        {
            UIButton* button = nil;
            if(index == 0)
            {
                CGRect rcControl  = CGRectMake(-7, y, cx, cy);
                MPVolumeView *airplayCtrl = [[MPVolumeView alloc] initWithFrame:rcControl];
                [airplayCtrl setShowsVolumeSlider:NO];
                for (UIView *view in airplayCtrl.subviews)
                {
                    if ([view isKindOfClass:[UIButton class]])
                    {
                        button = (UIButton*)view;
                        button.showsTouchWhenHighlighted = NO;
                        [button setImage:PNG_IMAGE_NAMED([disableImageArray objectAtIndex:index]) forState:UIControlStateDisabled];
                        [button setImage:PNG_IMAGE_NAMED([imageArray objectAtIndex:index]) forState:UIControlStateNormal];
                        [button setImage:PNG_IMAGE_NAMED([focusImageArray objectAtIndex:index]) forState:UIControlStateHighlighted];
                        [button setImage:PNG_IMAGE_NAMED([focusImageArray objectAtIndex:index]) forState:UIControlStateSelected];
                        button.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
                        [button addObserver:self forKeyPath:@"alpha" options:NSKeyValueObservingOptionNew context:nil];
                        button.enabled = NO;
                        _airplayButtonInMPVolumeView = button;
                        break;
                    }
                }
                [airplayCtrl sizeToFit];
                airplayCtrl.hidden = YES;
                [self.view addSubview:airplayCtrl];
                _airplayView = airplayCtrl;
            }
            
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x, y, cx, cy);
            button.backgroundColor = [UIColor clearColor];
            button.tag = index;
            [button setImage:PNG_IMAGE_NAMED([imageArray objectAtIndex:index]) forState:UIControlStateNormal];
            [button setImage:PNG_IMAGE_NAMED([focusImageArray objectAtIndex:index]) forState:UIControlStateSelected];
            [button setImage:PNG_IMAGE_NAMED([disableImageArray objectAtIndex:index]) forState:UIControlStateDisabled];
            if(index == 0)
            {
                _airplayButton = button;
                [button addTarget:self action:@selector(onClickedAirplayButton:) forControlEvents:UIControlEventTouchUpInside];
            }
            else if(index == 1)
            {
                _pushVideoButton = button;
            }
            [self.view addSubview:button];
            y += (cy + offset);
        }
    }
    
    UILabel *label;
    if (!self.titleLabel)
    {
        offset = WRUIOffset;
        y = _playerView.bottom + 2*offset;
        cx = frame.size.width*3/4;
        x = (frame.size.width - cx)/2;
        
        label = [[UILabel alloc] init];
        label.textColor = [UIColor blackColor];
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.frame = CGRectMake(x, y, cx, 0);
        label.font = [subTitleFont fontWithBold];;
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
    
    if (!self.timerLabel)
    {
        y = self.titleLabel.bottom + 4*offset;
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
    
    y = self.timerLabel.bottom + 4*offset;
    
    if (!self.progressBarView)
    {
        cx = 100, cy = cx;
        MBCircularProgressBarView *bar = [[MBCircularProgressBarView alloc] initWithFrame:CGRectMake(0, 0, cx, cy)];
        bar.backgroundColor = [UIColor clearColor];
        bar.progressAngle = 100;
        bar.progressLineWidth = 3;
        bar.progressStrokeColor = [UIColor orangeColor];
        bar.progressColor = bar.progressStrokeColor;
        bar.showValueString = NO;
        [bar setEmptyLineColor:[UIColor wr_lightGray]];
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
        button.hidden = NO;
        [container addSubview:button];
        button.center = self.progressBarView.center;
        [button bk_addEventHandler:^(UIButton* sender) {
            if (sender.selected) {
                sender.selected = NO;
                [weakSelf showPauseView];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        self.controlButton = button;
        
        UIView *view = [[UIView alloc] initWithFrame:button.frame];
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = view.width/2;
        view.backgroundColor = [UIColor whiteColor];
        [container insertSubview:view belowSubview:button];
    }
    
    if (!self.centerLabel) {
        cx  = 90;
        cy = cx;
        x = (frame.size.width - cx)/2;
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.center = self.controlButton.center;
        //        label.text = [@(_tickCount) stringValue];
        label.font = [UIFont wr_bigTitleFont];
        label.textColor = [UIColor lightGrayColor];
        label.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = label.width/2;
        label.layer.masksToBounds = YES;
        label.userInteractionEnabled = YES;
        [container addSubview:label];
        self.centerLabel = label;
        self.centerLabel.text = NSLocalizedString(@"", nil);
        __weak __typeof(self) weakSelf = self;
        [self.centerLabel bk_whenTapped:^{
            [UMengUtils careForRehabEnd:_treatName];
            if(!self.isStarted)
            {
            [weakSelf play];
            self.controlButton.hidden = NO;
            weakSelf.centerLabel.hidden = YES;
            [weakSelf.totalTimerLabel start];
            }
        }];
    }
    
    cy = progress_height;
    if (IPHONE_X) {
        cy = progress_height + 20;
    }
    
    
    
    x = 0;
    y = frame.size.height - cy;
    if (!self.proBac) {
        UIView* pro = [[UIView alloc]initWithFrame:CGRectMake(0, y, ScreenW, cy)];
        [self.view addSubview:pro];
        self.proBac = pro;
        self.smPrp = self.proBac.frame;
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
                UIImage *progressImage = [Utility createImageWithColor:[UIColor orangeColor] size:CGSizeMake(1, cy)];
                UIImage *trackImage = [Utility createImageWithColor:[UIColor wr_lightGray] size:CGSizeMake(1, cy)];
                
                for(NSInteger index = 0; index < count; index++)
                {
                    WRTreatRehabStageVideo *obj = self.videoSets[index];
                    cx = totalWidth*obj.duration/totalTimeSeconds;
                    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(x, 0, cx, cy)];
                    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
                    progressView.transform = transform;
                    progressView.progressImage = progressImage;
                    progressView.trackImage = trackImage;
                    [_progressViewArray addObject:progressView];
                    [pro addSubview:progressView];
                    x = progressView.right + dis;
                }
            }
        }

    }
    
    if (!self.totalTimerLabel)
    {
        cy = 30, cx = 75, x = container.width - cx - offset, y -= (cy + 15);
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.textColor = [UIColor grayColor];
        [container addSubview:label];
        
        MZTimerLabel *totalTimerLabel = [[MZTimerLabel alloc] initWithLabel:label];
        self.totalTimerLabel = totalTimerLabel;
        //        [self.totalTimerLabel start];
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%d/%d %@", (int)self.currentIndex + 1, (int)self.videoSets.count, stage.videoName];
    self.timerLabel.text = @"00/00";
    
    if (_playerView)
    {
        [_playerView stop];
        if (flag) {
            [self.view bringSubviewToFront:_playerView];
            [self.view bringSubviewToFront:self.closeImageView];
        }
        [_playerView hideControls];
 
        if (![Utility IsEmptyString:stage.videoUrl])
        {
            
            
            
            NSMutableArray* arr= [NSMutableArray array];
            arr = [[NSUserDefaults standardUserDefaults]objectForKey:self.rehab.indexId];
            if (!arr) {
                NSLog(@"????????%@",stage.videoUrl);
                [_playerView setContent:[NSURL URLWithString: stage.videoUrl] autoStart:NO];
                
                
            }else
            {
                NSLog(@"=-=-=-=-=%@",stage.videoUrl);
                int i = 0;
                for (NSString* url in  arr) {
                    
//
//                    NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//                    // 要检查的文件目录
//                    NSString *filePath = url;
//                    NSFileManager *fileManager = [NSFileManager defaultManager];
//                    if ([fileManager fileExistsAtPath:filePath]) {
//                        i++;
//                    }
                    
                    
                    NSArray *array = [stage.videoUrl componentsSeparatedByString:@"Documents/"];
                    //获取沙盒路径 拼接信息生成文件
                    NSString *localPath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    NSString *newPath = [NSString stringWithFormat:@"%@/%@",localPath2,array[1]];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    if ([fileManager fileExistsAtPath:newPath]) {
                        i++;
                    }
                    
                    
                    
                }
                
                if (i == arr.count) {
                    
                    NSArray *array = [stage.videoUrl componentsSeparatedByString:@"Documents/"];
                    //获取沙盒路径 拼接信息生成文件
                    NSString *localPath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
                    NSString *newPath = [NSString stringWithFormat:@"%@/%@",localPath2,array[1]];
                    [_playerView setContent:[NSURL fileURLWithPath: newPath] autoStart:NO];
                    
                    
                    
                    
                    
                    
                }
                else
                {
                    [_playerView setContent:[NSURL URLWithString: stage.videoUrl] autoStart:NO];
                }
                
                
            }
            
            
        


            
            
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
//    __weak __typeof(self) weakSelf = self;
//    
//    if (!_pauseView) {
//        RehabPlayerPauseViewType type = RehabPlayerPauseViewTypeRehab;
//        RehabPlayerPauseView *view = [[RehabPlayerPauseView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - progress_height) type:type];
//        //        [view bk_whenTouches:1 tapped:1 handler:^{
//        //            weakSelf.controlButton.selected = YES;
//        //            [UIView animateWithDuration:0.25 animations:^{
//        //                weakSelf.pauseView.alpha = 0;
//        //            } completion:^(BOOL finished) {
//        //                weakSelf.pauseView.hidden = YES;
//        //            }];
//        //        }];
//        [view.controlButton bk_addEventHandler:^(id sender) {
//            weakSelf.controlButton.selected = YES;
//            [_playerView start];
//            [UIView animateWithDuration:0.25 animations:^{
//                weakSelf.pauseView.alpha = 0;
//            } completion:^(BOOL finished) {
//                weakSelf.pauseView.hidden = YES;
//            }];
//        } forControlEvents:UIControlEventTouchUpInside];
//        view.hidden = YES;
//        [self.view addSubview:view];
//        self.pauseView = view;
//    }
//    
//    [self.pauseView.imageView setImageWithUrlString:self.video.thumbnailUrl holder:@"well_default_video"];
//    self.pauseView.titleLabel.text = self.video.videoName;
//    
//    [self.pauseView show];
    
    
    
    
    RestController* rest = [RestController new];
    rest.nextIm  = self.video.thumbnailUrl;
    rest.nextStr = self.video.videoName;
    rest.Ifpause = YES;
    self.canor = NO;
    rest.completionBlock = ^{
        self.controlButton.selected = YES;
        
        if (!self.isStarted) {
            [self play];
            self.controlButton.hidden = NO;
            self.centerLabel.hidden = YES;
            [self.totalTimerLabel start];
        }
        
        [_playerView start];
        self.canor = YES;
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        
    };
    [self presentViewController:rest animated:YES completion:nil];
    [_playerView pause];
    
}

#pragma mark - getter & setter
-(void)setCurrentIndex:(NSUInteger)currentIndex
{
    if (self.isStarted) {
        if (currentIndex > 0) {
            [self playSound:@"next"];
        }
        else
        {
            [self playSound:@"begin"];
        }
    }
    if (currentIndex<self.videoSets.count) {
        
        
        
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
   }

#pragma mark -
-(void)repeatVideos:(NSArray*)videos withTime:(NSInteger)times
{
   
//        self.index ++;
//        NSInteger num = [[RootTableViewManager shareManager] getDataArrayCount];
//        // 当时最后一首的时候 跳到最前面
//        if (self.index > num) {
//            self.index = 0;
//        }
//        [self Valuation];
//        
    
}


-(void)play
{
    __weak __typeof(self)weakself = self;
    if (self.isWWAN) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"使用移动网络在线播放视频可能会消耗大量数据流量", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"继续", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.isWWAN = NO;
            [weakself play];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
        if (IPAD_DEVICE) {
            alert.popoverPresentationController.sourceView = self.view;
            alert.popoverPresentationController.sourceRect = self.view.bounds;
        }
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
    
    
        self.isStarted = YES;
        self.currentTotalTime = self.video.duration;
        [self updatePreviousAndNextControl];
        if (self.currentTotalTime <= 0)
        {
            if (self.currentTimeValue >= self.currentTotalTime)
            {
                
                if (self.currentIndex < (self.videoSets.count - 1))
                {
                    self.currentIndex++;
                    [_playerView start];
                    
                }
                else
                {
                    self.currentIndex = 0;
                    [_playerView start];
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
        [self playSound:@"begin"];
        [_playerView start];
    }

}
static int re ;
static int nowStateIndex;
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
                RestController* rest = [RestController new];
                WRTreatRehabStageVideo* video = self.videoSets[++self.currentIndex];
                rest.nextIm  = video.thumbnailUrl;
                rest.nextStr = video.videoName;
                [_timer setFireDate:[NSDate distantFuture]];
                rest.completionBlock = ^{
                    
                    
                    [_timer setFireDate:[NSDate date]];
                    [_playerView start];
                    self.canor = YES;
                    [self interfaceOrientation:UIInterfaceOrientationPortrait];
                };
                self.canor = NO;
                [self presentViewController:rest animated:YES completion:nil];
            }
            else
            {
                self.isFinished = YES;
                self.nextButton.enabled = NO;
                self.previousButton.enabled = NO;
                self.controlButton.enabled = NO;
                
                [_timer invalidate];
                _timer = nil;
                
                [self playSound:@"finish"];
                [self finish];
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
    self.countLabel.text = [NSString stringWithFormat:@"%@/%@", [Utility formatTimeSeconds:self.currentTimeValue],[Utility formatTimeSeconds:self.currentTotalTime]];
    [self.countLabel sizeToFit];
    UIProgressView *progressView = _progressViewArray[self.currentIndex];
    progressView.progress = ((float)self.currentTimeValue/self.currentTotalTime);
    
    if (self.currentTimeValue == 0) {
        self.progressBarView.value = 0;
        self.fullpro.value = 0;
    } else {
        [self.progressBarView setValue:(self.currentTimeValue*100)/self.currentTotalTime animateWithDuration:self.currentTimeValue/100];
        [self.fullpro setValue:(self.currentTimeValue*100)/self.currentTotalTime animateWithDuration:self.currentTimeValue/100];
        
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
        [self.soundPlayer stop];
        self.soundPlayer = nil;
        
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager stopMonitoring];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [_airplayButtonInMPVolumeView removeObserver:self forKeyPath:@"alpha"];
        NSDate *now = [NSDate date];
        int duration = (int)[now timeIntervalSinceDate:_startDate];
        [UMengUtils careForRehabExercise:_treatName duration:duration];
        
        [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
            NSLog(@"999988888");
            if (self.disease) {
                self.completionwithdieaseBlock(interval,self.disease);
            }
            else if (self.completionBlock)
            {
                self.completionBlock(interval);
            }
        }];
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        
        /*
         FCAlertView *alert = [[FCAlertView alloc] init];
         [alert addButton:NSLocalizedString(@"确定", nil) withActionBlock:^{
         weakSelf.isFinished = YES;
         [weakSelf alertForExit];
         }];
         alert.colorScheme = [UIColor wr_themeColor];
         [alert showAlertInView:self withTitle:NSLocalizedString(@"提示", nil) withSubtitle:NSLocalizedString(@"康复运动尚未完成，是否要停止？", nil) withCustomImage:nil withDoneButtonTitle:NSLocalizedString(@"取消", nil) andButtons:nil];
         */
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"康复运动尚未完成不会加入锻炼记录，是否要停止？", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
//            weakSelf.isFinished = YES;
            [self.totalTimerLabel pause];
            NSTimeInterval interval = [self.totalTimerLabel getTimeCounted];
            
            [_playerView stop];
            _pauseView = nil;
            
            [self.backgroundMusicPlayer stop];
            self.backgroundMusicPlayer = nil;
            [self.soundPlayer stop];
            self.soundPlayer = nil;
            
            if (_timer) {
                [_timer invalidate];
                _timer = nil;
            }
            
            AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
            [manager stopMonitoring];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            [_airplayButtonInMPVolumeView removeObserver:self forKeyPath:@"alpha"];
            NSDate *now = [NSDate date];

            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:action];
        [controller addAction:cancelAction];
        if (IPAD_DEVICE) {
            controller.popoverPresentationController.sourceView = self.view;
            controller.popoverPresentationController.sourceRect = self.view.bounds;
        }
        [self presentViewController:controller animated:YES completion:nil];
    }
}

-(void)updatePreviousAndNextControl
{
    self.previousButton.hidden = !((self.currentIndex > 0) && (self.videoSets.count > 1) && self.isStarted);
    self.nextButton.hidden = !((self.currentIndex < (self.videoSets.count - 1) && (self.videoSets.count > 1))&& self.isStarted);
}


#pragma mark -
-(void)finish
{
    
    if ([self showbigAlert]&&!self.rehab.disease.isPro&&!self.rehab.isSelfRehab) {
        
        
        
        UIView* showview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 131*2+92, 81+324+27)];
        showview.backgroundColor = [UIColor clearColor];
        
        UIImageView* im = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 131*2+92,  81+324-40)];
        [im setImage:[UIImage imageNamed:@"庆祝效果"]];
        
        [showview addSubview:im];
        
        
        UIView* line = [UIView new];
        line.width = 2;
        line.height = 66;
        line.centerX = showview.width*1.0/2;
        line.bottom = showview.height-27;
        line.backgroundColor = [UIColor wr_themeColor];
        [showview addSubview:line];
        
        UIButton* close = [UIButton new];
        close.width = close.height = 27;
        [close setBackgroundImage:[UIImage imageNamed:@"组-7"] forState:0];
        close.centerX = showview.width*1.0/2;
        close.bottom = showview.height;
        [showview addSubview:close];
        
        UIView* bac = [[UIView alloc]initWithFrame:CGRectMake(56.5, 106, 241, 237)];
        bac.backgroundColor = [UIColor whiteColor];
        bac.layer.cornerRadius = WRCornerRadius;
        bac.layer.masksToBounds = YES;
        [showview addSubview:bac];
        
        UIImageView* head = [[UIImageView alloc]initWithFrame:CGRectMake(28, 0, showview.width-56, 76+149)];
        [head setImage:[UIImage imageNamed:@"组-6"]];
        [showview addSubview:head];
        
        UILabel* title = [UILabel new];
        title.y = 60;
        title.text = @"小提示";
        title.font = [UIFont boldSystemFontOfSize:15];
        title.textColor = [UIColor wr_titleTextColor];
        [title sizeToFit];
        title.centerX = bac.width*1.0/2;
        [bac addSubview:title];
        
        UILabel* content = [UILabel new];
        content.x = 32.5;
        content.y = title.bottom+13;
        content.text = @"快速定制方案适用于快速缓解疼痛想要进一步康复可以试试定制方案哦！";
        content.font = [UIFont systemFontOfSize:13];
        content.numberOfLines = 0;
        content.textAlignment = NSTextAlignmentCenter;
        content.textColor = [UIColor wr_themeColor];
        content.width = bac.width-23*2;
        [content sizeToFit];
        content.width = bac.width-23*2;
        [UILabel changeLineSpaceForLabel:content WithSpace:14];
        [bac addSubview:content];
        
        UIButton* prebtn = [UIButton new];
        prebtn.width = 121;
        prebtn.height = 29;
        prebtn.layer.cornerRadius = prebtn.height*1.0/2;
        prebtn.layer.masksToBounds = YES;
        [prebtn setTitle:@"立即试试" forState:0];
        [prebtn setTitleColor:[UIColor whiteColor] forState:0];
        prebtn.backgroundColor = [UIColor wr_themeColor];
        prebtn.titleLabel.font = [UIFont systemFontOfSize:13];
        prebtn.centerX = bac.width*1.0/2;
        prebtn.bottom = bac.height-20;
        [bac addSubview:prebtn];
        
        
        
        
        
        
        JCAlertView* ALART = [[JCAlertView alloc]initWithCustomView:showview dismissWhenTouchedBackground:NO];
//        [ALART show];
        
        [close bk_whenTapped:^{
            [ALART dismissWithCompletion:^{
                [self alertForExit];
            }];
        }];
        
        
        WRRehabDisease* dis;
        for (WRRehabDisease* dise in  [ShareData data].treatDisease) {
            if ([dise.diseaseName isEqualToString:self.rehab.disease.diseaseName]) {
                dis = dise;
            }
        }
        
        WRRehabDisease* redis;
        for (WRRehabDisease* dise in [ShareData data].proTreatDisease) {
            if ([dise.specialty isEqualToString:dis.specialty]) {
                redis =dise;
            }
        }
        
        WRRehab* rehab =nil;
        for (WRRehab* re in [ShareUserData userData].proTreatRehab) {
            if ([re.disease.diseaseName isEqual: redis.diseaseName]) {
                rehab = re;
            }
        }
        
        if (redis&&!rehab) {
            [ALART show];
            
        }else
        {
            UIAlertView* finishAl =  [[UIAlertView alloc]initWithTitle:@"恭喜你完成了锻炼动作" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
            
            [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
                self.isFinished  =YES;
                [self alertForExit];
            }];
            [finishAl show];
        }
        
        
        __weak __typeof(self) weakSelf = self;
        [prebtn bk_whenTapped:^{
            
            
           
                    if (redis) {
                        self.disease = redis;
                        [ALART dismissWithCompletion:^{
                            //
                           
                                [self alertForExit];
                           
                        }];
                        
                    }
        
            
            
        }];
        
    }
    else
    {
        UIAlertView* finishAl =  [[UIAlertView alloc]initWithTitle:@"恭喜你完成了锻炼动作" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        
        [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple *tuple) {
            self.isFinished  =YES;
            [self alertForExit];
        }];
        [finishAl show];

    }
    
    
    
}

-(BOOL)showbigAlert
{
    BOOL show = NO;
    
    WRDateformatter* formatter = [WRDateformatter formatter];
    NSString* date = [[NSUserDefaults standardUserDefaults]objectForKey:@"showBig"][self.rehab.indexId];
    
    if(date)
    {
        NSDate * last = [formatter dateFromString:date];
        NSDate * now = [[NSDate alloc]init];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
        NSDate *startDate = [calendar dateFromComponents:components];
        long  time1 = [last timeIntervalSince1970];
        long  time2 = [startDate timeIntervalSince1970]+8*60*60;
        if (time1<time2) {
            show =YES;
        }
        else
        {
            show = NO;
        }
        
        
    }
    else
    {
        show = YES;
        
    }
    
    
    
//#ifdef DEBUG
//    show =YES;
//#endif
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"showBig"]] ;
    dict[self.rehab.indexId] = [formatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults]setObject:dict forKey:@"showBig"];
    
    WRRehabDisease* dis;
    for (WRRehabDisease* dise in  [ShareData data].treatDisease) {
        if ([dise.diseaseName isEqualToString:self.rehab.disease.diseaseName]) {
            dis = dise;
        }
    }
    WRRehabDisease* prodis;
    for (WRRehabDisease* dise in [ShareData data].proTreatDisease) {
        if ([dise.specialty isEqualToString:dis.specialty]) {
            prodis = dise;
        }
    }
    
    
    for (WRRehab* rehab in [ShareUserData userData].proTreatRehab) {
        if ([rehab.disease.diseaseName isEqualToString:prodis.diseaseName]) {
            show=NO;
        }
    }
    
    return show;
}
-(void)playSound:(NSString*)musicName
{
//    if (!_soundIdDict) {
//        _soundIdDict = [NSMutableDictionary dictionary];
//        
//        NSArray *soundNameArray = @[@"begin", @"next", @"finish"];
//        for(NSString *name in soundNameArray)
//        {
//            NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
//            NSURL *url = [NSURL fileURLWithPath:path];
//            SystemSoundID soundId = 0;
//            AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundId);
//            if (soundId > 0) {
//                _soundIdDict[name] = @(soundId);
//            }
//        }
//    }
//
//    NSNumber *number = _soundIdDict[musicName];
//    if (number) {
//        AudioServicesPlaySystemSound(number.intValue);
//    }
    

    NSError *error;
    NSURL *backgroundMusicURL;
    
    backgroundMusicURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:musicName ofType:@"wav"]];
    
    self.soundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    self.soundPlayer.numberOfLoops = 0;
    [self.soundPlayer prepareToPlay];
    [self.soundPlayer play];
        //            [self.backgroundMusicPlayer setVolume:0.05];
//        _currentVolume = self.backgroundMusicPlayer.volume;
}
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
}

@end
