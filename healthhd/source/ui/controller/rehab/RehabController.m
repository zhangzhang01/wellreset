//
//  RehabController.m
//  rehab
//
//  Created by 何寻 on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "AlarmController.h"
#import "ArticleDetailController.h"
#import "CardView.h"
#import "CWStarRateView.h"
#import "ExtraSubView.h"
#import "IQKeyboardManager/IQKeyboardManager.h"
#import "PTRehabMarkView.h"
#import "RehabController.h"
#import "RehabPlayerController.h"
#import "SIAlertView.h"
#import "TreatViewModel.h"
#import "UIKit+AFNetworking.h"
#import "UINavigationBar+Awesome.h"
#import "UIview+BlocksKit.h"
#import "UMengUtils.h"
#import "UMSocial.h"
#import "UserViewModel.h"
#import "WRMediaPlayer.h"
#import "WRProTreatViewModel.h"
#import "WRRehabStageController.h"
#import "WRToolView.h"
#import "WRTreat.h"
#import "WRView.h"
#import "WRZanButton.h"
#import "YCInputBar.h"
#import <AVFoundation/AVFoundation.h>


#define NAVBAR_CHANGE_POINT 64

@interface RehabController ()<UIScrollViewDelegate, YCInputBarDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_bannerImageView;
    
    NSDate *_startDate;
    
    NSMutableArray *_timeLineDateArray, *_rehabTimeLineDateArray;
}

@property (nonatomic,strong) YCInputBar *bar;
@property(nonatomic)WRRehab *rehab;
@property(nonatomic, weak)WRRehabDisease *disease;

@property(nonatomic)ExtraSubView *totalDaysSubView, *totalTimeSubView;
@property(nonatomic)PTRehabMarkView *markView;
@property(nonatomic)UILabel *continuedDaysLabel, *totalMarkedDaysLabel;
@property(nonatomic)WRToolView *toolView;
@end

@implementation RehabController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForTreat:self.rehab.disease.diseaseName type:self.disease.isProTreat ? @"proTreat" : @"treat" duration:(int)duration];
}

