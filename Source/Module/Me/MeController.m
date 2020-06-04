//
//  MeController.m
//  rehab
//
//  Created by herson on 8/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "MeController.h"
#import "SettingController.h"
#import "ShareData.h"
#import "ShareUserData.h"
#import "BaseCell.h"
#import "UserViewModel.h"
#import "ProgressController.h"
#import "CategoryView.h"
#import "AlarmController.h"
#import "FavorListController.h"
#import "RehabPlayerController.h"
#import "ChallengePlayerController.h"
#import "WRRefreshHeader.h"
#import "ChallengeVideoCell.h"
#import "WNXSelectView.h"
#import "ArticleCell.h"
#import "WRProgressCell.h"
#import "ProTreatViewModel.h"
#import "RehabController.h"
#import "ArticleDetailController.h"
#import "WNXSelecButton.h"
#import "ChallengeController.h"
#import <YYKit/YYKit.h>
#import "firstReportViewController.h"
@interface MeController ()<UIScrollViewDelegate>

@property(nonatomic) UILabel *titleLabel, *nameLabel, *treatCountLabel, *completeTreatCountLabel, *totalTimeLabel, *totalDayLabel;
@property(nonatomic) UIImageView *headImageView;
@property(nonatomic) UIView *titleBarView;
@property (nonatomic, strong) WNXSelecButton *clickedButton;

@property(nonatomic) UIImageView *blurImageView;
@property(nonatomic) CategoryView *categoryView;
@property(nonatomic) UIView *sectionHeaderView, *topBgView, *redView;
@property(nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIView *sliderView;

@property(nonatomic) ProgressController *progressController;
@property(nonatomic) FavorListController *favorListController;
@property(nonatomic) ChallengeController *challengeController;

@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property(nonatomic)BOOL flag;

@end

@implementation MeController
- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init {
    if (self = [super init])
    {
        __weak __typeof(self) weakSelf = self;
        [@[WRUpdateSelfInfoNotification] enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(notificationHandler:) name:obj object:nil];
        }];
        
        [self updateUserInfo];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wr_lightThemeColor];
    
    self.topView = [self createTableHeaderView];
    self.topView.frame = CGRectMake(0, 0, _topView.width, _topView.height);
    [self.view addSubview:self.topView];
    
    NSArray *titleArray = @[NSLocalizedString(@"方案", nil), NSLocalizedString(@"收藏", nil),NSLocalizedString(@"挑战", nil)];
    NSArray *imageArray = @[@"me_rehab",@"me_favor", @"me_challenge"];
    NSUInteger count = titleArray.count;
    
    UIView *tabView = [[UIView alloc] init];
    tabView.backgroundColor = [UIColor whiteColor];
    tabView.layer.cornerRadius = 8.0f;
    tabView.layer.masksToBounds = YES;
    
    CGFloat cy = 0;
    CGFloat y = self.topView.bottom - WRUIOffset;
    CGFloat x = 2;
    
    tabView.frame = CGRectMake(x, y, self.view.width - 2*x, cy);
    
    CGFloat cx = tabView.width / count;
    x = 0;
    y = 0;
    self.buttonArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        WNXSelecButton *button = [WNXSelecButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        
        UIImage *image = [UIImage imageNamed:imageArray[i]];
        UIImage *selectedImage = [image imageByTintColor:[UIColor whiteColor]];
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:selectedImage forState:UIControlStateSelected];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (cy == 0) {
            cy = image.size.height + 4*WRUIOffset;
        }
        button.frame = CGRectMake(x, y, cx, cy);
        [tabView addSubview:button];
        
        [self.buttonArray addObject:button];
        x = button.right;
    }
    tabView.frame = [Utility resizeRect:tabView.frame cx:-1 height:cy + 4];
    [self.view addSubview:tabView];
    
    WNXSelecButton *firstTitleButton = self.buttonArray.firstObject;
    firstTitleButton.selected = YES;
    self.clickedButton = firstTitleButton;
    
