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
#import <YYKit/YYKit.h>
#define kMaxLength 11
#define countDownSeconds 60
@interface FloatLoginView ()<UITextFieldDelegate>{
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
}

@property (nonatomic, strong) UIButton *codeButton;
@property (nonatomic, strong) UIButton *sureButton;
@end

@implementation FloatLoginView

-(instancetype)initWithFrame:(CGRect)frame;
{
    BOOL biPad = [WRUIConfig IsHDApp];
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"0a0a0aaa"];
        CGFloat offset = WRUIOffset, x , y, cx, cy, topInset, leftInset, phoneInset = 20, padInset = 80;
        if (biPad) {
            x = padInset;
            leftInset = 80;
            topInset = 60;
        } else {
            x = phoneInset;
            leftInset = 20;
            topInset = 0;
        }
        CGFloat viewW = frame.size.width - 2 * leftInset;
        self.scrollWidth = viewW;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, topInset, viewW, frame.size.height - 2 *topInset)];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollEnabled = NO;
        [scrollView wr_roundBorderWithColor:[UIColor whiteColor]];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        x = offset;
        y = offset;
        cx = _scrollView.frame.size.width - 2*x;
        cy = 32;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"登录", nil);
        label.textColor = [UIColor blackColor];
        label.font = [UIFont wr_lightFont];
        if (biPad) {
            label.font = [UIFont wr_titleFont];
        }
        [label sizeToFit];
        label.frame = [Utility moveRect:label.frame x:(viewW - label.width)/2 y:label.height];
        [scrollView addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"login_button_close"] forState:UIControlStateNormal];
        [button sizeToFit];
        button.centerY = label.centerY;
        button.left = viewW - button.width - button.centerY + button.height/2;
        [button addTarget:self action:@selector(onClickedCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        
        y = label.bottom + offset/2;

        UITextField *textField = nil;
        UIView *lineView = nil;
        
        NSArray *placeHolderArray = @[
                                      NSLocalizedString(@"请输入手机号码", nil),
                                      NSLocalizedString(@"请输入验证码", nil)
                                      ];
//        NSArray *leftImageArray = @[
//                                    @"",
//                                    @""
//                                    ];
        for(NSUInteger index = 0; index < placeHolderArray.count; index++)
        {
            x = 2 * offset;
            if(index == 0)
            {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                [button setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont wr_textFont];
                button.backgroundColor = [UIColor wr_selectLabelBgColor];
                button.enabled = NO;
                [button sizeToFit];
                CGFloat cx0 = button.frame.size.width + offset;
                button.frame = CGRectMake(cx - cx0 + offset, y + (cy - cy*2/3)/2, cx0, cy*2/3);
                [button wr_roundBorderWithColor:[UIColor clearColor]];
                [button addTarget:self action:@selector(onClickedGetCodeButton:) forControlEvents:UIControlEventTouchUpInside];
                [_scrollView addSubview:button];
                self.codeButton = button;
                
                textField = [[UITextField alloc] init];
                textField.borderStyle = UITextBorderStyleNone;
                textField.returnKeyType = UIReturnKeyNext;
                textField.keyboardType = UIKeyboardTypeURL;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.layer.cornerRadius = 8.0f;
                textField.layer.masksToBounds = YES;
                textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
                textField.layer.borderWidth = 0.0f;
                [textField becomeFirstResponder];
//                textField = [UITextField wr_iconTextField:leftImageArray[index]];
                [textField addTarget:self action:@selector(onClickedPhoneTextField:) forControlEvents:UIControlEventEditingChanged];
                textField.frame = CGRectMake(x, y, cx - 3 * offset - cx0, cy);
                lineView = [[UIView alloc] initWithFrame:CGRectMake( x, textField.bottom, cx - offset - cx0 - 2 * offset, 1)];
            }
            else
            {
                textField = [[UITextField alloc] init];
                textField.borderStyle = UITextBorderStyleNone;
                textField.returnKeyType = UIReturnKeyNext;
                textField.keyboardType = UIKeyboardTypeURL;
                textField.clearButtonMode = UITextFieldViewModeWhileEditing;
                textField.layer.cornerRadius = 8.0f;
                textField.layer.masksToBounds = YES;
                textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
                textField.layer.borderWidth = 0.0f;
                textField.frame = CGRectMake(x, y, cx - 2 * offset, cy);
                lineView = [[UIView alloc] initWithFrame:CGRectMake(x , textField.bottom, cx - 2 * offset, 1)];
                [textField addTarget:self action:@selector(onClickedPhoneTextField:) forControlEvents:UIControlEventEditingChanged];
            }
            textField.delegate = self;
            textField.placeholder = placeHolderArray[index];
            [textField setValue:[UIColor colorWithHexString:@"dddddd"] forKeyPath:@"_placeholderLabel.textColor"];
            textField.returnKeyType = UIReturnKeyNext;
            textField.textColor = [UIColor grayColor];
//            if (index == placeHolderArray.count - 1) {
//                UIImage *image = [UIImage imageNamed:@"register_eye_blue"];
//                UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
//                rightView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//                rightView.contentMode = UIViewContentModeCenter;
//                [rightView setImage:image forState:UIControlStateSelected];
//                [rightView setImage:[UIImage imageNamed:@"register_eye_gray"] forState:UIControlStateNormal];
//                textField.rightView = rightView;
//                textField.rightViewMode = UITextFieldViewModeAlways;
//                rightView.selected = NO;
//                [rightView addTarget:self action:@selector(onClickedEyeButton:) forControlEvents:UIControlEventTouchUpInside];
//            }
            
            lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
            [_scrollView addSubview:textField];
            [_scrollView addSubview:lineView];
            y += cy + offset;
            switch (index) {
                case 0:
                    _phoneTextField = textField;
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                    break;
                    
                case 1:
                    _codeTextField = textField;
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                    break;
                default:
                    break;
            }
        }
        cy = WRUIButtonHeight;
        cx = viewW - 4 * offset;
        x = 2 * offset;
        UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnOK setTitle:@"确定" forState:UIControlStateNormal];
        [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        btnOK.enabled = NO;
        btnOK.backgroundColor = [UIColor wr_selectLabelBgColor];
        btnOK.layer.masksToBounds = YES;
        btnOK.layer.cornerRadius = 5.0f;
        [btnOK addTarget:self action:@selector(onClickedOKButton:) forControlEvents:UIControlEventTouchUpInside];
        btnOK.frame = CGRectMake(x, y, cx, cy);
        [_scrollView addSubview:btnOK];
        self.sureButton = btnOK;
        y = btnOK.bottom + offset;
        
        UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        moreButton.frame = CGRectMake(x, y, cx, cy);
        moreButton.titleLabel.font = [UIFont wr_smallFont];
        if (biPad) {
            moreButton.titleLabel.font = [UIFont wr_lightFont];
        }
        [moreButton setTitle:NSLocalizedString(@"更多登录方式", nil) forState:UIControlStateNormal];
        moreButton.backgroundColor = [UIColor whiteColor];
        [moreButton setTitleColor:[UIColor wr_rehabBlueColor] forState:UIControlStateNormal];
        [_scrollView addSubview:moreButton];
        [moreButton addTarget:self action:@selector(onClickedMoreButton:) forControlEvents:UIControlEventTouchUpInside];
        
        _scrollView.height = moreButton.bottom + offset;
        
    }
    return self;
    
}