-(instancetype)initWithRehab:(id)rehab{
    if(self = [super init]){
        self.rehab = rehab;
        self.disease = self.rehab.disease;
        
        CGRect frame = self.view.bounds;
        CGFloat offset = WRUIOffset,  x, y, cx, cy;
        
        UIImage *image = [UIImage imageNamed:@"well_icon_left"];
        
        cy = image.size.height + 2*offset;
        y = frame.size.height - cy;
        x = 0;
        cx = frame.size.width - 2*x;
        self.view.backgroundColor = [UIColor whiteColor];
        
        WRToolView *toolView = [[WRToolView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        toolView.backgroundColor = [[UIColor wr_themeColor] colorWithAlphaComponent:0.8];
        [toolView.centerButton setTitle:NSLocalizedString(@"开始锻炼", nil) forState:UIControlStateNormal];
        toolView.previousButton.hidden = YES;
        toolView.nextButton.hidden = YES;
        toolView.userInteractionEnabled = YES;
        __weak __typeof(self) weakSelf = self;
        [toolView.centerButton bk_addEventHandler:^(id sender) {
            [weakSelf beginRehab];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:toolView];
        self.toolView = toolView;
        
        UIImage *holderImage = [UIImage imageNamed:@"well_default_video"];
        cx = frame.size.width, cy = cx*holderImage.size.height/holderImage.size.width;
        UIImageView *bannerImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cx, cy)];
        bannerImageView.image = holderImage;
        [self.view addSubview:bannerImageView];
        _bannerImageView = bannerImageView;
        
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.frame = _bannerImageView.bounds;
        [_bannerImageView addSubview:visualEffectView];
        
        UIColor *textColor = [UIColor grayColor];
        //title
        x = offset, y = 64;
        UILabel *label = [[UILabel alloc] init];
        label.font = [[UIFont wr_lightFont] fontWithBold];
        label.textColor = textColor;
        label.text = self.rehab.disease.diseaseName;
        [label sizeToFit];
        label.frame = [Utility moveRect:label.frame x:x y:y];
        [self.view addSubview:label];
        
        x = label.right + offset;
        cx = _bannerImageView.width - offset - x;
        label = [[UILabel alloc] init];
        label.font = [UIFont wr_smallFont];
        label.text = self.rehab.disease.diseaseDetail;
        label.textColor = textColor;
        label.numberOfLines = 5;
        CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y, cx, size.height);
        [self.view addSubview:label];
        
        x = offset;
        label = [[UILabel alloc] init];
        label.font = [UIFont wr_textFont];
        label.textColor = textColor;
        label.text = NSLocalizedString(@"难度", nil);
        [label sizeToFit];
        y = _bannerImageView.bottom - label.height - x;
        label.frame = [Utility moveRect:label.frame x:x y:y];
        [self.view addSubview:label];
        x = label.right + offset;
        
        CGFloat value = (CGFloat)(self.rehab.disease.difficulty%5)/5;
        cx = MIN(frame.size.width - offset - x, 120);
        CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(x, y, cx, label.height) numberOfStars:5];
        starRateView.scorePercent = value;
        starRateView.allowIncompleteStar = NO;
        starRateView.hasAnimation = NO;
        starRateView.userInteractionEnabled = NO;
        [self.view addSubview:starRateView];
        
        y = _bannerImageView.bottom;
        cy = toolView.top - y;
        x = 0;
        cx = _bannerImageView.width - 2*x;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
        scrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        
        _startDate = [NSDate date];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"专业康复方案", nil);
    
    [IQKeyboardManager sharedManager].enable = NO;
    
    UINavigationBar *bar = self.navigationController.navigationBar;
    [bar lt_setBackgroundColor:[UIColor clearColor]];
    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new]];
    bar.barTintColor = [UIColor grayColor];
    bar.tintColor = bar.barTintColor;
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : bar.barTintColor}];
   
    if (!self.markView) {
        [self layoutWithTreatRehab:self.rehab];
        
        if (![self.disease isPro]) {
            [self initBarItems];
            
            /*
            _bar = [[YCInputBar alloc] initBar:self.view sendButtonTitle:NSLocalizedString(@"提问", nil) maxTextLength:200 isHideOnBottom:YES buttonColor:nil];
            _bar.placeholder = NSLocalizedString(@"说点什么", nil);
            _bar.delegate = self;
            [_bar showKeyboard];
             */
        }
    }
#if 0
    [self showRehabOptionsWhileOverTime];
#else
    if (self.rehab.checkedDate.count > 0)
    {
        if ([self rehabIsOverTime]) {
             [self showRehabOptionsWhileOverTime];
        }
    }
#endif
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /*
    _scrollView.delegate = nil;
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
     */
    [IQKeyboardManager sharedManager].enable = YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - IBActions
-(void)onClickedVideoThumbControl:(WRVideoThumbControl *)control
{
    NSUInteger tag = control.tag;
    WRTreatRehabStage *stage = self.rehab.stageSet[tag];
    UIViewController *vc = [[WRRehabStageController alloc] initWithTreatRehabStage:stage stageSets:self.rehab.stageSet];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

-(IBAction)onClickedAlarmBarItem:(UIBarButtonItem*)sender
{
    AlarmController *viewController = [[AlarmController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.title = NSLocalizedString(@"康复提醒", nil);
}

-(IBAction)onClickedShareButton:(id)sender {
    NSString *title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"专业运动治疗", nil), self.disease.diseaseName];
    NSString *url = self.rehab.shareUrl;
    NSString *detail = NSLocalizedString(@"快来试试专业的运动处方,疼痛缓解治疗您的病痛", nil);
    [UMengUtils shareWebWithTitle:title detail:detail url:url image:[UIImage imageNamed:@"well_logo"] viewController:self];
}

#pragma mark - YCBar delegate
-(BOOL)sendButtonClick:(UITextView *)textView
{
    if (textView.text.length == 0 && ![textView.text containsString:@"\n"]) {
        return NO;
    }
    return YES;
}

-(void)whenHide
{
    NSLog(@"收起键盘");
}

#pragma mark -
-(void)initBarItems
{
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"well_icon_share"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedShareButton:)];
    self.navigationItem.rightBarButtonItem = shareItem;
}