//    x = tabView.left;
    y = tabView.bottom - 8;
    cx = tabView.width;// - (int)(self.view.width/(self.buttonArray.count*6));
    cy = self.view.height - 48 - y;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(2, y, cx, cy)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(self.buttonArray.count* scrollView.width, scrollView.height);
    scrollView.backgroundColor = [UIColor wr_lightWhite];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [self addTableViewIntoScrollView];

    y = firstTitleButton.top, cx = firstTitleButton.width, cy = tabView.height;
    UIView *silderView = [[UIView alloc] initWithFrame:CGRectMake(0, y, cx, cy)];
    silderView.backgroundColor = [UIColor wr_themeColor] ;
    [tabView addSubview:silderView];
    [tabView sendSubviewToBack:silderView];
    self.sliderView = silderView;
    
    self.titleBarView.frame = [Utility resizeRect:self.titleBarView.frame cx:-1 height:self.view.bounds.size.height - 48];
    self.topView.frame = [Utility resizeRect:self.titleBarView.frame cx:-1 height:self.view.bounds.size.height - 48];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkAlarm];
}

#pragma mark - Getter & Setter
-(ProgressController *)progressController {
    if (!_progressController) {
        _progressController = [[ProgressController alloc] init];
        [self addChildViewController:_progressController];
    }
    return _progressController;
}

-(FavorListController *)favorListController
{
    if (!_favorListController) {
        _favorListController = [[FavorListController alloc] initWithStyle:UITableViewStylePlain];
        [self addChildViewController:_favorListController];
    }
    return _favorListController;
}

-(ChallengeController *)challengeController {
    if (!_challengeController) {
        _challengeController = [[ChallengeController alloc] init];
        [self addChildViewController:_challengeController];
    }
    return _challengeController;
}

#pragma mark - WNXSelectViewDelegate
- (void)titleClick:(WNXSelecButton *)titleButton
{
    switch (titleButton.tag) {
        case 0:{
            [UMengUtils careForMeRehab];
            break;
        }
        case 1:{
            [UMengUtils careForMeFavor];
            break;
        }
        case 2:{
            [UMengUtils careForMeChallenge];
            break;
        }
        default:
            break;
    }
    self.clickedButton.selected = NO;
    titleButton.selected = YES;
    self.clickedButton = titleButton;
    [self.scrollView setContentOffset:CGPointMake(titleButton.tag*self.scrollView.contentSize.width/self.buttonArray.count, 0) animated:YES];
}

- (void)addTableViewIntoScrollView
{
    NSInteger index = self.scrollView.contentOffset.x / self.scrollView.width;
    UIView *view = nil;
    WRTableViewController *controller = nil;
    switch (index) {
        case 0:
            controller = self.progressController;
            break;
            
        case 1:
            controller = self.favorListController;
            break;
            
        case 2:
            //controller = self.challengeController;
            break;
            
        default:
            break;
    }
    view = controller.view;
    controller.tableView.backgroundColor = [UIColor clearColor];
    if (view.superview != self.scrollView) {
        view.frame = [Utility moveRect:self.scrollView.bounds x:index*self.scrollView.width y:-1];
        [self.scrollView addSubview:view];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self addTableViewIntoScrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int x = (int)scrollView.contentOffset.x;
    int width = (int)scrollView.width;
    NSInteger index = x / width;
    if (x%width > 5) {
        index++;
    }
    if (index < self.buttonArray.count) {
        WNXSelecButton *titleButton = self.buttonArray[index];
        [self titleClick:titleButton];
        [self addTableViewIntoScrollView];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        CGFloat x = (scrollView.contentOffset.x*self.sliderView.width*self.buttonArray.count)/scrollView.contentSize.width;
        self.sliderView.frame = [Utility moveRect:self.sliderView.frame x:x y:-1];
    }
}

#pragma mark - Handler
-(void)showRehab:(WRRehab*)rehab
{
    __weak __typeof(self) weakSelf = self;
    if (rehab.disease.isProTreat)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在获取数据", nil)];
        [ProTreatViewModel userGetProTreatDetailWithData:rehab completion:^(NSError * error, id proTreatRehabDetailDict) {
            [SVProgressHUD dismiss];
            if (error) {
                
            } else {
                NSDictionary *dict = proTreatRehabDetailDict;
                WRRehab *rehab = [[WRRehab alloc] initWithDictionary:dict];
                rehab.disease.isProTreat = YES;
                RehabController *proTreatRehabDetailController = [[RehabController alloc] initWithRehab:rehab];
                WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:proTreatRehabDetailController];
                [[weakSelf.class root] presentViewController:nav animated:YES completion:^{
                    
                }];
            }
        }];
    }
    else
    {
        [[self.class root] presentTreatRehabWithDisease:rehab.disease isTreat:YES];
    }
}

