//
//  UIButton+WR.m
//  rehab
//
//  Created by Matech on 3/2/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "UIButton+WR.h"

@implementation UIButton(WR)

+(instancetype)wr_buttonWithTitle:(NSString*)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor wr_themeColor];
    button.layer.cornerRadius = 4.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = [UIColor wr_themeColor].CGColor;
    button.layer.borderWidth = 1.0f;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

+(instancetype)wr_lineBorderButtonWithTitle:(NSString*)title {
    static UIImage *normalImage = nil, *highImage = nil, *disableImage = nil;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        normalImage = [Utility createImageWithColor:[UIColor wr_themeColor]];
        highImage = [Utility createImageWithColor:[UIColor whiteColor]];
        disableImage = [Utility createImageWithColor:[UIColor lightGrayColor]];
    });
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor wr_themeColor].CGColor;
    [btn setTitleColor:[UIColor wr_themeColor] forState:UIControlStateHighlighted];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5.f;
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn setBackgroundImage:highImage forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}


+(instancetype)wr_lineBorderButtonWithTitle:(NSString *)title normalColor:(UIColor *)normalColor highLightColor:(UIColor *)highLightColor {
    UIImage *normalImage = [Utility createImageWithColor:normalColor];
    UIImage *highImage = [Utility createImageWithColor:highLightColor];
    UIImage *disableImage = [Utility createImageWithColor:[UIColor grayColor]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor wr_themeColor].CGColor;
    [btn setTitleColor:[UIColor wr_themeColor] forState:UIControlStateHighlighted];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5.f;
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn setBackgroundImage:highImage forState:UIControlStateSelected];
    [btn setBackgroundImage:disableImage forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}

+(instancetype)wr_defaultButtonWithTitle:(NSString *)title {
    UIImage *normalImage = [Utility createImageWithColor:[UIColor wr_lightThemeColor]];
    UIImage *highImage = [Utility createImageWithColor:[UIColor wr_themeColor]];
    UIImage *disableImage = [Utility createImageWithColor:[UIColor grayColor]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5.f;
    //btn.layer.borderWidth = 1.f;
    //btn.layer.borderColor = [UIColor wr_themeColor].CGColor;
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];

    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn setBackgroundImage:highImage forState:UIControlStateSelected];
    [btn setBackgroundImage:disableImage forState:UIControlStateDisabled];
    
    return btn;
}

- (void)wr_verticalImageAndTitle:(CGFloat)spacing
{
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    self.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    
}
@end
