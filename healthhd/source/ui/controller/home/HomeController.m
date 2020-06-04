//
//  HomeController.m
//  rehab
//
//  Created by 何寻 on 8/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ArticleDetailController.h"
#import "FormatterUtils.h"
#import "HomeController.h"
#import "JKScrollFocus.h"
#import "RehabController.h"
#import "ShareData.h"
#import "ShareUserData.h"
#import "UserViewModel.h"
#import "WRBodySelectorController.h"
#import "WRProTreatViewModel.h"
#import "WRRefreshHeader.h"


@interface HomeController ()
{
    WRUserInfo *_userInfo;
    
}
@property(nonatomic) UILabel *titleLabel, *nameLabel, *welcomeLabel, *treatCountLabel, *totalTimeLabel, *totalDayLabel;
@property(nonatomic) UIImageView *headImageView;
@property(nonatomic) BOOL loadedData;
@property(nonatomic) UIScrollView *scrollView;
@property(nonatomic) NSMutableArray *reservedViewsArray;

@end

@implementation HomeController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init
{
    if (self = [super init])
    {
        _userInfo = [[WRUserInfo alloc] initWithDictionary:[[WRUserInfo selfInfo] convertDictionary]];
        _reservedViewsArray = [NSMutableArray array];
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.tabBarController.tabBar.height)];
        scrollView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        __weak __typeof(self) weakSelf = self;
        self.scrollView.mj_header = [WRRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf fetchData];
        }];
        [self.reservedViewsArray addObject:self.scrollView.mj_header];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -1*_scrollView.height, _scrollView.width, _scrollView.height)];
        view.backgroundColor = [UIColor wr_themeColor];
        [_scrollView addSubview:view];
        [self.reservedViewsArray addObject:view];
        
        [self.scrollView sendSubviewToBack:view];
        
        [@[WRReloadRehabNotification, WRUpdateSelfInfoNotification] enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:obj object:nil];
        }];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.frame = self.view.bounds;
    if (![self headImageView]) {
        [self createBaseViews];
        [self initUserInfo];
    }
}

#pragma mark - Handler
-(void)notificationHandler:(NSNotification*)notification
{
    //重新加载个人方案
    if ([notification.name isEqualToString:WRReloadRehabNotification])
    {
        [self reload];
    }
    else if([notification.name isEqualToString:WRUpdateSelfInfoNotification])
    {
        [self initUserInfo];
    }
}

#pragma mark -
-(UIView*)createAddNotifyViewWithWidth:(CGFloat)width
{
    __weak __typeof(self) weakSelf = self;
    UIView *addControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    addControl.backgroundColor = [UIColor wr_lightWhite];
    [addControl wr_roundBorderWithColor:[UIColor whiteColor]];
    addControl.userInteractionEnabled = YES;
    [addControl bk_whenTapped:^{
        [weakSelf showRehabSelector];
    }];
    CGFloat offset = WRUIOffset;
    CGFloat x = 0;
    CGFloat y = offset;
    UILabel *label = [[UILabel alloc] init];
    label.font = [[UIFont wr_lightFont] fontWithBold];;
    label.textColor = [UIColor blackColor];
    label.text = NSLocalizedString(@"个性化定制", nil);
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.frame = CGRectMake(x, y, addControl.width, label.height);
    [addControl addSubview:label];
    y = label.bottom + 3;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, addControl.width, 0)];
    label.font = [UIFont wr_smallFont];;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"根据您的病症，量身定制运动治疗方案", nil);
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(addControl.width, CGFLOAT_MAX)];
    label.frame = CGRectMake(0, y, addControl.width, size.height);
    [addControl addSubview:label];
    y = label.bottom + offset;
    addControl.frame = [Utility resizeRect:addControl.frame cx:-1 height:y];
    return addControl;
}

