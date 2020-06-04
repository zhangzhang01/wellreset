//
//  Utility.h
//  UTVgo
//
//  Created by wen on 13-3-29.
//  Copyright (c) 2013年 UTVGO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#define DUMP NSLog(@"%s", __func__);

#define PNG_IMAGE(fileName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:fileName ofType:@"png"]]
#define PNG_NAMED(fileName, ext) [UIImage imageNamed:fileName#ext]
#define PNG_IMAGE_NAMED(fileName) [UIImage imageNamed:fileName]

#define FIXSTRING(x) if(x == nil) { x = @""; }

#define IPAD_DEVICE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

typedef NS_ENUM(NSInteger,ToastPosition)
{
    ToastPositionTop,
    ToastPositionCenter,
    ToastPositionBottom
};

@interface Utility : NSObject

+(NSString*)MD5Encrypt:(NSString *)str;
+(NSString*)URLEncode:(NSString*)src;

+(BOOL)IsEmptyString:(NSString *)string;
+(BOOL)IsString:(NSString*)string;
+(BOOL)ValidateIDCardNumber:(NSString *)value;
+(NSURL*)ValidateUrl:(NSString *)strURL;
+(BOOL)ValidateEmail:(NSString *)email;
+(BOOL)ValidateMobile:(NSString *)mobile;
+(BOOL)ValidateSmsCode:(NSString*)value;
+(BOOL)ValidatePassword:(NSString*)value;
+(BOOL)ValidateAccount:(NSString*)value;

+(BOOL)IsMute;
+(BOOL)CheckDeviceModel:(NSString*)model;
+(NSString*)GetCurrentDeviceName;
+(NSString *)GetLocalIPAddress;

+(void)Alert:(NSString*)text;
+(void)Alert:(NSString*)text title:(NSString*)title;

+(void)alertWithViewController:(UIViewController *)viewController title:(NSString *)title message:(NSString *)message;
+(void)alertWithViewController:(UIViewController *)viewController title:(NSString *)title;
+(void)messageBoxWithViewController:(UIViewController *)viewController title:(NSString *)title completion:(void(^)())completion;
+(void)alertWithViewController:(UIViewController *)viewController title:(NSString *)title buttonText:(NSString*)buttonText completion:(void (^)())completion;
+(void)retryAlertWithViewController:(UIViewController *)viewController title:(NSString *)title completion:(void(^)())completion;

+(void)showToast:(NSString*)text position:(ToastPosition)position;
+(UIViewController*)getSelfViewController:(UIView*)view;

+(void)viewAddToSuperViewWithAnimation:(UIView *)view superView:(UIView*)superView completion:(void(^)())completion;
+(void)removeFromSuperViewWithAnimation:(UIView*)view completion:(void(^)())completion;

+(void)showInTop:(UIView*)view;

+(CGRect)CenterRect:(CGPoint)point srcSize:(CGSize)srcSize parentSize:(CGSize)parentSize;

+(NSUInteger)GetBestRowCount:(CGFloat)width minCx:(CGFloat)minCx maxCx:(CGFloat)maxCx;
+(UIImage*)createImageWithColor:(UIColor *)color;
+(UIImage*)createImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;
+(UIImage*)createImageWithColor:(UIColor *)color size:(CGSize)size;

+(UIColor*)ColorFromHexCode:(NSString *)hexString;
+(UIColor*)ColorWithRGB:(NSUInteger)r g:(NSUInteger)g b:(NSUInteger)b;
+(UIColor*)ColorWithRGBA:(NSUInteger)r g:(NSUInteger)g b:(NSUInteger)b alpha:(CGFloat)alpha;

//if value less then 0 will not effect
+(CGRect)moveRect:(CGRect)src x:(CGFloat)x y:(CGFloat)y;
+(CGRect)resizeRect:(CGRect)src cx:(CGFloat)cx height:(CGFloat)cy;

+(NSString*)formatTimeSeconds:(NSInteger)seconds;

+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate;

+(UIColor*)mostColor:(UIImage*)image;
@end
