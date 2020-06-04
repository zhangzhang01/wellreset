//
//  WRUIConfig.m
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "WRUIConfig.h"

const CGFloat WRUIOffset = 10;
const CGFloat WRUIBigOffset = 20;
const CGFloat WRUIMidOffset = 8;
const CGFloat WRUILittleOffset = 5;
const CGFloat WRUINearbyOffset = 3;
const CGFloat WRUITextFieldHeight = 45;
const CGFloat WRUIButtonHeight = 38;
const CGFloat WRUISectionHeight = 10;
const CGFloat WRUILineHeight = 1;
const CGFloat WRUISectionLineHeight = 5;
const CGFloat WRNavBarHeight = 44;
const CGFloat WRStatusBarHeight = 20;
const BOOL WRAuthorModel = YES;
const CGFloat WRActivityIndicatorViewSize = 40;

NSString *WRSplashOutNotification = @"WRSplashOutNotification";
NSString *WRRegisterAutoLogInNotification = @"WRRegisterAutoLogInNotification";
NSString *WRUpdateSelfInfoNotification = @"WRUpdateSelfInfoNotification";
NSString *WRLogInNotification = @"WRLogInNotification";
NSString *WRLogOffNotification = @"WRLogOffNotification";
NSString *WRShowProTreatNotification = @"WRShowProTreatNotification";
NSString *WRReloadRehabNotification = @"WRReloadRehabNotification";

NSString *WRCellIdentifier = @"WRCell";

@implementation WRUIConfig

+ (BOOL)IsHDApp
{
    return IPAD_DEVICE;
}

+ (CGFloat)defaultLabelHeight {
    static CGFloat dy = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *text = @"test";
        CGSize size = [text sizeForFont:[UIFont systemFontOfSize:[UIFont labelFontSize]] size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MIN) mode:NSLineBreakByWordWrapping];
        dy = size.height;
    });
    return dy;
}

+ (UIImage *)defaultHeadImage {
    return [UIImage imageNamed:@"well_default_head"];
}

+ (NSString *)defaultName {
    return NSLocalizedString(@"过客", nil);
}

+(UIImageView *)createRoundImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.layer.borderWidth = 1.f;
    imageView.layer.borderColor = [UIColor wr_themeColor].CGColor;
    return imageView;
}

+(UIImageView *)createUserHeadImageView {
    UIImageView* imageView =  [WRUIConfig createRoundImageViewWithImage:[WRUIConfig defaultHeadImage]];
    BOOL biPad = [WRUIConfig IsHDApp];
    imageView.frame = CGRectMake(0, 0, 80, 80);
    if (biPad) {
        imageView.frame = CGRectMake(0, 0, 160, 160      );
    }
    imageView.layer.cornerRadius = imageView.width/2;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.borderWidth = 2;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    return imageView;
}

+(UIView *)createCentralWrapWithSubView:(UIView *)subView width:(CGFloat)cx offset:(CGFloat)offset {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cx, subView.frame.size.height + 2*offset)];
    [view addSubview:subView];
    subView.center = view.center;
    return view;
}

+(UIView *)createCentralWrapWithSubView:(UIView*)subView width:(CGFloat)cx {
    return [WRUIConfig createCentralWrapWithSubView:subView width:cx offset:WRUIOffset];
}

+(UIView *)createLineView:(UIView *)parentView height:(CGFloat)dy {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, parentView.frame.size.width, dy)];
    lineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [parentView addSubview:lineView];
    return lineView;
}

+(UIView *)tableView:(UITableView *)tableView createCustomSectionHeaderViewWithText:(NSString *)text headerHeight:(CGFloat)dy {
    dy = MAX(dy, [WRUIConfig defaultLabelHeight] + WRUIOffset);
    UIView* sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, dy)];
    //sectionHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    CGFloat x = 18, cx = sectionHeaderView.bounds.size.width - x, cy = [WRUIConfig defaultLabelHeight];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, dy - cy - 1, cx, cy)];
    titleLabel.textColor= [UIColor grayColor];
    titleLabel.text = text;
    titleLabel.font = [UIFont wr_detailFont];
    [sectionHeaderView addSubview:titleLabel];
    return sectionHeaderView;
}

+ (UIView *)tableView:(UITableView *)tableView createCustomSectionHeaderViewWithText:(NSString *)text {
    return [self tableView:tableView createCustomSectionHeaderViewWithText:text headerHeight:[WRUIConfig defaultLabelHeight]];
}

+(UIView*)createLineWithWidth:(CGFloat)cx {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cx, WRUISectionLineHeight)];
    view.backgroundColor = [UIColor colorWithHexString:@"d7eafd"];
    return view;
}

@end
