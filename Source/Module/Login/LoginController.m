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
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "FindPasswordController.h"
#import "LoginController.h"
#import "RegisterController.h"
#import "WRViewModel.h"
#import "WToast.h"
#import "WXApi.h"
#import "IQKeyboardManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

#import "WNXSelecButton.h"
#import "GuidIndexViewController.h"
#import "MainTabBarController.h"
#import <YYKit/YYKit.h>
#import "ProtocolController.h"
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
        NSString *path = [[NSBundle mainBundle] pathForResource:@"login_background" ofType:@"png"];
        UIImage *bgImage = [UIImage imageWithContentsOfFile:path];
//        self.view.layer.contents = (id)bgImage.CGImage;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self createBackBarButtonItem];
    
    //    LAContext * con = [[LAContext alloc]init];
    //
    //    //LAContext的localizedFallbackTitle属性设置(LAContext目前只有这一个属性),如果不设置的话,默认是”Enter Password”.值得注意的是,如果该属性设置为@“”(空字符串),该按钮会被隐藏
    //    con.localizedFallbackTitle = @"";
    //    NSError * error;
    //    BOOL can = [con canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    //    NSLog(@"%d",can);
    //    if (can) {
    //        [con evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"验证指纹" reply:^(BOOL success, NSError * _Nullable error) {
    //            NSLog(@"%d,%@",success,error);
    //        }];
    //    }

    self.title = NSLocalizedString(@"", nil);
    BOOL biPad = [WRUIConfig IsHDApp];
    CGRect frame = CGRectMake(0, 0, ScreenW,[[UIScreen mainScreen] bounds].size.height );
    if(biPad) {
        frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width*0.7f, [[UIScreen mainScreen] bounds].size.height*0.7f);
    }
    
    NSLog(@"login frame %@", NSStringFromCGRect(frame));
    
    //UIColor *textColor = [UIColor grayColor];
    UIColor *imageColor = [UIColor wr_lightThemeColor];
    
    CGFloat eraseHeight = 20;
    
    CGFloat x = 0, y = 0, cx = 0, cy = 0, offset = WRUIOffset;
    UIButton *button = nil;
    [self createBackBarButtonItem];
//    UIView *registerPanel = [self createRegisterView:frame];
//    [self.view addSubview:registerPanel];
//    registerPanel.center = CGPointMake(frame.size.width/2, eraseHeight + registerPanel.height/2 + 60);
    
    UIView *loginPanel = [self createLoginPanel:frame];
//    loginPanel.alpha = 0;
//    loginPanel.hidden = YES;
    [self.view addSubview:loginPanel];
    
    
//    [self.loginNotifyLabel bk_whenTapped:^{
//        loginPanel.centerY = loginPanel.centerY + 30;
//        CGFloat destY = registerPanel.centerY;
//        loginPanel.hidden = NO;
//        [UIView animateWithDuration:0.35 animations:^{
//            loginPanel.centerY = destY;
//            registerPanel.centerY = destY - 20;
//            registerPanel.alpha = 0;
//            loginPanel.alpha = 1;
//        } completion:^(BOOL finished) {
//            registerPanel.hidden = YES;
//        }];
//    }];
    
    y = MAX(loginPanel.bottom, loginPanel.bottom) + offset;
    cx = WRActivityIndicatorViewSize;
    if (biPad) {
        cx *= 2;
    }
    cy = cx;
//    x = (frame.size.width - cx/2)/2;
    x = ScreenW/2-cx/2;
    DGActivityIndicatorView *activityView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeTriplePulse tintColor:imageColor];
    activityView.frame = CGRectMake(x, y, cx, cy);
    activityView.hidden = YES;
