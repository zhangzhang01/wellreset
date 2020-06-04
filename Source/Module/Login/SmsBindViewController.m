//
//  SmsBindViewController.m
//  rehab
//
//  Created by yongen zhou on 2017/6/1.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "SmsBindViewController.h"
#import "SmsLoginViewController.h"
#import "DGActivityIndicatorView.h"
#import "ReactiveCocoa.h"
#import "SVProgressHUD.h"
//#import "UIButton+WR.h"
#import "UITextField+WR.h"

#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "LoginController.h"
#import "WXApi.h"
#import "WRViewModel.h"
#import "WToast.h"
#import "IQKeyboardManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

#import "WNXSelecButton.h"
#import "GuidIndexViewController.h"
#import "MainTabBarController.h"
#import <YYKit/YYKit.h>
#import "ZYEALView.h"
#import "JCAlertView.h"
#import "ProtocolController.h"
#define kMaxLength 11
#define countDownSeconds 60
@interface SmsBindViewController ()<UITextFieldDelegate>{
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
}
@property(nonatomic) DGActivityIndicatorView *loader;
@property(nonatomic, weak)UITextField *accountTextField, *codeTextField;
@property(nonatomic, weak)UIButton *submitButton ,*codeButton,*passsButton;
@end

@implementation SmsBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    //    [self createBackBarButtonItem];
    //     self.title = NSLocalizedString(@"快捷登陆", nil);
    UIColor *imageColor = [UIColor wr_lightThemeColor];
    CGRect frame = CGRectMake(0, 0, ScreenW,[[UIScreen mainScreen] bounds].size.height );;
    
    CGFloat eraseHeight = 20;
    
    CGFloat x = 0, y = 0, cx = 0, cy = 0, offset = WRUIOffset;
    UIButton *button = nil;
    
    //    UIView *registerPanel = [self createRegisterView:frame];
    //    [self.view addSubview:registerPanel];
    //    registerPanel.center = CGPointMake(frame.size.width/2, eraseHeight + registerPanel.height/2 + 60);
    
    UIView *loginPanel = [self createLoginPanel:frame];
    [self.view addSubview:loginPanel];
    
    DGActivityIndicatorView *activityView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeTriplePulse tintColor:imageColor];
    activityView.frame = CGRectMake(x, y, cx, cy);
    activityView.hidden = YES;
    [self.view addSubview:activityView];
    self.loader = activityView;
    NSMutableArray *oauthArray = [NSMutableArray array];
    if (!IPAD_DEVICE) {
        [oauthArray addObject:@"wechat"];
        
        
        [oauthArray addObject:@"qq"];
        
    }
    if (oauthArray.count > 0) {
        
        UIView *oauthView = [[UIView alloc] initWithFrame:CGRectMake(x, y, frame.size.width, 0)];
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
//        [self.view addSubview:oauthView];
        
        
        
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *lastAccount = [ud stringForKey:@"lastAccount"];
    if (![Utility IsEmptyString:lastAccount]) {
        _accountTextField.text = @"";
        self.codeButton.enabled =YES;
    } else {
#if DEBUG
        //        _accountTextField.text = @"18126620338";
        //        self.codeButton.enabled =YES;
        
        
#endif
    }
    
    self.submitButton.enabled = [self canSubmit];
    
    [WRNetworkService pwiki:@"登录"];
    
    
    
    
    // Do any additional setup after loading the view.
}
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
    
    //    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 0, 0)];
    //    label.text = NSLocalizedString(@"WELL健康", nil);
    //    label.font = [UIFont wr_titleFont];
    //    [label sizeToFit];
    //    label.frame = [Utility resizeRect:label.frame cx:label.width height:label.height];
    //    label.left = (panel.width - label.width)/2;
    //    label.textColor = [UIColor wr_loginLogoColor];
    //    [panel addSubview:label];
    //    y = label.bottom + 2 * offset;
    if (iPhone5) {
        y = iconImageView.bottom + 20;
    }

    
    x = offset;
    cx = self.view.frame.size.width - 2*x;
    x = 37;
    cy = WRUITextFieldHeight;
    
    UITextField *textField = [UITextField wr_iconTextField:@"手机或账号"];
    textField.delegate = self;
    textField.frame = CGRectMake(x, y, cx, cy);
    textField.placeholder = NSLocalizedString(@"手机号", nil);
    textField.returnKeyType = UIReturnKeyNext;
    textField.textColor = textColor;
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
    
    
    cx = self.view.frame.size.width - 2*x;
    
    
    y+= 21;
    textField = [UITextField wr_iconTextField:@"验证码"];
    textField.placeholder = NSLocalizedString(@"验证码", nil);
    UIButton *albutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [albutton setTitleColor:[UIColor wr_themeColor] forState:UIControlStateNormal];
    [albutton setTitleColor:[UIColor wr_themeColor] forState:UIControlStateDisabled];
    [albutton setTitle:NSLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    albutton.titleLabel.font = [UIFont systemFontOfSize:WRDetailFont];
    albutton.backgroundColor = [UIColor whiteColor];
    albutton.enabled = YES;
    //    [albutton sizeToFit];
    
    CGFloat cx0 = 96;
    albutton.frame = CGRectMake(cx+20 - cx0 , y + (cy - 27)/2, 96, 27);
    [albutton wr_roundBorderWithColor:[UIColor clearColor]];
    albutton.userInteractionEnabled =YES;
    [albutton bk_whenTapped:^{
        [self onClickedGetCodeButton:albutton];
    }];
    [panel addSubview:albutton];
    [albutton wr_roundBorderWithColor:[UIColor wr_themeColor]];
    self.codeButton = albutton;
    
    
    textField.borderStyle = UITextBorderStyleNone;
    textField.returnKeyType = UIReturnKeyNext;
    textField.keyboardType = UIKeyboardTypeURL;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.layer.cornerRadius = 8.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 0.0f;
    //    [textField becomeFirstResponder];
    //                textField = [UITextField wr_iconTextField:leftImageArray[index]];
    [textField addTarget:self action:@selector(onClickedaccountTextField:) forControlEvents:UIControlEventEditingChanged];
    self.codeTextField = textField;
    
    
    
    textField.frame = CGRectMake(x, y, cx - 3 * offset - cx0, cy);
    y = textField.bottom;
    lineView = [UIView new];
    lineView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    lineView.frame = CGRectMake(x +10 , y, cx-20 , 1);
    //    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x + 15, y, cx - 30, 1)];
    //    lineView.backgroundColor = [UIColor lightGrayColor];
    [panel addSubview:lineView];
    y = lineView.bottom;
    
    [panel addSubview:textField];
    
    
    //    UIButton * button = [UIButton wr_defaultButtonWithTitle:NSLocalizedString(@"登录", nil)];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"绑定", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    button.enabled =NO;
    button.backgroundColor = [UIColor wr_themeColor];
    button.userInteractionEnabled = YES;
    [button bk_whenTapped:^{
        [self onClickedOKButton:button];
    }];
    button.frame = CGRectMake(x + 10, y+15, cx - 20, WRUIButtonHeight);
    button.layer.cornerRadius = 4;
    button.layer.masksToBounds =YES;
    [panel addSubview:button];
    self.submitButton = button;
    y = CGRectGetMaxY(button.frame) + offset;
    
    UIFont *font = biPad ? [UIFont wr_textFont] : [UIFont systemFontOfSize:WRDetailFont];
    button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setTitle:NSLocalizedString(@"密码登陆", nil) forState:UIControlStateNormal];
    button.enabled =YES;
    button.titleLabel.font = font;
    [button setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self.navigationController pushViewController:[LoginController new] animated:YES];
    }];
    
    button.frame = CGRectMake(cx+20-50, y, 50, 13);
    [button sizeToFit];
