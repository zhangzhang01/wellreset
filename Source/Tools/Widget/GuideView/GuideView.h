//
//  GuideView.h
//  GuideDemo
//
//  Created by 李剑钊 on 15/7/23.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideView : UIView

-(void)showInView:(UIView *)view maskFrames:(NSArray<NSValue*>*)frames labels:(NSArray<NSString*>*)labels;
-(void)showInView:(UIView *)view maskViews:(NSArray<UIView*>*)views labels:(NSArray<NSString*>*)labels;

@end