//    activityView.backgroundColor = [UIColor redColor];
    [self.view addSubview:activityView];
    self.loader = activityView;
    
    NSMutableArray *oauthArray = [NSMutableArray array];
    if (!IPAD_DEVICE) {
        [oauthArray addObject:@"wechat"];
        
        
        [oauthArray addObject:@"qq"];

    }
    if (oauthArray.count > 0) {
        
        UIView *oauthView = [[UIView alloc] initWithFrame:CGRectMake(0, y, frame.size.width, 0)];
        y = offset;
        UILabel *label = [[UILabel alloc] init];
        label.text = NSLocalizedString(@"第三方登录", nil);
        label.font = [UIFont systemFontOfSize:WRDetailFont];
        label.textColor = [UIColor wr_titleTextColor];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.width = 103;
        label.centerX = oauthView.centerX;
        label.y = offset;
        label.backgroundColor = [UIColor whiteColor];
        
        
        UIView * line = [UIView new];
        line.x = WRUIBigOffset+WRUIDiffautOffset;
        line.width = self.view.width - (WRUIBigOffset+WRUIDiffautOffset)*2;
        line.height = 1;
        line.backgroundColor = [UIColor wr_lineColor];
        line.centerY = label.centerY;
        [oauthView addSubview:line];
        [oauthView addSubview:label];
        NSArray *imageArray = @[@"微信", @"QQ", /*@"well_login_weibo"*/];
        NSArray *titleArray = @[NSLocalizedString(@"微信登录", nil), NSLocalizedString(@"QQ登录", nil)];
        UIImage *image = [UIImage imageNamed:imageArray.firstObject];
        CGFloat offsetX = 3*offset;
        
        //        x = (frame.size.width - oauthArray.count *image.size.width - (oauthArray.count - 1)*offsetX)/2;
        //        cx = image.size.width;
        //
        y+= 13+23;
        cy = image.size.height;
        cx = 41;
        x = offsetX;
        cy = 41;
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
            //            UIImage * temImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            //            button.tintColor = [UIColor whiteColor];
            [button setBackgroundImage:image forState:0];
            button.frame = CGRectMake(x, y, cx, cy);
            button.centerX =   index*self.view.width/2.0 + self.view.width/4.0;
            button.tag = index;
            button.titleLabel.font = [UIFont wr_detailFont];
            [button setTitle:titleArray[index] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onClickedAuthorLogin:) forControlEvents:UIControlEventTouchUpInside];
            [oauthView addSubview:button];
            //            [button wr_verticalImageAndTitle:2.0];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            x += cx + offsetX;
            index++;
        }
        if (oauthArray.count > 1) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width * 0.5, y, 1, cy)];
            line.backgroundColor = [UIColor whiteColor];
            [oauthView addSubview:line];
        }
        
        UILabel* labal = [UILabel new];
        labal.text = @"登录即表示同意WELL健康用户协议";
        labal.y = button.bottom+40;
        labal.textAlignment = NSTextAlignmentCenter;
        labal.textColor = [UIColor wr_titleTextColor];
        labal.font = [UIFont systemFontOfSize:13];
        [labal sizeToFit];
        labal.centerX = ScreenW*1.0/2;
        [oauthView addSubview:labal];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labal.text];
        NSRange strRange = {str.length-4,4};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor wr_themeColor] range:strRange];
        [labal setAttributedText:str];
        
        UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(12*13+labal.x, labal.top-10, 6*13, 33)];
        //btn.backgroundColor = [UIColor redColor];
        [btn bk_whenTapped:^{
            [self.navigationController pushViewController:[ProtocolController new] animated:YES];
        }];
        [oauthView addSubview:btn];
        
        
        
        y = labal.bottom + 30 ;
        oauthView.frame = CGRectMake(0, frame.size.height - y-64, oauthView.width, y);
        [self.view addSubview:oauthView];
        
        
        
    }

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *lastAccount = [ud stringForKey:@"lastAccount"];
    if (![Utility IsEmptyString:lastAccount]) {
        _accountTextField.text = lastAccount;
//        self.codeButton.enabled =YES;
    } else {
#if DEBUG
//        _accountTextField.text = @"18126620338";
//        _passwordTextField.text = @"woaimeimei";
        
        
#endif
    }
    
    self.submitButton.enabled = YES;
    
    [WRNetworkService pwiki:@"登录"];
}

//-(UIView*)createRegisterView:(CGRect)frame {
//    UIColor *textColor = [UIColor grayColor];
//    
//    UIView *panel = [[UIView alloc] init];
//    CGFloat x = 0, y = 0, cx, offset = WRUIOffset;
//    cx = MIN(WRLoginOrRegisterMaxWidth, frame.size.width - 4*WRUIOffset);
//    x = (frame.size.width - cx) / 2;
//    BOOL biPad = [WRUIConfig IsHDApp];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, [WRUIConfig defaultLabelHeight])];
//    label.font = biPad ? [UIFont wr_titleFont] : [UIFont wr_textFont];
//    label.textColor = textColor;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = NSLocalizedString(@"还没有WELL健康帐号？", nil);
//    label.frame = CGRectMake(x, y, cx, 0);
//    [label sizeToFit];
//    label.frame = [Utility resizeRect:label.frame cx:cx height:-1];
//    [panel addSubview:label];
//    y = CGRectGetMaxY(label.frame) + 8;
//    
//    //    x = 20;
//    UIButton *button = [UIButton wr_defaultButtonWithTitle:NSLocalizedString(@"立即注册", nil)];
//    [button addTarget:self action:@selector(onClickedRegisterBtn:) forControlEvents:UIControlEventTouchUpInside];
//    button.frame = CGRectMake(x, y, cx, WRUIButtonHeight);
//    [panel addSubview:button];
//    y = CGRectGetMaxY(button.frame) + 8;
//    
//    cx = button.width;
//    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, [WRUIConfig defaultLabelHeight])];
//    label.font = biPad ? [UIFont wr_titleFont] : [UIFont wr_lightFont];
//    label.textColor = [UIColor wr_themeColor];
//    label.numberOfLines = 2;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.text = NSLocalizedString(@"已有WELL健康帐号？立即登录", nil);
//    label.frame = CGRectMake(x, y, cx, 0);
//    label.userInteractionEnabled = YES;
//    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
//    label.frame = [Utility resizeRect:label.frame cx:cx height:size.height];
//    [panel addSubview:label];
//    self.loginNotifyLabel = label;
//    y = CGRectGetMaxY(label.frame) + offset;
//    panel.frame = CGRectMake(0, 0, frame.size.width, y);
//    
//    return panel;
//}

