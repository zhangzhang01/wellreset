//
//  BirthdayField.m
//  Gofind
//
//  Created by shizaihao on 2016/11/17.
//  Copyright © 2016年 shizaihaoshizaihao. All rights reserved.
//

#import "BirthdayField.h"

@implementation BirthdayField

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

// 初始化操作
- (void)setUp
{
    
    // 创建日期选择控件
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    
    
    // 设置日期模式
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    // 设置日期地区
    // zh:中国
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    // 1990-1-1
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [fmt dateFromString:@"1990-1-1"];
    
    // 设置一开始日期
    datePicker.date = date;
    
    // 监听用户输入
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    // 自定义文本框键盘
    self.inputView = datePicker;
}

- (void)dateChange:(UIDatePicker *)datePicker
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [fmt stringFromDate:datePicker.date];
    //    NSLog(@"%@",dateStr);
    self.text = dateStr;
}
// 初始化文本框文字
- (void)setUpText
{
    [self dateChange:(UIDatePicker *)self.inputView];
    
}


@end
