//
//  FindPasswordController.m
//  rehab
//
//  Created by Matech on 3/4/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "FindPasswordController.h"
#import "WToast.h"
#import "IQKeyboardManager/IQKeyboardManager.h"
#import "JCAlertView.h"
#import "ZYEALView.h"
#import <YYKit/YYKit.h>
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
//    self.edgesForExtendedLayout = UIRectEdgeNone;
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
    segCtrl.tintColor = [UIColor wr_rehabBlueColor];
    [segCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    segCtrl.selectedSegmentIndex = tagResetByEmail;
    [segCtrl sizeToFit];
    [segCtrl addTarget:self action:@selector(onSegmentControlValueChange:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl = segCtrl;
    self.navigationItem.titleView = segCtrl;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"login_background" ofType:@"png"];
    UIImage *bgImage = [UIImage imageWithContentsOfFile:path];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    scrollView.hidden = YES;
    [self.view addSubview:scrollView];
    _mainSubEMailScrollView = scrollView;
    
    
    x = 38;
    y = 33 ;
    cx = _mainSubEMailScrollView.frame.size.width - 2*x;
    cy = WRUITextFieldHeight;
    offset = x;
    
    UITextField *textField = nil;
    UIView *lineView = nil;
    NSArray *titleArray = @[NSLocalizedString(@"电子邮箱", nil), NSLocalizedString(@"手机号码", nil)];
    for(NSUInteger index = 0; index < 1; index++)
    {
        textField = [UITextField wr_iconTextField:@"well_register_email"];
        textField.delegate = self;
        textField.frame = CGRectMake(x, y, cx, cy);
        textField.placeholder = [titleArray objectAtIndex:0];
//        [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        textField.returnKeyType = UIReturnKeyNext;
        textField.textColor = [UIColor grayColor];
        y = textField.bottom;
        lineView = [UIView new];
        lineView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
        lineView.frame = CGRectMake(x +10 , y, cx-20 , 1);
        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x + 15, textField.bottom, cx - 30, 1)];
//        lineView.backgroundColor = [UIColor lightGrayColor];
        [_mainSubEMailScrollView addSubview:textField];
        [_mainSubEMailScrollView addSubview:lineView];
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
    
    UIButton *btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(onClickedOKButton:) forControlEvents:UIControlEventTouchUpInside];
    btnOK.layer.cornerRadius = 5.0f;
    btnOK.layer.masksToBounds = YES;
    [btnOK setBackgroundImage:[UIImage imageNamed:@"well_register_bg"] forState:UIControlStateNormal];
    btnOK.frame = CGRectMake(x, y, cx, cy);
    btnOK.tag = tagResetByEmail;
    [btnOK addTarget:self action:@selector(onClickedOKButton:) forControlEvents:UIControlEventTouchUpInside];
    btnOK.frame = CGRectMake(x, y, cx, cy);
    [_mainSubEMailScrollView addSubview:btnOK];
    
    scrollView = [[UIScrollView alloc] initWithFrame:_mainSubEMailScrollView.frame];
    [self.view addSubview:scrollView];
    _mainSubPhoneScrollView = scrollView;

    
    
    x = offset;
    y = offset ;
    cx = frame.size.width - 2*x;
    cy = WRUITextFieldHeight;
    offset = x;
    NSArray *placeHolderArray = @[
                                  NSLocalizedString(@"手机号码", nil),
                                  NSLocalizedString(@"6位数字验证码", nil),
                                  NSLocalizedString(@"4-16位数字或字母", nil),
//                                  NSLocalizedString(@"确认密码", nil),
                                  ];
    NSArray *leftImageArray = @[
                                 @"well_register_phone",
                                 @"well_register_checkcode",
                                 @"well_icon_password",
//                                 @"well_icon_password",
                                 ];
    for(NSUInteger index = 0; index < placeHolderArray.count; index++)
    {
        if(index == 1)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:[UIColor wr_themeColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor wr_themeColor] forState:UIControlStateDisabled];
            [button setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
            button.backgroundColor = [UIColor whiteColor];
            button.titleLabel.font = [UIFont systemFontOfSize:WRDetailFont];
            [button sizeToFit];
            button.layer.cornerRadius = 5.0f;
            button.layer.masksToBounds = YES;
            CGFloat cx0 = button.frame.size.width*4/3;
            button.frame = CGRectMake(cx - cx0+5, y + (cy - cy*2/3)/2, cx0-5, cy*2/3);
//            button.frame = CGRectMake(cx - cx0, (cy - cy*2/3)/2, cx0, cy*2/3);

//            CGFloat cx0 = button.frame.size.width*3/2;
//            button.frame = CGRectMake(x + cx - cx0, y, cx0, cy);
//            [button wr_roundBorderWithColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(onClickedGetCodeButton:) forControlEvents:UIControlEventTouchUpInside];
            [button wr_roundBorderWithColor:[UIColor wr_themeColor]];
            [_mainSubPhoneScrollView addSubview:button];
            _getCodeButton = button;
            textField = [UITextField wr_iconTextField:leftImageArray[index]];
            textField.frame = CGRectMake(x+10, y, cx - offset - cx0-10, cy);
            textField.font = FONT_13;
            lineView = [UIView new];
            lineView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
            lineView.frame = CGRectMake(x +10 , textField.bottom, cx-20 , 1);
            
            
            
            
//            lineView = [[UIView alloc] initWithFrame:CGRectMake( x + 15, textField.bottom, cx - offset - cx0 - 30, 1)];
        }
        else
        {
            textField = [UITextField wr_iconTextField:leftImageArray[index]];
            textField.font = FONT_13;
            textField.frame = CGRectMake(x+10, y, cx-10, cy);
//        lineView = [[UIView alloc] initWithFrame:CGRectMake(x + 15, textField.bottom, cx - 30, 1)];
            lineView = [UIView new];
            lineView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
            lineView.frame = CGRectMake(x +10 , textField.bottom, cx-20 , 1);
            
            
            
        }
        textField.delegate = self;
        textField.placeholder = placeHolderArray[index];
