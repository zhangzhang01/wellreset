//
//  FloatLoginView.h
//  rehab
//
//  Created by yefangyang on 16/9/8.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CodeView;
@interface FloatLoginView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UILabel *labelPhone;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *buttonCountDown;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, assign) NSInteger sumSeconds;
@property (nonatomic, strong) void (^clickMoreBlock)();
@property (nonatomic, assign) CGFloat scrollWidth;
@property (nonatomic, strong) CodeView *identifierView;

-(instancetype)initWithFrame:(CGRect)frame;
@end
