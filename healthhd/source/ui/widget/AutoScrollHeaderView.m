//
//  AutoScrollHeaderView.m
//  rehab
//
//  Created by 何寻 on 8/16/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "AutoScrollHeaderView.h"
#import "DDChannelLabel.h"

@interface AutoScrollHeaderView()
{
    UIView *_underline;
    NSMutableArray *_labelArray;
    UIColor *_color;
}
@end

@implementation AutoScrollHeaderView

-(instancetype)initWithFrame:(CGRect)frame color:(UIColor*)color {
    if (self = [super initWithFrame:frame]) {
        self.showsHorizontalScrollIndicator = NO;
        _labelArray = [NSMutableArray array];
        _color = color;
        
        [self addSubview:({
            CGFloat cy = 3;
            _underline = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - cy, 0, cy)];
            _underline.centerX = 0;
            _underline.backgroundColor = color;
            _underline;
        })];
    }
    return self;
}

- (DDChannelLabel*)addChannel:(NSString*)text labelCount:(NSInteger)labelCount
{
    CGFloat margin = 10.0;
    CGFloat x = 0;
    if (_labelArray.count > 0) {
        DDChannelLabel *label = _labelArray.lastObject;
        x = label.right;
    }
    
    CGFloat h = self.bounds.size.height;
    DDChannelLabel *label = [DDChannelLabel channelLabelWithTitle:text];
    label.font = [UIFont wr_smallFont];
    label.textColor = [UIColor darkGrayColor];
    CGFloat labelWidth = ([UIScreen mainScreen].bounds.size.width - (labelCount - 1) * margin) / labelCount;
    if (labelCount <= 3) {
        label.frame = CGRectMake(x, 0, labelWidth, h);
    } else {
        label.frame = CGRectMake(x, 0, label.width + margin, h);
    }
    
    label.tag = _labelArray.count;
    [self addSubview:label];
    x += label.bounds.size.width;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
    self.contentSize = CGSizeMake(x + margin, 0);
    [_labelArray addObject:label];
    return label;
}

-(NSInteger)getChannelCount {
    return _labelArray.count;
}

- (void)syncWithScrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat value = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (value < 0) {return;} // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
    
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    if (rightIndex >= [self getChannelCount]) {  // 防止滑到最右，再滑，数组越界，从而崩溃
        rightIndex = [self getChannelCount] - 1;
    }
    
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft  = 1 - scaleRight;
    
    DDChannelLabel *labelLeft  = _labelArray[leftIndex];
    labelLeft.scale  = scaleLeft;
    DDChannelLabel *labelRight = _labelArray[rightIndex];
    labelRight.scale = scaleRight;
    
    if (scaleLeft == 1 && scaleRight == 0) {
        return;
    }
    
    _underline.centerX = labelLeft.centerX   + (labelRight.centerX   - labelLeft.centerX)   * scaleRight;
    _underline.width   = labelLeft.textWidth + (labelRight.textWidth - labelLeft.textWidth) * scaleRight;
}

- (void)syncWithScrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    [self scrollToIndex:index];
}

-(void)scrollToIndex:(NSInteger)index
{
    // 滚动标题栏到中间位置
    DDChannelLabel *titleLable = _labelArray[index];
    CGFloat offsetx   =  titleLable.center.x - self.width * 0.5;
    CGFloat offsetMax = self.contentSize.width - self.width;
    // 在最左和最右时，标签没必要滚动到中间位置。
    if (offsetx < 0)		 {offsetx = 0;}
    if (offsetx > offsetMax) {offsetx = offsetMax;}
    [self setContentOffset:CGPointMake(offsetx, 0) animated:YES];
    
    // 先把之前着色的去色：（快速滑动会导致有些文字颜色深浅不一，点击label会导致之前的标题不变回黑色）
    for (DDChannelLabel *label in _labelArray) {
        label.textColor = [UIColor darkGrayColor];
    }
    // 下划线滚动并着色
    [self bringSubviewToFront:_underline];
    [UIView animateWithDuration:0.3 animations:^{
        _underline.top = titleLable.bottom - _underline.height;
        _underline.width = titleLable.textWidth;
        _underline.centerX = titleLable.centerX;
        titleLable.textColor = _color;
    }];
    
    if (self.clickedEvent) {
        self.clickedEvent(self, index);
    }
}

#pragma mark - Event
-(IBAction)labelClick:(UITapGestureRecognizer*)recognizer
{
    DDChannelLabel *label = (DDChannelLabel *)recognizer.view;
    [self scrollToIndex:label.tag];
}
@end
