//
//  ShowAlertView.m
//  rehab
//
//  Created by yefangyang on 2016/12/21.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "ShowAlertView.h"
#import <YYKit/YYKit.h>
@implementation ShowAlertView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title titleArray:(NSArray *)titleArray {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"0a0a0aaa"];
        CGFloat x, y, cx, cy, offset, leftInset;
        x = 0;
        y = 0;
        cy = 0;
        offset = WRUIOffset;
        leftInset = 2 *WRUIOffset;
        cx = frame.size.width - 2 * leftInset;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftInset, y, cx, cy)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.layer.cornerRadius = 5.0f;
        bgView.layer.masksToBounds = YES;
        [self addSubview:bgView];
        
        UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cx, 0)];
        topView.image = [UIImage imageNamed:@"perfect_top_bg"];
        [bgView addSubview:topView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, offset, cx, cy)];
        label.text = title;
        label.font = [UIFont wr_smallTitleFont];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.frame = [Utility moveRect:label.frame x:(cx - label.width)/2 y:-1];
        [topView addSubview:label];
        topView.height = label.bottom + offset;
        y = topView.bottom + offset;
        
        for (int i = 0; i < titleArray.count; i++) {
            
            UIView *pointView = [self createPointView];
            [bgView addSubview:pointView];
            pointView.frame = [Utility moveRect:pointView.frame x:offset y:y + offset];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(pointView.right + WRUIOffset, y, cx - pointView.right - 2 * offset, cy)];
            label.textColor = [UIColor darkGrayColor];
            label.numberOfLines = 0;
            label.text = titleArray[i];
            [label sizeToFit];
            [bgView addSubview:label];
            
            y = label.bottom + offset;
        }
        bgView.height = y + offset;
        bgView.frame = [Utility moveRect:bgView.frame x:-1 y:(frame.size.height - bgView.height)/2];
        
    }
    return self;
}

-(UIView*)createPointView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
    view.backgroundColor = [UIColor wr_rehabBlueColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.width/2;
    return view;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [Utility removeFromSuperViewWithAnimation:self completion:^{
        
    }];
}

@end
