//
//  TagLabel.m
//  rehab
//
//  Created by yefangyang on 2016/12/15.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "TagLabel.h"

#define R_G_B_16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]
@implementation TagLabel
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.selected = NO;
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (selected) {
        self.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor wr_rehabBlueColor];
        self.layer.borderColor = [UIColor wr_rehabBlueColor].CGColor;
    } else {
        self.textColor = R_G_B_16(0x818181);
        self.backgroundColor = [UIColor wr_lightWhite];
        self.layer.borderColor = [UIColor wr_lightWhite].CGColor;
    }
}

@end
