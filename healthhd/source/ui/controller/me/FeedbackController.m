//
//  FeedbackController.m
//  rehab
//
//  Created by Matech on 3/2/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "FeedbackController.h"
#import "WRViewModel.h"
#import "SVProgressHUD.h"
#import "Masonry/Masonry.h"
#import "ReactiveCocoa.h"
#import "WToast.h"

@interface FeedbackController ()
{
    NSDate *_startDate;
}
@property(nonatomic)UITextView* textView;
@property(nonatomic)UITextField* contactInfoTextField;
@end

@implementation FeedbackController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForMeWithType:@"complain" duration:duration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    
    _startDate = [NSDate date];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIColor *borderColor = [UIColor lightGrayColor];
    UIColor *textColor = [UIColor grayColor];
    
    CGFloat offset = WRUIOffset;
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.text = NSLocalizedString(@"请留下您的联系方式以便我们能就您的反馈向您及时沟通", nil);
    labelTitle.numberOfLines = 0;
    labelTitle.textColor = textColor;
    labelTitle.font = [UIFont wr_smallFont];
    CGSize size = [labelTitle sizeThatFits:CGSizeMake(self.view.width - 20, CGFLOAT_MAX)];
    [self.view addSubview:labelTitle];
    [labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.left.mas_equalTo(self.view).offset(10);
        make.height.mas_equalTo(size.height);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    UIView *insetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 44)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = insetView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.rightView = insetView;
    textField.placeholder = NSLocalizedString(@"联系方式", nil);
    textField.layer.borderColor = borderColor.CGColor;
    textField.layer.borderWidth = 1.0f;
    textField.layer.cornerRadius = 8.0f;
    textField.layer.masksToBounds = YES;
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(labelTitle);
        make.top.mas_equalTo(labelTitle.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
    self.contactInfoTextField = textField;
    
    UITextView *textView = [[UITextView alloc] init];
    textView.layer.borderColor = borderColor.CGColor;
    textView.layer.borderWidth = 1.0f;
    textView.layer.cornerRadius = 8.0f;
    textView.layer.masksToBounds = YES;
    textView.font = [UIFont wr_textFont];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(textField);
        make.top.mas_equalTo(textField.mas_bottom).with.offset(10);
        make.height.mas_equalTo(180);
    }];
    self.textView = textView;
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = textColor;
    label.font = [UIFont wr_smallFont];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(textView);
        make.top.mas_equalTo(textView.mas_bottom).with.offset(3);
        make.height.mas_equalTo([WRUIConfig defaultLabelHeight]);
    }];
    
    NSString *wechatNumber = [WRNetworkService getFormatURLString:urlWechat];
    if (![Utility IsEmptyString:wechatNumber]) {
        UILabel *labelWeChat = [[UILabel alloc] init];
        labelWeChat.numberOfLines = 0;
        labelWeChat.text = [NSString stringWithFormat:NSLocalizedString(@"可以通过关注微信号『%@』来反馈\n(点击复制)", nil), wechatNumber];
        labelWeChat.textAlignment = NSTextAlignmentCenter;
        labelWeChat.textColor = textColor;
        labelWeChat.userInteractionEnabled = YES;
        labelWeChat.font = [UIFont wr_smallFont];
        CGSize size = [labelWeChat sizeThatFits:CGSizeMake((self.view.width - 2*offset), CGFLOAT_MAX)];
        [self.view addSubview:labelWeChat];
        [labelWeChat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(textView);
            make.top.mas_equalTo(label.mas_bottom).offset(10);
            make.height.mas_equalTo(size.height);
        }];
        
        [labelWeChat bk_whenTapped:^{
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:wechatNumber];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"复制成功", nil)];
        }];
    }
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"提交", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onClickedSubmitButton:)];
    
    RAC(self.navigationItem.rightBarButtonItem, enabled) = [RACSignal combineLatest:@[self.textView.rac_textSignal]
                                                                             reduce:^(NSString *content) {
                                                                                 return @(content.length >= WRComplainTextMinLength && content.length <= WRComplainTextMaxLength);
                                                                             }];
    
    RAC(label, text) = [RACSignal combineLatest:@[self.textView.rac_textSignal]
                                         reduce:^(NSString *content) {
                                             if (content.length < WRComplainTextMinLength) {
                                                 return [NSString stringWithFormat:NSLocalizedString(@"至少输入%d个字符", nil), WRComplainTextMinLength];
                                             } else {
                                                 return [NSString stringWithFormat:NSLocalizedString(@"还可以输入%d个字符", nil), WRComplainTextMaxLength - content.length];
                                             }
                                         }];
    [WRNetworkService pwiki:@"投诉建议"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [self.textView becomeFirstResponder];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
-(IBAction)onClickedSubmitButton:(id)sender {
    if (![Utility IsEmptyString:self.textView.text]) {
        [self.view endEditing:YES];
        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"正在提交...", nil)];
        __weak __typeof(self) weakSelf = self;
        NSString *text = self.textView.text;
        if (![Utility IsEmptyString:self.contactInfoTextField.text]) {
            text = [NSString stringWithFormat:@"%@ %@", self.contactInfoTextField.text, text];
        }
        [WRViewModel complain:text completion:^(NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            if(error) {
                [Utility Alert:NSLocalizedString(@"提交失败", nil)];
            } else {
                weakSelf.textView.text = @"";
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"您的宝贵意见已经收到,感谢您的支持", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"返回", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }]];
                [weakSelf presentViewController:controller animated:YES completion:nil];
            }
        }];
    }
    
}


@end
