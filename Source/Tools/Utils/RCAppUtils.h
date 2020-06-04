//
//  RCAppUtils.h
//  158Job
//
//  Created by Matech on 16/2/15.
//  Copyright © 2016年 X.H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCAppUtils : NSObject

+(void)showDateSelector:(NSInteger)tag container:(UIViewController*)vc completeBlock:(void (^)(NSDate *date))completeBlock;
+(UIAlertView*)showInputView:(NSInteger)tag title:(NSString*)title delegate:(id)delegate;
+(UIAlertView*)showInputView:(NSInteger)tag title:(NSString*)title message:(NSString*)message delegate:(id)delegate;

+(void)upgradeApp;

+(UIView *)createSectionHeaderWithTitle:(NSString *)title icon:(NSString *)iconName tintColor:(UIColor*)tintColor width:(CGFloat)width more:(BOOL)flag moreAction:(void(^)())action;
+(UIView *)createSectionHeaderWithTitle:(NSString *)title icon:(NSString *)iconName tintColor:(UIColor*)tintColor width:(CGFloat)width more:(BOOL)flag;

@end
