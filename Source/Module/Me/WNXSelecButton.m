//
//  WNXSelecButton.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69
//  Created by MacBook on 15/7/5.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//

#import "WNXSelecButton.h"

@implementation WNXSelecButton

- (void)setHighlighted:(BOOL)highlighted{}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont wr_smallFont];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.imageView.width = self.width * 0.5;
//    self.imageView.height = self.imageView.width;
    self.imageView.centerY = self.height/2;
//    self.imageView.centerX = self.width * 0.5;

    self.titleLabel.left = self.imageView.right + WRUILittleOffset;
//    self.titleLabel.width = self.width;
//    self.titleLabel.height = self.height * 0.3;
    self.titleLabel.centerY = self.imageView.centerY;
}
@end
