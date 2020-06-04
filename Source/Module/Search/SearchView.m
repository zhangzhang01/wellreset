//
//  SearchView.m
//  rehab
//
//  Created by yefangyang on 2016/10/9.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "SearchView.h"
#import "CodeView.h"
#import "LoginController.h"
#import "WRViewModel.h"
#import <YYKit/YYKit.h>
#define kMaxLength 11
#define countDownSeconds 60
@interface SearchView ()<UITextFieldDelegate>

@end

@implementation SearchView

-(instancetype)initWithFrame:(CGRect)frame;
{
    BOOL biPad = [WRUIConfig IsHDApp];
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"0a0a0aaa"];
        CGFloat offset = WRUIOffset, x , y = 74, cx, cy, buttonW, scrollHeight, phoneInset = 20, padInset = 80, verticalInset;
        if (biPad) {
            buttonW = 64;
            verticalInset = 3 * WRUIOffset;
            x = padInset;
            scrollHeight = 4 * verticalInset + 3 * buttonW + 2;;
        } else {
            buttonW = 34;
            verticalInset = WRUIOffset;
            x = phoneInset;
            scrollHeight = 4 * verticalInset + 3 * buttonW + 2;
        }
        CGFloat viewW = frame.size.width - 2 * x;
        self.scrollWidth = viewW;

        UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(x, y, viewW, scrollHeight)];
        messageView.backgroundColor = [UIColor whiteColor];
        messageView.layer.cornerRadius = 5.0f;
        [self addSubview:messageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(buttonW, verticalInset, viewW - 2 *buttonW, buttonW)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"搜索", nil);
        label.textColor = [UIColor blackColor];
        label.font = [UIFont wr_smallTitleFont];
        if (biPad) {
            label.font = [UIFont wr_titleFont];
        }
        [messageView addSubview:label];
//        x = label.right;
//        cx = buttonW;
        cy = buttonW;
//        y = 0;
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(x, y, cx, cy);
//        [button setImage:[UIImage imageNamed:@"close_gray_button"] forState:UIControlStateNormal];
//        [messageView addSubview:button];
//        [button addTarget:self action:@selector(onClickedCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        x = phoneInset;
        if (biPad) {
            x = padInset;
        }
        y = label.bottom + verticalInset;
        cx = viewW - 2 * x;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        textField.returnKeyType = UIReturnKeySearch;
        textField.frame = CGRectMake(x, y, cx, cy);
        [textField becomeFirstResponder];
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.placeholder = NSLocalizedString(@"请输入关键字", nil);
        [textField addTarget:self action:@selector(onClickedSearchTextField:) forControlEvents:UIControlEventEditingChanged];
        textField.delegate = self;
        [messageView addSubview:textField];
        self.searchTextField = textField;
        
        y = textField.bottom + 1;
        cy = 1;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.frame = CGRectMake(x, y, cx, cy);
        [messageView addSubview:line];
        
        phoneInset += offset;
        y = line.bottom + verticalInset;
        cx = (viewW - 2 * phoneInset - offset)/2;
        cy = buttonW;
        x = phoneInset;
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont wr_smallFont];
        if (biPad) {
            cancelButton.titleLabel.font = [UIFont wr_smallTitleFont];
        }
        cancelButton.frame = CGRectMake(x, y, cx, cy);
        cancelButton.backgroundColor = [UIColor orangeColor];
        [cancelButton wr_roundBorderWithColor:[UIColor orangeColor]];
        [messageView addSubview:cancelButton];
        [cancelButton addTarget:self action:@selector(onClickedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton = cancelButton;
        
        x = cancelButton.right + offset;
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(x, y, cx, cy);
        sureButton.titleLabel.font = [UIFont wr_smallFont];
        if (biPad) {
            sureButton.titleLabel.font = [UIFont wr_lightFont];
        }
        [sureButton setTitle:NSLocalizedString(@"搜索", nil) forState:UIControlStateNormal];
        sureButton.backgroundColor = [UIColor lightGrayColor];
        sureButton.enabled = NO;
        sureButton.layer.cornerRadius = 8.0f;
        sureButton.layer.masksToBounds = YES;
        sureButton.layer.borderColor = [UIColor whiteColor].CGColor;
        sureButton.layer.borderWidth = 1.0f;
        [messageView addSubview:sureButton];
        [sureButton addTarget:self action:@selector(onClickedSureButton:) forControlEvents:UIControlEventTouchUpInside];
        self.sureButton = sureButton;
    }
    return self;
    
}

- (IBAction)onClickedSearchTextField:(UITextField *)sender
{
    self.sureButton.enabled = (sender.text.length > 0);
    if (self.sureButton.enabled == YES) {
        self.sureButton.backgroundColor = [UIColor wr_themeColor];
    } else {
        self.sureButton.backgroundColor = [UIColor lightGrayColor];
    }
}

- (IBAction)onClickedCancelButton:(UIButton *)sender
{
    [Utility removeFromSuperViewWithAnimation:self completion:nil];
}


- (IBAction)onClickedCloseButton:(UIButton *)sender
{
    [Utility removeFromSuperViewWithAnimation:self completion:nil];
}

- (IBAction)onClickedSureButton:(UIButton *)sender
{
    __weak __typeof(self)weakself = self;
    [Utility removeFromSuperViewWithAnimation:self completion:^{
        if (weakself.onClickedSureButton) {
            weakself.onClickedSureButton(weakself.searchTextField.text);
        }
    }];
    
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    __weak __typeof(self)weakself = self;
    [Utility removeFromSuperViewWithAnimation:self completion:^{
        if (weakself.onClickedSureButton) {
            weakself.onClickedSureButton(weakself.searchTextField.text);
        }
    }];
    return YES;
}


@end