-(UILabel*)createTitleLabelWithTitle:(NSString*)title container:(UIView*)container width:(CGFloat)width {
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor whiteColor];
    label.textColor = [UIColor blackColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.font = [WRUIConfig IsHDApp] ? [UIFont wr_bigTitleFont] : [UIFont wr_titleFont];
    label.text = title;
    CGSize size = [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    label.frame = CGRectMake(0, 0, MIN(size.width, width), size.height);
    return label;
}

/**
 *  布局
 */
-(void)layoutWithTreatRehab:(WRRehab*)rehab
{
    BOOL flag = ([NSDate dateWithString:rehab.createTime] != nil);
    flag |= rehab.disease.isProTreat;
    
    UIColor *lineColor = [UIColor wr_lineColor];
    UILabel *label = nil;

    CGRect frame = self.view.bounds;
    CGFloat offset = WRUIOffset, littleOffset = WRUILittleOffset, x, y;
    CGFloat cx, cy;
    UIScrollView *scrollView = _scrollView;
    
    UIImage *holderImage = [UIImage imageNamed:@"well_default_video"];
    [_bannerImageView setImageWithUrlString:rehab.disease.bannerImageUrl2 holderImage:holderImage];
    
    UIView *container = scrollView;
    [container removeAllSubviews];
    
    y = 0;
    x = offset;
    y += offset;
    NSArray *titleArray = @[NSLocalizedString(@"时长", nil), NSLocalizedString(@"动作", nil), ];
    NSArray *unitArray = @[NSLocalizedString(@"分钟", nil), NSLocalizedString(@"套", nil)];
    NSArray *textAlign = @[@(NSTextAlignmentLeft), @(NSTextAlignmentRight)];
    cx = 45;
    
    CGFloat yTemp = y;
    
    __block NSInteger count = 0;
    __block NSInteger time = self.rehab.count;
    [self.rehab.stageSet enumerateObjectsUsingBlock:^(WRTreatRehabStage*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count++;
        time += obj.mtWellVideoInfo.duration;
    }];
    time /= 60;
    
    for (NSInteger index = 0; index < titleArray.count; index++) {
        ExtraSubView *subView = [[ExtraSubView alloc] initWithFrame:CGRectMake(x, y, cx, y) title:titleArray[index] infoString:unitArray[index] textAlign:[textAlign[index] intValue] autoSize:YES];
        [container addSubview:subView];
        subView.infoLabel.text = [[@(index == 1 ? count : time) stringValue] stringByAppendingString:unitArray[index]];
        //[subView setInfo:[@(index == 1 ? count : time) stringValue]];
        x = container.width - cx - offset;
        yTemp = subView.bottom + offset;
    }
    y = yTemp;
    
    //步骤视频
    if (rehab.stageSet.count > 0) {
        const CGFloat offsetTemp = offset;
        
        NSMutableArray *titles = [NSMutableArray array];
        [rehab.stageSet enumerateObjectsUsingBlock:^(WRTreatRehabStage * stage, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:stage.mtWellVideoInfo.videoName];
        }];
        
        CGFloat videoHeight = 54;
        cy = [WRVideoThumbControl getHeightWithTitles:titles videhThumbHeight:videoHeight];
        cx = scrollView.bounds.size.width;
        x = 0;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, 8)];
        view.backgroundColor = [UIColor wr_lightWhite];
        [scrollView addSubview:view];
        y = view.bottom;
        
        label = [[UILabel alloc] init];
        label.font = [[UIFont wr_textFont] fontWithBold];
        label.textColor = [UIColor blackColor];
        label.frame = CGRectMake(x, y, cx, cy);
        label.backgroundColor = [UIColor wr_lightWhite];
        label.text = NSLocalizedString(@"动作详解", nil);
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(x, y, cx, [label wr_virtualSize].height);
        [scrollView addSubview:label];
        y = label.bottom;
        
        UIScrollView *imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, cx, cy + offsetTemp + 3 )];
        imageScrollView.backgroundColor = [UIColor wr_lightWhite];
        imageScrollView.showsVerticalScrollIndicator = NO;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        [scrollView addSubview:imageScrollView];
        x = offsetTemp;
        y = x;
        
        NSInteger index = 0;
        for(WRTreatRehabStage *stage in rehab.stageSet)
        {
            WRVideoThumbControl *thumbControl = [[WRVideoThumbControl alloc] initWithHeight:cy videoHeight:videoHeight x:x y:y imageUrl:stage.mtWellVideoInfo.thumbnailUrl title:stage.mtWellVideoInfo.videoName];
            thumbControl.tag = index++;
            __weak __typeof(self) weakSelf = self;
            [thumbControl bk_whenTapped:^(void){
                [weakSelf onClickedVideoThumbControl:thumbControl];
            }];
            [imageScrollView addSubview:thumbControl];
            x = CGRectGetMaxX(thumbControl.frame) + offset;
        }
        imageScrollView.contentSize = CGSizeMake(x, imageScrollView.frame.size.height);
        y = imageScrollView.bottom + offset;
    }
    
    x = littleOffset;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, container.width - 2*x, WRUILineHeight)];
    lineView.backgroundColor = lineColor;
    [container addSubview:lineView];
    y = lineView.bottom + offset;
    
    if (self.rehab.reviewCount > 0 && self.rehab.users.count > 0) {
        x = offset;
        CGFloat imageSize = 40;
        cy = imageSize;
        cx = 60;
        label = [[UILabel alloc] init];
        label.font = [UIFont wr_textFont];
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 2;
        label.frame = CGRectMake(x, y, cx, cy);
        label.text = [NSString stringWithFormat:@"%d人\n完成", (int)rehab.reviewCount];
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
        label.frame = [Utility moveRect:label.frame x:x y:(y + (imageSize - label.height)/2)];
        [container addSubview:label];
        
        x = label.right + offset;
        CGFloat xOffset = 1;
        CGFloat y0 = y;
        for(NSUInteger index = 0; index < rehab.users.count; index++)
        {
            WRUserInfo* userInfo = rehab.users[index];
            if ((x +imageSize) > (container.width - xOffset)) {
                break;
            }
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageSize, imageSize)];
            imageView.layer.cornerRadius = imageView.width/2;
            imageView.layer.masksToBounds = YES;
            [imageView setImageWithUrlString:userInfo.headImageUrl holderImage:[WRUIConfig defaultHeadImage]];
            [container addSubview:imageView];
            y0 = imageView.bottom ;
            x = imageView.right + xOffset;
        }
        y = y0 + offset;
        
        x = 0;
        lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, container.width - 2*x, WRUILineHeight)];
        lineView.backgroundColor = lineColor;
        [container addSubview:lineView];
        y = lineView.bottom + offset;
    }
    
    if(flag)
    {
        /**
         *  总天数 分钟数
         */
        x = offset;
        NSArray *titleArray = @[NSLocalizedString(@"总天数", nil), NSLocalizedString(@"每日", nil), ];
        NSArray *unitArray = @[NSLocalizedString(@"天", nil), NSLocalizedString(@"分钟", nil)];
        NSArray *textAlign = @[@(NSTextAlignmentLeft), @(NSTextAlignmentRight)];
        cx = 60;
        
        CGFloat yTemp;
        for (NSInteger index = 0; index < titleArray.count; index++) {
            ExtraSubView *subView = [[ExtraSubView alloc] initWithFrame:CGRectMake(x, y, cx, y) title:titleArray[index] infoString:unitArray[index] textAlign:[textAlign[index] intValue] autoSize:YES];
            [container addSubview:subView];
            __block NSInteger count = self.rehab.count;
            if (index > 0) {
                count = 0;
                [self.rehab.stageSet enumerateObjectsUsingBlock:^(WRTreatRehabStage*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    count += obj.mtWellVideoInfo.duration;
                }];
                count /= 60;
            }
            [subView setInfo:[@(count) stringValue]];
            x = container.width - cx - offset;
            
            if (index == 0) {
                self.totalDaysSubView = subView;
            } else {
                self.totalTimeSubView = subView;
            }
        }
        
        /**
         *  打卡表
         */
        x = self.totalDaysSubView.right;
        cx = self.totalTimeSubView.left - x;
        label = [[UILabel alloc] init];
        label.font = [[UIFont wr_lightFont] fontWithBold];
        label.textColor = [UIColor darkGrayColor];
        label.text = NSLocalizedString(@"签到日历", nil);
        label.textAlignment = NSTextAlignmentCenter;
        cy  = self.totalDaysSubView.height;
        y = self.totalDaysSubView.top;
        label.frame = CGRectMake(x, y, cx, cy);
        [container addSubview:label];
        
        x = 2*offset;
        cx = MIN(frame.size.width - 2*x, 300);
        x  = (container.width - cx)/2;
        y = self.totalDaysSubView.bottom + 2*littleOffset;
        NSDate *beginDate = [NSDate dateWithString:rehab.createTime];
        PTRehabMarkView *markView = [[PTRehabMarkView alloc] initWithFrame:CGRectMake(x, y, cx, 0) beginDate:beginDate days:rehab.count];
        markView.backgroundColor = [UIColor wr_lightWhite];
        markView.layer.masksToBounds = YES;
        markView.layer.cornerRadius = 5.f;
        [container addSubview:markView];
        self.markView = markView;
        y = markView.bottom + littleOffset;
        
        NSArray *array = @[NSLocalizedString(@"连续签到", nil), NSLocalizedString(@"累计签到", nil)];
        NSString *unit = NSLocalizedString(@"天", nil);
        CGFloat dis = 10;
        yTemp = y;
        for(NSUInteger index = 0; index < array.count; index++)
        {
            NSInteger count = self.rehab.checkedDate.count;
            if (index == 0) {
                count = [self getRehabContinuousDays];
            }
            NSLog(@"count%d",(int)count);
            NSString *valueString = [@(count) stringValue];
            NSString *text = [NSString stringWithFormat:@"%@%@%@", array[index],
                              valueString, unit];
            
            label = [[UILabel alloc] init];
            label.font = [UIFont wr_textFont];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor darkGrayColor];
            label.text = text;
            CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
            cx = size.width + 2*offset;
            if (index == 0) {
                x = container.frame.size.width/2 - cx - dis;
            } else {
                x = container.frame.size.width/2 + dis;
            }
            label.frame = CGRectMake(x, yTemp, cx, size.height);
            [container addSubview:label];
            if (index == 0) {
                self.continuedDaysLabel = label;
            } else {
                self.totalMarkedDaysLabel = label;
            }
            
            
            NSDictionary *dict = @{
                                   NSFontAttributeName:[[UIFont wr_titleFont] fontWithBold],
                                   NSForegroundColorAttributeName:[UIColor blackColor]
                                   };
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
            NSRange range = [text rangeOfString:valueString];
            [string addAttributes:dict range:range];
            label.attributedText = string;
            
            CGRect rect = [Utility resizeRect:label.frame cx:-1 height:2];
            rect = [Utility moveRect:rect x:-1 y:label.bottom + 4];
            lineView = [[UIView alloc] initWithFrame:rect];
            lineView.backgroundColor = [UIColor orangeColor];
            [container addSubview:lineView];
            y = lineView.bottom + offset;
        }
    }
    
    {
        if (rehab.relate.count > 0) {
            UIView *panel = container;
            
            x = offset;
            cx = panel.width - 2*x;
            
            label = [self createTitleLabelWithTitle:NSLocalizedString(@"了解更多", nil)  container:panel width:cx];
            label.font = [UIFont wr_detailFont];
            label.frame = [Utility moveRect:label.frame x:x y:y];
            [panel addSubview:label];
            y = CGRectGetMaxY(label.frame) + 3;
            
            NSInteger tag = 0;
            for(WRArticle *news in rehab.relate){
                label = [self createTitleLabelWithTitle:news.title container:panel width:cx];
                label.frame = [Utility moveRect:label.frame x:x y:y];
                label.textColor = [UIColor wr_themeColor];
                label.font = [WRUIConfig IsHDApp] ? [UIFont wr_titleFont] : [UIFont wr_smallFont];
                label.tag = tag++;
                label.numberOfLines = 1;
                label.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
                label.userInteractionEnabled = YES;
                __weak __typeof(self) weakSelf = self;
                [label bk_whenTapped:^{
                    WRArticle *news = weakSelf.rehab.relate[label.tag];
                    ArticleDetailController *viewController = [[ArticleDetailController alloc] init];
                    [weakSelf.navigationController pushViewController:viewController animated:YES];
                    viewController.currentNews = news;
                }];
                [panel addSubview:label];
                y = label.bottom + 3;
            }
            y += offset;
        }
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.width, MAX(y, scrollView.height));
    
    if (flag) {
        NSMutableArray *dateArray = [NSMutableArray array];
        for(NSString *dateString in self.rehab.checkedDate) {
            NSDate *date = [NSDate dateWithString:dateString];
            [dateArray addObject:date];
        }
        if (dateArray.count > 0) {
            [self.markView checkForDateArray:dateArray];
        }
    }
    
    BOOL firstFlag = NO;
    NSDate *date = [NSDate dateWithString:rehab.createTime];
    if (date) {
        NSDate *currentDate = [NSDate date];
        NSInteger days = [Utility getDaysFrom:date To:currentDate];
        if (days == 0) {
            if (rehab.checkedDate.count == 0) {
                firstFlag = YES;
            }
        }
    }
    
    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"参加%d天康复锻炼", nil), (int)rehab.count];
    [self.toolView.centerButton setTitle:(firstFlag ? title : NSLocalizedString(@"开始锻炼", nil)) forState:UIControlStateNormal];
}

