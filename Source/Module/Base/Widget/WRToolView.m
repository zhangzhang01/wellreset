//
//  WRToolView.m
//  rehab
//
//  Created by Matech on 5/17/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRToolView.h"
#import "UIImage+Tint.h"

@implementation WRToolView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat x = 0, y = 0, cy = frame.size.height, cx = cy;
        
        UIImage *image = [UIImage imageNamed:@"prev_step"];
        UIImage *disableImage = [image imageTintedWithColor:[UIColor grayColor]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:disableImage forState:UIControlStateDisabled];
        button.frame = CGRectMake(x, y, cx, cy);
        [self addSubview:button];
        self.previousButton = button;
        
        image = [UIImage imageNamed:@"next_step"];
        disableImage = [image imageTintedWithColor:[UIColor grayColor]];
        x = self.bounds.size.width - x - cx;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:disableImage forState:UIControlStateDisabled];
        button.frame = CGRectMake(x, y, cx, cy);
        [self addSubview:button];
        self.nextButton = button;
        
        x = CGRectGetMaxX(self.previousButton.frame);
        cx = CGRectGetMinX(self.nextButton.frame) - x;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        button.frame = CGRectMake(x, y, cx, cy);
        [self addSubview:button];
        self.centerButton = button;
    }
    return self;
}
-(void)layout
{
    CGFloat x = 0, y = 0, cy = self.height, cx = cy;
    
    
    self.previousButton.frame = CGRectMake(x, y, cx, cy);
    
    
    x = self.bounds.size.width - x - cx;
    
    self.nextButton.frame = CGRectMake(x, y, cx, cy);
    
    
    x = CGRectGetMaxX(self.previousButton.frame);
    cx = CGRectGetMinX(self.nextButton.frame) - x;
    
    self.centerButton.frame = CGRectMake(x, y, cx, cy);
    self.centerButton.hidden = NO;
    self.backgroundColor = [[UIColor wr_themeColor] colorWithAlphaComponent:0.8];
    UIImage *image = [UIImage imageNamed:@"prev_step"];
    [self.previousButton setImage:image forState:0];
    image = [UIImage imageNamed:@"next_step"];
    [self.nextButton setImage:image forState:0];
   
}
-(void)layoutw
{
    CGFloat x = 0, y = 0, cy = self.height, cx = cy;
    
    
    self.previousButton.frame = CGRectMake(x, y, cx, cy);
    
    
    x = self.bounds.size.width - x - cx;
    
    self.nextButton.frame = CGRectMake(x, y, cx, cy);
    
    
    x = CGRectGetMaxX(self.previousButton.frame);
    cx = CGRectGetMinX(self.nextButton.frame) - x;
    
    self.centerButton.frame = CGRectMake(x, y, cx, cy);
    
    self.centerButton.hidden = YES;
    self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    
    UIImage *image = [UIImage imageNamed:@"全屏上一个"];
    [self.previousButton setImage:image forState:0];
    image = [UIImage imageNamed:@"全屏下一个"];
    [self.nextButton setImage:image forState:0];
    
}
@end
