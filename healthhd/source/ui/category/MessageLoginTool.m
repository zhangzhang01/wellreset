//
//  MessageLoginTool.m
//  rehab
//
//  Created by yefangyang on 16/9/8.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "MessageLoginTool.h"
#import "JCAlertView.h"
#import "TXTradePasswordView.h"
#import "CodeView.h"

@interface MessageLoginTool ()<TXTradePasswordViewDelegate>

@end
@implementation MessageLoginTool

- (void)showMessageLoginView
{
    CGFloat offset = WRUIOffset, x = 0, y = 0, cx, cy, buttonW = 44;
    CGFloat viewW = [UIScreen mainScreen].bounds.size.width - 4 * offset;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewW, 250)];
    scrollView.contentSize = CGSizeMake(viewW * 2, 250);
    scrollView.showsHorizontalScrollIndicator = NO;
    //    scrollView.userInteractionEnabled = NO;
    scrollView.scrollEnabled = NO;
    self.scrollView = scrollView;
    
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewW, 250)];
    messageView.backgroundColor = [UIColor whiteColor];
    messageView.layer.cornerRadius = 5.0f;
    [scrollView addSubview:messageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(buttonW, 0, viewW - 2 *buttonW, buttonW)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"登录", nil);
    label.textColor = [UIColor blackColor];
    [messageView addSubview:label];
    x = label.right;
    cx = buttonW;
    cy = buttonW;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, cx, cy);
    [button setImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
    [messageView addSubview:button];
    
    x = offset;
    y = button.bottom + 2 * offset;
    cx = viewW - 2 * offset;
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    textField.frame = CGRectMake(x, y, cx, cy);
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.placeholder = NSLocalizedString(@"请输入手机号码", nil);
    [textField addTarget:self action:@selector(onClickedPhoneTextField:) forControlEvents:UIControlEventEditingChanged];
    [messageView addSubview:textField];
    self.phoneTextField = textField;
    
    y = textField.bottom + 1;
    cy = 1;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.frame = CGRectMake(x, y, cx, cy);
    [messageView addSubview:line];
    
    y = line.bottom + 2 * offset;
    cx = viewW - 2 * offset;
    x = (viewW - cx) / 2;
    cy = buttonW;
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    nextButton.frame = CGRectMake(x, y, cx, cy);
    [nextButton wr_roundBorder];
    nextButton.backgroundColor = [UIColor lightGrayColor];
    [messageView addSubview:nextButton];
    [nextButton addTarget:self action:@selector(onClickedNextButton:) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton = nextButton;
    
    y = nextButton.bottom + offset;
    x = offset;
    cx = viewW - 2 * offset;
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(x, y, cx, cy);
    moreButton.titleLabel.font = [UIFont wr_smallFont];
    [moreButton setTitle:NSLocalizedString(@"更多登录方式", nil) forState:UIControlStateNormal];
    [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [messageView addSubview:moreButton];
    
    UIView *checkView = [[UIView alloc] initWithFrame:CGRectMake(viewW, 0, viewW, 250)];
    checkView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:checkView];
    
    x =  offset;
    y = 0;
    cx = buttonW;
    cy = cx;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(x, y, cx, cy);
    [backButton setImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
    [checkView addSubview:backButton];
    
    x = backButton.right;
    cx = viewW - 2 * buttonW - 2 * offset;
    UILabel *labelPass = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, cx, buttonW)];
    labelPass.textAlignment = NSTextAlignmentCenter;
    labelPass.text = NSLocalizedString(@"输入验证码", nil);
    labelPass.textColor = [UIColor blackColor];
    [checkView addSubview:labelPass];
    
    x = labelPass.right;
    cx = buttonW;
    UIButton *buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonClose.frame = CGRectMake(x, y, cx, cy);
    [buttonClose setImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
    [checkView addSubview:buttonClose];
    
    y = buttonClose.bottom + offset;
    x = offset;
    cx = 120;
    UILabel *labelPhone = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
    //    labelPhone.text = NSLocalizedString(@"输入验证码", nil);
    labelPhone.textColor = [UIColor blackColor];
    [checkView addSubview:labelPhone];
    self.labelPhone = labelPhone;
    
    NSInteger sumSeconds = 60;
    self.sumSeconds = sumSeconds;

    x = labelPhone.right + offset;
    cx = buttonW;
    UIButton *buttonCountDown = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonCountDown.frame = CGRectMake(x, y, cx, cy);
    [buttonCountDown setTitle:[NSString stringWithFormat:@"%d",(int)sumSeconds] forState:UIControlStateNormal];
    [buttonCountDown setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkView addSubview:buttonCountDown];
    self.buttonCountDown = buttonCountDown;
    
    x = offset;
    y = buttonCountDown.bottom + offset;
    cx = viewW - 2 * offset;

    CodeView *identifierView = [[CodeView alloc] initWithFrame:CGRectMake(x, y, cx, cy) num:6 lineColor:[UIColor lightGrayColor] textFont:16];
    [checkView addSubview:identifierView];
    identifierView.codeType = CodeViewTypeCustom;
    identifierView.hasUnderLine = NO;
    //分割线
    identifierView.hasSpaceLine = YES;
    //输入之后置空
    identifierView.emptyEditEnd = YES;
    identifierView.EndEditBlcok = ^(NSString *str) {
        NSLog(@"%@",str);
    };
    
    JCAlertView *alertView = [[JCAlertView alloc] initWithCustomView:scrollView dismissWhenTouchedBackground:YES];
    [alertView show];
}




- (IBAction)onClickedPhoneTextField:(UITextField *)sender
{
    self.nextButton.enabled = (sender.text.length == 11);
    if (self.nextButton.enabled == YES) {
        self.nextButton.backgroundColor = [UIColor wr_themeColor];
    } else {
        self.nextButton.backgroundColor = [UIColor lightGrayColor];
    }
}

- (IBAction)onClickedNextButton:(UIButton *)sender
{
__weak __typeof(self)weakself = self;
    self.scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width - 4 * 10 , 0);
    self.labelPhone.text = self.phoneTextField.text;

    self.buttonCountDown.enabled = NO;
    
    if (!_countDownTimer) {
        _sumSeconds = 60;
        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
            _sumSeconds--;
            NSString *text = nil;
            if (_sumSeconds == 0) {
                [_countDownTimer invalidate];
                _countDownTimer = nil;
                _sumSeconds = 60;
                text = NSLocalizedString(@"重新发送", nil);
                weakself.buttonCountDown.enabled = YES;
            } else {
                text = [NSString stringWithFormat:@"%ds", (int)_sumSeconds];
            }
            [weakself.buttonCountDown setTitle:text forState:UIControlStateNormal];
            
        } repeats:YES];
        
    }
    [_countDownTimer fire];
}
@end
