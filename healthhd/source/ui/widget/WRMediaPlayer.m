//
//  WRMediaPlayer.m
//  rehab
//
//  Created by Matech on 3/17/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRMediaPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "WRSlider.h"

@interface WRMediaPlayer ()
{
    BOOL _isReady, _isEnd;
}
@property(nonatomic ,strong) AVPlayer *avPlayer;
@property(nonatomic ,strong) AVPlayerItem *playerItem;
@property(nonatomic, strong) NSURL *currentContentUrl;
@property(nonatomic) id playbackTimeObserver;
@property(nonatomic) UIProgressView *videoProgress;
@property(nonatomic) UILabel *timeLabel;
@property(nonatomic) UISlider *videoSlider;
@property(nonatomic) UIView *controlBar;
@property(nonatomic) CGRect currentPlayerFrame;
@property(nonatomic) BOOL autoStart;
@property(nonatomic) WRMediaPlayerStyle style;
@end

@implementation WRMediaPlayer

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

-(void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"WRMediaPlayer dealloc");
}

-(instancetype)initWithFrame:(CGRect)frame style:(WRMediaPlayerStyle)style {
    if (self = [super initWithFrame:frame]) {
        self.style = style;
        self.backgroundColor = [UIColor blackColor];
        self.currentPlayerFrame = frame;
        
        UIImage *controlImage = [UIImage imageNamed:@"well_player_btn_play"];

        UIView *controlBar = [[UIView alloc] init];
        controlBar.backgroundColor = [UIColor colorWithHexString:@"202020aa"];
        [self addSubview:controlBar];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:controlImage forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"well_player_btn_pause"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(onClickedControlButton:) forControlEvents:UIControlEventTouchUpInside];
        button.enabled = YES;
        [button sizeToFit];
        [controlBar addSubview:button];
        self.controlBar = controlBar;
        self.stateButton = button;
        
        UIImage *resizeImage = [UIImage imageNamed:@"well_player_btn_expand"];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:resizeImage forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"well_player_btn_toggle"] forState:UIControlStateSelected];
        //[button addTarget:self action:@selector(onClickedResizeButton:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        self.resizeButton = button;
        [controlBar addSubview:button];
        
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
        progressView.backgroundColor = [UIColor clearColor];
        progressView.progressTintColor = [UIColor wr_themeColor];
        progressView.progress = 0;
        progressView.trackTintColor = [UIColor clearColor];
        [controlBar addSubview:progressView];
        self.videoProgress = progressView;
        
        UISlider *slider = [[WRSlider alloc] init];
        [self customVideoSlider:CMTimeMake(1500, 15)];
        slider.userInteractionEnabled = NO;
        [controlBar addSubview:slider];
        self.videoSlider = slider;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"00:00/00:00";
        label.font = [UIFont wr_detailFont];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        [controlBar addSubview:label];
        self.timeLabel = label;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"well_player_btn_back"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"well_player_btn_back_focus"] forState:UIControlStateHighlighted];
        [button sizeToFit];
        [self addSubview:button];
        self.backButton = button;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"well_player_sound"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"well_player_mute"] forState:UIControlStateSelected];
        [button sizeToFit];
        [button addTarget:self action:@selector(onClickedMuteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.muteButton = button;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"播放失败,点击重试", nil) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont wr_textFont];
        [button wr_roundBorderWithColor:[UIColor whiteColor]];
        [button sizeToFit];
        button.frame = CGRectMake(0, 0, button.frame.size.width + 2*WRUIOffset, button.frame.size.height);
        button.hidden = YES;
        [self addSubview:button];
        self.notifyButton = button;
        
        if (self.style == WRMediaPlayerStyleSmall) {
            self.resizeButton.hidden = YES;
            self.backButton.hidden = YES;
        }
    }
    self.controlBar.hidden = YES;
    return self;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!_isReady) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    if (self.hideControls)
    {
        if (self.backButton.alpha == 1)
        {
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.backButton.alpha = 0;
            } completion:^(BOOL finished) {
                weakSelf.muteButton.hidden = YES;
                weakSelf.backButton.hidden = YES;
            }];
        }
        else if (self.backButton.alpha == 0)
        {
            if (self.style != WRMediaPlayerStyleSmall)
            {
                self.backButton.hidden = NO;
            }
            self.muteButton.hidden = NO;
            
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.muteButton.alpha = 1;
                weakSelf.backButton.alpha = 1;
            } completion:^(BOOL finished) {
                
            }];
        }
        return;
    }
    
    UITouch *touch = touches.anyObject;
    if (touch) {
        CGPoint pt = [touch locationInView:self.controlBar];
        if ([self pointInside:pt withEvent:nil]) {
            [super touchesEnded:touches withEvent:event];
            return;
        }
    }
    
    if (self.controlBar.alpha == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.controlBar.alpha = 0;
            weakSelf.muteButton.alpha = 0;
            weakSelf.backButton.alpha = 0;
        } completion:^(BOOL finished) {
            weakSelf.controlBar.hidden = YES;
            weakSelf.muteButton.hidden = YES;
            weakSelf.backButton.hidden = YES;
        }];
    }
    else if (self.controlBar.alpha == 0) {
        self.controlBar.hidden = NO;
        if (self.style != WRMediaPlayerStyleSmall) {
            self.backButton.hidden = NO;
        }
        self.muteButton.hidden = NO;
        
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.controlBar.alpha = 1;
            weakSelf.muteButton.alpha = 1;
            weakSelf.backButton.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat offset = WRUIOffset;
    CGRect frame = self.bounds;
    CGFloat x = 0, y = 0, cx = frame.size.width, cy = self.stateButton.size.height + 2*offset;
    y = frame.size.height - cy;
    self.controlBar.frame = CGRectMake(0, y, cx, cy);
    
    self.stateButton.frame = CGRectMake(offset, offset, self.stateButton.frame.size.width, self.stateButton.frame.size.height);
    self.resizeButton.frame = CGRectMake(frame.size.width - self.resizeButton.frame.size.width - offset, offset, self.resizeButton.size.width, self.resizeButton.frame.size.height);
    
    x = CGRectGetMaxX(self.stateButton.frame)  + offset;
    if (self.style == WRMediaPlayerStyleSmall) {
        cx = frame.size.width - offset - x;
    } else {
        cx = CGRectGetMinX(self.resizeButton.frame) - offset - x;
    }
    y = offset + 5;
    cy = 10;
    self.videoSlider.frame = CGRectMake(x, y, cx, cy);
    self.videoProgress.frame = CGRectMake(x, y + 4, cx, cy - 3);
    
    y = CGRectGetMaxY(self.videoSlider.frame) + offset;
    self.timeLabel.frame = CGRectMake(x, y, cx, self.timeLabel.frame.size.height);
    
    x = offset;
    y = x;
    self.backButton.frame = CGRectMake(x, y, self.backButton.frame.size.width, self.backButton.frame.size.height);
    x = frame.size.width - offset - self.muteButton.bounds.size.width;
    self.muteButton.frame = CGRectMake(x, y, self.muteButton.frame.size.width, self.muteButton.frame.size.height);
    
    x = (frame.size.width - self.notifyButton.bounds.size.width)/2;
    y = (frame.size.height - self.notifyButton.bounds.size.height)/2;
    self.notifyButton.frame = [Utility moveRect:self.notifyButton.frame x:x y:y];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            
            _isReady = YES;
            self.stateButton.enabled = YES;
            CMTime duration = self.playerItem.duration;// 获取视频总长度
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            _totalTime = [self convertTime:totalSecond];// 转换成播放时间
            [self customVideoSlider:duration];// 自定义UISlider外观
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            [self monitoringPlayback:self.playerItem];// 监听播放状态
            [self updateTimeLine:self.playerItem];
            if (self.autoStart) {
                 [self.avPlayer play];
                self.stateButton.selected = YES;
            } else {
                if (!self.hideControls) {
                    self.controlBar.hidden = NO;
                }
            }
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
            self.notifyButton.hidden = NO;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        //NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.videoProgress setProgress:timeInterval / totalDuration animated:YES];
    }
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

