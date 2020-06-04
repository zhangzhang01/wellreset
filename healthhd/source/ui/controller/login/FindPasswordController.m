//
//  FindPasswordController.m
//  rehab
//
//  Created by Matech on 3/4/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "FindPasswordController.h"
#import "WToast.h"

enum { tagResetBySmsCode, tagResetByEmail };

@interface FindPasswordController ()<UITextFieldDelegate>
{
    UIScrollView *_mainSubEMailScrollView, *_mainSubPhoneScrollView;
    UITextField *_emailTextField, *_phoneTextField, *_codeTextField, *_passwordTextField, *_validatePasswordTextField;
    __weak UIButton* _getCodeButton;
    __weak UISegmentedControl *_segmentedControl;
    
    CGRect _scrollFrame;
    
    NSTimer *_timer;
    NSUInteger _timeCount;
}
@end

@implementation FindPasswordController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    // Custom initialization
    [self createBackBarButtonItem];
    
    self.title = NSLocalizedString(@"找回密码", nil);
    CGFloat x = 0, y = 0, cx = 0, cy = 0, offset = WRUIOffset;
    
    CGRect frame = self.view.bounds;
    if([WRUIConfig IsHDApp]) {
        frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width*0.7f, [[UIScreen mainScreen] bounds].size.height*0.7f);
    }

    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"手机找回", nil), NSLocalizedString(@"邮箱找回", nil)]];
    segCtrl.tintColor = [UIColor whiteColor];
    segCtrl.selectedSegmentIndex = tagResetByEmail;
    [segCtrl sizeToFit];
    [segCtrl addTarget:self action:@selector(onSegmentControlValueChange:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl = segCtrl;
    self.navigationItem.titleView = segCtrl;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.hidden = YES;
    [self.view addSubview:scrollView];
    _mainSubEMailScrollView = scrollView;
    
    x = offset;
    y = offset;
    cx = _mainSubEMailScrollView.frame.size.width - 2*x;
    cy = WRUITextFieldHeight;
    offset = x;
    
    UITextField *textField = nil;
    NSArray *titleArray = @[NSLocalizedString(@"电子邮箱", nil), NSLocalizedString(@"手机号码", nil)];
    for(NSUInteger index = 0; index < 1; index++)
    {
        textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        textField.placeholder = [titleArray objectAtIndex:index];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyNext;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        [_mainSubEMailScrollView addSubview:textField];
        y += cy + offset;
        
        switch (index) {
            case 0:
                _emailTextField = textField;
                textField.keyboardType = UIKeyboardTypeEmailAddress;
                textField.returnKeyType = UIReturnKeySend;
                break;
                
            default:
                break;
        }
    }
    
    cy = WRUIButtonHeight;
    cx = CGRectGetWidth(frame) - 6*offset;
    x = (frame.size.width - cx)/2;
    UIButton *btnOK = [UIButton wr_buttonWithTitle:NSLocalizedString(@"确定", nil)];
    btnOK.tag = tagResetByEmail;
    [btnOK addTarget:self action:@selector(onClickedOKButton:) forControlEvents:UIControlEventTouchUpInside];
    btnOK.frame = CGRectMake(x, y, cx, cy);
    [_mainSubEMailScrollView addSubview:btnOK];
    
    scrollView = [[UIScrollView alloc] initWithFrame:_mainSubEMailScrollView.frame];
    [self.view addSubview:scrollView];
    _mainSubPhoneScrollView = scrollView;
    
    x = offset;
    y = offset;
    cx = frame.size.width - 2*x;
    cy = WRUITextFieldHeight;
    offset = x;
    NSArray *placeHolderArray = @[
                                  NSLocalizedString(@"手机号码", nil),
                                  NSLocalizedString(@"6位数字验证码", nil),
                                  NSLocalizedString(@"4-16位数字或字母", nil),
                                  NSLocalizedString(@"确认密码", nil),
                                  ];
    for(NSUInteger index = 0; index < placeHolderArray.count; index++)
    {
        if(index == 1)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            [button setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
            [button sizeToFit];
            CGFloat cx0 = button.frame.size.width*3/2;
            button.frame = CGRectMake(x + cx - cx0, y, cx0, cy);
            [button wr_roundBorderWithColor:[UIColor lightGrayColor]];
            [button addTarget:self action:@selector(onClickedGetCodeButton:) forControlEvents:UIControlEventTouchUpInside];
            [_mainSubPhoneScrollView addSubview:button];
            _getCodeButton = button;
            
            textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, CGRectGetMinX(button.frame) - offset - x, cy)];
        }
        else
        {
            textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y,  cx, cy)];
        }
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = [placeHolderArray objectAtIndex:index];
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyNext;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        [_mainSubPhoneScrollView addSubview:textField];
        
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
                
            case 2:
                textField.secureTextEntry = YES;
                _passwordTextField = textField;
                break;
                
            case 3:
                textField.returnKeyType = UIReturnKeySend;
                textField.secureTextEntry = YES;
                _validatePasswordTextField = textField;
                break;
                
            default:
                break;
        }
    }
    cy = WRUIButtonHeight;
    cx = CGRectGetWidth(frame) - 6*offset;
    x = (frame.size.width - cx)/2;
    btnOK = [UIButton wr_buttonWithTitle:NSLocalizedString(@"重置", nil)];
    btnOK.tag = tagResetBySmsCode;
    [btnOK addTarget:self action:@selector(onClickedOKButton:) forControlEvents:UIControlEventTouchUpInside];
    btnOK.frame = CGRectMake(x, y, cx, cy);
    [_mainSubPhoneScrollView addSubview:btnOK];
    
    UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    sigleTapRecognizer.numberOfTapsRequired = 1;
    [_mainSubEMailScrollView addGestureRecognizer:sigleTapRecognizer];
    [_mainSubPhoneScrollView addGestureRecognizer:sigleTapRecognizer];
    
    [WRNetworkService pwiki:@"找回密码"];
    
    _segmentedControl.selectedSegmentIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == _phoneTextField)
    {
        [_codeTextField becomeFirstResponder];
    }
    else if(textField == _codeTextField)
    {
        [_passwordTextField becomeFirstResponder];
    }
    else if(textField == _passwordTextField)
    {
        [_validatePasswordTextField becomeFirstResponder];
    }
    else if((textField == _validatePasswordTextField) || (textField == _emailTextField))
    {
        [self onClickedOKButton:nil];
    }
    return YES;
}