#pragma mark - logic
-(void)notificationHandler:(NSNotification*)notification
{
    if([notification.name isEqualToString:WRUpdateSelfInfoNotification])
    {
        [self updateUserInfo];
    }
}

-(void)actionOnCategoryAtIndex:(NSInteger)index title:(NSString*)title
{
    if (index == 2 || index == 0 || index == 1) {
        UIViewController *viewController = nil;
        switch (index) {
            case 0:
                viewController = [[AlarmController alloc] init];
                break;
                
            case 2:
            {
                NSString *title = NSLocalizedString(@"诚邀您体验WELL健康", nil);
                NSString *detail = NSLocalizedString(@"专业运动康复", nil);
                NSString *targetUrlString = @"http://www.well-health.cn/m";
                /*
                NSString *shareLogoUrl = [WRNetworkService getFormatURLString:urlShareLogo];
                [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:shareLogoUrl];
                [UMSocialData defaultData].extConfig.title = NSLocalizedString(@"诚邀您体验WELL健康", nil);
                [UMSocialData defaultData].extConfig.qqData.url = @"http://www.well-health.cn/m";
                [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
                [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.well.health";
                [UMSocialSnsService presentSnsIconSheetView:self
                                                     appKey:UMAppKey
                                                  shareText:NSLocalizedString(@"专业运动康复", nil)
                                                 shareImage:nil
                                            shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ]
                                                   delegate:nil];
                 */
                [UMengUtils shareWebWithTitle:title detail:detail url:targetUrlString image:[UIImage imageNamed:@"logo"] viewController:self];
                break;
            }
                
            case 1:
                viewController = [[SettingController alloc] init];
                break;
                
            default:
                break;
        }
        if (viewController != nil) {
            if (viewController) {
                WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];
                [[self.class root] presentViewController:nav animated:YES completion:nil];
                viewController.title = title;
            }
        }
    }
}

-(IBAction)onClickedSettingButton:(UIButton*)sender {
    SettingController *viewController = [[SettingController alloc] init];
    WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];
    [[self.class root] presentViewController:nav animated:YES completion:nil];
}

#pragma mark -
-(void)updateHeadImage {
    BOOL defaultHeadImageFlag = YES;
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    if ([selfInfo isLogged]) {
        if (![Utility IsEmptyString:selfInfo.headImageUrl]) {
            defaultHeadImageFlag = NO;
            self.blurImageView.hidden = NO;
            [self.headImageView setImageWithUrlString:selfInfo.headImageUrl holderImage:[WRUIConfig defaultHeadImage]];
            [self.blurImageView setImageWithUrlString:selfInfo.headImageUrl holderImage:[WRUIConfig defaultHeadImage]];
            [NSThread detachNewThreadSelector:@selector(downloadSelfHeadImage) toTarget:self withObject:nil];
        }
    }
    if (defaultHeadImageFlag) {
        self.headImageView.image = [WRUIConfig defaultHeadImage];
        //self.blurImageView.image = self.headImageView.image;
        self.blurImageView.hidden = YES;
        //self.topBgView.backgroundColor = [Utility mostColor:self.headImageView.image];
    }
}

