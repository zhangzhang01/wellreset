//
//  RehabPlayerPauseView.m
//  rehab
//
//  Created by herson on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "RehabPlayerPauseView.h"

@interface RehabPlayerPauseView()

@end

@implementation RehabPlayerPauseView

-(instancetype)initWithFrame:(CGRect)frame type:(RehabPlayerPauseViewType)type
{
    if (self = [super initWithFrame:frame]) {
        self.type = type;
        
        self.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIImage *image = [UIImage imageNamed:@"big_play"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        [button sizeToFit];
        button.center = CGPointMake(frame.size.width/2, frame.size.width/2 + 10 + button.height/2);
        [self addSubview:button];
        self.controlButton = button;
        
        CGFloat y = self.controlButton.bottom + WRUIOffset;
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"继续康复", nil);
        label.numberOfLines = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont wr_textFont];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        CGFloat x = frame.size.width/2 - label.width/2;
        label.frame = [Utility moveRect:label.frame x:x y:y];
        [self addSubview:label];
        
        CGFloat cy = 54, cx = 200;
        y = frame.size.height - cy - 30;
        x = (frame.size.width - cx)/2;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        view.layer.borderWidth = 1;
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:view];
        
        CGFloat offset = 0;
        x = offset, y = x, cy = cy - 2*y, cx = (cy*16)/9;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        imageView.image = [UIImage imageNamed:@"well_default_video"];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [view addSubview:imageView];
        self.imageView = imageView;
        
        CGFloat smallOffset = WRUILittleOffset;
        y = offset;
        x = imageView.right + smallOffset;
        cx = view.width - x - smallOffset;
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.text = @"test";
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont wr_textFont];
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
        
        self.titleLabel = label;
    }
    return self;
}

-(void)show
{
    self.alpha = 0;
    self.hidden = NO;
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.alpha = 1;
    }];
}
@end
