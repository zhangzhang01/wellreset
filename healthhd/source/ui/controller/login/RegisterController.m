//
//  RegisterController.m
//  rehab
//
//  Created by Matech on 3/3/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "RegisterController.h"
#import "WToast.h"
#import "WRViewModel.h"
#import "SVProgressHUD.h"

typedef NS_ENUM(NSInteger, RegisterType){
    RegisterTypeByPhone,
    RegisterTypeByEmail
};

@interface RegisterController ()<UITextFieldDelegate>
{
    __weak UITextField *_phoneTextField, *_mailTextField, *_nameTextField, *_passwordTextField, *_validatePasswordTextField;
    __weak UIButton *_checkButton;
    __weak UIButton *_getCodeButton;
    __weak UITextField *_smsCodeTextField, *_currentTextField;
    
    __weak UISegmentedControl *_segmentedControl;
    __weak UIView *_smsCodeView;
    
    NSTimer *_timer;
    NSUInteger _timeCount;
    NSString *_inviteCode;
    //MyLinearLayout *linear;
}
@property(nonatomic,weak)UIScrollView* mainScrollView;
@property(nonatomic, weak) UIButton *getSmsCodeButton;
@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    
    _inviteCode = @"";
    self.title = NSLocalizedString(@"注册", nil);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.backgroundColor = self.view.backgroundColor;
    [self setView:scrollView];
    _mainScrollView = scrollView;
    UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    sigleTapRecognizer.numberOfTapsRequired = 1;
    [_mainScrollView addGestureRecognizer:sigleTapRecognizer];
    
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"手机注册", nil), NSLocalizedString(@"邮箱注册", nil)]];
    segCtrl.selectedSegmentIndex = RegisterTypeByPhone;
    segCtrl.tintColor = [UIColor whiteColor];
    [segCtrl sizeToFit];
    [segCtrl addTarget:self action:@selector(onSegCtrlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segCtrl;
    _segmentedControl = segCtrl;
    
    [self createSubViews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleTapGesture:( UITapGestureRecognizer *)tapRecognizer {
    [self.view endEditing:YES];
}

-(void)createSubViews {
    UIView *containerView = self.view;
    [containerView removeAllSubviews];
    
    CGFloat x = 0, y = 0, cx = 0, cy = 0, offset = WRUIOffset;
    CGRect frame = self.view.bounds;
    
    if([WRUIConfig IsHDApp]) {
        frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width*0.7f, [[UIScreen mainScreen] bounds].size.height*0.7f);
    }
    
    x = offset;
    y = x;

    UITextField *textField = nil;
    NSArray *titleArray = @[
                            NSLocalizedString(@"手机号码", nil),
                            NSLocalizedString(@"验证码", nil),
                            NSLocalizedString(@"电子邮件", nil),
                            NSLocalizedString(@"密码", nil),
                            NSLocalizedString(@"确认密码", nil),
                            ];
    NSArray *placeHolderArray = @[
                                  NSLocalizedString(@"填写中国大陆手机号，其他地区不可见", nil),
                                  NSLocalizedString(@"6位数字验证码", nil),
                                  NSLocalizedString(@"常用的电子邮箱", nil),
                                  NSLocalizedString(@"4-16位密码，建议数字，字母，符号组合", nil),
                                  NSLocalizedString(@"确认密码", nil),
                                  ];
    
    cy = WRUITextFieldHeight;
    cx = frame.size.width - 2*offset;
    for(NSUInteger index = 0; index < titleArray.count; index++)
    {
        if (_segmentedControl.selectedSegmentIndex == 0) {
            if (index == 2) {
                continue;
            }
        } else {
            if (index <= 1) {
                continue;
            }
        }
        
        textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        textField.placeholder = [placeHolderArray objectAtIndex:index];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.delegate = self;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyNext;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        
        if (index == 1) {
            
            UIView *smsCodeView = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
            //smsCodeView.myTopMargin = offset;
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
            [button setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
            [button sizeToFit];
            CGFloat cx0 = button.frame.size.width*4/3;
            button.frame = CGRectMake(cx - cx0, 0, cx0, cy);
            [button wr_roundBorderWithColor:[UIColor lightGrayColor]];
            [button addTarget:self action:@selector(onClickedGetCodeButton:) forControlEvents:UIControlEventTouchUpInside];
            [smsCodeView addSubview:button];
            self.getSmsCodeButton = button;
            
            textField.frame = CGRectMake(0, 0, cx - offset - cx0, cy);
            [smsCodeView addSubview:textField];
            _smsCodeView = smsCodeView;
            
            [containerView addSubview:smsCodeView];
        } else {
            
            //textField.myTopMargin = offset;
            [containerView addSubview:textField];
        }
        y += cy + offset;
        
        switch (index) {
            case 0:
                _phoneTextField = textField;
                textField.keyboardType = UIKeyboardTypeNumberPad;
                break;
                
            case 1:
                textField.keyboardType = UIKeyboardTypeNumberPad;
                _smsCodeTextField = textField;
                break;
                
            case 2:
                _mailTextField = textField;
                textField.keyboardType = UIKeyboardTypeEmailAddress;
                break;
                
                
            case 3:
                textField.secureTextEntry = YES;
                _passwordTextField = textField;
                break;
                
            case 4:
                textField.secureTextEntry = YES;
                textField.returnKeyType = UIReturnKeySend;
                _validatePasswordTextField = textField;
                break;

            default:
                break;
        }
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = NSLocalizedString(@"使用邀请码", nil);
    label.userInteractionEnabled = YES;
    label.font = [UIFont wr_labelFont];
    label.textColor = [UIColor wr_lightThemeColor];
    [label sizeToFit];
    label.frame = CGRectMake(x, y, cx, label.frame.size.height);
    __weak __typeof(self) weakSelf = self;
    [label bk_whenTapped:^{
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"输入邀请码", nil) message:NSLocalizedString(@"6位数字", nil) preferredStyle:UIAlertControllerStyleAlert];
        [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *submitAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = controller.textFields.firstObject;
            if (textField.text.length > 0 && textField.text.length != 6) {
                [Utility alertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"邀请码为6位数字", nil)];
            } else {
                _inviteCode = textField.text;
                if ([Utility IsEmptyString:_inviteCode]) {
                    label.text = NSLocalizedString(@"使用邀请码", nil);
                } else {
                    label.text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"当前邀请码", nil), _inviteCode];
                }
            }
        }];
        [controller addAction:cancelAction];
        [controller addAction:submitAction];
        [weakSelf.navigationController presentViewController:controller animated:YES completion:nil];
    }];
    [containerView addSubview:label];
    y = CGRectGetMaxY(label.frame) + offset;
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
    //subView.myTopMargin = offset;
    UIImage *imgButton = PNG_IMAGE_NAMED(@"well_icon_checked");
    cx = imgButton.size.width;
    cy = imgButton.size.height;
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setImage:imgButton forState:UIControlStateSelected];
    [checkButton setImage:PNG_IMAGE_NAMED(@"well_icon_radio") forState:UIControlStateNormal];
    checkButton.selected = YES;
    checkButton.frame = CGRectMake(0, 0, cx, cy);
    [checkButton addTarget:self action:@selector(onClickedCheckButton:) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:checkButton];
    _checkButton = checkButton;
    
    x = CGRectGetMaxX(checkButton.frame) + WRUINearbyOffset;
    cx = subView.frame.size.width - x - WRUINearbyOffset;
    y = 0;
    UIButton *readAgreenment = [UIButton buttonWithType:UIButtonTypeCustom];
    readAgreenment.titleLabel.font = [UIFont systemFontOfSize:([UIFont labelFontSize] - 2)];
    readAgreenment.titleLabel.numberOfLines = 2;
    readAgreenment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [readAgreenment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [readAgreenment setTitle:NSLocalizedString(@"我已经阅读并同意《服务协议》", nil) forState:UIControlStateNormal];
    if([WRUIConfig IsHDApp])
    {
        [readAgreenment sizeToFit];
        cy = readAgreenment.frame.size.height;
        cx = readAgreenment.frame.size.width;
        y = MAX(cy, checkButton.frame.size.height)/2 - cy/2;
    }
    readAgreenment.frame = CGRectMake(x, y, cx, cy);
    [readAgreenment addTarget:self action:@selector(onClickedReadAgreementButton:) forControlEvents:UIControlEventTouchUpInside];
    [subView addSubview:readAgreenment];
    
    subView.frame = [Utility resizeRect:subView.frame cx:-1 height:MAX(CGRectGetHeight(checkButton.frame), CGRectGetHeight(readAgreenment.frame))];
    //subView.myTopMargin = offset;
    [containerView addSubview:subView];
    y = CGRectGetMaxY(subView.frame) + offset;
    
    cy = WRUIButtonHeight;
    cx = frame.size.width - 2*offset - 2*x;
    x = (frame.size.width - cx)/2;
    UIButton *btnOK = [UIButton wr_buttonWithTitle:NSLocalizedString(@"注册", nil)];
    [btnOK addTarget:self action:@selector(onClickedOKButton:) forControlEvents:UIControlEventTouchUpInside];
    btnOK.frame = CGRectMake(x, y, cx, cy);
    //btnOK.myTopMargin = 3*offset;
    //btnOK.myLeftMargin = x;
    //btnOK.myCenterXOffset = 0;
    [containerView addSubview:btnOK];
    y = CGRectGetMaxY(btnOK.frame) + offset;
    _mainScrollView.contentSize = CGSizeMake(_mainScrollView.frame.size.width, y);
    
#if DEBUG
    _phoneTextField.text = @"18820012612";
    _mailTextField.text = @"1193087100@qq.com";
    _passwordTextField.text = @"000000";
    _validatePasswordTextField.text = @"000000";
#endif
    [WRNetworkService pwiki:@"注册"];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _phoneTextField) {
        [_smsCodeTextField becomeFirstResponder];
    } else if(textField == _smsCodeTextField || textField == _mailTextField) {
        [_passwordTextField becomeFirstResponder];
    } else if(textField == _passwordTextField) {
        [_validatePasswordTextField becomeFirstResponder];
    } else if(textField == _validatePasswordTextField) {
        [self onClickedOKButton:nil];
        return NO;
    }
    return YES;
}

