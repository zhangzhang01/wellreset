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
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        //imageView.layer.borderWidth = 1.f;
        //imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:imageView];
        self.headImageView = imageView;
        if (isSimply) {
            CGRect frame = self.bounds;
            CGFloat size = frame.size.height - 2*WRUIOffset;
            self.headImageView.frame = CGRectMake((frame.size.width - size)/2, (frame.size.height - size)/2, size, size);
            self.headImageView.layer.masksToBounds = YES;
            self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width/2;
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