/**
 *  获取方案持续天数
 *
 *  @return 持续天数
 */
-(NSUInteger)getRehabContinuousDays
{
    NSUInteger count = 0;
    NSDate *date = nil;
    for(NSString *dateString in self.rehab.checkedDate)
    {
        NSDate *obj = [NSDate dateWithString:dateString];
        if (date == nil) {
            date = obj;
            count = 1;
            continue;
        }
        if ([Utility getDaysFrom:obj To:date] == 1) {
            count++;
        } else {
            count = 1;
        }
        date = obj;
    }
    return count;
}

/**
 *  检查方案是否过时
 *
 *  @return 是否过时
 */
-(BOOL)rehabIsOverTime
{
    NSDate *beginDate = [NSDate dateWithString:self.rehab.createTime];
    if (beginDate) {
        NSInteger day = [Utility getDaysFrom:beginDate To:[NSDate date]];
        if (day > self.rehab.count)
        {
            return YES;
        }
    }
    return NO;
}

-(void)beginRehab
{
    __weak __typeof(self) weakSelf = self;
    NSMutableArray *array = [NSMutableArray array];
    for(WRTreatRehabStage *stage in self.rehab.stageSet)
    {
        [array addObject:stage.mtWellVideoInfo];
    }
    
    RehabPlayerControllerType type = [self.disease isPro] ? RehabPlayerControllerTypeProTreat : RehabPlayerControllerTypeTreat;
    
    RehabPlayerController *rehabPlayerController = [[RehabPlayerController alloc] initWithVideoSets:array type:type];
    rehabPlayerController.completionBlock = ^(NSTimeInterval countTime) {
        if (countTime > 0) {
            //方案超时 无需再打卡
            if (![self rehabIsOverTime]) {
                [weakSelf checkRehabWithTime:countTime];
            }
        }
    };
    [self.navigationController presentViewController:rehabPlayerController animated:YES completion:nil];
}

