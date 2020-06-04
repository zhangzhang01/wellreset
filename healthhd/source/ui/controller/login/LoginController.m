//
//  LoginController.m
//  rehab
//
//  Created by Matech on 2/25/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "DGActivityIndicatorView.h"
#import "ReactiveCocoa.h"
#import "SVProgressHUD.h"
#import "UIButton+WR.h"
#import "UITextField+WR.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "FindPasswordController.h"
#import "LoginController.h"
#import "RegisterController.h"
#import "WRViewModel.h"
#import "WToast.h"
#import "WXApi.h"

@interface LoginController ()<UITextFieldDelegate>

@property(nonatomic, weak)UILabel *loginNotifyLabel;
@property(nonatomic, weak)UITextField *accountTextField, *passwordTextField;
@property(nonatomic, weak)UIButton *submitButton;
@property(nonatomic) DGActivityIndicatorView *loader;

@end

@implementation LoginController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationHandler:)
                                                     name:WRRegisterAutoLogInNotification
                                                   object:nil];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    
    self.title = NSLocalizedString(@"登录", nil);
    BOOL biPad = [WRUIConfig IsHDApp];
    CGRect frame = self.view.frame;
    if(biPad) {
        frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width*0.7f, [[UIScreen mainScreen] bounds].size.height*0.7f);
    }
    
    NSLog(@"login frame %@", NSStringFromCGRect(frame));
    
    UIColor *textColor = [UIColor grayColor];
    UIColor *imageColor = [UIColor wr_lightThemeColor];
    
    CGFloat eraseHeight = 64;
    
    CGFloat x = 0, y = 0, cx = 0, cy = 0, offset = WRUIOffset;
    UIButton *button = nil;
    
    UIView *registerPanel = [self createRegisterView:frame];
    [self.view addSubview:registerPanel];
    registerPanel.center = CGPointMake(frame.size.width/2, eraseHeight + registerPanel.height/2 + 60);
    
    UIView *loginPanel = [self createLoginPanel:frame];
    loginPanel.alpha = 0;
    loginPanel.hidden = YES;
    [self.view addSubview:loginPanel];
    loginPanel.center = registerPanel.center ;
    
    [self.loginNotifyLabel bk_whenTapped:^{
        loginPanel.centerY = loginPanel.centerY + 30;
        CGFloat destY = registerPanel.centerY;
        loginPanel.hidden = NO;
        [UIView animateWithDuration:0.35 animations:^{
            loginPanel.centerY = destY;
            registerPanel.centerY = destY - 20;
            registerPanel.alpha = 0;
            loginPanel.alpha = 1;
        } completion:^(BOOL finished) {
            registerPanel.hidden = YES;
        }];
    }];
    
    y = MAX(loginPanel.bottom, registerPanel.bottom) + offset;
    cx = WRActivityIndicatorViewSize;
    if (biPad) {
        cx *= 2;
    }
    cy = cx;
    x = (frame.size.width - cx)/2;
    DGActivityIndicatorView *activityView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeTriplePulse tintColor:imageColor];
    activityView.frame = CGRectMake(x, y, cx, cy);
    activityView.hidden = YES;
    [self.view addSubview:activityView];
    self.loader = activityView;
    
    NSMutableArray *oauthArray = [NSMutableArray array];
    if ([WXApi isWXAppInstalled]) {
        [oauthArray addObject:@"wechat"];
    }
    if ([QQApiInterface isQQInstalled]) {
        [oauthArray addObject:@"qq"];
    }
    
    if (oauthArray.count > 0) {
        UIView *oauthView = [[UIView alloc] initWithFrame:CGRectMake(x, y, frame.size.width, 0)];
        
        y = offset;
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"有微信或QQ帐号？一键登录WELL健康:", nil);
        label.font = [UIFont wr_textFont];
        label.textColor = textColor;
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        cx = CGRectGetWidth(_accountTextField.frame);
        label.frame = [Utility resizeRect:label.frame cx:cx height:-1];
        x = CGRectGetMinX(_accountTextField.frame);
        label.frame = [Utility moveRect:label.frame x:x y:y];
        [oauthView addSubview:label];
        
        if ([oauthArray containsObject:@"wechat"] && [oauthArray containsObject:@"qq"]) {
            label.text = NSLocalizedString(@"有微信或QQ帐号？一键登录WELL健康:", nil);
        } else if ([oauthArray containsObject:@"wechat"]){
            label.text = NSLocalizedString(@"有微信帐号？一键登录WELL健康:", nil);
        } else {
            label.text = NSLocalizedString(@"有QQ帐号？一键登录WELL健康:", nil);
        }
        
        y = label.bottom + 2*WRUIOffset;
        
        NSArray *imageArray = @[@"well_login_weixin", @"well_login_qq", /*@"well_login_weibo"*/];
        NSArray *titleArray = @[NSLocalizedString(@"微信登录", nil), NSLocalizedString(@"QQ登录", nil)];
        UIImage *image = [UIImage imageNamed:imageArray.firstObject];
        CGFloat offsetX = 3*offset;
        x = (frame.size.width - oauthArray.count *image.size.width - (oauthArray.count - 1)*offsetX)/2;
        cx = image.size.width;
        cy = image.size.height;
        NSUInteger index = 0;
        for(NSString *oauthTypeName in oauthArray) {
            if ([oauthTypeName isEqualToString:@"wechat"]) {
                index = 0;
            } else if ([oauthTypeName isEqualToString:@"qq"]){
                index = 1;
            }
            if (index >= imageArray.count) {
                continue;
            }
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            image = [UIImage imageNamed:imageArray[index]];
            [button setImage:image forState:UIControlStateNormal];
            button.frame = CGRectMake(x, y, cx, cy);
            button.tag = index;
            button.titleLabel.font = [UIFont wr_detailFont];
            [button setTitle:titleArray[index] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onClickedAuthorLogin:) forControlEvents:UIControlEventTouchUpInside];
            [oauthView addSubview:button];
            [button wr_verticalImageAndTitle:2.0];
            x += cx + offsetX;
            index++;
        }
        
        y = button.bottom + offset;
        oauthView.frame = CGRectMake(0, frame.size.height - y - eraseHeight, oauthView.width, y);
        [self.view addSubview:oauthView];
    }
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *lastAccount = [ud stringForKey:@"lastAccount"];
    if (![Utility IsEmptyString:lastAccount]) {
        _accountTextField.text = lastAccount;
    } else {
#if DEBUG
        _accountTextField.text = @"18820012612";
        _passwordTextField.text = @"000000";
#endif
    }

    self.submitButton.enabled = [self canSubmit];
    
    [WRNetworkService pwiki:@"登录"];
}

