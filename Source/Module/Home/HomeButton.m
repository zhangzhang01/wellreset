//
//  HomeButton.m
//  rehab
//
//  Created by yefangyang on 2016/11/14.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "HomeButton.h"

@interface HomeButton ()<CAAnimationDelegate>

@end
@implementation HomeButton

- (instancetype)initWithImage:(NSString *)image title:(NSString *)title superView:(UIView *)superView amount:(NSInteger)amount index:(NSInteger)index
{
    self = [HomeButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:image];
    if (self) {
        [self setImage:img forState:UIControlStateNormal];
        self.titleLabel.text = title;
        [self setUpBezierPath];
        [superView addSubview:self];
    }
    return self;
}

//绘制贝塞尔曲线方法
- (void)setUpBezierPath
{

    CGPoint originPoint = CGPointMake(20, self.center.y);
    CGFloat endAngle;
//    endAngle = M_PI/2 - ((self.amount - self.index +1) +(self.amount - self.index +1)/15.0)*M_PI/(self.amount + 2);

    if (self.index == 1) {
        endAngle = M_PI/2 - (self.amount - 1.2 )*M_PI/(self.amount + 1);
    } else {
        endAngle = M_PI/2 - (self.amount - self.index)*M_PI/(self.amount + 1);
    }
    
    NSLog(@"%d%f",(int)self.index, endAngle);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:originPoint radius:self.radius startAngle:M_PI/2 endAngle:endAngle clockwise:NO];

    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [keyFrameAnimation setDuration:1];
    keyFrameAnimation.path = bezierPath.CGPath;
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.delegate = self;
    [self.layer addAnimation:keyFrameAnimation forKey:@"movingAnimation"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.centerY = self.height/2;
    self.imageView.left = 0;
    
    self.titleLabel.left = self.imageView.right + WRUILittleOffset;
    self.titleLabel.centerY = self.imageView.centerY;
}

@end