/**
 *  打卡
 *  快速缓解 第一次打卡 服务端将生成一个 个人方案
 *  @param time 打卡时间
 */
-(void)checkRehabWithTime:(NSInteger)time
{
    __weak __typeof(self) weakSelf = self;
    void(^block)(NSError * _Nullable error, id _Nullable object) = ^(NSError * _Nullable error, id _Nullable object){
        
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"打卡失败", nil) completion:^{
                [weakSelf checkRehabWithTime:time];
            }];
        } else {
            
            NSString *dateString = object;
            if(![weakSelf.rehab.disease isPro])
            {
                if (weakSelf.rehab.checkedDate.count == 0) {
                    weakSelf.rehab.createTime = dateString;
                    
                    //新方案必须通知首页重新加载
                    [[NSNotificationCenter defaultCenter]  postNotificationName:WRReloadRehabNotification object:nil];
                }
            }
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:weakSelf.rehab.checkedDate];
            [array addObject:dateString];
            weakSelf.rehab.checkedDate = array;
            [weakSelf reload];
        }
    };
    
    if ([self.rehab.disease isPro]) {
        NSUInteger stage = 0;
        if (self.rehab.stageSet.count > 0) {
            WRTreatRehabStage *rehabStage = self.rehab.stageSet.firstObject;
            stage = rehabStage.stage + 1;
        }
        [WRProTreatViewModel userCheckRehab:self.rehab.indexId state:stage completion:block];
    }
    else
    {
        [UserViewModel checkRehabWidthIndexId:self.rehab.indexId sportTimeSeconds:(NSUInteger)time isProTreat:NO completion:block];
    }
}

