//
//  UITextField+WR.m
//  rehab
//
//  Created by Matech on 3/4/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "UITextField+WR.h"

@implementation UITextField(WR)

+(instancetype)wr_iconTextField:(NSString*)iconName height:(CGFloat)height {
    UITextField *textField = [[UITextField alloc] init];
    textField.borderStyle = UITextBorderStyleNone;
    textField.returnKeyType = UIReturnKeyNext;
    textField.keyboardType = UIKeyboardTypeURL;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.layer.cornerRadius = 8.0f;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textField.layer.borderWidth = 0.0f;
    
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,[UIImage imageNamed:iconName].size.width, [UIImage imageNamed:iconName].size.height)];
    leftView.contentMode = UIViewContentModeCenter;
    leftView.image = [UIImage imageNamed:iconName];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    return textField;
}

+(instancetype)wr_iconTextField:(NSString*)iconName {
    return [UITextField wr_iconTextField:iconName height:WRUITextFieldHeight];
}

@end
