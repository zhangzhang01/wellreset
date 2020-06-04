//
//  MTMissionHeadButton.m
//  MTExpense
//
//  Created by yefangyang on 16/4/8.
//  Copyright © 2016年 yefangyang. All rights reserved.
//

#import "MTMissionHeadButton.h"

@implementation MTMissionHeadButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.top = self.height * 0.1;
    self.imageView.centerX = self.width * 0.5;
    
    self.titleLabel.left = 0;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height * 0.3;
    self.titleLabel.top = self.height * 0.6 ;
}

@end


@implementation ImageTitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat offset = 3;
    
    self.imageView.top = (self.height - self.imageView.height - self.titleLabel.height - offset)/2;
    self.imageView.centerX = self.width/2;
    
    self.titleLabel.top = self.imageView.bottom + offset;
    self.titleLabel.left = offset;
    self.titleLabel.width = self.width - 2*offset;
}

@end
