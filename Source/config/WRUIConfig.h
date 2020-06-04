//
//  WRUIConfig.h
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Btnblock)();
extern const CGFloat WRUIOffset;
extern const CGFloat WRUIBigOffset;
extern const CGFloat WRUIDiffautOffset;
extern const CGFloat WRUILittleOffset;
extern const CGFloat WRUIMidOffset;
extern const CGFloat WRUINearbyOffset;
extern const CGFloat WRUITextFieldHeight;
extern const CGFloat WRUIButtonHeight;
extern const CGFloat WRUISectionHeight;
extern const CGFloat WRLoginOrRegisterMaxWidth;
extern const CGFloat WRUILineHeight;
extern const CGFloat WRUISectionLineHeight;
extern const CGFloat WRNavBarHeight;
extern const CGFloat WRStatusBarHeight;
extern const CGFloat WRNavBarHeight;
extern const CGFloat WRActivityIndicatorViewSize;
extern const CGFloat WRMeButtonHeight;
extern const BOOL WRAuthorModel;
extern const CGFloat WRReplyCellIconWidthAndHeight;
extern const CGFloat WRNextWeight;
extern const CGFloat WRNextHeight;
extern const CGFloat WRCornerRadius;
extern const CGFloat WRBorderWidth;
extern const CGFloat WRTabbarHeight;
extern NSString *WRSplashOutNotification;
extern NSString *WRRegisterAutoLogInNotification;
extern NSString *WRUpdateSelfInfoNotification;
extern NSString *WRLogInNotification;
extern NSString *WRLogOffNotification;
extern NSString *WRShowProTreatNotification;
extern NSString *WRReloadRehabNotification;
extern NSString *WRReloadFavorNotification;
extern NSString *WRUpdateUserRehabNotification;
extern NSString *WRUpdateExperise;
extern NSString *WRCellIdentifier;

extern const CGFloat WRDetailFont;
extern const CGFloat WRTitleFont;
extern const CGFloat WRMidButtonFont;
extern const CGFloat WRBigButtonFont;


@interface WRUIConfig : NSObject

+ (BOOL)IsHDApp;
+ (CGFloat)defaultLabelHeight;
+ (UIImage*)defaultHeadImage;
+ (UIImage *)defaultNavImage;
+ (UIImage *)defaultBarImage;
+ (NSString*)defaultName;

+(UIImageView *)createRoundImageViewWithImage:(UIImage*)image;
+(UIImageView*)createUserHeadImageView;

+(UIView *)createCentralWrapWithSubView:(UIView*)subView width:(CGFloat)cx offset:(CGFloat)offset;
+(UIView*)createCentralWrapWithSubView:(UIView*)subView width:(CGFloat)cx;

+(UIView*)createLineView:(UIView*)parentView height:(CGFloat)dy;

+(UIView*)tableView:(UITableView*)tableView createCustomSectionHeaderViewWithText:(NSString*)text;
+(UIView*)tableView:(UITableView*)tableView createCustomSectionHeaderViewWithText:(NSString*)text headerHeight:(CGFloat)dy;

+(UIView*)createLineWithWidth:(CGFloat)cx;

+(UIView*)createNoDataViewWithFrame:(CGRect)frame title:(NSString*)title image:(UIImage*)image;
+(UIView *)createNoDataViewWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image button:(NSString*)button block:(Btnblock)block;

+(void)updateSelfHeadForImageView:(UIImageView*)imageView;

@end

