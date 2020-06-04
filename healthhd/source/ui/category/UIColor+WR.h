//
//  UIColor+WR.h
//  rehab
//
//  Created by Matech on 2/29/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(WR)

+(instancetype)wr_themeColor;
+(instancetype)wr_lightThemeColor;
+(instancetype)wr_imageTintColor;

+(instancetype)wr_bgColor;
+(instancetype)wr_grayBorderColor;
+(instancetype)wr_lightBorderColor;
+(instancetype)wr_lineColor;
+(instancetype)wr_lightGray;
+(instancetype)wr_lightWhite;

+(instancetype)wr_lightFontColor;

+(instancetype)wr_titleTextColor;
+(instancetype)wr_detailTextColor;

@end