#pragma mark - IBActions
-(IBAction)onSegmentControlValueChange:(UISegmentedControl*)sender {
    _smsCodeView.hidden = (sender.selectedSegmentIndex != 0);
    _mailTextField.hidden = (sender.selectedSegmentIndex == 0);
    _phoneTextField.hidden = !_mailTextField.hidden;
}

-(IBAction)onClickedGetCodeButton:(UIButton*)sender {
    NSString *errorString = nil;
    do{
        NSString *phone = _phoneTextField.text;
        if (![Utility ValidateMobile:phone]) {
            errorString = NSLocalizedString(@"手机号码不正确", nil);
            break;
        }
        
        __weak __typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:nil];
        [WRViewModel requestSmsCodeWithPhone:phone type:@"reg" completion:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                [Utility retryAlertWithViewController:weakSelf title:error.domain completion:^{
                    [weakSelf onClickedGetCodeButton:sender];
                }];
            } else {
                //[WToast showWithText:NSLocalizedString(@"验证码已发送", nil)];
                [_smsCodeTextField becomeFirstResponder];
                [weakSelf smsCodeTimer];
            }
        }];
        
        
    }while (NO);
    if (![Utility IsEmptyString:errorString]) {
        [SVProgressHUD showErrorWithStatus:errorString];
    }
}

