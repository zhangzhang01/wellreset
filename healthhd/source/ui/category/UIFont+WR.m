//
//  UIFont+WR.m
//  rehab
//
//  Created by Matech on 2/29/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "UIFont+WR.h"

@implementation UIFont(WR)
+(instancetype)wr_smallestFont {
    return [UIFont systemFontOfSize:([UIFont smallSystemFontSize] - 2)];
}

+(instancetype)wr_detailFont {
    return [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
}

+(instancetype)wr_smallFont {
    return [UIFont systemFontOfSize:([UIFont smallSystemFontSize] + 2)];
}

+(instancetype)wr_textFont {
    return [UIFont systemFontOfSize:[UIFont systemFontSize]];
}

+(instancetype)wr_textFontWithScale {
    return [UIFont systemFontOfSize:[UIFont systemFontSize]*[UIScreen mainScreen].scale/2];
}

+(instancetype)wr_tinyFont {
    return [UIFont systemFontOfSize:([UIFont buttonFontSize] - 2)];
}

+(instancetype)wr_lightFont {
    return [UIFont systemFontOfSize:([UIFont buttonFontSize] - 1)];
}

+(instancetype)wr_smallTitleFont {
    return [UIFont systemFontOfSize:([UIFont buttonFontSize] + 1)];
}

+(instancetype)wr_titleFont {
    return [UIFont systemFontOfSize:([UIFont buttonFontSize] + 3)];
}

+(instancetype)wr_bigFont {
    return [UIFont systemFontOfSize:([UIFont labelFontSize]*2)];
}

+(instancetype)wr_bigTitleFont {
    return [UIFont systemFontOfSize:([UIFont labelFontSize]*1.6)];
}

+(instancetype)wr_labelFont {
    return [UIFont systemFontOfSize:[UIFont labelFontSize]];
}

+(instancetype)wr_boldLabelFont {
    return [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
}
@end
