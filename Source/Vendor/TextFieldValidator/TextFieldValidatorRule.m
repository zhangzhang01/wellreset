//
//  TextFieldValidatorRule.m
//  BJFZ
//
//  Created by user on 15/8/18.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import "TextFieldValidatorRule.h"
#import <objc/runtime.h>
#import "NSString+String.h"

#define NSNumWithUnsignedInteger(u) ([NSNumber numberWithUnsignedInteger:u])


@implementation TextFieldValidatorRule


typedef NS_ENUM(NSUInteger, ValidatorType) {
    /// 最大长度
    ValidatorTypeMaxLength,
    /// 最小长度
    ValidatorTypeMinLength,
    /// 手机号码
    ValidatorTypeMobile,
    
    /// 手机号码和邮箱
    ValidatorTypeMobileAndEmail,
    /// 邮箱
    ValidatorTypeEmail,
    
};

// 类型
static char kValidatorTypeKey;
// 运行时变量
static char kMaxLength, kMinLength;
// 额外
static char kTrimTextField;

#pragma mark - getter -
- (BOOL)isValid {
    // 默认NO
    BOOL flag = NO;
    // 获取类型
    ValidatorType type = [objc_getAssociatedObject(self, &kValidatorTypeKey) unsignedIntegerValue];
    // 文本
    NSString *text;
    if ([objc_getAssociatedObject(self, &kValidatorTypeKey) intValue]) {
        text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }else {
        text = _textField.text;
    }
    switch (type) {
        case ValidatorTypeMaxLength: {// 最大长度
            NSInteger maxLength = [objc_getAssociatedObject(self, &kMaxLength) unsignedIntegerValue];
            flag = text.length <= maxLength;
            break;
        }
        case ValidatorTypeMinLength: {// 最小长度
            NSInteger minLength = [objc_getAssociatedObject(self, &kMinLength) unsignedIntegerValue];
            flag = text.length >= minLength;
            break;
        }
        case ValidatorTypeMobile: {// 手机号码
            
            
            flag = [text isValidateMobile];
            break;
        }
        case ValidatorTypeMobileAndEmail:{//电话号码和邮箱
            flag = [text isValidateMobile]||[text isValidateEmail];
        }
            
        case ValidatorTypeEmail: {// 邮箱
            flag = [text isValidateEmail];
            break;
        }
        
        default: {
            break;
        }
    }
    
    return flag;
}
#pragma mark - init method -
- (instancetype)initWithValidatorType:(NSUInteger)validatorType withFailureString:(NSString *)failureString forTextField:(UITextField *)textField {
    if (self = [super init]) {
        // default
        _condition = YES;
        
        objc_setAssociatedObject(self, &kValidatorTypeKey, NSNumWithUnsignedInteger(validatorType), OBJC_ASSOCIATION_RETAIN);
        _failureString = failureString;
        _textField = textField;
    }
    
    return self;
}

#pragma mark - private method -


#pragma mark - implement method -
/// 文本非空，默认去掉前后的空格
+ (TextFieldValidatorRule *)nonZeroTextWithFailureString:(NSString *)failureString forTextField:(UITextField *)textField {
    TextFieldValidatorRule *rule = [self minLength:1 withFailureString:failureString forTextField:textField];
    objc_setAssociatedObject(rule, &kTrimTextField, @"1", OBJC_ASSOCIATION_RETAIN);
    
    return rule;
}

/// 文本最大长度， 最大为 maxLength
+ (TextFieldValidatorRule *)maxLength:(NSUInteger)maxLength withFailureString:(NSString *)failureString forTextField:(UITextField *)textField {
    TextFieldValidatorRule *rule = [[TextFieldValidatorRule alloc] initWithValidatorType:ValidatorTypeMaxLength withFailureString:failureString forTextField:textField];
    objc_setAssociatedObject(rule, &kMaxLength, NSNumWithUnsignedInteger(maxLength), OBJC_ASSOCIATION_RETAIN);
    
    return rule;
}

/// 文本最小长度， 最小为 minLength
+ (TextFieldValidatorRule *)minLength:(NSUInteger)minLength withFailureString:(NSString *)failureString forTextField:(UITextField *)textField {
    TextFieldValidatorRule *rule = [[TextFieldValidatorRule alloc] initWithValidatorType:ValidatorTypeMinLength withFailureString:failureString forTextField:textField];
    objc_setAssociatedObject(rule, &kMinLength, NSNumWithUnsignedInteger(minLength), OBJC_ASSOCIATION_RETAIN);
    
    return rule;
}

/// 判断是否是合法手机号码
+ (TextFieldValidatorRule *)checkIsValidMobileWithFailureString:(NSString *)failureString forTextField:(UITextField *)textField {
    TextFieldValidatorRule *rule = [[TextFieldValidatorRule alloc] initWithValidatorType:ValidatorTypeMobile withFailureString:failureString forTextField:textField];
    
    return rule;
}

//判断是否是合法的手机号码和邮箱
+ (TextFieldValidatorRule *)checkIsValidMobileAndEmailWithFailureString:(NSString *)failureString forTextField:(UITextField *)textField
{
    TextFieldValidatorRule *rule = [[TextFieldValidatorRule alloc] initWithValidatorType:ValidatorTypeMobileAndEmail withFailureString:failureString forTextField:textField];
    
    return rule;
}

/// 判断是否是合法邮箱
+ (TextFieldValidatorRule *)checkIsValidEmailWithFailureString:(NSString *)failureString forTextField:(UITextField *)textField {
    TextFieldValidatorRule *rule = [[TextFieldValidatorRule alloc] initWithValidatorType:ValidatorTypeEmail withFailureString:failureString forTextField:textField];
    
    return rule;
}




@end
