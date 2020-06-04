//
//  UIView+WR.m
//  rehab
//
//  Created by Matech on 3/4/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "UIView+WR.h"

@implementation UIView(WR)
-(void)wr_roundFill
{
    self.height = self.width;
    self.layer.cornerRadius = self.height/2.0;
    self.layer.masksToBounds = YES;
}
-(void)wr_roundBorderWithColor:(UIColor *)borderColor {
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1.0f;
}

-(void)wr_roundBorder {
    [self wr_roundBorderWithColor:[UIColor wr_themeColor]];
}

-(void)wr_setShadow {
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 2.0;
}

-(void)wr_move:(CGFloat)x y:(CGFloat)y {
    self.frame = [Utility moveRect:self.frame x:x y:y];
}


-(void)wr_resize:(CGFloat)cx cy:(CGFloat)cy {
    self.frame = [Utility resizeRect:self.frame cx:cx height:cy];
}

@end
