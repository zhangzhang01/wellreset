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

@end
