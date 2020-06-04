//
//  RCAppUtils.m
//  158Job
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 X.H. All rights reserved.
//

#import "RCAppUtils.h"

@implementation RCAppUtils

+(void)showDateSelector:(NSInteger)tag container:(UIViewController *)vc completeBlock:(void (^)(NSDate *))completeBlock
{
    //CGFloat y = IOS7 ? 64 : 20;
    //CGFloat cy = vc.view.frame.size.height - y;
    //DatePickerView *view = [[DatePickerView alloc] initWithFrame:CGRectMake(0, y, vc.view.bounds.size.width,  cy)];
    //[view showWithBlock:vc.view completeBlock:completeBlock];
}

+(UIAlertView*)showInputView:(NSInteger)tag title:(NSString*)title delegate:(id)delegate
{
    return [self showInputView:tag title:title message:nil delegate:delegate];
}

+(UIAlertView *)showInputView:(NSInteger)tag title:(NSString *)title message:(NSString *)message delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:NSLocalizedString(@"取消", nil)
                                              otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    alertView.tag = tag;
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    return alertView;
}

+(void)upgradeApp {
    NSString *iTunesLink = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/utvgo-hd/id%@?ls=1&mt=8", @""];
    NSURL *url = [NSURL URLWithString:iTunesLink];
    [[UIApplication sharedApplication] openURL:url];
}


+(UIView *)createSectionHeaderWithTitle:(NSString *)title icon:(NSString *)iconName tintColor:(UIColor*)tintColor width:(CGFloat)width more:(BOOL)flag moreAction:(void (^)())action
{
    UIView *panel = [UIView new];
    UIImage *icon = [UIImage imageNamed:iconName];
    icon = [icon imageByResizeToSize:CGSizeMake(18, 18)];
    CGFloat x = 0, y = 0;
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:icon];
    iconImageView.tintColor = tintColor;
    [iconImageView wr_move:x y:y];
    [panel addSubview:iconImageView];
    x = CGRectGetMaxX(iconImageView.frame) + WRUINearbyOffset;
    
    BOOL biPad = [WRUIConfig IsHDApp];
    UIFont *textFont = biPad ? [UIFont wr_titleFont] : [UIFont wr_lightFont];
    
    CGFloat cx = 0;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, [WRUIConfig defaultLabelHeight])];
    label.font = textFont;
    label.textColor = tintColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = title;
    [label sizeToFit];
    [panel addSubview:label];
    
    CGFloat cy = MAX(iconImageView.frame.size.height, label.size.height);
    iconImageView.frame = CGRectMake(0, (cy - iconImageView.height)/2, iconImageView.width, iconImageView.height);
    x = iconImageView.right + WRUINearbyOffset;
    y = (cy - label.height)/2;
    label.frame = CGRectMake(x, y, label.width, label.height);
    
    panel.frame = CGRectMake(0, 0, width, cy);
    
    if (flag) {
        UILabel *titleLabel = label;
        label = [[UILabel alloc] init];
        label.font = textFont;
        label.textColor = tintColor;
        label.textAlignment = NSTextAlignmentLeft;
        label.text = NSLocalizedString(@"更多", nil);
        [label sizeToFit];
        label.frame = CGRectMake(width - label.width, titleLabel.top, label.width, titleLabel.height);
        [panel addSubview:label];
        label.userInteractionEnabled = YES;
        [label bk_whenTapped:action];
    }
    
    return panel;
}

+(UIView *)createSectionHeaderWithTitle:(NSString *)title icon:(NSString *)iconName tintColor:(UIColor*)tintColor width:(CGFloat)width more:(BOOL)flag
{
    return [RCAppUtils createSectionHeaderWithTitle:title icon:iconName tintColor:tintColor width:width more:flag moreAction:nil];
}
@end