- (void)customVideoSlider:(CMTime)duration {
    self.videoSlider.maximumValue = CMTimeGetSeconds(duration);
    UIGraphicsBeginImageContextWithOptions((CGSize){ 1, 1 }, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.videoSlider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [self.videoSlider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
}

-(void)updateVideoSlider:(CGFloat)ss {
    self.videoSlider.value = ss;
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    __weak __typeof(self) weakSelf = self;
    
    self.playbackTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        [weakSelf updateTimeLine:playerItem];
    }];
}

-(void)updateTimeLine:(AVPlayerItem *)playerItem
{
    NSString *timeString = @"";
    if (self.avPlayer.actionAtItemEnd != AVPlayerActionAtItemEndNone ) {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
        [self updateVideoSlider:currentSecond];
        timeString = [NSString stringWithFormat:@"%@/%@", [self convertTime:currentSecond], _totalTime];
    } else {
        timeString = [NSString stringWithFormat:@"%@/%@",[self convertTime:0],_totalTime];
    }
    self.timeLabel.text = timeString;
}

-(void)moviePlayDidEnd:(NSNotification*)notification {
    NSLog(@"play video finished");
    self.videoSlider.value = 0;
    self.stateButton.selected = NO;
    _isEnd = YES;
    
    if (self.isLoop) {
        AVPlayerItem *p = [notification object];
        [p seekToTime:kCMTimeZero];
    }
}

