//
//  TextFieldValidator.h
//  BJFZ
//
//  Created by user on 15/8/18.
//  Copyright (c) 2015年 QinJun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TextFieldValidatorRule;

@interface TextFieldValidator : NSObject

/// 添加一条规则
- (void)addRule:(TextFieldValidatorRule *)rule;

/// 添加多条规则
- (void)addRules:(NSArray *)rules;

/// 验证所有规则
- (BOOL)validateWithSuccessBlock:(void(^)())successBlock failedBlock:(void(^)(TextFieldValidatorRule *rule))failedBlock;


@end