-(void)createBaseViews
{
    CGRect frame = self.scrollView.bounds;
    CGFloat offset = WRUIOffset, littleOffset = WRUILittleOffset,  x, y, cx, cy;
    
    UIImageView *headImageView = [WRUIConfig createUserHeadImageView];
    
    CGFloat titleBarHeight = headImageView.height/2;
    CGFloat statusBarHeight = 20;
    
    UIView *container = _scrollView;//[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    container.backgroundColor = [UIColor whiteColor];
    
    CGFloat dis = offset;
    cy = titleBarHeight + dis + statusBarHeight;
    UIView *titleBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, cy)];
    titleBarView.backgroundColor = [UIColor wr_themeColor];
    [container addSubview:titleBarView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont wr_smallTitleFont];
    label.textColor = [UIColor whiteColor];
    [container addSubview:label];
    label.center = CGPointMake(frame.size.width/2, titleBarView.centerY + statusBarHeight/2);
    self.titleLabel = label;
    self.title = self.title;
    
    y = titleBarView.top + statusBarHeight + dis;
    cx = (titleBarView.bottom - y)*2, cy = cx;
    
    __weak __typeof(self) weakSelf = self;
    headImageView.frame = [Utility moveRect:headImageView.bounds x:dis y:y];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.userInteractionEnabled = YES;
    [headImageView bk_whenTapped:^{
        if ([weakSelf checkUserLogState:nil]) {
            [[UIViewController root] showSelfInfo];
        }
    }];
    [container addSubview:headImageView];
    self.headImageView = headImageView;
    
    label = [[UILabel alloc] init];
    label.text = NSLocalizedString(@"WELL健康用户", nil);
    label.font = [UIFont wr_detailFont];
    label.textColor = [UIColor darkGrayColor];
    label.numberOfLines = 1;
    CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    x = self.headImageView.right + littleOffset;
    cy = size.height;
    cx = frame.size.width - offset - x;
    y = self.headImageView.centerY + 3;
    label.frame = CGRectMake(x, y, cx, cy);
    label.userInteractionEnabled = YES;
    [container addSubview:label];
    self.nameLabel = label;
    y = self.headImageView.bottom + offset;
    x = self.headImageView.left;
    [self.nameLabel bk_whenTapped:^{
        if ([weakSelf checkUserLogState:nil]) {
            [[UIViewController root] showSelfInfo];
        }
    }];
    
    NSArray *titleArray = @[NSLocalizedString(@"已定制", nil), NSLocalizedString(@"总共", nil), NSLocalizedString(@"累计", nil)];
    NSArray *unitArray = @[NSLocalizedString(@"0套", nil), NSLocalizedString(@"0分钟", nil), NSLocalizedString(@"0天", nil)];
    NSArray *textAlign = @[@(NSTextAlignmentLeft), @(NSTextAlignmentCenter), @(NSTextAlignmentRight)];
    cx = (frame.size.width - titleArray.count*offset - x)/titleArray.count;
    for (NSInteger index = 0; index < titleArray.count; index++) {
        label = [[UILabel alloc] init];
        label.font = [UIFont wr_detailFont];
        label.textColor = [UIColor grayColor];
        label.numberOfLines = 1;
        label.frame = CGRectMake(x, y, cx, cy);
        label.text = titleArray[index];
        label.textAlignment = [textAlign[index] intValue];
        [container addSubview:label];
        
        label = [[UILabel alloc] init];
        label.font = [UIFont wr_detailFont];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 1;
        label.text = unitArray[index];
        label.textAlignment = [textAlign[index] intValue];
        size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y + cy + WRUILittleOffset, cx, size.height);
        [container addSubview:label];
        
        x = label.right + offset;
        switch (index) {
            case 0:
                self.treatCountLabel = label;
                break;
                
            case 1:
                self.totalTimeLabel = label;
                break;
                
            case 2:
                self.totalDayLabel = label;
                break;
                
            default:
                break;
        }
    }
    
    y = label.bottom + offset;
    UIView *lineView = [WRUIConfig createLineWithWidth:frame.size.width];
    lineView.frame = [Utility moveRect:lineView.frame x:0 y:y];
    [container addSubview:lineView];
    
    [self.reservedViewsArray addObjectsFromArray:_scrollView.subviews];
}

