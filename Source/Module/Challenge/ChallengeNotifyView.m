//
//  ChallengeNotifyView.m
//  rehab
//
//  Created by herson on 8/24/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ChallengeNotifyView.h"

#import "WNXSelecButton.h"
#import "ShareData.h"
#import "WRUserInfo.h"
#import "UIKit+WR.h"
#import <YYKit/YYKit.h>
#import "UserViewModel.h"
//#import "UIImage+WR.h"
@interface ChallengeNotifyView ()
@property (nonatomic,strong)UIViewController *controller;
@property (nonatomic, copy) NSString *shareUrl;

@end
@implementation ChallengeNotifyView

-(instancetype)initWithFrame:(CGRect)frame isExcellent:(BOOL)flag viewController:(UIViewController *)viewController shareUrl:(NSString *)shareUrl{
    if (self = [super initWithFrame:frame]) {
        _shareUrl = shareUrl;
        _controller = viewController;
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
        
        CGFloat itemCount = 3;
        CGFloat itemWidth  = self.lightImageView.width/3;
        CGFloat itemHeight = 50;
        y = label.bottom + 10;
        NSArray *titleArray = @[NSLocalizedString(@"朋友圈", nil),NSLocalizedString(@"微信好友", nil),NSLocalizedString(@"QQ好友", nil)];
         NSArray *imageArray = @[@"challenge_wechat_timeline",@"challenge_wechat_friend",@"challenge_qq_friend"];
        for (int i=0; i<itemCount; i++) {
            WNXSelecButton *itemBtn = [[WNXSelecButton alloc] initWithFrame:CGRectMake(itemWidth*i, y, itemWidth, itemHeight)];
            [itemBtn setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            itemBtn.tag = i + 100;
//            NSString *itemName =  [self getTitleAndImageWithItem:itemBtn];
            [itemBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [container addSubview:itemBtn];
            UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemBtn.left, itemBtn.bottom+5, itemWidth, 20)];
            itemLabel.text = titleArray[i];
            itemLabel.font = [UIFont systemFontOfSize:12];
            itemLabel.textAlignment = NSTextAlignmentCenter;
            [container addSubview:itemLabel];
//            y = itemLabel.bottom;
        }
        y = label.bottom + itemHeight + 45;
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
        [button wr_roundBorderWithColor:self.titleLabel.backgroundColor];
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

- (IBAction)itemClick:(UIButton *)sender
{
    __weak __typeof(self)weakself = self;
    NSString *title = NSLocalizedString(@"WELL健康挑战结果", nil);
    NSString *url = _shareUrl;
    if ([Utility IsEmptyString:url]) {
        url = [NSString stringWithFormat:@"%@/share/dare/dare.html?userId=%@&videoId=%@&time=%ld",[ShareData data].shareIP,[WRUserInfo selfInfo].userId,self.videoId,self.time];
    }
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:[NSString stringWithFormat:@"挑战-%@",self.titleLabel.text]thumImage:self.head];
    shareObject.webpageUrl = url;
    messageObject.shareObject= shareObject;
    
    [UserViewModel fetchSaveShareType:@"challenge" completion:^(NSError *error, id object) {
        
    }];
   NSArray *array = @[@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_QQ)];
    [[UMSocialManager defaultManager]  shareToPlatform:[array[sender.tag - 100] integerValue] messageObject:messageObject currentViewController:_controller completion:^(id data, NSError *error) {
        if (!error) {
            [Utility removeFromSuperViewWithAnimation:self completion:^{
                if (weakself.shareSuccessBlock) {
                    weakself.shareSuccessBlock();
                }
            }];
        }
    }];
}
@end
