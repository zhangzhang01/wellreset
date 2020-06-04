//
//  WRUIConfig.h
//  rehab
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 Matech. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const CGFloat WRUIOffset;
extern const CGFloat WRUIBigOffset;
extern const CGFloat WRUILittleOffset;
extern const CGFloat WRUIMidOffset;
extern const CGFloat WRUINearbyOffset;
extern const CGFloat WRUITextFieldHeight;
extern const CGFloat WRUIButtonHeight;
extern const CGFloat WRUISectionHeight;
extern const CGFloat WRUILineHeight;
extern const CGFloat WRUISectionLineHeight;
extern const CGFloat WRNavBarHeight;
extern const CGFloat WRStatusBarHeight;
extern const CGFloat WRNavBarHeight;
extern const CGFloat WRActivityIndicatorViewSize;

extern const BOOL WRAuthorModel;

extern NSString *WRSplashOutNotification;
extern NSString *WRRegisterAutoLogInNotification;
extern NSString *WRUpdateSelfInfoNotification;
extern NSString *WRLogInNotification;
extern NSString *WRLogOffNotification;
extern NSString *WRShowProTreatNotification;
extern NSString *WRReloadRehabNotification;

extern NSString *WRCellIdentifier;

@interface WRUIConfig : NSObject

+ (BOOL)IsHDApp;
+ (CGFloat)defaultLabelHeight;
+ (UIImage*)defaultHeadImage;
+ (NSString*)defaultName;

+(UIImageView *)createRoundImageViewWithImage:(UIImage*)image;
+(UIImageView*)createUserHeadImageView;

+(UIView *)createCentralWrapWithSubView:(UIView*)subView width:(CGFloat)cx offset:(CGFloat)offset;
+(UIView*)createCentralWrapWithSubView:(UIView*)subView width:(CGFloat)cx;

+(UIView*)createLineView:(UIView*)parentView height:(CGFloat)dy;

+(UIView*)tableView:(UITableView*)tableView createCustomSectionHeaderViewWithText:(NSString*)text;
+(UIView*)tableView:(UITableView*)tableView createCustomSectionHeaderViewWithText:(NSString*)text headerHeight:(CGFloat)dy;

+(UIView*)createLineWithWidth:(CGFloat)cx;

@end

