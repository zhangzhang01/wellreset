//
//  UIColor+WR.m
//  rehab
//
//  Created by Matech on 2/29/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "UIColor+WR.h"

@implementation UIColor(WR)

+(instancetype)wr_themeColor {
    return [UIColor colorWithHexString:@"3e90f7"];
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
    return [UIColor colorWithHexString:@"414141"];
}

+(instancetype)wr_detailTextColor {
    return [UIColor colorWithHexString:@"999999"];
}

@end
