//
//  HomeSubPageView.m
//  rehab
//
//  Created by herson on 2016/9/23.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "HomeSubPageView.h"
#import <YYKit/YYKit.h>
@interface HomeSubPageView ()
{
    NSArray<NSString*>* _titleArray, *_imageArray;
}


@end

@implementation HomeSubPageView

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*>*)titleArray images:(NSArray<NSString*>*)imageArray holderImage:(UIImage*)holderImage title:(NSString*)title icon:(NSString*)icon isLeft:(BOOL)isLeft enableArray:(NSMutableArray *)enableArray
{
    if (self = [super initWithFrame:frame]) {
        
        CGFloat offset = WRUIOffset, x = offset, y = x, cx = frame.size.width - 2*x;
        
        __weak __typeof(self) weakSelf = self;
        UIView *header = [RCAppUtils createSectionHeaderWithTitle:title icon:(NSString *)icon tintColor:[UIColor wr_titleTextColor] width:cx more:isLeft moreAction:^{
            if (weakSelf.moreEvent) {
                weakSelf.moreEvent();
            }
        }];
        header.frame = [Utility moveRect:header.frame x:x y:y];
        [self addSubview:header];
        
        CGFloat cy = cx*holderImage.size.height/holderImage.size.width;
        y = header.bottom + offset;
        for(NSUInteger index = 0; index < titleArray.count; index++)
        {
            NSNumber *number = enableArray[index];
            BOOL enable = [number integerValue];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
            imageView.userInteractionEnabled = YES;
            [imageView setImageWithUrlString:imageArray[index] holderImage:holderImage];
            imageView.tag = index;
            [imageView wr_setShadow];
            [self addSubview:imageView];
            [imageView bk_whenTapped:^{
                if (weakSelf.itemClickEvent) {
                    weakSelf.itemClickEvent(imageView);
                }
            }];
            
            UILabel *label = [UILabel new];
            label.textColor = [UIColor whiteColor];
            label.font = [[UIFont wr_titleFont] fontWithBold];
            label.numberOfLines = 1;
            if (!enable) {
                imageView.userInteractionEnabled =  NO;
                label.text = [NSString stringWithFormat:@"%@（即将上线）",titleArray[index]];
            } else {
                label.text = titleArray[index];
            }
            label.textAlignment = NSTextAlignmentCenter;
            label.frame = imageView.bounds;
            [imageView addSubview:label];
            
            y = imageView.bottom + offset;
            
            
        }
        self.frame = [Utility resizeRect:self.frame cx:-1 height:y];
        
        UIView *layerView = [[UIView alloc] initWithFrame:self.bounds];
        
        UIColor *gradientColor = [UIColor wr_themeColor];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];  // 设置渐变效果
        gradientLayer.bounds = layerView.bounds;
        gradientLayer.frame = layerView.bounds;
        gradientLayer.colors = isLeft ? @[(id)[[UIColor clearColor] CGColor], (id)[gradientColor colorWithAlphaComponent:0.5] .CGColor] :  @[(id)[gradientColor colorWithAlphaComponent:0.5].CGColor, (id)[[UIColor clearColor] CGColor]];
        gradientLayer.startPoint = CGPointMake(0.0, 0.0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        
        [layerView.layer insertSublayer:gradientLayer atIndex:0];
        [self addSubview:layerView];
        self.alphaView = layerView;
    }
    return self;
}

@end
