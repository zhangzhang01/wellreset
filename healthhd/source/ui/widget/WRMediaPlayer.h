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
@property(nonatomic) BOOL hideControls;
@property(nonatomic) BOOL isLoop;

-(instancetype)initWithFrame:(CGRect)frame style:(WRMediaPlayerStyle)style;
-(void)setContent:(NSURL*)url autoStart:(BOOL)flag;
-(void)pause;
-(void)stop;
-(void)start;

#if 0
@property(nonatomic, readonly) BOOL isFullScreen;
-(void)setViewScaleTyle:(BOOL)isFullScreen;
#endif

@end