-(void)layout {
    __weak __typeof(self) weakSelf = self;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![weakSelf.reservedViewsArray containsObject:obj]) {
            [obj removeFromSuperview];
        }
    }];
    
    CGFloat offset = WRUIOffset, littleOffset = WRUILittleOffset,  x, y, cx, cy;
    UIImageView *imageView;
    UILabel *label;
    UIView *container = _scrollView;
    CGRect frame = container.bounds;
    UIView *lineView = self.reservedViewsArray.lastObject;
    y = lineView.bottom + offset;
    
    //推荐
    x = offset;
    cx = frame.size.width - 2*x;
    UIImage *holder = [UIImage imageNamed:@"well_default_video"];
    cy = cx*holder.size.height/holder.size.width;
    NSArray *bannerArray = [ShareData data].bannerArray;
    if(bannerArray.count > 0)
    {
        JKScrollFocus *scroller  = [[JKScrollFocus alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        [container addSubview:scroller];
        scroller.items = bannerArray;
        scroller.autoScroll = YES;

        [scroller downloadJKScrollFocusItem:^(id item, UIImageView *currentImageView) {
            WRBannerInfo *object = item;
            [currentImageView setImageWithUrlString:object.imageUrl holderImage:holder];
        }];
        [scroller titleForJKScrollFocusItem:^NSString *(id item, UILabel *currentLabel) {
            WRBannerInfo *object = item;
            return object.title;
        }];
        [scroller didSelectJKScrollFocusItem:^(id item, NSInteger index) {
            WRBannerInfo *object = item;
            [self actionWithType:object.type data:object.extraData];
            
            [UMengUtils careForBannerHome:object.title];
        }];
        y += cy + offset;
        
        lineView = [WRUIConfig createLineWithWidth:frame.size.width];
        lineView.frame = [Utility moveRect:lineView.frame x:0 y:y];
        [container addSubview:lineView];
        y = lineView.bottom + offset;
    }
    
    //个人方案区
    UIView *addView = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
    x = 0, y = 0;
    holder = [UIImage imageNamed:@"well_default_banner"];
    cx = addView.width;
    cy = cx*holder.size.height/holder.size.width;
    
    NSArray<WRRehab*> *rehabArray = nil;
    if ([[WRUserInfo selfInfo] isLogged])
    {
        rehabArray = [ShareUserData userData].treatRehab;
    }
    
    if(([ShareUserData userData].treatRehab.count + [ShareUserData userData].proTreatRehab.count) > 0)
    {
        label = [[UILabel alloc] init];
        label.font =[[UIFont wr_textFont] fontWithBold];
        label.textColor = [UIColor blackColor];
        label.text = NSLocalizedString(@"我的方案", nil);
        [label sizeToFit];
        [addView addSubview:label];
        label.center = CGPointMake(addView.width/2, y + label.height/2);
        y = label.bottom + littleOffset;
    }
    
    
    for(NSUInteger index = 0; index < 2; index++)
    {
        if (rehabArray.count > 0)
        {
            for(WRRehab *rehab in rehabArray)
            {
                imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
                imageView.userInteractionEnabled = YES;
                [addView addSubview:imageView];
                [imageView setImageWithUrlString:rehab.disease.bannerImageUrl holderImage:holder];
                y = imageView.bottom + offset;
                
                label = [[UILabel alloc] init];
                label.font = [[UIFont wr_titleFont] fontWithBold];
                label.textColor = [UIColor whiteColor];
                label.numberOfLines = 1;
                label.text = rehab.disease.diseaseName;
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                [imageView addSubview:label];
                label.center = CGPointMake(imageView.width/2, imageView.height/2);
                
                [rehab.disease setIsProTreat:(index == 1)];
                [imageView bk_whenTapped:^{
                    [weakSelf showRehab:rehab];
                }];
            }
        }
        rehabArray = [ShareUserData userData].proTreatRehab;
    }
    UIView *addControl = [self createAddNotifyViewWithWidth:addView.width];
    addControl.frame = [Utility moveRect:addControl.frame x:-1 y:y];
    [addView addSubview:addControl];
    y = addControl.bottom + littleOffset;
    
    addView.frame = [Utility resizeRect:addView.frame cx:-1 height:y];
    [container addSubview:addView];
    y = addView.bottom + offset;
    
    lineView = [WRUIConfig createLineWithWidth:frame.size.width];
    lineView.frame = [Utility moveRect:lineView.frame x:0 y:y];
    [container addSubview:lineView];
    y = lineView.bottom + littleOffset;
    x = offset;

    //推荐方案
    if ([ShareData data].recommendTreat.count > 0)
    {
        label = [[UILabel alloc] init];
        label.font = [[UIFont wr_textFont] fontWithBold];
        label.textColor = [UIColor blackColor];
        label.text = NSLocalizedString(@"推荐方案", nil);
        [label sizeToFit];
        [container addSubview:label];
        label.center = CGPointMake(container.width/2, y + label.height/2);
        y = label.bottom + littleOffset;
        
        for(NSUInteger index = 0; index < [ShareData data].recommendTreat.count; index++)
        {
            WRRehabDisease *disease = [ShareData data].recommendTreat[index];
            
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, addView.width, cy)];
            imageView.userInteractionEnabled = YES;
            [container addSubview:imageView];
            [imageView setImageWithUrlString:disease.bannerImageUrl holder:@"well_default_banner"];
            
            label = [[UILabel alloc] init];
            label.font = [[UIFont wr_titleFont] fontWithBold];
            label.textColor = [UIColor whiteColor];
            label.numberOfLines = 1;
            label.text = disease.diseaseName;
            label.textAlignment = NSTextAlignmentCenter;
            [label sizeToFit];
            [imageView addSubview:label];
            label.center = CGPointMake(imageView.width/2, imageView.height/2);
            
            label = [[UILabel alloc] init];
            label.font = [UIFont wr_detailFont];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor wr_themeColor];
            label.textAlignment = NSTextAlignmentCenter;
            NSString *ext = NSLocalizedString(@"人参与", nil);
            label.text = [NSString stringWithFormat:@" 1000000%@ ", ext];
            CGSize size = [label sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
            label.text = [NSString stringWithFormat:@"%@%@", [FormatterUtils stringForCount:disease.clicks], ext];
            [imageView addSubview:label];
            label.frame = CGRectMake(imageView.width - size.width, imageView.height - size.height - littleOffset, size.width, size.height + littleOffset);
            
            y = imageView.bottom + offset;
            
            [imageView bk_whenTapped:^{
                if ([weakSelf checkUserLogState:nil]) {
                    [weakSelf presentTreatRehabWithDisease:disease isTreat:YES];
                } 
            }];
        }
    }
    
    y = MAX(y, self.scrollView.height);
    _scrollView.contentSize = CGSizeMake(_scrollView.width, y);
    
    [self initUserInfo];
}

