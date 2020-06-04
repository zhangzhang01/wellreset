//
//  UIButton+WR.h
//  rehab
//
//  Created by Matech on 3/2/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(WR)

+(instancetype)wr_buttonWithTitle:(NSString*)title;
+(instancetype)wr_defaultButtonWithTitle:(NSString *)title;
+(instancetype)wr_lineBorderButtonWithTitle:(NSString*)title;
+(instancetype)wr_lineBorderButtonWithTitle:(NSString*)title normalColor:(UIColor*)normalColor highLightColor:(UIColor*)highLightColor;

- (void)wr_verticalImageAndTitle:(CGFloat)spacing;

@end
