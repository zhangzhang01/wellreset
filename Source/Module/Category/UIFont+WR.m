//
//  UIFont+WR.m
//  rehab
//
//  Created by Matech on 2/29/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "UIFont+WR.h"
#import <YYKit/YYKit.h>
@implementation UIFont(WR)
//iphone6
+(instancetype)wr_smallestFont {
    return [UIFont systemFontOfSize:([UIFont smallSystemFontSize] - 2)];
}
//10
+(instancetype)wr_detailFont {
    return [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
}
//12
+(instancetype)wr_smallFont {
    return [UIFont systemFontOfSize:([UIFont smallSystemFontSize] + 2)];
}
//14
+(instancetype)wr_textFont {
    return [UIFont systemFontOfSize:[UIFont systemFontSize]];
}
//14
+(instancetype)wr_textFontWithScale {
    return [UIFont systemFontOfSize:[UIFont systemFontSize]*[UIScreen mainScreen].scale/2];
}
//根据屏幕计算
+(instancetype)wr_tinyFont {
    return [UIFont systemFontOfSize:([UIFont buttonFontSize] - 2)];
}
//16
+(instancetype)wr_lightFont {
    return [UIFont systemFontOfSize:([UIFont buttonFontSize] - 1)];
}
//17
+(instancetype)wr_smallTitleFont {
    return [UIFont systemFontOfSize:([UIFont buttonFontSize] + 1)];
}
//19
+(instancetype)wr_titleFont {
    return [UIFont systemFontOfSize:([UIFont buttonFontSize] + 3)];
}
//21
+(instancetype)wr_bigFont {
    return [UIFont systemFontOfSize:([UIFont labelFontSize]*2)];
}
//34
+(instancetype)wr_bigTitleFont {
    return [UIFont systemFontOfSize:([UIFont labelFontSize]*1.6)];
}
//27.2
+(instancetype)wr_largeFont {
    return [UIFont systemFontOfSize:([UIFont systemFontSize]*4)];
}
//56
+(instancetype)wr_labelFont {
    return [UIFont systemFontOfSize:[UIFont labelFontSize]];
}
//17
+(instancetype)wr_boldLabelFont {
    return [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
}
//19
@end