//    [panel addSubview:button];
    self.passsButton = button;
    
    y = button.bottom;
    
    __weak __typeof(self) weakSelf = self;
    //    RAC(self.submitButton, enabled) = [RACSignal combineLatest:@[self.accountTextField.rac_textSignal, self.passwordTextField.rac_textSignal]
    //                                                        reduce:^(NSString *account, NSString *password) {
    //                                                            return @([weakSelf canSubmit]);
    //                                                        }];
    
    panel.frame = CGRectMake(0, 0, frame.size.width, y);
    
    return panel;
}
#pragma mark -
-(BOOL)canSubmit {
    BOOL flag = YES;
    flag &= ([Utility ValidateMobile:self.accountTextField.text]);
    flag &= self.codeTextField.text.length ==6;
    return flag;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onClickedOKButton:(UIButton *)sender
{
    if (![Utility ValidateMobile:[self pureTextFieldWithString:self.accountTextField.text]]) {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
    } else {
        __weak __typeof(self)weakself = self;
        [SVProgressHUD showWithStatus:nil];
        NSLog(@"accountTextField%@",[self pureTextFieldWithString:self.accountTextField.text]);
        NSLog(@"codeTextField%@",self.accountTextField.text);
        __weak __typeof(self) weakSelf = self;
        [WRViewModel userBindPhone:self.accountTextField.text code:self.codeTextField.text completion:^(NSError * _Nonnull error) {
            
            if (error) {
                [SVProgressHUD dismiss];
                [Utility retryAlertWithViewController:weakSelf.navigationController title:error.domain completion:^{
                    [weakSelf onClickedOKButton:sender];
                }];
            }
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"绑定成功"];
                [WRUserInfo selfInfo].phone = self.accountTextField.text;
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }];
    }
}
- (void)valueChanged:(UITextField *)sender
{
    self.submitButton.enabled = [self isRightCode:sender.text];
    if (self.submitButton.enabled) {
        self.submitButton.backgroundColor = [UIColor wr_rehabBlueColor];
    } else {
        self.submitButton.backgroundColor = [UIColor wr_selectLabelBgColor];
    }
}

