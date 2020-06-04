//
//  WRMediaPlayer.h
//  rehab
//
//  Created by Matech on 3/17/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WRMediaPlayerStyle)
{
    WRMediaPlayerStyleDefault,
    WRMediaPlayerStyleSmall
};

@interface WRMediaPlayer : UIView

@property(nonatomic) UIButton *resizeButton, *backButton;
@property(nonatomic) UIButton *stateButton, *notifyButton, *muteButton;
@property(nonatomic, copy) NSString* totalTime;
@property(nonatomic) BOOL hideControls, disableOnTouch;
@property(nonatomic) BOOL isLoop;
@property(nonatomic) UISlider *videoSlider;
@property(nonatomic) UIProgressView *videoProgress;
@property(nonatomic) UILabel *timeLabel;

-(instancetype)initWithFrame:(CGRect)frame style:(WRMediaPlayerStyle)style;
-(void)setContent:(NSURL*)url autoStart:(BOOL)flag;
-(void)pause;
-(void)stop;
-(void)start;


@property(nonatomic) BOOL isFullScreen;
-(void)setViewScaleTyle:(BOOL)isFullScreen;


@end
