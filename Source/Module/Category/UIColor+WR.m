//
//  UIColor+WR.m
//  rehab
//
//  Created by Matech on 2/29/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "UIColor+WR.h"
#import <YYKit/YYKit.h>
@implementation UIColor(WR)

//只有n>40的时候才需要
+(CGFloat)cal:(NSUInteger)n
{
    return (CGFloat)((n - 40) / (1- 40 / 255))/255.0;
}

+(instancetype)wr_navThemeColor {
    //此颜色由wr_themeColor计算出来的
    return [UIColor colorWithHexString:@"1A7BF6"];
    //return [UIColor colorWithHexString:@"4AB0E0"];
}

+(instancetype)wr_themeColor {
    return [UIColor colorWithRed:53/255.0 green:191/255.0 blue:227/255.0 alpha:1];
    //    return [UIColor colorWithHexString:@"3e90f7"];
    //return [UIColor colorWithHexString:@"66bce5"];
}

+(instancetype)wr_lightThemeColor {
    return [UIColor colorWithHexString:@"369eff"];
}


+(instancetype)wr_imageTintColor {
    return [UIColor colorWithHexString:@"3FA9F5"];
}

+(instancetype)wr_bgColor {
    return [UIColor whiteColor];
}

+(instancetype)wr_alphaWhiteColor
{
    return [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.1];
}

+(instancetype)wr_purpleColor
{
    return [UIColor colorWithRed:98.0/255.0 green:53.0/255.0 blue:130.0/255.0 alpha:1];
}

+(instancetype)wr_alphaLabelWhiteColor
{
    return [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.6];
}

+(instancetype)wr_alphaLabelBlackColor
{
    return [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.5];
}

+(instancetype)wr_headBackgroundColor
{
    return [UIColor colorWithRed:22/255.0 green:39/255.0 blue:75/255.0 alpha:1];
}

+(instancetype)wr_redRoundColor
{
    return [UIColor colorWithRed:219/255.0 green:66/255.0 blue:55/255.0 alpha:1];
}

+(instancetype)wr_yellowRoundColor
{
    return [UIColor colorWithRed:239/255.0 green:177/255.0 blue:10/255.0 alpha:1];
}

+(instancetype)wr_grayBorderColor {
    return [UIColor grayColor];
}

+(instancetype)wr_lightBorderColor {
    return [UIColor colorWithHexString:@"eeeeee"];
}

+(instancetype)wr_lineColor {
    return [UIColor colorWithHexString:@"eeeeee"];
}

+(instancetype)wr_lightGray {
    return [UIColor colorWithHexString:@"f0f0f0"];
}

+(instancetype)wr_lightWhite {
    return [UIColor colorWithHexString:@"f7f8fb"];
}

+(instancetype)wr_lightFontColor {
    return [UIColor colorWithHexString:@"b4b4b4"];
}

+(instancetype)wr_titleTextColor {
    return [UIColor colorWithHexString:@"515151"];
}

+(instancetype)wr_detailTextColor {
    return [UIColor colorWithHexString:@"999999"];
}

+(instancetype)wr_selectItemColor {
    //return [UIColor colorWithHexString:@"69a0f1"];
    return [self wr_themeColor];
}

+(instancetype)wr_selectLabelBgColor {
       return [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.9];
}

+(instancetype)wr_loginLogoColor {
    return [UIColor colorWithRed:41/255.0 green:155/255.0 blue:225/255.0 alpha:1];
}

+(instancetype)wr_faqContentColor {
    return [UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:1];
}

+(instancetype)wr_rehabBlueColor {
    return [UIColor colorWithRed:53/255.0 green:191/255.0 blue:227/255.0 alpha:1];
}

+(instancetype)wr_buttonDeffaultColor;
{
    return [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
}

@end