- (BOOL)isRightCode:(NSString *)text
{
    BOOL flag = NO;
    if (text.length == 6) {
        flag = YES;
    }
    return flag;
}

- (NSString *)pureTextFieldWithString:(NSString *)string
{
    NSString *text = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return text;
}

- (void)onClickedGetCodeButton:(UIButton *)sender
{
    if (self.accountTextField.text.length>0) {
        NSString *pureText = [self pureTextFieldWithString:self.accountTextField.text];
        [SVProgressHUD showWithStatus:nil];
        //    [self endEditing:YES];
        //  [self.codeTextField becomeFirstResponder];
        __weak __typeof(self) weakself = self;
        //    self.labelPhone.text = pureText;
        if (_sumSeconds < countDownSeconds && _sumSeconds > 0) {
            //        self.scrollView.contentOffset = CGPointMake(_scrollWidth , 0);
            [SVProgressHUD showWithStatus:NSLocalizedString(@"已发送验证码", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        } else {
            ZYEALView* code = [[ZYEALView alloc]initwithPhone:pureText type:@"bind"];
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
                [WRViewModel requestSmsCodeWithPhone:pureText type:@"bind" uuid:codeid code:md5code completion:^(NSError * _Nonnull error) {
                    [SVProgressHUD dismiss];
                    if (error) {
                        [AppDelegate show:error.domain];
                    }
                    else
                    {
                        [al dismissWithCompletion:^{
                            
                        }];
                        //                weakSelf.phone = phone;
                        [self smsCodeTimer];
                    }
                }];
            };
        }
    }
    else
    {
        [AppDelegate show:@"请输入手机号码"];
    }
    
    
}

- (IBAction)onClickedaccountTextField:(UITextField *)sender
{
    if (sender == _accountTextField) {
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
        if (sender.text.length > 6) {
            sender.text = [sender.text substringToIndex:6];
        }
        self.submitButton.enabled = [self isRightCode:sender.text];
        if (self.submitButton.enabled) {
            self.submitButton.backgroundColor = [UIColor wr_rehabBlueColor];
        } else {
            self.submitButton.backgroundColor = [UIColor wr_selectLabelBgColor];
        }
    }
    
    
}

- (IBAction)onClickedNextButton:(UIButton *)sender
{
    NSString *pureText = [self pureTextFieldWithString:self.accountTextField.text];
    [SVProgressHUD showWithStatus:nil];
    [self.view endEditing:YES];
    //    [self.identifierView beginEdit];
    __weak __typeof(self) weakself = self;
    self.accountTextField.text = pureText;
    if (_sumSeconds < countDownSeconds && _sumSeconds > 0) {
        
        [SVProgressHUD showWithStatus:NSLocalizedString(@"已发送验证码", nil)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    } else {
        ZYEALView* code = [[ZYEALView alloc]initwithPhone:pureText type:@"bind"];
        code.backgroundColor = [UIColor whiteColor];
        code.layer.cornerRadius = 5;
        JCAlertView* al = [[JCAlertView alloc]initWithCustomView:code dismissWhenTouchedBackground:YES];
        [al show];
        code.clossBlock = ^{
            [al dismissWithCompletion:^{
                
            }];
        };
        
        code.completionBlock = ^(NSString *text, NSString *codeid) {
            [al dismissWithCompletion:^{
                
            }];
            NSString* uptext =  [text uppercaseString];
            NSString* md5code = [uptext md5String];
            [WRViewModel requestSmsCodeWithPhone:pureText type:@"login" uuid:codeid code:md5code completion:^(NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"获取验证码失败", nil)];
            } else {
                [al dismissWithCompletion:^{
                    
                }];
                [SVProgressHUD dismiss];
                
                [self smsCodeTimer];
            }
        }];
        };
    }
}


