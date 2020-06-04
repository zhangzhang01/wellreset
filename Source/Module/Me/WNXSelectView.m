//
//  WNXSelectView.m
//  WNXHuntForCity
//  github:    https://github.com/ZhongTaoTian/WNXHuntForCity
//  项目讲解博客:http://www.jianshu.com/p/8b0d694d1c69
//  Created by MacBook on 15/7/5.
//  Copyright (c) 2015年 维尼的小熊. All rights reserved.
//  用来处理详情页选着哪一个tableView的View，有两种情况，如果服务器返回的数据中评论为空，就有3个tableView
//  如果返回的评论时空就显示俩个view

#import "WNXSelectView.h"
#import "WNXSelecButton.h"

@interface WNXSelectView ()

/** 方案按钮 */
@property (nonatomic, strong) WNXSelecButton *schemeBtm;
/** 收藏按钮 */
@property (nonatomic, strong) WNXSelecButton *infoBtn;
/** 挑战按钮 */
@property (nonatomic, strong) WNXSelecButton *commentBtn;
/** 底部滑动的动画条 */
@property (nonatomic, strong) UIView *slideLineView;

@property (nonatomic, weak) CALayer *highlightLayer;

//记录当前被选中的按钮
@property (nonatomic, weak) WNXSelecButton *nowSelectedBtn;

@end

@implementation WNXSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp
{
    //背景色和阴影
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowOpacity = 0.1;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    
    //正常是需要注意图片和文字的距离，我一般在button的layoutSubViews重新布局
    //这个没有找到对应图片，我直接截取的 把文字一块截下来了，偷个懒
    self.schemeBtm = [WNXSelecButton buttonWithType:UIButtonTypeCustom];
    [self addBtnToView:self.schemeBtm image:[UIImage imageNamed:@"me_rehab"] title:@"方案" tag:0];
    self.infoBtn = [WNXSelecButton buttonWithType:UIButtonTypeCustom];
    [self addBtnToView:self.infoBtn image:[UIImage imageNamed:@"me_favor"] title:@"收藏" tag:1];
    
    //在setIsShowComment方法中写初始化，如果需要就将这个button初始化并且添加到view上
    self.commentBtn = [WNXSelecButton buttonWithType:UIButtonTypeCustom];
    [self addBtnToView:self.commentBtn image:[UIImage imageNamed:@"me_challenge"] title:@"挑战" tag:2];
    
//    CALayer *highlightLayer = [CALayer layer];
//    UIColor *highlightColor = [UIColor colorWithRed:253/255.0 green:148/255.0 blue:38/255.0 alpha:0.8];
//    highlightLayer.backgroundColor = highlightColor.CGColor;
//    _highlightLayer = highlightLayer;
//    [self.layer addSublayer: _highlightLayer];
    
    self.slideLineView = [[UIView alloc] init];
    self.slideLineView.backgroundColor = [UIColor orangeColor] ;
    self.slideLineView.layer.masksToBounds = YES;
    self.slideLineView.layer.cornerRadius = 2;
    [self addSubview:self.slideLineView];
    [self sendSubviewToBack:self.slideLineView];
    
        [self.commentBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.schemeBtm addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self.infoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
}

- (void)addBtnToView:(WNXSelecButton *)btn image:(UIImage *)image title:(NSString *)title tag:(NSInteger)tag
{
    [btn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    btn.tintColor = [UIColor lightGrayColor];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
    [self addSubview:btn];
}

//便利构造方法
+ (instancetype)selectViewWithisShowComment:(BOOL)isShowComment
{
    WNXSelectView *selectView = [[self alloc] init];
    selectView.isShowComment = isShowComment;
    return selectView;
}



#pragma mark - item移动算法
- (CGFloat)countMoveXWithItem : (UIButton *) item {
    const CGFloat x = CGRectGetMinX(item.frame);
    
    const CGFloat width = CGRectGetWidth(item.frame);
    
    const CGFloat currtWith = CGRectGetWidth(self.frame);
    
    CGFloat moveX = x - (currtWith - width) / 2;
    
    if (moveX < 0.f) {
        moveX = 0.f;
    }
    else if (moveX > self.bounds.size.width - currtWith) {
        moveX = self.bounds.size.width - currtWith;
    }
    
    return moveX;
}

//设置控件的frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //这里需要判断下是否显示commentBtn,抓不到数据，暂时先不显示，如果需要显示就给也设置frame
    CGFloat viewH = self.bounds.size.height;
    CGFloat viewW = self.bounds.size.width;
    CGFloat btnW = viewW /3;
    CGFloat btnH = viewH;
    //计算间距
    //CGFloat margin = (viewW - btnW * (self.subviews.count - 1)) / self.subviews.count;

    self.schemeBtm.frame = CGRectMake(0, 0, btnW, btnH);
    self.infoBtn.frame = CGRectMake(btnW , 0, btnW, btnH);
    self.commentBtn.frame = CGRectMake(2 * btnW, 0, btnW, btnH);
//    self.slideLineView.frame = CGRectMake(margin, viewH - 4, btnW, 4);
    self.slideLineView.frame = self.schemeBtm.frame;
}

#pragma mark - 按钮的Action
- (void)btnClick:(WNXSelecButton *)sender
{
    if (self.nowSelectedBtn == sender) return;
    self.nowSelectedBtn.selected = NO;
    sender.selected = YES;
    //通知代理点击
    if ([self.delegate respondsToSelector:@selector(selectView:didSelectedButtonFrom:to:)]) {
        [self.delegate selectView:self didSelectedButtonFrom:self.nowSelectedBtn.tag to:sender.tag];
    }
    //给滑动小条做动画
    CGRect rect = self.slideLineView.frame;
    rect.origin.x = sender.frame.origin.x;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.slideLineView.frame = rect;
    }];
    
    self.nowSelectedBtn = sender;
}

//有代理时，点击按钮
- (void)setDelegate:(id<WNXSelectViewDelegate>)delegate
{
    _delegate = delegate;
    
    [self btnClick:self.schemeBtm];
}

- (void)lineToIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(selectView:didChangeSelectedView:)]) {
                [self.delegate selectView:self didChangeSelectedView:0];
            }
            self.nowSelectedBtn = self.schemeBtm;
            break;
        case 1:
            if ([self.delegate respondsToSelector:@selector(selectView:didChangeSelectedView:)]) {
                [self.delegate selectView:self didChangeSelectedView:1];
            }
            self.nowSelectedBtn = self.infoBtn;
            break;
        default:
            break;
    }
    
    CGRect rect = self.slideLineView.frame;
    rect.origin.x = self.nowSelectedBtn.frame.origin.x;


    [UIView animateWithDuration:0.3 animations:^{
        self.slideLineView.frame = rect;
    }];

}

@end