#pragma mark - Control Event
-(IBAction)onSegmentControlValueChange:(UISegmentedControl*)sender
{
    _mainSubEMailScrollView.hidden = (sender.selectedSegmentIndex != tagResetByEmail);
    _mainSubPhoneScrollView.hidden = !_mainSubEMailScrollView.hidden;
}

-(void)handleTapGesture:( UITapGestureRecognizer *)tapRecognizer
{
    [self.view endEditing:YES];
}

-(IBAction)onClickedGetCodeButton:(UIButton*)sender
{
    if(![Utility ValidateMobile:_phoneTextField.text])
    {
        [Utility Alert:NSLocalizedString(@"手机号格式错误", nil)];
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:nil];
        [WRViewModel requestSmsCodeWithPhone:_phoneTextField.text type:@"pwd" completion:^(NSError * error) {
            [SVProgressHUD dismiss];
            if (error) {
                [Utility retryAlertWithViewController:weakSelf title:error.domain completion:^{
                    [weakSelf onClickedGetCodeButton:sender];
                }];
            } else {
                //[WToast showWithText:NSLocalizedString(@"验证码已发送", nil)];
            }
        }];
    
        _getCodeButton.enabled = NO;
        if (!_timer) {
            _timeCount = WRSmsCodeTime;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
                _timeCount--;
                NSString *text = nil;
                if (_timeCount == 0) {
                    [_timer invalidate];
                    _timer = nil;
                    _timeCount = WRSmsCodeTime;
                    text = NSLocalizedString(@"获取验证码", nil);
                    _getCodeButton.enabled = YES;
                } else {
                    text = [NSString stringWithFormat:@"%ds", (int)_timeCount];
                }
                [_getCodeButton setTitle:text forState:UIControlStateNormal];
                
            } repeats:YES];
            
        }
        [_timer fire];
    }
}

-(IBAction)onClickedOKButton:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    BOOL bSuccess = NO;
    if(_segmentedControl.selectedSegmentIndex == tagResetByEmail)
    {
        do {
            if([Utility IsEmptyString:_emailTextField.text])
            {
                [Utility Alert:NSLocalizedString(@"请填写邮箱", nil)];
                break;
            }
            
            if(_segmentedControl.selectedSegmentIndex == 1 && ![Utility ValidateEmail:_emailTextField.text])
            {
                [Utility Alert:NSLocalizedString(@"邮箱格式错误", nil)];
                break;
            }
            
            bSuccess = YES;
        } while (NO);
    }
    else
    {
        do {
            if(![Utility ValidateMobile:_phoneTextField.text])
            {
                [Utility Alert:NSLocalizedString(@"手机号不正确", nil)];
                break;
            }
            
            if(![Utility ValidateSmsCode:_codeTextField.text])
            {
                [Utility Alert:NSLocalizedString(@"验证码不正确", nil)];
                break;
            }
            
            if( ![Utility ValidatePassword:_passwordTextField.text] ||
               ![Utility ValidatePassword:_validatePasswordTextField.text] )
            {
                [Utility Alert:NSLocalizedString(@"密码或者确认密码不正确", nil)];
                break;
            }
            
            if(![_passwordTextField.text isEqualToString:_validatePasswordTextField.text])
            {
                [Utility Alert:NSLocalizedString(@"两次密码不一致", nil)];
                break;
            }
            
            bSuccess = YES;
        } while (NO);
    }
    
    if(bSuccess)
    {
        __weak __typeof(self) weakSelf = self;
        __weak __typeof(sender) weakSender = sender;
        
        NSString *phone = _phoneTextField.text;
        NSString *email = _emailTextField.text;
        NSString *password = _passwordTextField.text;
        NSString *code = _codeTextField.text;
        NSString *notifyText = NSLocalizedString(@"密码重置成功", nil);
        if (_segmentedControl.selectedSegmentIndex == tagResetByEmail) {
            phone = @"";
            password = @"";
            code = @"";
            notifyText = NSLocalizedString(@"密码重置成功，新密码已经发至您所注册的邮箱", nil);
        } else {
            email = @"";
        }
        
        [SVProgressHUD showWithStatus:nil];
        
        [WRViewModel resetPasswordWithEmail:email
                                      phone:phone
                                    smsCode:code
                                   password:password
                                 completion:^(NSError * error) {
                                     [SVProgressHUD dismiss];
                                     
                                     if (error) {
                                         [Utility retryAlertWithViewController:weakSelf title:error.domain completion:^{
                                             [weakSender sendActionsForControlEvents:UIControlEventTouchUpInside];
                                         }];
                                     } else {
                                         UIAlertController *controller = [UIAlertController alertControllerWithTitle:notifyText message:nil preferredStyle:UIAlertControllerStyleAlert];
                                         [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"返回", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                             [weakSelf.navigationController popViewControllerAnimated:YES];
                                         }]];
                                         [weakSelf presentViewController:controller animated:YES completion:nil];
                                     }
                                     
                                 }];
    }
}


@end
