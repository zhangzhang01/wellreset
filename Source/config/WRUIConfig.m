//
//  WRUIConfig.m
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import "WRUIConfig.h"
#import "Masonry/Masonry.h"
#import <YYKit/YYKit.h>
const CGFloat WRUIOffset = 10;
const CGFloat WRUIBigOffset = 20;
const CGFloat WRUIDiffautOffset = 15;
const CGFloat WRUIMidOffset = 18;
const CGFloat WRUILittleOffset = 5;
const CGFloat WRUINearbyOffset = 3;
const CGFloat WRUITextFieldHeight = 32;
const CGFloat WRLoginOrRegisterMaxWidth = 320;
const CGFloat WRUIButtonHeight = 44;
const CGFloat WRUISectionHeight = 10;
const CGFloat WRUILineHeight = 1;
const CGFloat WRUISectionLineHeight = 5;
const CGFloat WRNavBarHeight = 44;
const CGFloat WRStatusBarHeight = 20;
const BOOL WRAuthorModel = YES;
const CGFloat WRActivityIndicatorViewSize = 40;
const CGFloat WRMeButtonHeight = 45;
const CGFloat WRReplyCellIconWidthAndHeight = 28;
const CGFloat WRNextWeight = 8.5;
const CGFloat WRNextHeight = 14;
const CGFloat WRCornerRadius = 4;
const CGFloat WRBorderWidth = 1;
 const CGFloat WRTabbarHeight = 48;
NSString *WRSplashOutNotification = @"WRSplashOutNotification";
NSString *WRRegisterAutoLogInNotification = @"WRRegisterAutoLogInNotification";
NSString *WRUpdateSelfInfoNotification = @"WRUpdateSelfInfoNotification";
NSString *WRLogInNotification = @"WRLogInNotification";
NSString *WRLogOffNotification = @"WRLogOffNotification";
NSString *WRShowProTreatNotification = @"WRShowProTreatNotification";
NSString *WRReloadRehabNotification = @"WRReloadRehabNotification";
NSString *WRReloadFavorNotification = @"WRReloadFavorNotification";
NSString *WRUpdateUserRehabNotification = @"WRUpdateUserRehab";
NSString *WRCellIdentifier = @"WRCell";
NSString *WRUpdateExperise = @"WRUpdateExperise";


const CGFloat WRDetailFont = 13;
const CGFloat WRTitleFont = 15;
const CGFloat WRMidButtonFont = 14;
const CGFloat WRBigButtonFont = 15;


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

+ (UIImage *)defaultNavImage {
    return [UIImage imageNamed:@"well_nav_shandow"];
}

+ (UIImage *)defaultBarImage {
    return [UIImage imageNamed:@"well_nav_bar"];
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
        imageView.frame = CGRectMake(0, 0, 120, 120);
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

+(UIView *)createNoDataViewWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image
{
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    
    const CGFloat offset = WRUIOffset;
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:image];
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.top.mas_equalTo(bgView).with.offset(0.3*YYScreenSize().height);
        make.size.mas_equalTo(CGSizeMake(image.size.height, image.size.width));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    titleLabel.tag =1001;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:title];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.left.mas_equalTo(bgView).with.offset(offset);
        make.right.mas_equalTo(bgView).with.offset(-offset);
        make.top.mas_equalTo(backImageView.mas_bottom).offset(offset);
    }];
    
    
    
    return bgView;
}

+(UIView *)createNoDataViewWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image button:(NSString*)button block:(Btnblock)block
{
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    
    const CGFloat offset = WRUIOffset;
    UIImageView *backImageView = [[UIImageView alloc] initWithImage:image];
    backImageView.contentMode = UIViewContentModeScaleAspectFit;
    [bgView addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(bgView.mas_centerX);
        make.top.mas_equalTo(bgView).with.offset(0.3*YYScreenSize().height);
        make.size.mas_equalTo(CGSizeMake(image.size.height, image.size.width));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 2;
    titleLabel.tag =1001;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:title];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [titleLabel setTextColor:[UIColor colorWithHexString:@"c9c9c9"]];
    [bgView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.left.mas_equalTo(bgView).with.offset(offset);
        make.right.mas_equalTo(bgView).with.offset(-offset);
        make.top.mas_equalTo(backImageView.mas_bottom).offset(offset);
    }];
    
    
    UIButton* btn = [UIButton new];
    btn.tag = 1001;
    [btn setTitle:button forState:0];
    [btn setTitleColor:[UIColor wr_themeColor]  forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds =YES;
    btn.layer.borderColor = [UIColor wr_themeColor].CGColor;
    btn.layer.borderWidth = 1;
    [bgView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(120, 32));
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(WRUIBigOffset);
    }];
    btn.userInteractionEnabled = YES;
    [btn bk_whenTapped:^{
        block();
    }];
    
    return bgView;
}



+(void)updateSelfHeadForImageView:(UIImageView *)imageView
{
    BOOL defaultHeadImageFlag = YES;
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    if ([selfInfo isLogged]) {
        if (![Utility IsEmptyString:selfInfo.headImageUrl]) {
            defaultHeadImageFlag = NO;
            [imageView setImageWithUrlString:selfInfo.headImageUrl holderImage:[WRUIConfig defaultHeadImage]];
        }
    }
    if (defaultHeadImageFlag) {
        imageView.image = [WRUIConfig defaultHeadImage];
    }
}

@end
