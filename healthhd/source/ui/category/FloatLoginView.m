//
//  FloatLoginView.m
//  rehab
//
//  Created by yefangyang on 16/9/8.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "FloatLoginView.h"
#import "CodeView.h"
#import "LoginController.h"
#import "WRViewModel.h"

#define kMaxLength 11
#define countDownSeconds 60
@interface FloatLoginView ()<UITextFieldDelegate>

@end

@implementation FloatLoginView

-(instancetype)initWithFrame:(CGRect)frame;
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"0a0a0aaa"];
        CGFloat offset = WRUIOffset, x = 2 * offset, y = 80, cx, cy, buttonW = 44, scrollHeight = 220;
        CGFloat viewW = frame.size.width - 4 * offset;
        self.scrollWidth = viewW;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, viewW, scrollHeight)];
        scrollView.contentSize = CGSizeMake(viewW * 2, scrollView.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        //    scrollView.userInteractionEnabled = NO;
        scrollView.scrollEnabled = NO;
        [scrollView wr_roundBorderWithColor:[UIColor whiteColor]];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, scrollHeight)];
        messageView.backgroundColor = [UIColor whiteColor];
        messageView.layer.cornerRadius = 5.0f;
        [scrollView addSubview:messageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(buttonW, 0, viewW - 2 *buttonW, buttonW)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"登录", nil);
        label.textColor = [UIColor blackColor];
        label.font = [UIFont wr_smallTitleFont];
        [messageView addSubview:label];
        x = label.right;
        cx = buttonW;
        cy = buttonW;
        y = 0;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, cx, cy);
        [button setImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
        [messageView addSubview:button];
        [button addTarget:self action:@selector(onClickedCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        x = offset;
        y = button.bottom + offset;
        cx = viewW - 2 * offset;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        textField.frame = CGRectMake(x, y, cx, cy);
        [textField becomeFirstResponder];
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.placeholder = NSLocalizedString(@"请输入手机号码", nil);
        [textField addTarget:self action:@selector(onClickedPhoneTextField:) forControlEvents:UIControlEventEditingChanged];
        textField.delegate = self;
        [messageView addSubview:textField];
        self.phoneTextField = textField;
        
        y = textField.bottom + 1;
        cy = 1;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.frame = CGRectMake(x, y, cx, cy);
        [messageView addSubview:line];
        
        y = line.bottom + offset;
        cx = viewW - 2 * offset;
        x = (viewW - cx) / 2;
        cy = buttonW;
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [nextButton setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
        nextButton.frame = CGRectMake(x, y, cx, cy);
        nextButton.enabled = NO;
        nextButton.backgroundColor = [UIColor lightGrayColor];
        [nextButton wr_roundBorderWithColor:[UIColor lightGrayColor]];
        [messageView addSubview:nextButton];
        [nextButton addTarget:self action:@selector(onClickedNextButton:) forControlEvents:UIControlEventTouchUpInside];
        self.nextButton = nextButton;
        
        y = nextButton.bottom + WRUILittleOffset;
        x = offset;
        cx = viewW - 2 * offset;
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame = CGRectMake(x, y, cx, cy);
        moreButton.titleLabel.font = [UIFont wr_smallFont];
        [moreButton setTitle:NSLocalizedString(@"更多登录方式", nil) forState:UIControlStateNormal];
        moreButton.backgroundColor = [UIColor whiteColor];
        [moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [messageView addSubview:moreButton];
        [moreButton addTarget:self action:@selector(onClickedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *checkView = [[UIView alloc] initWithFrame:CGRectMake(viewW, 0, viewW, scrollHeight)];
        checkView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:checkView];
        
        x =  offset;
        y = 0;
        cx = buttonW;
        cy = cx;
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(x, y, cx, cy);
        [backButton setImage:[UIImage imageNamed:@"well_player_btn_back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(onClickedScrollButton:) forControlEvents:UIControlEventTouchUpInside];
        [checkView addSubview:backButton];
        
        x = backButton.right;
        cx = viewW - 2 * buttonW - 2 * offset;
        UILabel *labelPass = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, cx, buttonW)];
        labelPass.textAlignment = NSTextAlignmentCenter;
        labelPass.text = NSLocalizedString(@"输入验证码", nil);
        labelPass.textColor = [UIColor wr_titleTextColor];
        labelPass.font = [UIFont wr_smallTitleFont];
        [checkView addSubview:labelPass];
        
        x = labelPass.right;
        cx = buttonW;
        UIButton *buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonClose.frame = CGRectMake(x, y, cx, cy);
        [buttonClose setImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
        [checkView addSubview:buttonClose];
        [buttonClose addTarget:self action:@selector(onClickedCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        y = buttonClose.bottom + offset;
        x = 2 * offset;
        cx = 120;
        UILabel *labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        //    labelPhone.text = NSLocalizedString(@"输入验证码", nil);
        labelPhone.textColor = [UIColor lightGrayColor];
        [checkView addSubview:labelPhone];
        self.labelPhone = labelPhone;
        
        
        self.sumSeconds = countDownSeconds;
        
        x = labelPhone.right + offset;
        cx = 2 * buttonW;
        UIButton *buttonCountDown = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonCountDown.frame = CGRectMake(x, y, cx, cy);
        [buttonCountDown setTitle:[NSString stringWithFormat:@"%d",(int)_sumSeconds] forState:UIControlStateNormal];
        [buttonCountDown setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buttonCountDown wr_roundBorderWithColor:[UIColor wr_lightGray]];
        [buttonCountDown addTarget:self action:@selector(onClickedSendOnceMore:) forControlEvents:UIControlEventTouchUpInside];
        buttonCountDown.titleLabel.font = [UIFont wr_smallFont];
        [checkView addSubview:buttonCountDown];
        self.buttonCountDown = buttonCountDown;
        
        x = offset;
        y = buttonCountDown.bottom + 2*offset;
        cx = viewW - 2 * offset;
        cy = cx/4;
        CodeView *identifierView = [[CodeView alloc] initWithFrame:CGRectMake(x, y, cx, cy) num:4 lineColor:[UIColor wr_themeColor] textFont:20];
        [checkView addSubview:identifierView];
        identifierView.codeType = CodeViewTypeCustom;
        identifierView.hasUnderLine = NO;
        //分割线
        identifierView.hasSpaceLine = YES;
        //输入之后置空
        identifierView.emptyEditEnd = YES;
        identifierView.EndEditBlcok = ^(NSString *str) {
            [WRViewModel loginWithAccount:self.phoneTextField.text password:str type:@"smsCode" completion:^(NSError * _Nonnull error) {
                if (error) {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"登录失败", nil)];
                } else {
                    [Utility removeFromSuperViewWithAnimation:self completion:nil];
                }
            }];
            
        };
        self.identifierView = identifierView;
    }
    return self;
    
}

- (IBAction)onClickedPhoneTextField:(UITextField *)sender
{
    self.nextButton.enabled = [Utility ValidateMobile:sender.text];
    if (self.nextButton.enabled == YES) {
        self.nextButton.backgroundColor = [UIColor wr_themeColor];
    } else {
        self.nextButton.backgroundColor = [UIColor lightGrayColor];
    }
}

- (IBAction)onClickedNextButton:(UIButton *)sender
{
    [self endEditing:YES];
    [self.identifierView beginEdit];
    __weak __typeof(self) weakself = self;
    self.scrollView.contentOffset = CGPointMake(_scrollWidth , 0);
    self.labelPhone.text = self.phoneTextField.text;
    
    self.buttonCountDown.enabled = NO;
    
    if (!_countDownTimer) {
        _sumSeconds = countDownSeconds;
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            _sumSeconds--;
            NSString *text = nil;
            if (_sumSeconds == 0) {
                [_countDownTimer invalidate];
                _countDownTimer = nil;
                _sumSeconds = countDownSeconds;
                text = NSLocalizedString(@"重新发送", nil);
                weakself.buttonCountDown.enabled = YES;
            } else {
                text = [NSString stringWithFormat:@"%ds", (int)_sumSeconds];
            }
            [weakself.buttonCountDown setTitle:text forState:UIControlStateNormal];
            
        } repeats:YES];
        
    }
    [_countDownTimer fire];
    
    [WRViewModel requestSmsCodeWithPhone:self.phoneTextField.text type:@"login" completion:^(NSError *error) {
        if (error) {
            
        }
    }];
}


- (IBAction)onClickedScrollButton:(UIButton *)sender
{
    [self.identifierView endEditing:YES];
    [self.phoneTextField becomeFirstResponder];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)onClickedCloseButton:(UIButton *)sender
{
    [Utility removeFromSuperViewWithAnimation:self completion:nil];
}

- (IBAction)onClickedMoreButton:(UIButton *)sender
{
    __weak __typeof(self)weakself = self;
    [Utility removeFromSuperViewWithAnimation:self completion:^{
        if (weakself.clickMoreBlock) {
            weakself.clickMoreBlock();
        }
    }];
    
}

- (IBAction)onClickedSendOnceMore:(UIButton *)sender
{
    NSLog(@"%s",__func__);
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField == self.phoneTextField) {
        if (textField.text.length > (kMaxLength - 1) && string.length > 0) {
            return NO;
        }
        //self.nextButton.enabled = [Utility ValidateMobile:textField.text];
    }
    return YES;  
}
@end
