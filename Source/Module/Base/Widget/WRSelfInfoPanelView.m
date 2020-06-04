//
//  WRSelfInfoPanelView.m
//  rehab
//
//  Created by Matech on 3/9/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRSelfInfoPanelView.h"
#import "WRUserInfo.h"
#import "UIKit+AFNetworking.h"
#import "Masonry.h"

@implementation WRSelfInfoPanelView

+(CGFloat)defaultHeight {
    CGFloat offset = WRUILittleOffset;
    return [WRUIConfig defaultHeadImage].size.height + offset + [WRUIConfig defaultLabelHeight];
}

-(instancetype)initWithFrame:(CGRect)frame isSimple:(BOOL)isSimply {
    if (self = [super initWithFrame:frame]) {
        CGFloat offset = WRUILittleOffset;
        
        UIImage *defaultHeadImage = [WRUIConfig defaultHeadImage];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[WRUIConfig defaultHeadImage]];
        WRUserInfo *selfInfo = [WRUserInfo selfInfo];
        
//        if ([selfInfo isLogged] && selfInfo.headImageUrl) {
//            [imageView setImageWithUrlString:selfInfo.headImageUrl holderImage:[WRUIConfig defaultHeadImage]];
//        }
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        //imageView.layer.borderWidth = 1.f;
        //imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:imageView];
        self.headImageView = imageView;
        UIImage *image = [WRUIConfig defaultHeadImage];
        if (isSimply) {
//            CGRect frame = self.bounds;
//            CGFloat size = frame.size.height - 6*WRUIOffset;
//            self.headImageView.frame = CGRectMake((frame.size.width - size)/2, (frame.size.height - size)/2, size, size);
//            self.headImageView.layer.masksToBounds = YES;
//            self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2;
            CGRect frame = self.bounds;
            CGFloat size = image.size.width;
            self.headImageView.frame = CGRectMake((frame.size.width - size)/2, WRUIOffset, size, size);
            self.headImageView.layer.masksToBounds = YES;
            self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2;
            
            UIProgressView *pro=[[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
            //设置的高度对进度条的高度没影响，整个高度=进度条的高度，进度条也是个圆角矩形
            pro.frame=CGRectMake(30, self.headImageView.bottom + 2 * WRUIOffset, frame.size.width - 60, 50);
            //设置进度条颜色
            pro.trackTintColor=[UIColor lightGrayColor];
//            pro.layer.borderColor = [UIColor wr_rehabBlueColor].CGColor;
//            pro.layer.borderWidth = 0.5f;
            //设置进度默认值，这个相当于百分比，范围在0~1之间，不可以设置最大最小值
            //pro.progress=0.7;
            //设置进度条上进度的颜色
            pro.progressTintColor=[UIColor wr_rehabBlueColor];
            //设置进度条的背景图片
            // pro.trackImage=[UIImage imageNamed:@"1"];
            //设置进度条上进度的背景图片 IOS7后好像没有效果了)
            //  pro.progressImage=[UIImage imageNamed:@"1.png"];
            //设置进度值并动画显示
            [pro setProgress:(float)[WRUserInfo selfInfo].integral/[WRUserInfo selfInfo].nextLevel animated:NO];
            
//            CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
//            pro.transform = transform;//设定宽高
            //由于pro的高度不变 使用放大的原理让其改变
            pro.transform = CGAffineTransformMakeScale(1.0f, 2.0f);
            //自己设置的一个值 和进度条作比较 其实为了实现动画进度
            [self addSubview:pro];
            self.progressView = pro;
            
            UILabel *levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(pro.left, pro.bottom +  WRUIOffset, 0, 0)];
            levelLabel.text = [NSString stringWithFormat:@"LV%d",(int)[WRUserInfo selfInfo].level];
            levelLabel.font = [UIFont wr_textFont];
            [levelLabel sizeToFit];
            levelLabel.textColor = [UIColor wr_rehabBlueColor];
            levelLabel.width += WRUIOffset * 2;
            levelLabel.textAlignment = NSTextAlignmentLeft;
            [self addSubview:levelLabel];
            self.levellabal = levelLabel;
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(levelLabel.right, pro.bottom +  WRUIOffset, pro.width - levelLabel.right, 0)];
            label.text = [NSString stringWithFormat:@"%d/%d",(int)[WRUserInfo selfInfo].integral,(int)[WRUserInfo selfInfo].nextLevel];
            label.font = [UIFont wr_textFont];
            [label sizeToFit];
            label.width = pro.right - levelLabel.right;
            label.textColor = [UIColor wr_rehabBlueColor];
            label.textAlignment = NSTextAlignmentRight;

            [self addSubview:label];
            self.experiseLabel = label;
        } else {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:NSLocalizedString(@"注销", nil) forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button sizeToFit];
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self).with.offset(offset + 20);
                make.right.mas_equalTo(self).with.offset(-2*offset);
            }];
            self.logOffButton = button;
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                //make.center.mas_equalTo(self).with.offset(offset);
                make.center.mas_equalTo(self);
                make.size.mas_equalTo(defaultHeadImage.size);
            }];
            
            
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = NSLocalizedString(@"立即登录", nil);
            label.font = [UIFont wr_detailFont];
            label.textColor = [UIColor whiteColor];
            [label sizeToFit];
            [self addSubview:label];
            self.nameLabel = label;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.width.equalTo(self);
                make.top.equalTo(imageView.mas_bottom).with.offset(WRUINearbyOffset);
            }];
        }
    }
    return self;
}

#pragma mark - public
-(void)update {
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    UIImage *defaultHeadImage = [WRUIConfig defaultHeadImage];
    if ([selfInfo isLogged]) {
        if (![Utility IsEmptyString:selfInfo.headImageUrl]) {
            [self.headImageView setImageWithUrlString:selfInfo.headImageUrl holder:@"well_default_head"];
        } else {
            self.headImageView.image = defaultHeadImage;
        }
        
        NSString *name = selfInfo.name;
        if ([Utility IsEmptyString:name]) {
            name = NSLocalizedString(@"请到个人资料填写昵称", nil);
        }
        self.nameLabel.text = name;
    } else {
        self.headImageView.image = defaultHeadImage;
        self.nameLabel.text = NSLocalizedString(@"立即登录", nil);
    }
    //self.logOffButton.hidden = ![selfInfo isLogged];
}

@end