//- (IBAction)onClickedScrollButton:(UIButton *)sender
//{
//    [self.identifierView endEditing:YES];
//    [self.accountTextField becomeFirstResponder];
//    [self.scrollView setContentOffset:CGPointZero animated:YES];
//}



- (IBAction)onClickedSendOnceMore:(UIButton *)sender
{
    ZYEALView* code = [[ZYEALView alloc]initwithPhone:[self pureTextFieldWithString:[self pureTextFieldWithString:self.accountTextField.text]] type:@"login"];
    code.backgroundColor = [UIColor whiteColor];
    code.layer.cornerRadius = 5;
    JCAlertView* al = [[JCAlertView alloc]initWithCustomView:code dismissWhenTouchedBackground:YES];
    [al show];
    code.clossBlock = ^{
        [al dismissWithCompletion:^{
            
        }];
    };
    
    code.completionBlock = ^(NSString *text, NSString *codeid) {
        [al dismissWithCompletion:^{
            
        }];
        NSString* uptext =  [text uppercaseString];
        NSString* md5code = [uptext md5String];

    __weak __typeof(self)weakself = self;
        [WRViewModel requestSmsCodeWithPhone:[self pureTextFieldWithString:[self pureTextFieldWithString:self.accountTextField.text]] type:@"bind" uuid:codeid code:md5code completion:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"获取验证码失败", nil)];
        } else {
            [al dismissWithCompletion:^{
                
            }];
            [self smsCodeTimer];
        }
    }];
    };
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

-(IBAction)onClickedAuthorLogin:(UIButton*)sender
{
    __weak __typeof(self) weakSelf = self;
    
    NSString *openType = sender.tag == 0 ? @"weixin":@"qq";
    
    UMSocialPlatformType  platformType = sender.tag == 0? UMSocialPlatformType_WechatSession :UMSocialPlatformType_QQ;
    
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
#if DEBUG
                    //        _accountTextField.text = @"18126620338";
                    //        self.codeButton.enabled =YES;
                    [WRUserInfo selfInfo].isfirst =YES;
                    
#endif
                    
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