-(UIView*)createRegisterView:(CGRect)frame {
    UIColor *textColor = [UIColor grayColor];
  
    UIView *panel = [[UIView alloc] init];
    CGFloat x = 0, y = 0, cx, offset = WRUIOffset;
    cx = frame.size.width - 2*x;
    
    BOOL biPad = [WRUIConfig IsHDApp];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, [WRUIConfig defaultLabelHeight])];
    label.font = biPad ? [UIFont wr_titleFont] : [UIFont wr_textFont];
    label.textColor = textColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"还没有WELL健康帐号？", nil);
    label.frame = CGRectMake(x, y, cx, 0);
    [label sizeToFit];
    label.frame = [Utility resizeRect:label.frame cx:cx height:-1];
    [panel addSubview:label];
    y = CGRectGetMaxY(label.frame) + 8;
    
    x = 20;
    UIButton *button = [UIButton wr_defaultButtonWithTitle:NSLocalizedString(@"立即注册", nil)];
    [button addTarget:self action:@selector(onClickedRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(x, y, cx - 2*x, WRUIButtonHeight);
    [panel addSubview:button];
    y = CGRectGetMaxY(button.frame) + 8;
    
    cx = button.width;
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, [WRUIConfig defaultLabelHeight])];
    label.font = biPad ? [UIFont wr_titleFont] : [UIFont wr_lightFont];
    label.textColor = [UIColor wr_themeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"已有WELL健康帐号？立即登录", nil);
    label.frame = CGRectMake(x, y, cx, 0);
    label.userInteractionEnabled = YES;
    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    label.frame = [Utility resizeRect:label.frame cx:cx height:size.height];
    [panel addSubview:label];
    self.loginNotifyLabel = label;
    y = CGRectGetMaxY(label.frame) + offset;
    panel.frame = CGRectMake(0, 0, frame.size.width, y);
    
    return panel;
}

