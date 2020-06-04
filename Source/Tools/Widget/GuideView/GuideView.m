//
//  GuideView.m
//  GuideDemo
//
//  Created by 李剑钊 on 15/7/23.
//  Copyright (c) 2015年 sunli. All rights reserved.
//

#import "GuideView.h"
#import "UIView+Layout.h"
#import "UIImage+Mask.h"
#import <YYKit/YYKit.h>
@interface GuideView ()
{
    NSArray<NSValue*> *_maskViews;
    NSArray<NSString*> *_labels;
}
@property (nonatomic, weak) UIView *parentView;
@property (nonatomic, strong) UIView *maskBg;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UIImageView *btnMaskView;
@property (nonatomic, strong) UIImageView *arrwoView;
@property (nonatomic, strong) UILabel *tipsLabel;

//@property (nonatomic, weak) UIButton *maskBtn;

@property (nonatomic, strong) UIView *topMaskView;
@property (nonatomic, strong) UIView *bottomMaskView;
@property (nonatomic, strong) UIView *leftMaskView;
@property (nonatomic, strong) UIView *rightMaskView;

@property(nonatomic) NSUInteger currentIndex;

@end

@implementation GuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topMaskView];
        [self addSubview:self.bottomMaskView];
        [self addSubview:self.leftMaskView];
        [self addSubview:self.rightMaskView];
        [self addSubview:self.okBtn];
        [self addSubview:self.btnMaskView];
        [self addSubview:self.arrwoView];
        [self addSubview:self.tipsLabel];
        self.arrwoView.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = _parentView.bounds;
    _maskBg.frame = self.bounds;
    CGRect frame = _maskViews[self.currentIndex].CGRectValue;
    
    _btnMaskView.center = CGRectGetCenter(frame);
    
    CGRect btnMaskRect = frame;
    btnMaskRect.size = CGSizeMake(floor(btnMaskRect.size.width), floor(btnMaskRect.size.height));
    btnMaskRect.origin = CGPointMake(floor(btnMaskRect.origin.x), floor(btnMaskRect.origin.y));
    _btnMaskView.frame = btnMaskRect;
    
    _topMaskView.left = 0;
    _topMaskView.top = 0;
    _topMaskView.height = _btnMaskView.top;
    _topMaskView.width = self.width;
    
    _bottomMaskView.left = 0;
    _bottomMaskView.top = _btnMaskView.bottom;
    _bottomMaskView.width = self.width;
    _bottomMaskView.height = self.height - _bottomMaskView.top;
    
    _leftMaskView.left = 0;
    _leftMaskView.top = _btnMaskView.top;
    _leftMaskView.width = _btnMaskView.left;
    _leftMaskView.height = _btnMaskView.height;
    
    _rightMaskView.left = _btnMaskView.right;
    _rightMaskView.top = _btnMaskView.top;
    _rightMaskView.width = self.width - _rightMaskView.left;
    _rightMaskView.height = _btnMaskView.height;
    
    CGFloat offset = WRUIOffset;
    CGSize size = [_tipsLabel sizeThatFits:CGSizeMake(self.width - 2*offset, CGFLOAT_MAX)];
    _tipsLabel.size = size;
    _tipsLabel.centerX = _btnMaskView.centerX;
    if (_tipsLabel.left < offset) {
        _tipsLabel.left = offset;
    }
    else if(_tipsLabel.right > (self.frame.size.width - offset)) {
        _tipsLabel.right = (self.frame.size.width - offset);
    }
    
    if ((_btnMaskView.top - 2*offset - size.height - _arrwoView.height) < 0) {
        
        //should below
        _arrwoView.left = _btnMaskView.center.x;
        _arrwoView.top = _btnMaskView.bottom + offset;
        _tipsLabel.top = _arrwoView.top + offset;
        if (_tipsLabel.left < _btnMaskView.left) {
            _arrwoView.image = [_arrwoView.image imageByFlipHorizontal];
            _arrwoView.right = _btnMaskView.center.x;
                    _arrwoView.transform = CGAffineTransformMakeRotation(M_PI);
        } else {
            _arrwoView.transform = CGAffineTransformMakeRotation(M_PI);
        }
    } else {
        _arrwoView.right = _btnMaskView.center.x ;
        _arrwoView.bottom = _btnMaskView.top - offset;
        _tipsLabel.bottom = _arrwoView.bottom - offset;
        _arrwoView.transform = CGAffineTransformMakeRotation(0);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

- (void)dismiss {
    [self layoutWithIndex:(self.currentIndex + 1)];
}

-(void)layoutWithIndex:(NSUInteger)index {
    if (index < _maskViews.count) {
        self.currentIndex = index;
        self.tipsLabel.text = _labels[self.currentIndex];
        [self.okBtn setTitle:_labels[self.currentIndex] forState:UIControlStateNormal];
        [self setNeedsLayout];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

#pragma mark - getter and setter

- (UIView *)maskBg {
    if (!_maskBg) {
        UIView *view = [[UIView alloc] init];
        _maskBg = view;
    }
    return _maskBg;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.numberOfLines = NSIntegerMax;
        btn.hidden = YES;
        [btn setImage:[UIImage imageNamed:@"well_intro_btn_ok"] forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _okBtn = btn;
    }
    return _okBtn;
}

- (UIImageView *)btnMaskView {
    if (!_btnMaskView) {
        UIImage *image = [UIImage imageNamed:@"well_intro_white_mask"];
        image = [image maskImage:[[UIColor blackColor] colorWithAlphaComponent:0.71]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        _btnMaskView = imageView;
    }
    return _btnMaskView;
}

- (UIImageView *)arrwoView {
    if (!_arrwoView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"well_intro_arrow"]];
        _arrwoView = imageView;
    }
    return _arrwoView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.text = @"";
        tipsLabel.numberOfLines = 0;
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.font = [UIFont wr_textFont];
        tipsLabel.textAlignment = NSTextAlignmentLeft;
        [tipsLabel sizeToFit];
        _tipsLabel = tipsLabel;
    }
    return _tipsLabel;
}

- (UIView *)topMaskView {
    if (!_topMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        _topMaskView = view;
    }
    return _topMaskView;
}

- (UIView *)bottomMaskView {
    if (!_bottomMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        _bottomMaskView = view;
    }
    return _bottomMaskView;
}

- (UIView *)leftMaskView {
    if (!_leftMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        _leftMaskView = view;
    }
    return _leftMaskView;
}

- (UIView *)rightMaskView {
    if (!_rightMaskView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.71];
        _rightMaskView = view;
    }
    return _rightMaskView;
}

-(void)showInView:(UIView *)view maskFrames:(NSArray<NSValue*>*)frames labels:(NSArray<NSString*>*)labels {
    _maskViews = frames;
    _labels = labels;
    
    self.parentView = view;
    //self.maskBtn = _maskViews.firstObject;
    self.alpha = 0;
    self.currentIndex = 0;
    [view addSubview:self];
    
    __weak __typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.alpha = 1;
    } completion:nil];
    
    [self layoutWithIndex:0];
}

-(void)showInView:(UIView *)view maskViews:(NSArray<UIView*>*)views labels:(NSArray<NSString*>*)labels {
    NSMutableArray *framesArray = [NSMutableArray array];
    [views enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [framesArray addObject:[NSValue valueWithCGRect:obj.frame]];
    }];
    [self showInView:view maskFrames:framesArray labels:labels];
}
@end