- (IBAction)onClickedOKButton:(UIButton *)sender
{
    if (![Utility ValidateMobile:[self pureTextFieldWithString:self.phoneTextField.text]]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
    } else {
        __weak __typeof(self)weakself = self;
        [SVProgressHUD showWithStatus:nil];
        NSLog(@"phoneTextField%@",[self pureTextFieldWithString:self.phoneTextField.text]);
        NSLog(@"codeTextField%@",self.codeTextField.text);
        [WRViewModel loginWithAccount:[self pureTextFieldWithString:self.phoneTextField.text] password:self.codeTextField.text type:@"smsCode" completion:^(NSError * _Nonnull error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"验证码错误", nil)];
                [weakself.codeTextField becomeFirstResponder];
            } else {
                [SVProgressHUD dismiss];
                [Utility removeFromSuperViewWithAnimation:self completion:nil];
            }
        }];
    }
}
- (void)valueChanged:(UITextField *)sender
{
    self.sureButton.enabled = [self isRightCode:sender.text];
    if (self.sureButton.enabled) {
        self.sureButton.backgroundColor = [UIColor wr_rehabBlueColor];
    } else {
        self.sureButton.backgroundColor = [UIColor wr_selectLabelBgColor];
    }
}

- (BOOL)isRightCode:(NSString *)text
{
    BOOL flag = NO;
    if (text.length == 4) {
        flag = YES;
    }
    return flag;
}

