//
//  UIBarButtonItem+custom.m
//  rehab
//
//  Created by yongen zhou on 2017/10/12.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "UIBarButtonItem+custom.h"

@implementation UIBarButtonItem (custom)
- (void)setButtonImage:(UIImage *)image
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
    self.customView = button;
}

- (UIImage *)buttonImage
{
    return [(UIButton *)self.customView imageForState:UIControlStateNormal];
}

@end