-(UIView *)createLoginPanel:(CGRect)frame {
    UIColor *textColor = [UIColor grayColor];
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    
    CGFloat x, y = 0, cx, cy, offset = WRUIOffset;
    x = offset;
    cx = MIN(frame.size.width - 2*x, 300);
    x = (frame.size.width - cx) / 2;
    cy = WRUITextFieldHeight;
    
    BOOL biPad = [WRUIConfig IsHDApp];
    
    UITextField *textField = [UITextField wr_iconTextField:@"well_icon_account"];
    textField.delegate = self;
    textField.frame = CGRectMake(x, y, cx, cy);
    textField.placeholder = NSLocalizedString(@"邮箱/手机号", nil);
    textField.returnKeyType = UIReturnKeyNext;
    textField.textColor = textColor;
    [panel addSubview:textField];
    _accountTextField = textField;
    y = textField.bottom;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x + 15, y, cx - 30, 0.6)];
    lineView.backgroundColor = [UIColor grayColor];
    [panel addSubview:lineView];
    y = lineView.bottom;
    
    textField = [UITextField wr_iconTextField:@"well_icon_password"];
    textField.delegate = self;
    textField.keyboardType = UIKeyboardTypeASCIICapable;
    textField.returnKeyType = UIReturnKeySend;
    textField.frame = [Utility moveRect:_accountTextField.frame x:-1 y:y];
    textField.placeholder = NSLocalizedString(@"密码", nil);
    textField.secureTextEntry = YES;
    textField.textColor = textColor;
    [panel addSubview:textField];
    _passwordTextField = textField;
    y = textField.bottom;
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(x + 15, y, cx - 30, 0.6)];
    lineView.backgroundColor = [UIColor grayColor];
    [panel addSubview:lineView];
    y = lineView.bottom + offset;
    
    UIFont *font = biPad ? [UIFont wr_textFont] : [UIFont wr_labelFont];
    UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"忘记密码", nil) forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleColor:[UIColor wr_themeColor] forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(onClickedResetPasswordBtn:)
     forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = [Utility moveRect:button.frame x:(lineView.left)  y:y];
    [panel addSubview:button];
    
    UIButton *registerButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [registerButton setTitle:NSLocalizedString(@"立即注册", nil) forState:UIControlStateNormal];
    registerButton.titleLabel.font = font;
    [registerButton setTitleColor:[UIColor wr_themeColor] forState:UIControlStateNormal];
    [registerButton addTarget:self
                       action:@selector(onClickedRegisterBtn:)
             forControlEvents:UIControlEventTouchUpInside];
    [registerButton sizeToFit];
    registerButton.frame = [Utility moveRect:button.frame x:(lineView.right - button.frame.size.width)  y:y];
    [panel addSubview:registerButton];
    y = registerButton.bottom + offset;
    
    button = [UIButton wr_defaultButtonWithTitle:NSLocalizedString(@"登录", nil)];
    [button addTarget:self action:@selector(onClickedLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(x + 20, y, cx - 40, WRUIButtonHeight);
    [panel addSubview:button];
    self.submitButton = button;
    y = CGRectGetMaxY(button.frame) + offset;
    
    __weak __typeof(self) weakSelf = self;
    RAC(self.submitButton, enabled) = [RACSignal combineLatest:@[self.accountTextField.rac_textSignal, self.passwordTextField.rac_textSignal]
                                                        reduce:^(NSString *account, NSString *password) {
                                                            return @([weakSelf canSubmit]);
                                                        }];
    
    panel.frame = CGRectMake(0, 0, frame.size.width, y);
    
    return panel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.accountTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [self.submitButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return YES;
}

#pragma mark - IBActions
-(IBAction)onClickedCancelButton:(id)sender {
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onClickedLoginBtn {
    //[self.view endEditing:YES];
    [self.accountTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    NSString *errorString = nil;
    do {
        NSString *account = _accountTextField.text;
        if (!([Utility ValidateMobile:account] || [Utility ValidateEmail:account])) {
            errorString = NSLocalizedString(@"帐号必须为手机或者邮箱", nil);
            break;
        }
        
        NSString *password = _passwordTextField.text;
        if (![Utility ValidatePassword:password]) {
            errorString = NSLocalizedString(@"密码不正确", nil);
            break;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:self.accountTextField.text forKey:@"lastAccount"];
        [self loginWithFlag:YES];

        __weak __typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *type = @"email";
            if ([Utility ValidateMobile:account]) {
                type = @"phone";
            }
            [WRViewModel loginWithAccount:account password:password type:type completion:^(NSError *error) {
                if (error) {
                    NSString *text = error.domain;
                    if (!text) {
                        text = NSLocalizedString(@"登录失败", nil);
                    }
                    //[Utility Alert:text];
                    [SVProgressHUD showErrorWithStatus:text];
                } else {
                    //[SVProgressHUD dismiss];
                    [weakSelf.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
                [weakSelf loginWithFlag:NO];
            }];
        });
        
        
    } while (NO);
    
    if (errorString) {
        [Utility Alert:errorString];
    }
}

-(IBAction)onClickedResetPasswordBtn:(UIButton*)sender {
    UIViewController *viewController = [[FindPasswordController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)onClickedRegisterBtn:(UIButton*)sender {
    UIViewController *viewController = [[RegisterController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)onClickedAuthorLogin:(UIButton*)sender
{
    __weak __typeof(self) weakSelf = self;
    
    NSString *platform = sender.tag == 0 ? UMShareToWechatSession : UMShareToQQ;
    NSString *openType = sender.tag == 0 ? @"weixin":@"qq";

    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platform];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"openType"] = openType;
            params[@"type"] = @"login";
            if (snsAccount.usid) {
                params[@"openId"] = snsAccount.usid;
            }
            if (snsAccount.userName) {
                params[@"name"] = snsAccount.userName;
            }
            if (snsAccount.iconURL) {
                params[@"icon"] = snsAccount.iconURL;
            }
            /*
            Gender gender = GenderUnknown;
            switch (user.gender) {
                case SSDKGenderMale:
                    gender = GenderMale;
                    break;
                    
                case SSDKGenderFemale:
                    gender = GenderFemale;
                    break;
                    
                default:
                    gender = GenderUnknown;
                    break;
            }
            if (gender != GenderUnknown) {
                params[@"sex"] = @(gender);
            }
            */
            [SVProgressHUD show];
            [WRViewModel userAuthorWithParams:params type:@"login" completion:^(NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                if (error) {
                    NSString *text = error.domain;
                    if (!text) {
                        text = NSLocalizedString(@"登录失败", nil);
                    }
                    [Utility Alert:text];
                } else {
                    [weakSelf.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
        else
        {
            
        }
    });
}

#pragma mark - Notification Handler
-(void)notificationHandler:(NSNotification*)notification
{
    if ([notification.name isEqualToString:WRRegisterAutoLogInNotification])
    {
        _accountTextField.text = notification.userInfo[@"account"];
        _passwordTextField.text = @"";
        [_passwordTextField becomeFirstResponder];
    }
}

#pragma mark -
-(BOOL)canSubmit {
    BOOL flag = YES;
    flag &= ([Utility ValidateMobile:self.accountTextField.text] || [Utility ValidateEmail:self.accountTextField.text]);
    flag &= [Utility ValidatePassword:self.passwordTextField.text];
    return flag;
}

-(void)loginWithFlag:(BOOL)flag {
    _accountTextField.enabled = !flag;
    _passwordTextField.enabled = _accountTextField.enabled;
    _submitButton.hidden = flag;
    self.loader.hidden = !_submitButton.hidden;
    if (self.loader.hidden) {
        [self.loader stopAnimating];
    } else {
        [self.loader startAnimating];
    }
}
@end
