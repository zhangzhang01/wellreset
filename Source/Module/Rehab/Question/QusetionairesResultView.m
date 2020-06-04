//
//  QusetionairesResultView.m
//  rehab
//
//  Created by yefangyang on 16/9/14.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "QusetionairesResultView.h"
#import <YYKit/YYKit.h>
@implementation QusetionairesResultView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"0a0a0aaa"];
        CGFloat x, y, cx, cy, offset, viewWidth;
        offset = WRUIOffset;
        x = 2 *offset;
        y = 74;
        viewWidth = frame.size.width - 2 *x;
        cy = frame.size.height - 2 * y;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, y, viewWidth, cy)];
        bgView.layer.cornerRadius = 5.0f;
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        UIImage *image = [UIImage imageNamed:@"well_logo"];
        cx = image.size.width;
        cy = image.size.height;
        x = (viewWidth - cx) / 2;
        y = 50;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(x, y, cx, cy);
        [bgView addSubview:imageView];
        y = imageView.bottom + 2 * offset;
        
        cx = viewWidth - 2 * offset;
        UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(offset, y, cx, 0)];
        labelTitle.numberOfLines = 0;
        labelTitle.text = NSLocalizedString(@"根据您的提交的信息，您的***很健康！\n如出现***不适，可使用【快速缓解】中的康复运动舒缓。", nil);
        labelTitle.font = [[UIFont wr_smallTitleFont] fontWithBold];
        labelTitle.textColor = [UIColor blackColor];
        CGSize size = [labelTitle sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        labelTitle.frame = CGRectMake(offset, y, size.width, size.height);
        [labelTitle sizeToFit];
        [bgView addSubview:labelTitle];
        y = labelTitle.bottom + 2 *offset;
        
        UILabel *labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(offset, y, cx, 0)];
        labelDetail.numberOfLines = 0;
        labelDetail.text = NSLocalizedString(@"1、	该测试结果只提供参考，不作为临床诊断意见及治疗依据；\n2、如需获得完整诊断意见请前往正规医疗机构；\n3、	您有权选择是否遵循测试结果及建议，属于个人自由；\n4、	因遵循测试结果及建议可能带来风险由您个人承担；WELL健康不承担相关法律责任；", nil);
        labelDetail.font = [UIFont wr_tinyFont];
        labelDetail.textColor = [UIColor lightGrayColor];
        size = [labelDetail sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        labelDetail.frame = CGRectMake(offset, y, size.width, size.height);
        [labelDetail sizeToFit];
        [bgView addSubview:labelDetail];
        y = labelDetail.bottom + offset;
        
        x = offset;
        cy = 44;
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(x, y, cx, cy);
        [sureButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sureButton.backgroundColor = [UIColor wr_themeColor];
        sureButton.layer.cornerRadius = 5.0f;
        [sureButton addTarget:self action:@selector(onClickedSureButton:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:sureButton];
    }
    return self;
}

- (IBAction)onClickedSureButton:(UIButton *)sender
{
    [Utility removeFromSuperViewWithAnimation:self completion:nil];
}

@end