- (NSString *)pureTextFieldWithString:(NSString *)string
{
    NSString *text = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return text;
}

- (IBAction)onClickedGetCodeButton:(UIButton *)sender
{
    NSString *pureText = [self pureTextFieldWithString:self.phoneTextField.text];
    [SVProgressHUD showWithStatus:nil];
//    [self endEditing:YES];
    [self.codeTextField becomeFirstResponder];
    __weak __typeof(self) weakself = self;
//    self.labelPhone.text = pureText;
    if (_sumSeconds < countDownSeconds && _sumSeconds > 0) {
//        self.scrollView.contentOffset = CGPointMake(_scrollWidth , 0);
        [SVProgressHUD showWithStatus:NSLocalizedString(@"已发送验证码", nil)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    } else {
        
        
//        [WRViewModel requestSmsCodeWithPhone:pureText type:@"login" completion:^(NSError *error) {
//            if (error) {
//                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"获取验证码失败", nil)];
//            } else {
//                [SVProgressHUD dismiss];
////                self.scrollView.contentOffset = CGPointMake(_scrollWidth , 0);
//                [weakself smsCodeTimer];
//            }
//        }];
    }

}

- (IBAction)onClickedPhoneTextField:(UITextField *)sender
{
    if (sender == _phoneTextField) {
        //限制手机账号长度（有两个空格）
        if (sender.text.length > 13) {
            sender.text = [sender.text substringToIndex:13];
        }
//        NSString *pureText = [sender.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//        self.nextButton.enabled = [Utility ValidateMobile:pureText];
//        if (self.nextButton.enabled == YES) {
//            self.nextButton.backgroundColor = [UIColor wr_themeColor];
//        } else {
//            self.nextButton.backgroundColor = [UIColor wr_selectLabelBgColor];
//        }
        
        NSUInteger targetCursorPosition = [sender offsetFromPosition:sender.beginningOfDocument toPosition:sender.selectedTextRange.start];
        
        NSString *currentStr = [sender.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *preStr = [previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        //正在执行删除操作时为0，否则为1
        char editFlag = 0;
        if (currentStr.length <= preStr.length) {
            editFlag = 0;
        }
        else {
            editFlag = 1;
        }
        
        NSMutableString *tempStr = [NSMutableString new];
        
        int spaceCount = 0;
        if (currentStr.length < 3 && currentStr.length > -1) {
            spaceCount = 0;
        }else if (currentStr.length < 7 && currentStr.length > 2) {
            spaceCount = 1;
        }else if (currentStr.length < 12 && currentStr.length > 6) {
            spaceCount = 2;
        }
        
        for (int i = 0; i < spaceCount; i++) {
            if (i == 0) {
                [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 3)], @" "];
            }else if (i == 1) {
                [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(3, 4)], @" "];
            }else if (i == 2) {
                [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
            }
        }
        
        if (currentStr.length == 11) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
        }
        if (currentStr.length < 4) {
            [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
        }else if(currentStr.length > 3 && currentStr.length <12) {
            NSString *str = [currentStr substringFromIndex:3];
            [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
            if (currentStr.length == 11) {
                [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
            }
        }
        sender.text = tempStr;
        // 当前光标的偏移位置
        NSUInteger curTargetCursorPosition = targetCursorPosition;
        
        if (editFlag == 0) {
            //删除
            if (targetCursorPosition == 9 || targetCursorPosition == 4) {
                curTargetCursorPosition = targetCursorPosition - 1;
            }
        }else {
            //添加
            if (currentStr.length == 8 || currentStr.length == 4) {
                curTargetCursorPosition = targetCursorPosition + 1;
            }
        }
        self.codeButton.enabled = [Utility ValidateMobile:[self pureTextFieldWithString:sender.text]];
        if (self.codeButton.enabled) {
            self.codeButton.backgroundColor = [UIColor wr_rehabBlueColor];
        } else {
            self.codeButton.backgroundColor = [UIColor wr_selectLabelBgColor];
        }
        UITextPosition *targetPosition = [sender positionFromPosition:[sender beginningOfDocument] offset:curTargetCursorPosition];
        [sender setSelectedTextRange:[sender textRangeFromPosition:targetPosition toPosition :targetPosition]];
    } else {
        if (sender.text.length > 4) {
            sender.text = [sender.text substringToIndex:4];
        }
        self.sureButton.enabled = [self isRightCode:sender.text];
        if (self.sureButton.enabled) {
            self.sureButton.backgroundColor = [UIColor wr_rehabBlueColor];
        } else {
            self.sureButton.backgroundColor = [UIColor wr_selectLabelBgColor];
        }
    }
  
    
}

- (IBAction)onClickedNextButton:(UIButton *)sender
{
    NSString *pureText = [self pureTextFieldWithString:self.phoneTextField.text];
    [SVProgressHUD showWithStatus:nil];
    [self endEditing:YES];
    [self.identifierView beginEdit];
    __weak __typeof(self) weakself = self;
    self.labelPhone.text = pureText;
    if (_sumSeconds < countDownSeconds && _sumSeconds > 0) {
        self.scrollView.contentOffset = CGPointMake(_scrollWidth , 0);
        [SVProgressHUD showWithStatus:NSLocalizedString(@"已发送验证码", nil)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    } else {
//        [WRViewModel requestSmsCodeWithPhone:pureText type:@"login" completion:^(NSError *error) {
//            if (error) {
//                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"获取验证码失败", nil)];
//            } else {
//                [SVProgressHUD dismiss];
//                self.scrollView.contentOffset = CGPointMake(_scrollWidth , 0);
//                [weakself smsCodeTimer];
//            }
//        }];
    }
}


//- (IBAction)onClickedScrollButton:(UIButton *)sender
//{
//    [self.identifierView endEditing:YES];
//    [self.phoneTextField becomeFirstResponder];
//    [self.scrollView setContentOffset:CGPointZero animated:YES];
//}

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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [Utility removeFromSuperViewWithAnimation:self completion:nil];

}

- (IBAction)onClickedSendOnceMore:(UIButton *)sender
{
    __weak __typeof(self)weakself = self;
//    [WRViewModel requestSmsCodeWithPhone:[self pureTextFieldWithString:[self pureTextFieldWithString:self.phoneTextField.text]] type:@"login" completion:^(NSError *error) {
//        if (error) {
//            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"获取验证码失败", nil)];
//        } else {
//            [weakself smsCodeTimer];
//        }
//    }];
}

- (void)smsCodeTimer
{
    __weak __typeof(self) weakself = self;
    self.codeButton.enabled = NO;
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
                weakself.codeButton.enabled = YES;
            } else {
                text = [NSString stringWithFormat:@"%ds", (int)_sumSeconds];
            }
            [weakself.codeButton setTitle:text forState:UIControlStateNormal];
            
        } repeats:YES];
        
    }
    [_countDownTimer fire];
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    previousTextFieldContent = textField.text;
    previousSelection = textField.selectedTextRange;
    return YES;
}
@end