-(void)setTitle:(NSString *)title {
    [super setTitle:title];
    self.titleLabel.text = title;
    CGPoint pt = CGPointMake(self.titleLabel.centerX, self.titleLabel.centerY);
    [self.titleLabel sizeToFit];
    self.titleLabel.center = pt;
}

-(void)setUserActionValue:(NSInteger)treatCount completionTreatCount:(NSInteger)completionTreatCount totalTime:(NSInteger)totalTime totalDays:(NSInteger)totalDays
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    
    NSDictionary *dict = @{
                           NSFontAttributeName:[[UIFont wr_titleFont] fontWithBold],
                           NSForegroundColorAttributeName:[UIColor wr_themeColor]
                           };
    
    NSArray *valueArray = @[@(treatCount), @(totalTime), @(totalDays)];
    NSArray *unitStringArray = @[NSLocalizedString(@"套", nil), NSLocalizedString(@"分钟", nil), NSLocalizedString(@"天", nil)];
    NSArray *labelArray = @[self.treatCountLabel, self.totalTimeLabel, self.totalDayLabel];
    for(NSInteger index = 0; index < valueArray.count; index++)
    {
        NSString *valueString = [valueArray[index] stringValue];
        NSString *text = [NSString stringWithFormat:@"%@%@", valueString, unitStringArray[index]];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange range = [text rangeOfString:valueString];
        [string addAttributes:dict range:range];
        UILabel *label = labelArray[index];
        label.attributedText = string;
    }
}

