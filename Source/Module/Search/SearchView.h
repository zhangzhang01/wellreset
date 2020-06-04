//
//  SearchView.h
//  rehab
//
//  Created by yefangyang on 2016/10/9.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CodeView;
@interface SearchView : UIView
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UILabel *labelPhone;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *buttonCountDown;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, assign) NSInteger sumSeconds;
@property (nonatomic, strong) void (^clickMoreBlock)();
@property (nonatomic, assign) CGFloat scrollWidth;
@property (nonatomic, strong) CodeView *identifierView;
@property (nonatomic, copy) void (^onClickedSureButton)(NSString *text);

-(instancetype)initWithFrame:(CGRect)frame;
@end
