//
//  ShareSuccessView.m
//  rehab
//
//  Created by yefangyang on 2017/1/22.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "ShareSuccessView.h"
#import <YYKit/YYKit.h>
@implementation ShareSuccessView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor colorWithHexString:@"0a0a0aaa"];
        
        CGFloat offset = WRUIOffset;
        UIProgressView *pro=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
        pro.frame=CGRectMake(30, offset, frame.size.width - 60, 50);
        //设置进度条颜色
        pro.trackTintColor=[UIColor lightGrayColor];
        pro.progressTintColor=[UIColor wr_rehabBlueColor];
        [pro setProgress:(float)[WRUserInfo selfInfo].integral/[WRUserInfo selfInfo].nextLevel animated:NO];
        
        pro.transform = CGAffineTransformMakeScale(1.0f, 2.0f);
        //自己设置的一个值 和进度条作比较 其实为了实现动画进度
        [self addSubview:pro];
    }
    return self;
}

@end
