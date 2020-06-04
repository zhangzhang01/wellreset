
//
//  RehabLevelView.m
//  rehab
//
//  Created by herson on 2016/11/24.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "RehabLevelView.h"

@implementation RehabLevelView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UILabel *label;
        CGFloat offset = WRUIOffset, x = offset, y = x, cx = frame.size.width - 2*x;
        
        x = offset;
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        label.textColor = [UIColor whiteColor];
        label.text = NSLocalizedString(@"选择方案", nil);
        label.font = [UIFont wr_titleFont];
        [label sizeToFit];
        label.frame = [Utility moveRect:label.frame x:x y:y];
        [self addSubview:label];
        y = label.bottom;
    }
    return self;
}

@end
