//
//  PTRehabMarkView.m
//  rehab
//
//  Created by herson on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "PTRehabMarkView.h"
#import <YYKit/YYKit.h>
@interface PTRehabMarkView()

@property(nonatomic)NSDate *beginDate;
@property(nonatomic)NSInteger days;
@property(nonatomic)NSMutableArray *labelArray;

@end

@implementation PTRehabMarkView

-(instancetype)initWithFrame:(CGRect)frame beginDate:(NSDate*)beginDate days:(NSInteger)days
{
    if (self = [super initWithFrame:frame]) {
        self.labelArray = [NSMutableArray array];
        
        self.beginDate = beginDate;
        self.days = days;
        [self createSubViews];
    }
    return self;
}

-(void)createSubViews
{
    //    CGFloat offset = 4;
    CGRect frame = self.frame;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    [self addSubview:scrollView];
    
    CGFloat cx = (frame.size.width)/7, cy = cx;
    CGFloat x = 0, y = 0;
    CGFloat yMax = 0;
    UIFont *font = [WRUIConfig IsHDApp] ? [UIFont wr_smallTitleFont] : [UIFont wr_textFont];
    
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, frame.size.width, 44)];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.text = [NSString stringWithFormat:@"%@月",[@(_beginDate.month) stringValue]];
    [scrollView addSubview:monthLabel];
    y = monthLabel.bottom;

    __weak __typeof(self) weakSelf = self;
    NSDate *nowDate = [NSDate date];
    BOOL findToday = NO;
    for(NSInteger i = 0; i < self.days; i++)
    {
        NSDate *date = [self.beginDate dateByAddingDays:i];
        BOOL flag = NO;
        if (!findToday) {
            findToday = ([Utility getDaysFrom:date To:nowDate] == 0);
            flag = findToday;
        }
        NSInteger weekDay = [date weekday];
        if ([[@(date.day) stringValue] isEqualToString:@"1"]) {
            if (weekDay != 1) {
                y += 44;
            }
            UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, frame.size.width, 44)];
            monthLabel.textAlignment = NSTextAlignmentCenter;
            monthLabel.text = [NSString stringWithFormat:@"%@月",[@(date.month) stringValue]];
            [scrollView addSubview:monthLabel];
            y = monthLabel.bottom;
        }
        
        
        x = (weekDay - 1)*cx;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.text = [@(date.day) stringValue];
        if (flag) {
            label.layer.borderColor = [UIColor wr_rehabBlueColor].CGColor;
            label.layer.borderWidth = 1;
        }
        UIColor *color = [UIColor grayColor];
        label.textColor = color;
        label.layer.cornerRadius = cx / 2;
        label.clipsToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = font;
        label.tag = i;
        label.userInteractionEnabled = YES;
        [label bk_whenTapped:^{
            [weakSelf actionForLabel:label];
        }];
        [scrollView addSubview:label];
        if (weekDay == 7) {
            y = label.bottom;
        }
        yMax = label.bottom;
        
        [self.labelArray addObject:label];
    }
    self.frame = [Utility resizeRect:self.frame cx:-1 height:frame.size.height];
    scrollView.height = frame.size.height;
    scrollView.contentSize = CGSizeMake(frame.size.width, yMax);
}

-(void)checkForDateArray:(NSArray<NSDate *> *)dateArray
{
    for(NSDate *date in dateArray)
    {
        NSInteger daysInterval = [Utility getDaysFrom:self.beginDate To:date];
        if (daysInterval >= 0)
        {
            if (daysInterval < self.labelArray.count)
            {
                UILabel *label = self.labelArray[daysInterval];
                if (![Utility IsEmptyString:label.text]) {
                    label.backgroundColor = [[UIColor wr_rehabBlueColor] colorWithAlphaComponent:1];
                    label.textColor = [UIColor whiteColor];
                    label.userInteractionEnabled = NO;
                }
            }
        }
    }
}

-(void)actionForLabel:(UILabel*)sender
{
    NSInteger daysInterval = [Utility getDaysFrom:self.beginDate To:[NSDate date]];
    if (daysInterval == sender.tag)
    {
        if (self.clickedEvent) {
            self.clickedEvent(sender);
        }
    }
}

@end