-(UIView *)createLoginPanel:(CGRect)frame {
    UIColor *textColor = [UIColor grayColor];
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    
    CGFloat x, y = 0, cx, cy, offset = WRUIOffset;
//    cx = MIN(frame.size.width - 2*x, 300);
//    x = (frame.size.width - cx) / 2;
//    cy = WRUITextFieldHeight;
    
    BOOL biPad = [WRUIConfig IsHDApp];
    y = 59;
    
    UIImage *iconImage = [UIImage imageNamed:@"login_logo_new"];
    x = (frame.size.width - 142) / 2;
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:iconImage];
    iconImageView.frame = CGRectMake(x, y, 142, 63);
    [panel addSubview:iconImageView];
    y = iconImageView.bottom + 70;
    if (iPhone5) {
        y = iconImageView.bottom + 20;
    }
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 0, 0)];
//    label.text = NSLocalizedString(@"WELL健康", nil);
//    label.font = [UIFont wr_titleFont];
//    [label sizeToFit];
//    label.frame = [Utility resizeRect:label.frame cx:label.width height:label.height];
//    label.left = (panel.width - label.width)/2;
//    label.textColor = [UIColor wr_loginLogoColor];
//    [panel addSubview:label];
//    y = label.bottom + 2 * offset;
    
    x = offset;
    
    x = 37;
    cx = self.view.frame.size.width - 2*x;
    cy = WRUITextFieldHeight;
    
    UIImageView *phoneiconImage = [[UIImageView alloc]init];
    phoneiconImage.image = [UIImage imageNamed:@"手机"];
    phoneiconImage.frame = CGRectMake(x, y+7, 20, 20);
    [panel addSubview:phoneiconImage];
    
    UITextField *textField = [[UITextField alloc]init];
    textField.delegate = self;
    textField.frame = CGRectMake(x+25, y, cx-25, cy);
    textField.placeholder = NSLocalizedString(@"手机", nil);
    textField.returnKeyType = UIReturnKeyNext;
    textField.textColor = textColor;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [panel addSubview:textField];
    _accountTextField = textField;
    y = textField.bottom;
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    lineView.frame = CGRectMake(x +10 , y, cx-20 , 1);
    //    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x + 15, y, cx - 30, 1)];
    //    lineView.backgroundColor = [UIColor lightGrayColor];
    [panel addSubview:lineView];

    
    
    y = lineView.bottom;
    y+= 21;
    
    UIImageView *messageiconImage = [[UIImageView alloc]init];
    messageiconImage.image = [UIImage imageNamed:@"密码"];
    messageiconImage.frame = CGRectMake(x, y+7, 20, 20);
    [panel addSubview:messageiconImage];
    
     textField = [UITextField new];
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
    
    lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    lineView.frame = CGRectMake(x +10 , y, cx-20 , 1);
    //    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x + 15, y, cx - 30, 1)];
    //    lineView.backgroundColor = [UIColor lightGrayColor];
    [panel addSubview:lineView];
    y = lineView.bottom + offset;
    