-(void)reload
{
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self layoutWithTreatRehab:self.rehab];
}

-(void)showRehabOptionsWhileOverTime
{
    __weak __typeof(self) weakSelf = self;
    
    
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:NSLocalizedString(@"恭喜", nil)
                                                     andMessage:NSLocalizedString(@"您已完成本阶段WELL定康复治疗", nil)];
    [alertView addButtonWithTitle:NSLocalizedString(@"重复当前方案", nil)
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              [weakSelf repeatRehab];
                          }];
    if ([self.rehab.disease isPro])
    {
        [alertView addButtonWithTitle:NSLocalizedString(@"重新定制方案", nil)
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                                  [weakSelf requestNewRehab];
                              }];
    }
    
    [alertView addButtonWithTitle:NSLocalizedString(@"不,谢谢", nil)
                             type:SIAlertViewButtonTypeCancel
                          handler:nil];
    alertView.backgroundStyle = SIAlertViewBackgroundStyleGradient;
    alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows;
    alertView.transitionStyle = SIAlertViewTransitionStyleSlideFromBottom;
    [alertView show];
}


-(void)repeatRehab {
    __weak __typeof(self) weakSelf = self;
    void (^block)(NSError *, WRRehab*) = ^(NSError *error, WRRehab* rehab) {
        [SVProgressHUD dismiss];
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"重复当前方案失败", nil) completion:^{
                [weakSelf repeatRehab];
            }];
        } else {
            [rehab.disease setIsProTreat:[weakSelf.rehab.disease isPro]];
            weakSelf.rehab = rehab;
            [weakSelf layoutWithTreatRehab:rehab];
        }
    };
    
    [SVProgressHUD showWithStatus:nil];
    if ([self.rehab.disease isPro])
    {
        [WRProTreatViewModel repeatProTreatRehabWithDiseaseId:self.rehab.disease.indexId completion:block];
    }
    else
    {
        [TreatViewModel repeatTreatRehabWithDiseaseId:self.rehab.disease.indexId completion:block];
    }
}

-(void)requestNewRehab {
    
    WRRehabDisease *disease = self.rehab.disease;
    
    NSUInteger stage = 0;
    if (self.rehab.stageSet.count > 0) {
        WRTreatRehabStage *rehabStage = self.rehab.stageSet.firstObject;
        stage = rehabStage.stage + 1;
    }
    [self generaNewProTreatRehabWithDisease:disease stage:stage fromController:self.navigationController rootViewController:[self.class root]];
}

@end
