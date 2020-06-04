//
//  WRSheetView.m
//  rehab
//
//  Created by Matech on 3/16/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRSheetView.h"

@interface WRSheetView()
{
    CGRect _panelFrame;
    UIView *_customView, *_panelView;
}
@end

@implementation WRSheetView

-(instancetype)initWithCustomView:(UIView*)view {
    CGRect frame = [UIApplication sharedApplication].keyWindow.bounds;
    if (self = [super initWithFrame:frame]) {
        
        _customView = view;
        
        CGFloat cx = frame.size.width, cy = 0 , x = 0, y = 0;
        
        x = 0, y = frame.size.height - cy;
        UIVisualEffectView *panel = [[UIVisualEffectView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        panel.backgroundColor = [UIColor whiteColor];
        panel.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        //[panel wr_roundBorderWithColor:[UIColor wr_themeColor]];
        [self addSubview:panel];
        
        CGFloat offset = WRUIOffset;
        x = offset, y = x;
        
        UIButton *button = [UIButton wr_lineBorderButtonWithTitle:NSLocalizedString(@"确定", nil)];
        button.titleLabel.font = [UIFont wr_labelFont];
        [button sizeToFit];
        cx = button.frame.size.width*2;
        x = panel.bounds.size.width - cx - offset;
        cy = button.frame.size.height + offset;
        button.frame = CGRectMake(x, y, cx, cy);
        [button addTarget:self action:@selector(onClickedOKButton:) forControlEvents:UIControlEventTouchUpInside];
        [panel addSubview:button];
        _rightButton = button;
        
        button = [UIButton wr_lineBorderButtonWithTitle:NSLocalizedString(@"取消", nil)];
        button.titleLabel.font = [UIFont wr_labelFont];
        x = offset;
        button.frame = CGRectMake(x, y, cx, cy);
        [button addTarget:self action:@selector(onClickedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        [panel addSubview:button];
        _leftButton = button;
        
        UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width,
                                                               CGRectGetMaxY(button.frame) + [WRUIConfig defaultLabelHeight] + offset)];
        [panel addSubview:bar];
        [panel sendSubviewToBack:bar];
        
        y = CGRectGetMaxY(button.frame) + offset;
        x = (frame.size.width - view.frame.size.width)/2;
        view.frame = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
        [panel addSubview:view];
        y += view.frame.size.height + offset;
        _panelFrame = CGRectMake(0, frame.size.height - y, frame.size.width, y);
        panel.frame = _panelFrame;
        _panelView = panel;
        
    }
    return self;
}

/*
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}
*/

#pragma mark - Control Event
-(IBAction)onClickedOKButton:(id)sender
{
    if(self.completion)
    {
        self.completion();
    }
    [self dismiss];
    
}

-(IBAction)onClickedCancelButton:(id)sender
{
    [self dismiss];
}

-(void)show {
    _panelView.frame = CGRectOffset(_panelFrame, 0, _panelView.frame.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        _panelView.frame = _panelFrame;
    }];
}

-(void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        _panelView.frame = CGRectOffset(_panelView.frame, 0, _panelView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -
+(void)showWithCustomView:(UIView*)customView completion:(void (^)())completion {
    WRSheetView* sheet = [[[self class] alloc] initWithCustomView:customView];
    sheet.completion = [completion copy];
    [sheet show];
}

@end
