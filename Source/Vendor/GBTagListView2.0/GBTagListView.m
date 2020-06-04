//
//  GBTagListView.m
//  升级版流式标签支持点击
//
//  Created by 张国兵 on 15/8/16.
//  Copyright (c) 2015年 zhangguobing. All rights reserved.
//

#import "GBTagListView.h"
#import "RehabObject.h"
#import "TagLabel.h"

#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       10.0f
#define BOTTOM_MARGIN      10.0f
#define KBtnTag            1000
#define R_G_B_16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@interface GBTagListView()
{
    UIColor *_selectedBgColor, *_titleColor;
}
@end

@implementation GBTagListView
- (instancetype)initWithFrame:(CGRect)frame style:(tagViewStyle)style;{
    
    self = [super initWithFrame:frame];
    if (self) {
        _selectedBgColor = [UIColor wr_selectItemColor];
        _titleColor = R_G_B_16(0x818181);
        
        _style = style;
        totalHeight = 0;

        _tagArr = [[NSMutableArray alloc]init];
    }
    return self;
    
    
}

-(void)setTagWithTagArray:(NSArray*)arr selectedArray:(NSArray *)selectedArray{
    previousFrame = CGRectZero;
    [_tagArr addObjectsFromArray:arr];
    [arr enumerateObjectsUsingBlock:^(WRProTreatAnswer * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TagLabel *label = [[TagLabel alloc] initWithFrame:CGRectZero];
        label.treatAnswer = obj;
        if(_signalTagColor){
            //可以单一设置tag的颜色
            label.backgroundColor = _signalTagColor;
        }else{
            //tag颜色多样
         label.backgroundColor = [UIColor wr_themeColor];
        }
        if(_canTouch){
            label.userInteractionEnabled = YES;
            
        }else{
            label.userInteractionEnabled = NO;
        }
        UIColor *titleColor = _titleColor;
        __weak __typeof(self)weakself = self;
        [label bk_whenTapped:^{
            [weakself labelClick:label];
        }];
        label.font = [UIFont wr_textFont];
        label.text = obj.answer?obj.answer:obj;
        label.tag = KBtnTag + idx;
        label.layer.cornerRadius = 5;
        label.layer.borderColor = titleColor.CGColor;
        label.layer.borderWidth = 0.8;
        label.clipsToBounds=YES;
        label.selected = NO;
        CGSize Size_str = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        Size_str = CGSizeMake(Size_str.width + 20, Size_str.height + 10);
        
        CGRect newRect = CGRectZero;
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width)
        {
            newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }
        else
        {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
        }
        newRect.size = Size_str;
        label.frame = newRect;
        label.textAlignment = NSTextAlignmentCenter;
        previousFrame=label.frame;
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:label];
        
        for (WRProTreatAnswer *treat in selectedArray) {
            if ([obj.answer isEqualToString:treat.answer]) {
                label.selected = YES;
            }
        }
    }];
}


-(void)setTagWithNormalArray:(NSArray*)arr selectedArray:(NSArray *)selectedArray{
    previousFrame = CGRectZero;
    _tagArr = [[NSMutableArray alloc]init];
    [_tagArr addObjectsFromArray:arr];
    [arr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TagLabel *label = [[TagLabel alloc] initWithFrame:CGRectZero];
        label.treatAnswer = obj;
        if(_signalTagColor){
            //可以单一设置tag的颜色
            label.backgroundColor = _signalTagColor;
        }else{
            //tag颜色多样
            label.backgroundColor = [UIColor wr_themeColor];
        }
        if(_canTouch){
            label.userInteractionEnabled = YES;
            
        }else{
            label.userInteractionEnabled = NO;
        }
        UIColor *titleColor = _titleColor;
        __weak __typeof(self)weakself = self;
        [label bk_whenTapped:^{
            [weakself labelClick:label];
        }];
        label.font = [UIFont wr_textFont];
        label.text = obj;
        label.tag = KBtnTag + idx;
        label.layer.cornerRadius = 5;
        label.layer.borderColor = titleColor.CGColor;
        label.layer.borderWidth = 0.8;
        label.clipsToBounds=YES;
        label.selected = NO;
        CGSize Size_str = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        Size_str = CGSizeMake(Size_str.width + 20, Size_str.height + 10);
        
        CGRect newRect = CGRectZero;
        if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width)
        {
            newRect.origin = CGPointMake(10, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
            totalHeight +=Size_str.height + BOTTOM_MARGIN;
        }
        else
        {
            newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
        }
        newRect.size = Size_str;
        label.frame = newRect;
        label.textAlignment = NSTextAlignmentCenter;
        previousFrame=label.frame;
        [self setHight:self andHight:totalHeight+Size_str.height + BOTTOM_MARGIN];
        [self addSubview:label];
        
        for (NSString *obj in selectedArray) {
            if ([obj isEqualToString:label.text]) {
                label.selected = YES;
            }
        }
    }];
}



#pragma mark - 
-(void)setButtonSelected:(BOOL)flag button:(UIButton*)button
{
    button.selected = flag;
    button.backgroundColor = flag ? _selectedBgColor : [UIColor whiteColor];
    button.layer.borderColor = (flag ? _selectedBgColor : _titleColor).CGColor;
}

-(void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}

-(void)labelClick:(TagLabel*)label
{
    if (_style == tagViewStyleSingle)
    {
        for(UIView*view in self.subviews)
        {
            if([view isKindOfClass:[TagLabel class]])
            {
                TagLabel*temLabel=(TagLabel*)view;
                if (temLabel.selected)
                {
                    temLabel.selected = NO;
                } 
            }
        }
    }
    else
    {
        if (label.treatAnswer.type == ProTreatAnswerTypeExclusive && label.selected == NO)
        {
            for(UIView*view in self.subviews)
            {
                if([view isKindOfClass:[TagLabel class]])
                {
                    TagLabel *temLabel=(TagLabel*)view;
                    if (temLabel.selected == YES)
                    {
                        temLabel.selected = NO;
                    }
                }
            }
        }
        else
        {
            for(UIView *view in self.subviews)
            {
                if([view isKindOfClass:[TagLabel class]])
                {
                    TagLabel*temLabel = (TagLabel*)view;
                    if (temLabel.selected == YES && temLabel.treatAnswer.type == ProTreatAnswerTypeExclusive)
                    {
                        temLabel.selected = NO;
                    }
                }
            }
        }
    }
    label.selected = !label.selected;
    [self didSelectItems];
}

-(void)didSelectItems
{
    NSMutableArray*arr=[[NSMutableArray alloc]init];
    for(UIView*view in self.subviews)
    {
        
        if([view isKindOfClass:[TagLabel class]])
        {
            TagLabel*temLabel=(TagLabel *)view;
            if (temLabel.selected)
            {
                [arr addObject:_tagArr[temLabel.tag - KBtnTag]];
            }
        }
    }
    self.didselectItemBlock(arr);
}
@end
