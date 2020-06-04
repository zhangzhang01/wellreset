//
//  LeftSideController.m
//  rehab
//
//  Created by herson on 2016/11/21.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "LeftSideController.h"

#import "MTMissionHeadButton.h"

#import <YYKit/YYKit.h>
@interface LeftSideController ()
{
    CGFloat _sideWidth;
    BOOL _createdIcon;
    
    UIImageView *_bgImageView;
}
@property(nonatomic)UIImageView *headImageView;
@property(nonatomic)UILabel *nameLabel;

@end

@implementation LeftSideController

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithSideWidth:(CGFloat)width
{
    if (self = [super init]) {
        _sideWidth = width;
        
        [@[WRUpdateSelfInfoNotification, WRLogOffNotification, WRLogInNotification] enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:obj object:nil];
        }];
        
        [self updateUserInfo];
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"main_bg"];
    image = [image imageByRotate180];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = image;
    _bgImageView = imageView;
    [self.view addSubview:imageView];
    
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithFrame:self.view.bounds];
    effectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [self.view addSubview:effectView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _bgImageView.frame = CGRectMake(_sideWidth - _bgImageView.width, 0, _bgImageView.width, _bgImageView.height);
    
    [self.view bringSubviewToFront:self.headImageView];
    [self.view bringSubviewToFront:self.nameLabel];
    
    if (!_createdIcon) {
        _createdIcon = YES;
        
        CGRect bounds = self.view.bounds;
        
        CGFloat offset = WRUIOffset, x = offset, y = x + 20;
        self.headImageView.center = CGPointMake(bounds.size.width/2, y + self.headImageView.height/2);
        
        self.nameLabel.frame = CGRectMake(offset, self.headImageView.bottom + offset, bounds.size.width - 2*offset, self.nameLabel.height);
        
        NSArray *sideImageArray = @[@"home_sidebar_rehab", @"home_sidebar_collection", @"home_sidebar_alarm", @"home_sidebar_setting"];
        NSArray *sideTitleArray = @[NSLocalizedString(@"方案", nil),NSLocalizedString(@"收藏", nil),NSLocalizedString(@"提醒", nil), NSLocalizedString(@"设置", nil)];
        y = self.nameLabel.bottom + offset;
        UIView *view = self.view;
        for (int i = 0 ; i < sideImageArray.count; i++) {
            UIImage *image = [UIImage imageNamed:sideImageArray[i]];
            ImageTitleButton *button = [ImageTitleButton buttonWithType:UIButtonTypeCustom];
            button.tag = i + 1;
            button.frame = CGRectMake(0, y, view.size.width, view.size.width*0.8);
            button.titleLabel.font = [UIFont wr_tinyFont];
            [button setTitle:sideTitleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(onClickedButton:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
            y = button.bottom;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark - getter & setter
-(UIImageView *)headImageView {
    if (!_headImageView) {
        UIImage *defaultHeadImage = [WRUIConfig defaultHeadImage];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:defaultHeadImage];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imageView.frame.size.width/2;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 2.f;
        imageView.userInteractionEnabled = YES;
        __weak __typeof(self) weakSelf = self;
        [imageView bk_whenTapped:^{
            if (weakSelf.clickedEvent) {
                weakSelf.clickedEvent(imageView);
            }
        }];
        _headImageView = imageView;
        [self.view addSubview:imageView];
    }
    return _headImageView;
}

-(UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = NSLocalizedString(@"立即登录", nil);
        label.font = [UIFont wr_lightFont];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        [self.view addSubview:label];
        _nameLabel = label;
    }
    return _nameLabel;
}

#pragma mark - Callback
-(void)notificationHandler:(NSNotification*)notification
{
    if([notification.name isEqualToString:WRUpdateSelfInfoNotification] || [notification.name isEqualToString:WRLogOffNotification] || [notification.name isEqualToString:WRLogInNotification])
    {
        [self updateUserInfo];
    }
}

#pragma mark - Control Event
-(IBAction)onClickedButton:(UIButton*)sender
{
    if (self.clickedEvent) {
        self.clickedEvent(sender);
    }
}

#pragma mark -
-(void)updateUserInfo {
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    [WRUIConfig updateSelfHeadForImageView:self.headImageView];
    if ([selfInfo  isLogged])
    {
        NSString *name = selfInfo.name;
        if ([Utility IsEmptyString:name]) {
            name = NSLocalizedString(@"WELL用户", nil);
        }
        self.nameLabel.text = name;
    }
    else
    {
        self.nameLabel.text = NSLocalizedString(@"点击登录", nil);
    }
}

@end