#pragma mark - IBAction
-(IBAction)onClickedControlButton:(UIButton*)sender {
    if (sender == self.stateButton) {
        if (_isEnd) {
            if (!sender.selected) {
                _isEnd = NO;
                [self.avPlayer seekToTime:kCMTimeZero];
                [self.avPlayer play];
                sender.selected = !sender.selected;
            }
        } else {
            if (self.avPlayer.actionAtItemEnd != AVPlayerActionAtItemEndNone ) {
                if (sender.selected) {
                    [self.avPlayer pause];
                    sender.selected = NO;
                } else {
                    [self.avPlayer play];
                    sender.selected = YES;
                }
            }
            else{
                if(!sender.selected) {
                    AVPlayerItem *p = self.playerItem;
                    [p seekToTime:kCMTimeZero];
                }
            }
        }
        
    }
}

-(IBAction)onClickedNotifyButton:(UIButton*)sender {
    [self setContent:self.currentContentUrl autoStart:self.autoStart];
}

-(IBAction)onClickedMuteButton:(UIButton*)sender {
    self.avPlayer.muted = !sender.selected;
    sender.selected = !sender.selected;
}

#pragma mark - getter & setter
-(void)setHideControls:(BOOL)hideControls
{
    _hideControls = hideControls;
    self.controlBar.hidden = YES;
}

#pragma mark -
-(void)setContent:(NSURL *)url autoStart:(BOOL)flag {
    _isReady = NO;
    _isEnd = NO;
    self.notifyButton.hidden = YES;
    self.muteButton.hidden = YES;
    
    self.controlBar.hidden = self.hideControls;
    self.autoStart = flag;
    self.currentContentUrl = url;
    
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    self.playerItem = nil;
    
    self.videoSlider.value = 0;
    self.stateButton.selected = NO;
    self.videoProgress.progress = 0;
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",[self convertTime:0],[self convertTime:0]];
    
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性
    self.avPlayer = [AVPlayer playerWithPlayerItem:self.playerItem];
    if (self.isLoop) {
        self.avPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    }
    AVPlayerLayer *playerLayer = (AVPlayerLayer*)self.layer;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    [self setPlayer:self.avPlayer];
}

-(void)pause {
    [self.avPlayer pause];
    self.stateButton.selected = NO;
}

-(void)stop {
    if (self.playbackTimeObserver) {
        [self.player removeTimeObserver:self.playbackTimeObserver];
        self.playbackTimeObserver = nil;
    }
    
    
    [self.avPlayer pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];

    self.avPlayer = nil;
    self.playerItem = nil;
    self.stateButton.selected = NO;
}

-(void)start
{
    [self.avPlayer play];
    self.stateButton.selected = YES;
}

#if 0
-(BOOL)isFullScreen {
    return self.frame.size.width != self.bounds.size.width;
}

-(void)setViewScaleTyle:(BOOL)isFullScreen {
    __weak __typeof(self) weakSelf = self;
    if (!isFullScreen) {
        //[UIApplication sharedApplication].statusBarHidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.transform = CGAffineTransformMakeRotation(0);
            weakSelf.frame = weakSelf.currentPlayerFrame;
        } completion:^(BOOL finished) {
            //[weakSelf updateConstraints];
        }];
        
    } else {
        //[UIApplication sharedApplication].statusBarHidden = YES;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.transform = CGAffineTransformMakeRotation(M_PI_2);
            weakSelf.frame = CGRectMake(0, 0, weakSelf.superview.bounds.size.width, weakSelf.superview.bounds.size.height);
        } completion:^(BOOL finished) {
            //[weakSelf updateConstraints];
        }];
        
        /*
        UIWindow *windows = [UIApplication sharedApplication].keyWindow;
        CGRect frame = [self convertRect:self.bounds toView:windows];
        self.frame = frame;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.transform = CGAffineTransformMakeRotation(M_PI_2);
            weakSelf.frame = CGRectMake(0, 0, weakSelf.superview.bounds.size.width, weakSelf.superview.bounds.size.height);
        } completion:^(BOOL finished) {
            sender.selected = !sender.selected;
        }];
        */
    }
    self.resizeButton.selected = isFullScreen;
}
#endif
@end
