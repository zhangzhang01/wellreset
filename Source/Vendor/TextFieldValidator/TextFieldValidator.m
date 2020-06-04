//
//  TextFieldValidator.m
//  BJFZ
//
//  Created by user on 15/8/18.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import "TextFieldValidator.h"

#import "TextFieldValidatorRule.h"
#import <UIKit/UIKit.h>

@interface TextFieldValidator()

/// 保存所有规则
@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation TextFieldValidator

#pragma mark - init -
- (instancetype)init {
    if (self = [super init]) {
        _data = [NSMutableArray array];
    }
    return self;
}

#pragma mark - implement -
/// 添加一条规则
- (void)addRule:(TextFieldValidatorRule *)rule {
    [self.data addObject:rule];
}

/// 添加多条规则
- (void)addRules:(NSArray *)rules {
    [self.data addObjectsFromArray:rules];
}

/// 验证所有规则
- (BOOL)validateWithSuccessBlock:(void(^)())successBlock failedBlock:(void(^)(TextFieldValidatorRule *rule))failedBlock {
    for (TextFieldValidatorRule *rule in self.data) {
        // 如果textField隐藏或者不可用，默认当做YES
        UITextField *tf = rule.textField;
//        ContinueIf(tf.isHidden || tf.superview.isHidden || !tf.enabled);
//
//        if (!(rule.condition && rule.isValid)) {
//            if (failedBlock) {
//                failedBlock(rule);
//            }
            return NO;
//        }
    }
    
    if (successBlock) {
        successBlock();
    }
    return YES;
}

@end