-(void)downloadSelfHeadImage
{
    __weak __typeof(self) weakSelf = self;
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:selfInfo.headImageUrl]]];
    if (!image)
    {
        image = [WRUIConfig defaultHeadImage];
    }
    UIColor *color = [Utility mostColor:image];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        weakSelf.topBgView.backgroundColor = color;
    }];
}

-(UIImageView*)blurImageView {
    if (_blurImageView == nil) {
        UIImageView *blurImageView = [[UIImageView alloc] initWithFrame:self.titleBarView.bounds];
        blurImageView.contentMode = UIViewContentModeScaleAspectFill;
        blurImageView.clipsToBounds = YES;
        
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.frame = blurImageView.bounds;
        [blurImageView addSubview:visualEffectView];
        [self.titleBarView addSubview:blurImageView];
        _blurImageView = blurImageView;
    }
    return _blurImageView;
}

-(void)updateUserInfo {
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    [self updateHeadImage];
    if ([selfInfo  isLogged])
    {
        NSString *name = selfInfo.name;
        if ([Utility IsEmptyString:name]) {
            name = NSLocalizedString(@"没有填写昵称", nil);
        }
        self.nameLabel.text = name;
    }
    else
    {
        self.nameLabel.text = NSLocalizedString(@"点击登录", nil);
    }
}

-(UIView*)createTableHeaderView
{
    BOOL biPad = [WRUIConfig IsHDApp];
    CGRect frame = self.view.bounds;
    CGFloat offset = WRUIOffset, x, y, cx, cy;
    cx = frame.size.width;
//    cy = (int)(cx*0.33);
//    if (biPad) {
//        cy = (int)(cx*9/16);
//    }
    cy = frame.size.height;
    UIImage *bgImage = [UIImage imageNamed:@"main_me_bg"];
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cx, cy)];
    container.layer.contents = (id)bgImage.CGImage;
    
    UIView *bgView = [[UIView alloc] initWithFrame:container.frame];
    [container addSubview:bgView];
    self.titleBarView = bgView;
    
    __weak __typeof(self) weakSelf = self;
    void (^action)() = ^(){
        if ([weakSelf checkUserLogState:nil]) {
            [weakSelf showSelfInfo];
        }
    };
    
    UIImageView *imageView = [WRUIConfig createUserHeadImageView];
    x = offset;// - imageView.width / 2;
    y = WRStatusBarHeight + offset;
    if (biPad) {
        x = 2 * offset;
        y = WRStatusBarHeight + 2 * offset;
    }
    imageView.frame = [Utility moveRect:imageView.frame x:x y:y];
    imageView.userInteractionEnabled = YES;
    [imageView bk_whenTapped:action];
    [container addSubview:imageView];
    self.headImageView = imageView;
    
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @" ";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.font = [[UIFont wr_titleFont] fontWithBold];
    if (biPad) {
        label.font = [UIFont wr_titleFont];
    }
    [label sizeToFit];
    
    CGFloat offsetTemp = 5;
    y = self.headImageView.top;
    x = self.headImageView.right + offset;
    cx = container.width - offset - x;
    cy = label.height;
    
    label.frame = CGRectMake(x, y, cx, cy);
    label.userInteractionEnabled = YES;
    [label bk_whenTapped:action];
    [container addSubview:label];
    self.nameLabel = label;
    
    
    y = self.headImageView.centerY + offsetTemp;
    
    NSArray *titles = @[
                        NSLocalizedString(@"提醒", nil),
                        NSLocalizedString(@"设置", nil)
                        ];
    NSArray *imageNameArray = @[@"me_alarm",  @"me_setting"];
    
    NSUInteger index = 0;
    cx = 0;
    CGFloat yTemp = 0;
    for(NSString *imageName in imageNameArray)
    {
        UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        if (cx == 0) {
            cx = image.size.width + offset;
            cy = cx;
        }
        if (index == 0) {
            x = container.width - imageNameArray.count*(cx + offset);//self.headImageView.centerX - 1.5*cx - 2*offset;
            y = self.headImageView.bottom - cy;
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(x, y, cx, cy);
        imageView.contentMode = UIViewContentModeCenter;
        imageView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = cx/2;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.tintColor = [UIColor whiteColor];
        imageView.tag = index;
        [container addSubview:imageView];
        x = imageView.right + offset;
        index++;
        yTemp = imageView.bottom;
        [self.imageArray addObject:imageView];
        imageView.userInteractionEnabled = YES;
        [imageView bk_whenTapped:^{
            [weakSelf actionOnCategoryAtIndex:imageView.tag title:titles[imageView.tag]];
        }];
    }
    
    /*
    NSUInteger count = titles.count;
    CGFloat itemWidth = container.width / count;
    CGFloat itemHeight = [UIImage imageNamed:imageNameArray.firstObject].size.height;
    cx = container.width;
    x = 0;
    y = self.titleBarView.height -  itemHeight;
    cy = itemHeight;
    CategoryView *categoryView = [[CategoryView alloc] initWithFrame:CGRectMake(x, y, cx, cy) titles:titles icons:imageNameArray itemWidth:itemWidth itemHeight:itemHeight];
    [container addSubview:categoryView];
    categoryView.itemAction = ^(NSUInteger index, NSString *title) {
        [weakSelf actionOnCategoryAtIndex:index title:title];
    };
    self.categoryView = categoryView;
    */
    
    /*
    x = 0;
    y = self.headImageView.bottom + 2 * offset;
    cx = frame.size.width - 2*x;
    cy = 1;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, self.categoryView.top - 1, cx, cy)];
    line.backgroundColor = [UIColor wr_lightWhite];
//    line.hidden = YES;
    [container addSubview:line];
    */
    
    y = yTemp + self.headImageView.top;
    
    container.frame = [Utility resizeRect:container.frame cx:-1 height:y];
    
    self.titleBarView.frame = container.bounds;
    return container;
}

