//
//  InputCodeView.m
//  rehab
//
//  Created by yefangyang on 2016/12/20.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "InputCodeView.h"
#import <YYKit/YYKit.h>
@interface InputCodeView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *codeTextField;
@end

@implementation InputCodeView

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
            topInset = 64;
        }
        CGFloat viewW = frame.size.width - 2 * leftInset;
//        self.scrollWidth = viewW;
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
        cy = WRUITextFieldHeight;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"登录", nil);
        label.textColor = [UIColor blackColor];
        label.font = [UIFont wr_smallTitleFont];
        if (biPad) {
            label.font = [UIFont wr_titleFont];
        }
        [label sizeToFit];
        label.frame = [Utility moveRect:label.frame x:(viewW - label.width)/2 y:label.height];
        [scrollView addSubview:label];
        y = label.bottom + offset;
        
        UITextField *textField = nil;
        UIView *lineView = nil;
        
        NSArray *placeHolderArray = @[
                                      NSLocalizedString(@"请输入邀请码", nil),
                                      NSLocalizedString(@"请输入验证码", nil)
                                      ];
        NSArray *leftImageArray = @[
                                    @"",
                                    @""
                                    ];
        for(NSUInteger index = 0; index < placeHolderArray.count; index++)
        {
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
                CGFloat cx0 = button.frame.size.width*4/3;
                button.frame = CGRectMake(cx - cx0, y + (cy - cy*2/3)/2, cx0, cy*2/3);
                [button wr_roundBorderWithColor:[UIColor clearColor]];
//                [button addTarget:self action:@selector(onClickedGetCodeButton:) forControlEvents:UIControlEventTouchUpInside];
                [_scrollView addSubview:button];
//                self.codeButton = button;
                
                textField = [UITextField wr_iconTextField:leftImageArray[index]];
//                [textField addTarget:self action:@selector(onClickedPhoneTextField:) forControlEvents:UIControlEventEditingChanged];
                textField.frame = CGRectMake(x, y, cx - offset - cx0, cy);
                lineView = [[UIView alloc] initWithFrame:CGRectMake( x + 15, textField.bottom, cx - offset - cx0 - 30, 1)];
            }
            else
            {
                textField = [UITextField wr_iconTextField:leftImageArray[index]];
                textField.frame = CGRectMake(x, y, cx, cy);
                lineView = [[UIView alloc] initWithFrame:CGRectMake(x + 15, textField.bottom, cx - 30, 1)];
//                [textField addTarget:self action:@selector(onClickedPhoneTextField:) forControlEvents:UIControlEventEditingChanged];
            }
//            textField.delegate = self;
            textField.placeholder = placeHolderArray[index];
            [textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
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
            
            lineView.backgroundColor = [UIColor wr_lightGray];
            [_scrollView addSubview:textField];
            [_scrollView addSubview:lineView];
            y += cy + offset;
            switch (index) {
                case 0:
                    _codeTextField = textField;
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
//        [btnOK addTarget:self action:@selector(onClickedOKButton:) forControlEvents:UIControlEventTouchUpInside];
        btnOK.frame = CGRectMake(x, y, cx, cy);
        [_scrollView addSubview:btnOK];
//        self.sureButton = btnOK;
        y = btnOK.bottom + offset;
        
        
        _scrollView.height = y;
        
    }
    return self;
    
}

@end
