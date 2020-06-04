//
//  ReceiveQuestionnaireView.m
//  rehab
//
//  Created by yefangyang on 2016/10/28.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "ReceiveQuestionnaireView.h"

@interface ReceiveQuestionnaireView()<CAAnimationDelegate>
{
    NSInteger _currentClickedButtonIndex;
    CAAnimation *_endAnimation;
}
@property(nonatomic) UIView *contentView;
@end

@implementation ReceiveQuestionnaireView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        BOOL biPad = [WRUIConfig IsHDApp];
        CGFloat x, y, cx, cy, viewWidth;
        x = 2 * WRUIOffset;
        if (biPad) {
           x = frame.size.width / 4;
        }
        y = 84;
        viewWidth = frame.size.width - 2 * x;
        cy = 300;
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, y, viewWidth, cy)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        bgView.layer.cornerRadius = 5.0f;
        bgView.clipsToBounds = YES;
        self.contentView = bgView;
        
        y = 0;
        x = 0;
        cx = viewWidth;
        cy = 150;
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor wr_themeColor];
        topView.frame = CGRectMake(x, y, cx, cy);
        [bgView addSubview:topView];
        UIImage *image = [UIImage imageNamed:@"well_questionnaire_icon"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(2 * WRUIOffset, y, image.size.width, image.size.height);
        [topView addSubview:imageView];
        
        NSArray *textArray = @[NSLocalizedString(@"WELL健康", nil),NSLocalizedString(@"诚邀您参与科研调查", nil)];
        y = imageView.bottom;
        for (int i = 0; i < textArray.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
            label.text = textArray[i];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont wr_titleFont];
            [label sizeToFit];
            [topView addSubview:label];
            label.frame = [Utility moveRect:label.frame x:(viewWidth - label.width)/2 y:-1];
            y = label.bottom + WRUIOffset;
        }
    
        NSArray *titlesArray = @[NSLocalizedString(@"立即参与", nil),NSLocalizedString(@"以后再说", nil),NSLocalizedString(@"残忍拒绝", nil)];
        y = topView.bottom + WRUIOffset;
        for (int i = 0; i < titlesArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.frame = CGRectMake(x, y, cx, 44);
            [bgView addSubview:button];
            [button setTitle:titlesArray[i] forState:UIControlStateNormal];
            
            if (i == 0)
            {
                [button setTitleColor:[UIColor wr_themeColor] forState:UIControlStateNormal];
            }
            else
            {
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            }
            button.titleLabel.font = [UIFont wr_lightFont];
            [button addTarget:self action:@selector(onClickedChooseButton:) forControlEvents:UIControlEventTouchUpInside];
            button.frame = [Utility moveRect:button.frame x:(viewWidth - button.width)/2 y:-1];
            y = button.bottom + 2 * WRUIOffset;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, y - WRUIOffset, viewWidth, 0.5)];
            line.backgroundColor = [UIColor wr_lightWhite];
            [bgView addSubview:line];
        }
        
        bgView.height =  y;
        bgView.frame = [Utility moveRect:bgView.frame x:-1 y:(frame.size.height - y)/2];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint currentPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.contentView.frame, currentPoint)) {
        
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.alpha = 0;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}
#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (anim == _endAnimation) {
        [self removeFromSuperview];
        [self doCompletion];
    }
}

#pragma mark - event
- (IBAction)onClickedChooseButton:(UIButton *)sender
{
    _currentClickedButtonIndex = sender.tag;
    [self dismiss];
}

#pragma mark - 
-(void)doCompletion
{
    [self removeFromSuperview];
    NSInteger index = _currentClickedButtonIndex;
    void(^action)(NSInteger) = self.clickedChooseBlock;
    if (action) {
        action(index);
    }
}

#pragma mark - public
-(void)showWithAnimationInSuperView:(UIView*)superView
{
    //self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [superView addSubview:self];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            [NSValue valueWithCATransform3D:scale2],
                            [NSValue valueWithCATransform3D:scale3],
                            [NSValue valueWithCATransform3D:scale4],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.0],
                           [NSNumber numberWithFloat:0.5],
                           [NSNumber numberWithFloat:0.9],
                           [NSNumber numberWithFloat:1.0],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .2;
    
    [self.contentView.layer addAnimation:animation forKey:@"popup"];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
}

-(void)dismiss
{
    
    /*
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform"];
    
    CATransform3D scale1 = CATransform3DMakeScale(0.01, 0.01, 1);
    
    NSArray *frameValues = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:scale1],
                            nil];
    [animation setValues:frameValues];
    
    NSArray *frameTimes = [NSArray arrayWithObjects:
                           [NSNumber numberWithFloat:0.2],
                           nil];
    [animation setKeyTimes:frameTimes];
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .2;
    animation.delegate = self;
    animation.keyPath = @"dismiss";
    
    _endAnimation = animation;
    
    [self.contentView.layer addAnimation:animation forKey:@"finish"];
    */
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf doCompletion];
    }];
}
@end