-(UIView*)createSectionHeaderView:(UITableView*)tableView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0)];
    view.backgroundColor = [UIColor wr_lightWhite];
    CGFloat offset = WRUIOffset;
    CGFloat x = offset, y = x;
    UILabel *label = [UILabel new];
    label.font = [[UIFont wr_titleFont] fontWithBold];
    label.text = NSLocalizedString(@"挑战自我", nil);
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:x y:y];
    [view addSubview:label];
    
    y = label.bottom + WRUILittleOffset;
    label = [UILabel new];
    label.font = [UIFont wr_smallFont];
    label.textColor = [UIColor lightGrayColor];
    label.text = NSLocalizedString(@"刷新纪录，测试健康水平", nil);
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:x y:y];
    [view addSubview:label];
    
    y = label.bottom + WRUILittleOffset;
    label = [UILabel new];
    label.font = [UIFont wr_smallFont];
    label.textColor = [UIColor lightGrayColor];
    label.text = NSLocalizedString(@"成功达标，开启下阶测试", nil);
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:x y:y];
    [view addSubview:label];
    
    label = [UILabel new];
    label.font = [UIFont wr_smallFont];
    label.textColor = [UIColor lightGrayColor];
    label.text = NSLocalizedString(@"我的成就", nil);
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    CGFloat cx = view.width/3;
    x = view.width - cx;
    label.frame = CGRectMake(x, y, cx, label.height);
    [view addSubview:label];
    
    view.frame = [Utility resizeRect:view.frame cx:-1 height:label.bottom + offset];
    return view;
}

-(void)checkAlarm
{
    self.redView.hidden = ([ShareUserData userData].alarmArray.count > 0);
}

- (UIView *)redView
{
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        _redView.backgroundColor = [UIColor redColor];
        _redView.layer.cornerRadius = _redView.width/2;
        _redView.layer.masksToBounds = YES;
        UIImageView *imageView = self.imageArray.firstObject;
        _redView.center = CGPointMake(imageView.centerX + imageView.width/2.818, imageView.centerY -imageView.height/2.818);
        [imageView.superview addSubview:_redView];
    }
    return _redView;
}

#pragma mark -
-(void)fetchData {
    
}
@end