-(void)initUserInfo {
    BOOL shouldUserDefaultHead = YES;
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    NSString *welcomeString = NSLocalizedString(@"欢迎回来", nil);
    
    if([selfInfo isLogged]) {
        
        NSString *name = selfInfo.name;
        if ([Utility IsEmptyString:name]) {
            name = [NSString stringWithFormat:@"%@,%@", welcomeString, NSLocalizedString(@"请填写昵称", nil)];
        } else {
            name = [NSString stringWithFormat:@"%@,%@", name, welcomeString];
        }
        self.nameLabel.text = name;
        
        NSString *imageUrl = selfInfo.headImageUrl;
        if (![Utility IsEmptyString:imageUrl]) {
            shouldUserDefaultHead = NO;
            [self.headImageView setImageWithUrlString:imageUrl holderImage:[WRUIConfig defaultHeadImage]];
        }
        [self setUserActionValue:[ShareUserData userData].rehabCount completionTreatCount:[ShareUserData userData].rehabIsFinishedCount totalTime:[ShareUserData userData].rehabTime/60 totalDays:[ShareUserData userData].rehabDays];
        
    } else {
        
        [self setUserActionValue:0 completionTreatCount:0 totalTime:0 totalDays:0];
        self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", welcomeString, NSLocalizedString(@"请登录", nil)];
    }
    
    if (shouldUserDefaultHead) {
        self.headImageView.image = [WRUIConfig defaultHeadImage];
    }
}

-(void)showRehabSelector
{
    if ([self checkUserLogState:nil]) {
        WRBodySelectorController *viewController = [[WRBodySelectorController alloc] init];
        WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];
        [[self.class root] presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - Network
-(void)fetchData {
    __weak __typeof(self) weakSelf = self;
    [UserViewModel fetchPersonDataWithCompletion:^(NSError *error) {
        [_scrollView.mj_header endRefreshing];
        if (error) {
            [weakSelf layout];
        } else {
            weakSelf.loadedData = YES;
            [weakSelf layout];
        }
    }];
}

-(void)reload {
    if ([WRUserInfo selfInfo].isLogged) {
        [self fetchData];
    } else {
        self.loadedData = YES;
        [self layout];
    }
}

-(void)loadData
{
    [self fetchData];
}

#pragma mark - 
-(void)actionWithType:(BannerActionType)type data:(id)data {
    switch (type) {
        case BannerActionTypeTreat:
        case BannerActionTypeProTreat:
        case BannerActionTypeArticle:
        {
            if (![self checkUserLogState:nil]) {
                return;
            }
            break;
        }
            
        default:
            break;
    }
    
    switch (type) {
        case BannerActionTypeUnknown: {
            break;
        }
     
        case BannerActionTypeTreat: {
            [self presentTreatRehabWithDisease:data isTreat:YES];
            break;
        }
        case BannerActionTypeProTreat: {
            WRRehabDisease *disease = data;
            [self presentProTreatRehabWithDisease:disease stage:0];
            break;
        }
            
        case BannerActionTypeArticle: {
            WRArticle *object = data;
            ArticleDetailController *viewController = [[ArticleDetailController alloc] init];
            WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];
            [[self.class root] presentViewController:nav animated:YES completion:nil];
            viewController.currentNews = object;
            break;
        }
            
        default:{
            break;
        }
    }
}

-(void)showRehab:(WRRehab*)rehab
{
    __weak __typeof(self) weakSelf = self;
    if (rehab.disease.isProTreat)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在获取数据", nil)];
        [WRProTreatViewModel userGetProTreatDetailWithData:rehab completion:^(NSError * error, id proTreatRehabDetailDict) {
            [SVProgressHUD dismiss];
            if (error) {
                [Utility retryAlertWithViewController:[self.class root] title:NSLocalizedString(@"获取数据失败", nil) completion:^{
                    [weakSelf showRehab:rehab];
                }];
            } else {
                NSDictionary *dict = proTreatRehabDetailDict;
                WRRehab *rehab = [[WRRehab alloc] initWithDictionary:dict];
                rehab.disease.isProTreat = YES;
                RehabController *controller = [[RehabController alloc] initWithRehab:rehab];
                WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:controller];
                [[self.class root] presentViewController:nav animated:YES completion:nil];
            }
        }];
    }
    else
    {
        [self presentTreatRehabWithDisease:rehab.disease isTreat:YES];
    }
}

@end
