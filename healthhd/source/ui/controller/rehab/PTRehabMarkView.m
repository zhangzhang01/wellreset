//
//  PTRehabMarkView.m
//  rehab
//
//  Created by 何寻 on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "PTRehabMarkView.h"

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
    NSArray *weekDays = @[
                         NSLocalizedString(@"日", nil),
                         NSLocalizedString(@"一", nil),
                         NSLocalizedString(@"二", nil),
                         NSLocalizedString(@"三", nil),
                         NSLocalizedString(@"四", nil),
                         NSLocalizedString(@"五", nil),
                         NSLocalizedString(@"六", nil),
                         ];
    
    CGRect frame = self.frame;
    CGFloat cx = frame.size.width/weekDays.count, cy = MIN(30, cx);
    CGFloat x = 0, y = 0;
    CGFloat yMax = 0;
    UILabel *label;
    UIFont *font = [UIFont wr_textFont];
    for(NSInteger index = 0; index < weekDays.count; index++)
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.text = weekDays[index];
        label.textColor = [UIColor darkGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = font;
        [self addSubview:label];
        x = label.right;
    }
    y = label.bottom;
    
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
        x = (weekDay - 1)*cx;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        label.text = flag ? NSLocalizedString(@"今天", nil): [@(date.day) stringValue];
        UIColor *color = flag ? [UIColor orangeColor] : [UIColor darkGrayColor];
        label.textColor = color;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = font;
        label.tag = i;
        label.userInteractionEnabled = YES;
        [label bk_whenTapped:^{
            [weakSelf actionForLabel:label];
        }];
        [self addSubview:label];
        if (weekDay == weekDays.count) {
            y = label.bottom;
        }
        yMax = label.bottom;
        
        [self.labelArray addObject:label];
    }
    self.frame = [Utility resizeRect:self.frame cx:-1 height:yMax];
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
                    UIImage *image = [UIImage imageNamed:@"rehab_checked"];
                    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                    imageView.contentMode = UIViewContentModeScaleToFill;
                    CGFloat size = MIN(label.width, label.height) - 6;
                    imageView.frame = CGRectMake((label.width - size)/2, (label.height - size)/2, size, size);
                    [label addSubview:imageView];
                    
                    label.userInteractionEnabled = NO;
                    label.text = @"";
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
