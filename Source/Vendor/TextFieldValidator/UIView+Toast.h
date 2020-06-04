//
//  UIView+Toast.h
//  HUDNavigate
//
//  Created by com on 15/7/8.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Toast)


// each makeToast method creates a view and displays it as toast
- (void)makeToast:(NSString *)message;
//- (void)makeToast:(NSString *)message duration:(CGFloat)interval;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title image:(UIImage *)image;
- (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image;

// displays toast with an activity spinner
- (void)makeToastActivity;
- (void)makeToastActivity:(id)position;
- (void)hideToastActivity;

// the showToast methods display any view as toast
- (void)showToast:(UIView *)toast;
- (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point;



@end
