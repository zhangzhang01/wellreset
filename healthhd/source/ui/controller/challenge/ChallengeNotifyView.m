//
//  ChallengeNotifyView.m
//  rehab
//
//  Created by 何寻 on 8/24/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ChallengeNotifyView.h"

@implementation ChallengeNotifyView

-(instancetype)initWithFrame:(CGRect)frame isExcellent:(BOOL)flag {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"0a0a0aaa"];
        
        UIColor *color = flag ? [UIColor colorWithHexString:@"f6d552"] : [UIColor wr_themeColor];
        
        UIImage *image = flag ? [UIImage imageNamed:@"challenge_bg_shine"] : [UIImage imageNamed:@"challenge_bg_light"];
        
        UIView *container = [[UIView alloc] init];
        container.backgroundColor = [UIColor wr_lightWhite];
        CGFloat x = 0, y, cx, cy;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [container addSubview:imageView];
        self.lightImageView = imageView;
        
        cx = 80;
        cy = cx;
        x = (imageView.width - cx)/2;
        y = (imageView.height - cy)/2;
        image = [UIImage imageNamed:@"well_logo_white"];
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frame = CGRectMake(x, y, cx, cy);
        [container addSubview:imageView];
        
        x = 0;
        y = self.lightImageView.bottom - 1;
        UILabel *label = [[UILabel alloc] init];
        label.text = @" ";
        label.font = [UIFont wr_titleFont];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = color;
        label.textAlignment = NSTextAlignmentCenter;
        CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y, self.lightImageView.width, size.height + 20);
        [container addSubview:label];
        self.titleLabel = label;
        
        y = label.bottom - 1;
        label = [[UILabel alloc] init];
        label.text = @" ";
        label.font = [UIFont wr_textFont];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = self.titleLabel.backgroundColor;
        size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y, self.lightImageView.width, size.height + 10);
        [container addSubview:label];
        self.detailLabel = label;
        
        y = label.bottom + 10;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        cx = self.lightImageView.width/3;
        cy = 36;
        x = cx/3;
        button.frame = CGRectMake(x, y, cx, cy);
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont wr_smallFont];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"再来一次", nil) forState:UIControlStateNormal];
        [button wr_roundBorderWithColor:[UIColor lightGrayColor]];
        [container addSubview:button];
        [button addTarget:self action:@selector(onClickedCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        x = button.right + button.left;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, cx, cy);
        button.backgroundColor = self.titleLabel.backgroundColor;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont wr_smallFont];
        [button wr_roundBorderWithColor:[UIColor lightGrayColor]];
        [container addSubview:button];
        button.tag = 1;
        [button addTarget:self action:@selector(onClickedCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        y = button.bottom + 10;
        cx = self.lightImageView.width;
        x = (frame.size.width - cx)/2;
        cy = y;
        y = (frame.size.height - cy)/2;
        container.frame = CGRectMake(x, y, cx, cy);
        [container wr_roundBorder];
        [self addSubview:container];
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
        [button sizeToFit];
        x = container.right - button.width/2;
        y = container.top - button.height/2;
        button.frame = [Utility moveRect:button.frame x:x y:y];
        button.tag = -1;
        [self addSubview:button];
        [button addTarget:self action:@selector(onClickedCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

#pragma mark - event
-(IBAction)onClickedCloseButton:(UIButton*)sender
{
    __weak __typeof(self) weakSelf = self;
    [Utility removeFromSuperViewWithAnimation:self completion:^{
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.click(sender.tag);
    }];
}
@end