//    UIButton * button = [UIButton wr_defaultButtonWithTitle:NSLocalizedString(@"登录", nil)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    button.enabled =NO;
    button.backgroundColor = [UIColor wr_themeColor];
    [button addTarget:self action:@selector(onClickedLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(x + 10, y+15, cx - 20, WRUIButtonHeight);
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds =YES;
    [panel addSubview:button];

    self.submitButton = button;
    y = CGRectGetMaxY(button.frame) + offset;
    
    UIFont *font = biPad ? [UIFont wr_textFont] : [UIFont systemFontOfSize:WRDetailFont];
    button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"忘记密码", nil) forState:UIControlStateNormal];
    button.enabled =YES;
    button.titleLabel.font = font;
    [button setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self.navigationController pushViewController:[FindPasswordController new] animated:YES];
    }];
    
    button.frame = CGRectMake(cx+20-50, y, 50, 13);
    [button sizeToFit];
    [panel addSubview:button];
    
    y = button.bottom;
    
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
    [IQKeyboardManager sharedManager].enable = YES;
    BOOL biPad = [WRUIConfig IsHDApp];
    if (biPad) {
        [IQKeyboardManager sharedManager].enable = NO;
    }
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar lt_reset];
//    self.navigationController.navigationBar.barTintColor = [UINavigationBar appearance].barTintColor;
//    self.navigationController.navigationBar.tintColor = [UINavigationBar appearance].tintColor;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [IQKeyboardManager sharedManager].enable = YES;

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
//-(IBAction)onClickedCancelButton:(id)sender {
//    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//}

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
                    if ([WRUserInfo selfInfo].isfirst) {
                        [weakSelf.navigationController pushViewController:[GuidIndexViewController new] animated:YES];
                    }else
                    {
                        [self dismissViewControllerAnimated:YES completion:nil];
                        MainTabBarController *tabbarController = [[MainTabBarController alloc] init];
                       AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                   app.window.rootViewController = tabbarController;
                        app.window.rootViewController = tabbarController;
                        WRUserInfo* info = [WRUserInfo selfInfo];
                        [[NSNotificationCenter defaultCenter] postNotificationName:WRLogInNotification object:nil];
                    }
                    
                    
//                    [WRViewModel getRegeHxcompletion:^(NSError * _Nonnull error, NSString * _Nonnull account, NSString * _Nonnull password) {
//                        if (!error) {
//                            __weak typeof(self) weakself = self;
////                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////                                EMError *error = [[EMClient sharedClient] loginWithUsername:account password:password];
////
////                                dispatch_async(dispatch_get_main_queue(), ^{
////                                    [weakself hideHud];
////                                    if (!error) {
////                                        //设置是否自动登录
////                                        [[EMClient sharedClient].options setIsAutoLogin:YES];
////
////                                        //保存最近一次登录用户名
////                                                                                [weakself saveLastLoginUsername];
////                                        //发送自动登陆状态通知
////                                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:[NSNumber numberWithBool:YES]];
////
////                                    }
////                                });
////
////
////                            });
//
//                        }}];
//
                    
             
//                    [weakSelf.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
    
    NSString *openType = sender.tag == 0 ? @"weixin":@"qq";
    
    UMSocialPlatformType  platformType = sender.tag == 0? UMSocialPlatformType_WechatSession :UMSocialPlatformType_QQ;
    [SVProgressHUD show];
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        if (!error)
        {
            UMSocialUserInfoResponse *snsAccount = result;
            
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@",snsAccount.name,snsAccount.uid,snsAccount.accessToken,snsAccount.iconurl, snsAccount.unionId);
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"openType"] = openType;
            params[@"type"] = @"login";
            if (snsAccount.usid) {
                params[@"openId"] = snsAccount.uid;
            }
            if (snsAccount.name) {
                params[@"name"] = snsAccount.name;
            }
            if (snsAccount.iconurl) {
                params[@"icon"] = snsAccount.iconurl;
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
            
            [WRViewModel userAuthorWithParams:params type:@"login" completion:^(NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                if (error) {
                    NSString *text = error.domain;
                    if (!text) {
                        text = NSLocalizedString(@"登录失败", nil);
                    }
                    [Utility Alert:text];
                } else {

                    
                    if ([WRUserInfo selfInfo].isfirst) {
                        [self.navigationController pushViewController:[GuidIndexViewController new] animated:YES];
                    }else
                    {
                        MainTabBarController *tabbarController = [[MainTabBarController alloc] init];
                        AppDelegate* app = [UIApplication sharedApplication].delegate;
                        app.window.rootViewController = tabbarController;
                        WRUserInfo* info = [WRUserInfo selfInfo];
                        [[NSNotificationCenter defaultCenter] postNotificationName:WRLogInNotification object:nil];
                    }
//                    [WRViewModel getRegeHxcompletion:^(NSError * _Nonnull error, NSString * _Nonnull account, NSString * _Nonnull password) {
//                        if (!error) {
//                            __weak typeof(self) weakself = self;
//                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                                EMError *error = [[EMClient sharedClient] loginWithUsername:account password:password];
//
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [weakself hideHud];
//                                    if (!error) {
//                                        //设置是否自动登录
//                                        [[EMClient sharedClient].options setIsAutoLogin:YES];
//
//                                        //保存最近一次登录用户名
//                                        [weakself saveLastLoginUsername];
//                                        //发送自动登陆状态通知
//                                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:[NSNumber numberWithBool:YES]];
//
//                                    }
//                                });
//
//
//                            });}}];
                    
                    
                }
            }];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"获取授权信息失败"];
        }
    }];
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

- (void)saveLastLoginUsername
{
//    NSString *username = [[EMClient sharedClient] currentUsername];
//    NSLog(@"-----debug %@",username);
//    if (username && username.length > 0) {
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
//        [ud synchronize];
//    }
}

@end
