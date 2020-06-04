//
//  MessageLoginTool.h
//  rehab
//
//  Created by yefangyang on 16/9/8.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MessageLoginTool : NSObject<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *labelPhone;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIButton *buttonCountDown;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, assign) NSInteger sumSeconds;



- (void)showMessageLoginView;
@end