-(IBAction)onClickedCheckButton:(UIButton*)sender {
    sender.selected = !sender.selected;
}

-(IBAction)onClickedResetButton:(UIButton*)sender {
    _phoneTextField.text = @"";
    _smsCodeTextField.text = @"";
    _mailTextField.text = @"";
    _passwordTextField.text = @"";
    _validatePasswordTextField.text = @"";
}

-(IBAction)onClickedOKButton:(UIButton*)sender {
    __block NSString *errorString = nil;
    do{
        NSString *phone = _phoneTextField.text;
        NSString *smsCode = _smsCodeTextField.text;
        RegisterType type = _segmentedControl.selectedSegmentIndex;
        if(type == RegisterTypeByPhone) {
            if (![Utility ValidateMobile:phone]) {
                errorString = NSLocalizedString(@"手机号码不正确", nil);
                break;
            }
            
            if (![Utility ValidateSmsCode:smsCode]) {
                errorString = NSLocalizedString(@"验证码不正确", nil);
                break;
            }
        }
        
        if(_segmentedControl.selectedSegmentIndex == RegisterTypeByEmail) {
            if (![Utility ValidateEmail:_mailTextField.text]) {
                errorString = NSLocalizedString(@"邮箱不正确", nil);
                break;
            }
        }
        
        if (![Utility ValidatePassword:_passwordTextField.text]) {
            errorString = NSLocalizedString(@"密码不正确", nil);
            break;
        }
        
        if (![Utility ValidatePassword:_validatePasswordTextField.text]) {
            errorString = NSLocalizedString(@"重复密码不正确", nil);
            break;
        }
        
        if (![_passwordTextField.text isEqualToString:_validatePasswordTextField.text]) {
            errorString = NSLocalizedString(@"两次密码不一致", nil);
            break;
        }
        
        if (!_checkButton.selected) {
            errorString = NSLocalizedString(@"您请先阅读并同意WELL用户协议", nil);
            break;
        }
        
        [self.view endEditing:YES];
        
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在注册", nil)];
        if (_segmentedControl.selectedSegmentIndex != 0) {
            phone = @"";
            smsCode = @"";
        }
        NSString *email = _mailTextField.text;
        if (_segmentedControl.selectedSegmentIndex != 1) {
            email = @"";
        }
        
        [WRViewModel registerWithPhone:phone email:email password:_passwordTextField.text smsCode:smsCode inviteCode:_inviteCode completion:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                errorString = error.domain;
                if (errorString) {
                    [Utility Alert:errorString];
                }
            } else {
                NSString *text = nil;
                NSString *account = @"";
                if(type == RegisterTypeByPhone) {
                    account = phone;
                    text = [NSString stringWithFormat:NSLocalizedString(@"注册成功,请使用手机号码登录", nil), email];
                } else {
                    account = email;
                    text = [NSString stringWithFormat:NSLocalizedString(@"注册成功,请到邮箱 %@ 打开邮件进行激活", nil), email];
                }
                __weak __typeof(self) weakSelf = self;
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"恭喜", nil)
                                                                                    message:text
                                                                             preferredStyle:UIAlertControllerStyleAlert];
                [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"返回登录", nil) style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 [weakSelf.navigationController popViewControllerAnimated:YES];
                                                                 NSDictionary *userInfoDict = @{@"account":account};
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:WRLogInNotification object:WRRegisterAutoLogInNotification userInfo:userInfoDict];
                                                             }]];
                [self presentViewController:controller animated:YES completion:nil];
            }
        }];
        
    }while (NO);
    
    if (errorString) {
        [Utility Alert:errorString];
    }
}

-(IBAction)onClickedReadAgreementButton:(UIButton*)sender {
    
}

-(IBAction)onSegCtrlValueChanged:(UISegmentedControl*)sender {
    [self createSubViews];
}

#pragma mark - 
-(void)smsCodeTimer {
    __weak __typeof(self) weakSelf = self;
    weakSelf.getSmsCodeButton.enabled = NO;
    
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
                weakSelf.getSmsCodeButton.enabled = YES;
            } else {
                text = [NSString stringWithFormat:@"%ds", (int)_timeCount];
            }
            [weakSelf.getSmsCodeButton setTitle:text forState:UIControlStateNormal];
            
        } repeats:YES];
        
    }
    [_timer fire];
}

@end
