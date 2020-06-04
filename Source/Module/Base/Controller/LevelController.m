//
//  LevelController.m
//  rehab
//
//  Created by 何寻 on 2016/12/1.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "LevelController.h"
#import "LevelUpgradeController.h"

#import "PermissionsViewModel.h"
#import "ShowAlertView.h"


@interface LevelController ()

@property(nonatomic)BOOL isLoadedData;
@property (nonatomic) PermissionsViewModel *viewModel;

@end


@implementation LevelController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"用户等级", nil);
    [WRNetworkService pwiki:@"用户等级"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!self.isLoadedData)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"well_icon_faq"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(onClickedFaqItem:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *faqItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = faqItem;
        
        [self loadData];
    }
}


#pragma mark - getter & setter
-(PermissionsViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[PermissionsViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - handler
-(IBAction)onClickedFaqItem:(UIBarButtonItem*)sender
{
    __weak __typeof(self)weakself = self;
    [SVProgressHUD showWithStatus:nil];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
    [self.viewModel fetchAllLevelRuleWithCompletion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [Utility retryAlertWithViewController:weakself.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
                [weakself onClickedFaqItem:weakself.navigationItem.rightBarButtonItem];
            }];
        } else {
            ShowAlertView *alertView = [[ShowAlertView alloc] initWithFrame:self.navigationController.view.bounds title:NSLocalizedString(@"升级规则", nil) titleArray:weakself.viewModel.ruleArray];
            [Utility viewAddToSuperViewWithAnimation:alertView superView:self.navigationController.view completion:^{
                
            }];
//            LevelUpgradeController *viewController = [[LevelUpgradeController alloc] init];
//            viewController.dataArray = weakself.viewModel.ruleArray;
//            [self.navigationController pushViewController:viewController animated:YES];
        }
    }];

}

#pragma mark -
-(void)layout
{
    UIView *container = self.scrollView;
    
    CGFloat x = 0, y = x;
    int level = 1;
    for(WRUserPermission *permission in self.viewModel.dataArray)
    {
        UIView *itemView = [self createPanelWithPermission:permission level:level];
        itemView.top = y;
        [container addSubview:itemView];
        y = itemView.bottom;
        level++;
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, y+90);
}

-(UIView*)createPanelWithPermission:(WRUserPermission*)permission level:(NSUInteger)level
{
    CGRect frame = self.scrollView.bounds;
    CGFloat offset = WRUIOffset, x = offset, y = x, cx = frame.size.width - 2*x;
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(x, y, frame.size.width, 0)];
    
    NSInteger userLevel = 1;
    if ([[WRUserInfo selfInfo] isLogged]) {
        userLevel = [WRUserInfo selfInfo].level;
        if (userLevel == 0) {
            userLevel = 1;
        }
    }
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:(level) <= userLevel ? @"rank_normal_%d" : @"rank_gray_%d", (int)level]];
    
    NSMutableArray *descArray = [NSMutableArray array];
    if (level > 0) {
        if (permission.askCount > 0) {
            [descArray addObject:[NSString stringWithFormat:NSLocalizedString(@"每周可以向专家提问%@个；", nil), [@(permission.askCount) stringValue]]];
        }
        if (permission.collection > 0) {
            [descArray addObject:[NSString stringWithFormat:NSLocalizedString(@"可以收藏%@个视频动作；", nil), [@(permission.collection) stringValue]]];
        }
    }
    
    if (descArray.count == 0) {
        [descArray addObject:NSLocalizedString(@"没有高级权限", nil)];
    }
    
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:image];
    iconImageView.frame = CGRectMake(x, y, 80, 80);
    [panel addSubview:iconImageView];
    
    x = iconImageView.right + offset;
    cx = panel.width - offset - x;
    UIView *allTitleView = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
    y = 0;
    x = 0;
    for(NSString *text in descArray)
    {
        UIView *pointView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 4, 4)];
        pointView.layer.masksToBounds = YES;
        pointView.layer.cornerRadius = pointView.width/2;
        pointView.backgroundColor = [UIColor lightGrayColor];
        [allTitleView addSubview:pointView];
        
        UILabel *label = [UILabel new];
        label.font = [UIFont wr_smallFont];
        label.numberOfLines = 1;
        label.textColor = [UIColor grayColor];
        label.text = text;
        [label sizeToFit];
        label.frame = CGRectMake(pointView.right + offset, y, cx, label.height);
        [allTitleView addSubview:label];
        y = label.bottom + offset;
        
        pointView.right = label.left - offset;
        pointView.centerY = label.centerY;
    }
    allTitleView.height = y;
    allTitleView.centerY = iconImageView.centerY;
    [panel addSubview:allTitleView];
    
    y = MAX(iconImageView.bottom, allTitleView.bottom) + 3;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, y, panel.width, WRUILineHeight)];
    lineView.backgroundColor = [UIColor wr_lineColor];
    [panel addSubview:lineView];
    y = lineView.bottom + 2;
    
    panel.frame = [Utility resizeRect:panel.frame cx:-1 height:y];
    iconImageView.top = (y - iconImageView.height)/2;
    return panel;
}

-(void)loadData
{
    __weak __typeof(self) weakSelf = self;
    [self.viewModel fetchAllPermissionsWithCompletion:^(NSError * _Nonnull error) {
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController
                                            title:NSLocalizedString(@"加载数据失败", nil)
                                       completion:^{
                                           [weakSelf loadData];
                                       }];
        } else {
            weakSelf.isLoadedData = YES;
            [weakSelf layout];
        }
    }];
}
@end