//        [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        textField.returnKeyType = UIReturnKeyNext;
        textField.textColor = [UIColor grayColor];
        if (index == placeHolderArray.count - 1) {
            UIImage *image = [UIImage imageNamed:@"register_eye_blue"];
            UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
            rightView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
            rightView.contentMode = UIViewContentModeCenter;
            [rightView setImage:image forState:UIControlStateSelected];
            [rightView setImage:[UIImage imageNamed:@"register_eye_gray"] forState:UIControlStateNormal];
            textField.rightView = rightView;
            textField.rightViewMode = UITextFieldViewModeAlways;
            rightView.selected = NO;
            [rightView addTarget:self action:@selector(onClickedEyeButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        

//        lineView.backgroundColor = [UIColor lightGrayColor];
        [_mainSubPhoneScrollView addSubview:textField];
        [_mainSubPhoneScrollView addSubview:lineView];
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
    cx = CGRectGetWidth(frame) - 4*offset;
    x = (frame.size.width - cx)/2;
    
    btnOK = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnOK setTitle:@"重置" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(onClickedOKButton:) forControlEvents:UIControlEventTouchUpInside];
    btnOK.layer.cornerRadius = 5.0f;
    btnOK.layer.masksToBounds = YES;
    [btnOK setBackgroundImage:[UIImage imageNamed:@"well_register_bg"] forState:UIControlStateNormal];
    btnOK.frame = CGRectMake(x, y, cx, cy);
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    
////    UINavigationBar *bar = self.navigationController.navigationBar;
////    [bar lt_setBackgroundColor:[UIColor clearColor]];
//    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [bar setShadowImage:[UIImage new]];
//    bar.barTintColor = [UIColor grayColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //明文切换密文后避免被清空
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == _passwordTextField && textField.isSecureTextEntry) {
        textField.text = toBeString;
        return NO;
    }
    return YES;
}

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
- (IBAction)onClickedEyeButton:(UIButton *)sender
{
    _passwordTextField.enabled = NO;
    _passwordTextField.secureTextEntry = sender.selected;
    sender.selected = !sender.selected;
    _passwordTextField.enabled = YES;
//    [_passwordTextField becomeFirstResponder];
}

-(IBAction)onSegmentControlValueChange:(UISegmentedControl*)sender
{
    _mainSubEMailScrollView.hidden = (sender.selectedSegmentIndex != tagResetByEmail);
    _mainSubPhoneScrollView.hidden = !_mainSubEMailScrollView.hidden;
}

-(void)handleTapGesture:( UITapGestureRecognizer *)tapRecognizer
{
    [self.view endEditing:YES];
}

-(void)onClickedGetCodeButton:(UIButton*)sender
{
    if(![Utility ValidateMobile:_phoneTextField.text])
    {
        [Utility Alert:NSLocalizedString(@"手机号格式错误", nil)];
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:nil];
        ZYEALView* code = [[ZYEALView alloc]initwithPhone:_phoneTextField.text type:@"pwd"];
        code.backgroundColor = [UIColor whiteColor];
        code.layer.cornerRadius = 5;
        JCAlertView* al = [[JCAlertView alloc]initWithCustomView:code dismissWhenTouchedBackground:YES];
        [al show];
        code.clossBlock = ^{
            [al dismissWithCompletion:^{
                
            }];
        };
        
        code.completionBlock = ^(NSString *text, NSString *codeid) {
            
            NSString* uptext =  [text uppercaseString];
            NSString* md5code = [uptext md5String];
            [WRViewModel requestSmsCodeWithPhone:_phoneTextField.text type:@"pwd" uuid:codeid code:md5code completion:^(NSError * error) {
            [SVProgressHUD dismiss];
                
            if (error) {
                [AppDelegate show:error.domain];
            } else {
                [al dismissWithCompletion:^{
                    [AppDelegate show:@"验证码已发送"];
                }];
                //[WToast showWithText:NSLocalizedString(@"验证码已发送", nil)];
                
            }
        }];
        };
    
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
            
            if( ![Utility ValidatePassword:_passwordTextField.text])
            {
                [Utility Alert:NSLocalizedString(@"密码或者确认密码不正确", nil)];
                break;
            }
            
//            if( ![Utility ValidatePassword:_passwordTextField.text] ||
//               ![Utility ValidatePassword:_validatePasswordTextField.text] )
//            {
//                [Utility Alert:NSLocalizedString(@"密码或者确认密码不正确", nil)];
//                break;
//            }

            
//            if(![_passwordTextField.text isEqualToString:_validatePasswordTextField.text])
//            {
//                [Utility Alert:NSLocalizedString(@"两次密码不一致", nil)];
//                break;
//            }
            
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
