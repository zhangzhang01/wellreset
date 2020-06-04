//
//  RehabController.m
//  rehab
//
//  Created by herson on 8/21/16.
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
#import "firstReportViewController.h"
#import "UIview+BlocksKit.h"
#import "UMengUtils.h"
#import "UserViewModel.h"
#import "WRMediaPlayer.h"
#import "ProTreatViewModel.h"
#import "WRRehabStageController.h"
#import "WRToolView.h"
#import "RehabObject.h"
#import "WRView.h"
#import "WRDownloadArray.h"
#import "YCInputBar.h"

#import "WRTestResultViewController.h"
#import "RehabCalendarController.h"
#import "FAQListController.h"
#import "RehabUsersCloundController.h"
#import "RehabFeedbackController.h"
#import "ReceiveQuestionnaireView.h"
#import "AssessController.h"
#import "TreatDiseaseSelectorController.h"
#import "UIViewController+JTNavigationExtension.h"
#import "QuestionareIndexController.h"
#import "GuideView.h"
#import "RehabStageView.h"
#import "HomeController.h"
#import "HealthController.h"
#import "AddTreatDiseaseBaseContrller.h"
#import <AVFoundation/AVFoundation.h>
#import "ShareData.h"
#import "ShareUserData.h"
#import "AskIndexController.h"
#define NAVBAR_CHANGE_POINT 64
#import "WRDownlistController.h"
#import "UMengUtils.h"
#import <UMMobClick/MobClick.h>
#import <YYKit/YYKit.h>
#import "annoceViewController.h"
#import "MCDownloader.h"
#import "PromptViewModel.h"
#import "JCAlertView.h"
#import "WRTestBaseViewController.h"
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
#import "M13BadgeView.h"
#import "ColorButton.h"
#import "NetworkNotifier.h"
#import "DownController.h"
#import "ComulitModel.h"
#import "CreatTreatController.h"
#import "resultViewController.h"
@interface RehabController ()<UIScrollViewDelegate, YCInputBarDelegate,UIAlertViewDelegate,CAAnimationDelegate>
{
//    UIScrollView *_scrollView;
    NSDate *_startDate;
    NSMutableArray *_timeLineDateArray, *_rehabTimeLineDateArray;
    long _re;
    long _ex;
    long _i;
        CALayer     *_layer;
    
}
@property ComulitModel* viewModel;
@property (nonatomic,strong) YCInputBar *bar;
@property(nonatomic)WRRehab *rehab;
@property(nonatomic, weak)WRRehabDisease *disease;
@property(nonatomic)BOOL isSelfRehab;
@property(nonatomic)ExtraSubView *totalDaysSubView, *totalTimeSubView;
@property(nonatomic)PTRehabMarkView *markView;
@property(nonatomic)UILabel *continuedDaysLabel, *totalMarkedDaysLabel;
@property(nonatomic)WRToolView *toolView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSDate *previousDate;
@property (nonatomic, assign) BOOL firstAppeared, hasDisplayedFeedbackController, hasDisplayedOverTimeOptionalView, hasDisplayedReceiveView,hasFinishRehab;
@property (nonatomic, strong) ReceiveQuestionnaireView *surveyView;
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, assign) CGFloat topContentInset;
@property (nonatomic, strong) UIImageView * topImageView;
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, assign) CGFloat alphaMemory;
@property (nonatomic)UIButton* exBTn;
@property (nonatomic)UIButton* downLowBTn;
@property (nonatomic)UIButton* right;
@property UINavigationController* navi;
@property NSString* umstr;
@property (strong, nonatomic) NSMutableArray *urls;
@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic)UIButton* down;
@property (nonatomic)UIButton* downsate;
@property NSMutableArray* onlinePlays;
@property M13BadgeView* bageView;
@property NetworkNotifier* networkNotifier;
@property UIButton* downleve;
@property UIButton* edit;
@end

@implementation RehabController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    
}

-(instancetype)initWithRehab:(id)rehab{
    if(self = [super init]){
        self.firstAppeared = YES;
        self.rehab = rehab;
        [UMengUtils careForRehab:self.rehab.disease.diseaseName];
        self.disease = self.rehab.disease;
        self.automaticallyAdjustsScrollViewInsets = NO;
        CGRect frame = self.view.bounds;
        CGFloat  x = 0, y, cx, cy = 0;
        self.view.backgroundColor = [UIColor whiteColor];
        cx = frame.size.width;

        y = 0;
        cy = self.view.bottom - y;

        UIImage *image = [self bannerPlaceHolderImage];
//        UIImage *holderImage = [UIImage imageNamed:@"well_default_4_3"];
        
        _topContentInset = frame.size.width*image.size.height/image.size.width;
        
        [self.view addSubview:self.scrollView];
//        _scrollView = scrollView;
        [self createScaleImageView];
        _startDate = [NSDate date];
        self.onlinePlays = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        UIImage *image = [self bannerPlaceHolderImage];
        CGRect bounds = self.view.bounds;
        //        CGFloat height = bounds.size.width*image.size.height/image.size.width;
        CGFloat height = 0;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, self.view.height)];
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.contentInset = UIEdgeInsetsMake(height + _topContentInset, 0, 0, 0);
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(height + _topContentInset, 0, 0, 0);
        CGPoint offset = CGPointMake(scrollView.contentOffset.x, -_topContentInset);
        [scrollView setContentOffset:offset animated:YES];
        _scrollView = scrollView;
    }
    return _scrollView;
}

//创建顶部图
- (void)createScaleImageView
{
    UIImage *image = [self bannerPlaceHolderImage];
    CGRect frame = self.view.bounds;
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width*image.size.height/image.size.width)];
    _topImageView.userInteractionEnabled = YES;
    _topImageView.backgroundColor = [UIColor whiteColor];
   // _topImageView.image = image;
    [_topImageView   sd_setImageWithURL:[NSURL URLWithString:self.rehab.disease.bannerImageUrl2] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGRect frame = self.view.bounds;
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        //    [_topImageView setImageWithUrlString:self.rehab.disease.imageUrl holder:@"well_default_4_3"];
        
        CGFloat x, y, offset, height;
        height = frame.size.width*image.size.height/image.size.width;
        offset = WRUIOffset;
        x = WRUIOffset;
        UILabel *label;
        label = [[UILabel alloc] init];
        UIFont *font;
        font = [WRUIConfig IsHDApp] ? [UIFont wr_titleFont] : [UIFont wr_smallTitleFont];
        label.font = [font fontWithBold];
        label.textColor = [UIColor whiteColor];
        label.text = self.rehab.disease.diseaseName;
        [label sizeToFit];
        label.frame = [Utility moveRect:label.frame x:x y:_topImageView.bottom - offset - 3 * label.height];
        if(self.disease.isProTreat)
        {
            label.frame = [Utility moveRect:label.frame x:x y:_topImageView.bottom - offset - 3 * label.height];
            
        }
        [_topImageView addSubview:label];
        
        UILabel * textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont wr_textFont];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.text = NSLocalizedString(@"(快速缓解)", nil);
        
        
//        if([self.disease.diseaseName isEqualToString:@"高低肩"]||[self.disease.diseaseName isEqualToString:@"O型腿"]||[self.disease.diseaseName isEqualToString:@"X型腿"]||[self.disease.diseaseName isEqualToString:@"扁平足"])
//        {
//            textLabel.text = NSLocalizedString(@"(体态调整)", nil);
//        }
        
        NSMutableArray* arr = [NSMutableArray arrayWithArray:[ShareData data].proTreatDisease.copy ];
        [arr addObjectsFromArray:[ShareData data].treatDisease.copy];
        WRRehabDisease*dis ;
        for (WRRehabDisease* diease in arr) {
            if ([diease.indexId isEqualToString:self.rehab.disease.indexId]) {
                dis = diease;
            }
        }
        
        NSMutableArray* classarry = [NSMutableArray array];
        for (WRTreatclass* class in [ShareData data].treatclassArry ) {
            
            [classarry addObject:class];
            
        }
        
        WRTreatclass* typeclas = nil;
        for (WRTreatclass* class in classarry ) {
            for (NSString* str in [dis.classifyId componentsSeparatedByString:@"|"]) {
                if ([str isEqualToString:class.indexId]&&[class.classifyType intValue] == 1  ) {
                    textLabel.text = [NSString stringWithFormat:@"(%@)",class.classifyName];
                }
            }
        }
        
        
        
        if(self.disease.isProTreat)
        {
            textLabel.text = NSLocalizedString(@"(定制方案)", nil);
        }
        
        
        if (self.rehab.isSelfRehab) {
            textLabel.text = NSLocalizedString(@"(自建方案)", nil);
        }
        
        [textLabel sizeToFit];
        textLabel.frame = [Utility moveRect:textLabel.frame x:label.right + offset y:label.top + (label.height - textLabel.height)/2];
        [_topImageView addSubview:textLabel];
        
        UIButton *button;
        
            button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:NSLocalizedString(@"专家建议", nil) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont wr_smallFont];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button sizeToFit];
            button.frame = [Utility resizeRect:button.frame cx:button.width + 2 * offset height:-1];
            button.frame = [Utility moveRect:button.frame x:_topImageView.width - button.width - 2 * offset y:_topImageView.bottom - button.height - offset*2];
            button.layer.cornerRadius = 10.0f;
            button.layer.masksToBounds = YES;
            button.layer.borderColor = [UIColor wr_rehabBlueColor].CGColor;
            button.layer.borderWidth = 1;
            [button addTarget:self action:@selector(onClickedFaqItem:) forControlEvents:UIControlEventTouchUpInside];
            [_topImageView addSubview:button];
        
        if(self.disease.isProTreat||self.rehab.isSelfRehab)
        {
            label.frame = [Utility moveRect:label.frame x:x y:_topImageView.bottom - offset - 3 * label.height];
            label.centerY = button.centerY;
            textLabel.bottom = label.bottom;
        }
        
        BOOL hasAssess = self.rehab.assess.count > 0;
        if (hasAssess) {
            UIButton *assessButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //        [assessButton setBackgroundImage:[UIImage imageNamed:@"well_rehab_assessBg"] forState:UIControlStateNormal];
            [assessButton addTarget:self action:@selector(onClickedAssessButton:) forControlEvents:UIControlEventTouchUpInside];
            [assessButton setImage:[UIImage imageNamed:@"rehab_assess_icon"] forState:UIControlStateNormal];
            [assessButton setTitle:NSLocalizedString(@"自我检测", nil) forState:UIControlStateNormal];
            [assessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            assessButton.titleLabel.font = [UIFont wr_smallFont];
            [assessButton sizeToFit];
            assessButton.frame = [Utility resizeRect:assessButton.frame cx:assessButton.width + 2 * offset height:-1];
            assessButton.frame = [Utility moveRect:assessButton.frame x:offset y:button.top + (button.height - assessButton.height)/2];
            [assessButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10 , 0, 0)];
            [_topImageView addSubview:assessButton];
        }
        
        
        [self.view insertSubview:_topImageView belowSubview:_scrollView];
        [self.view bringSubviewToFront:_topImageView];
    }];
    
//    [_scrollView addSubview:_topImageView];
}

//顶部视图
-(UIImage *)bannerPlaceHolderImage {
    return [UIImage imageNamed:@"详情banner-2"];
}
- (void)setnavi
{
    JTNavigationController *jtNav = self.navigationController;
    UINavigationBar *bar = jtNav.navigationBar;
    
    self.firstAppeared =YES;
    bar.barTintColor = [UIColor whiteColor];
    bar.tintColor = [UIColor blackColor];
    [bar setTranslucent:NO];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [ComulitModel new];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    self.hasDisplayedFeedbackController = NO;
    self.hasDisplayedOverTimeOptionalView = NO;
    self.hasDisplayedReceiveView = NO;
//    [WRNetworkService pwiki:@"康复详情"];
    self.topImageView.image = [UIImage imageNamed:@"bg_banner_challenge"];
    self.shouldBounce = YES;
    self.navi =self.navigationController;
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    if ([self.disease.diseaseName isEqualToString:@"颈椎"]) {
        self.umstr =@"J";
    }
   else if ([self.disease.diseaseName isEqualToString:@"肩背部"]) {
        self.umstr =@"A";
    }
   else if ([self.disease.diseaseName isEqualToString:@"腰部"]) {
       self.umstr =@"Y";
   }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = [self.rehab.disease isPro] ? NSLocalizedString(@"专业康复方案", nil) : NSLocalizedString(@"康复方案", nil);
    [IQKeyboardManager sharedManager].enable = NO;
    [self createBackBarButtonItem];
    _startDate = [NSDate date];
    _re = 0;
    _ex = 0;
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    [bar lt_setBackgroundColor:[UIColor wr_themeColor]];
//    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [bar setShadowImage:[UIImage new]];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
  
    
//        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
        [self.navigationController.navigationBar setTranslucent:YES];
    
//    [self.navigationController.navigationBar setTranslucent:YES];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
    UIColor * textColor = [UIColor new];
    if (!self.markView) {
        [self layoutWithTreatRehab:self.rehab];
        [self initBarItems];
    }
    if (_alphaMemory < 1) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        textColor = [UIColor whiteColor];
      
        [self.right setImage:[UIImage imageNamed:@"测试结果"] forState:0];
        [self.down setImage:[UIImage imageNamed:@"下载图标"]forState:0];
        [self.downleve setImage:[UIImage imageNamed:@"降阶"] forState:0];
        [self.edit setImage:[UIImage imageNamed:@"自建方案图标"] forState:0];
        
    }
    else {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        textColor = [UIColor blackColor];
       
        [self.right setImage:[UIImage imageNamed:@"测试结果shen"] forState:0];
        [self.down setImage:[UIImage imageNamed:@"下载图标（黑）"] forState:0];
        [self.edit setImage:[UIImage imageNamed:@"自建方案图标2"] forState:0];
         [self.downleve setImage:[UIImage imageNamed:@"降阶2"] forState:0];
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor}];

    
    
    
    
    
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    UINavigationBar *bar = self.navigationController.navigationBar;
    UINavigationController* navi = self.navigationController;
    self.networkNotifier = nil;
    [self setnavi];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = _scrollView.contentOffset.y + _scrollView.contentInset.top;//注意
    CGFloat contentOffsetY = _scrollView.contentOffset.y ;
   // NSLog(@"offsetY%f",offsetY);
   // NSLog(@"contentOffsetY%f",_scrollView.contentOffset.y);
    if (self.shouldBounce) {
        if (offsetY < 0) {
            _topImageView.transform = CGAffineTransformMakeScale(1 + offsetY/(-500), 1 + offsetY/(-500));
        }
        CGRect frame = _topImageView.frame;
        frame.origin.y = 0;
        _topImageView.frame = frame;
        if (offsetY > 1) {
            _topImageView.top = -offsetY;
        }
    }

    UIImageView *barImageView = self.navigationController.navigationBar.subviews.firstObject;
    barImageView.alpha = (scrollView.contentOffset.y + _topImageView.height)/64;
;
//     barImageView.alpha = 1;
//    barImageView.alpha = (scrollView.contentOffset.y + 64)/64;
  //  NSLog(@"y=%lf",scrollView.contentOffset.y+ _topImageView.height);
   // NSLog(@"a=%lf",barImageView.alpha);
    UIColor *textColor;
    if (barImageView.alpha < 1) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        textColor = [UIColor whiteColor];
        [self.right setImage:[UIImage imageNamed:@"测试结果"] forState:0];
        [self.down setImage:[UIImage imageNamed:@"下载图标"]forState:0];
        [self.downleve setImage:[UIImage imageNamed:@"降阶"] forState:0];
        [self.edit setImage:[UIImage imageNamed:@"自建方案图标"] forState:0];
        
    }
    else {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        textColor = [UIColor blackColor];
        [self.right setImage:[UIImage imageNamed:@"测试结果shen"] forState:0];
        [self.down setImage:[UIImage imageNamed:@"下载图标（黑）"] forState:0];
        [self.edit setImage:[UIImage imageNamed:@"自建方案图标2"] forState:0];
        [self.downleve setImage:[UIImage imageNamed:@"降阶2"] forState:0];
        
        
    }
    _alphaMemory = barImageView.alpha;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor}];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.firstAppeared) {
        return;
    }
    self.firstAppeared = NO;
    
    if ([self.rehab.disease isPro])
    {
        if (self.rehab.operation.count>0)
        {
           
                [self showRehabOptionsWhileOverTime];
//                self.hasDisplayedOverTimeOptionalView = YES;
            
        }
        else
        {
            if (![Utility IsEmptyString:self.rehab.createTime] && [self.rehab.disease isPro])
            {
                BOOL flag = YES;
                NSDate *nowDate = [NSDate date];
                for(NSString *dateString in self.rehab.checkedDate)
                {
                    NSDate *obj = [NSDate dateWithString:dateString];
                    if ([Utility getDaysFrom:obj To:nowDate] == 0) {
                        flag = NO;
                        break;
                    }
                }
                
                if (flag)
                {
                    //不需要提醒
//                    __weak __typeof(self) weakSelf = self;
//                    NSString *title = NSLocalizedString(@"您今天尚未开始锻炼", nil);
//                    NSInteger remainDays = self.rehab.count - self.rehab.checkedDate.count;
//                    NSString *detail = [NSString stringWithFormat:NSLocalizedString(@"坚持锻炼%d天后可以定制进阶方案", nil), (int)remainDays];
//            
//                    
//                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:detail preferredStyle:UIAlertControllerStyleActionSheet];
//                    
//                    UIAlertAction *repeatAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"开始锻炼", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
//                        [weakSelf beginRehab];
//                    }];
//                    [controller addAction:repeatAction];
//                    
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
//                    
//                    [controller addAction:cancelAction];
//                    if (IPAD_DEVICE) {
//                        controller.popoverPresentationController.sourceView = self.navigationController.view;
//                        controller.popoverPresentationController.sourceRect = self.navigationController.view.bounds;
//                    }
//                    [self presentViewController:controller animated:YES completion:nil];
                }
            }
        }
        
    }
    else
    {
        [self showSurveyView];
    }
}


#pragma mark - override
-(void)onClickedBackButton:(UIBarButtonItem *)sender
{
    
    if ([self ifIndownload]) {
        
        UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"退出后中断下载视频到本地"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定退出", nil];
        al.tag = 100;
        [al show];
        
    }else{
        JTNavigationController *jtNav = self.navigationController;
        if (jtNav)
        {
            UIViewController *destViewController = nil;
            NSArray *viewControllers = jtNav.viewControllers;
            for(UIViewController *viewController in viewControllers)
            {
                if ([viewController isKindOfClass:[AddTreatDiseaseBaseContrller class]])
                {
                    destViewController = viewController;
                    break;
                }
            }
            if (!destViewController) {
                for(UIViewController *viewController in viewControllers)
                {
                    if ([viewController isKindOfClass:[HealthController class]])
                    {
                        destViewController = viewController;
                        break;
                    }
                }
            }
            if (destViewController) {
                [self.navigationController popToViewController:destViewController animated:YES];
            }
            else
            {
                UIViewController *viewController = [self.navigationController popViewControllerAnimated:YES];
                if (viewController == nil)
                {
                    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
                
                
            }
        } else {
            UIViewController *viewController = [self.navigationController popViewControllerAnimated:YES];
            if (viewController == nil)
            {
                [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }
        }
        UINavigationBar *bar = jtNav.navigationBar;
        UINavigationController* navi = self.navigationController;
        
        bar.barTintColor = [UIColor whiteColor];
        bar.tintColor = [UIColor blackColor];
        [bar setTranslucent:NO];
        [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    }
    
    
    
    
    
    
       
    
    
    
    
    
}

#pragma mark - IBActions
- (void)onClickedFaqItem:(UIBarButtonItem *)sender
{
    AskIndexController *faqController = [[AskIndexController alloc] init];
    faqController.index=0;
        [self setnavi];
    
    [self.navigationController pushViewController:faqController animated:YES];
    //锚点
    if (self.disease.isProTreat) {
        NSDate *now = [NSDate date];
        int duration = (int)[now timeIntervalSinceDate:_startDate];
        NSLog(@"%@",[NSString stringWithFormat:@"%@zjjy",self.umstr]);
        [MobClick event:[NSString stringWithFormat:@"%@zjjy",self.umstr] attributes:nil counter:duration];
    }else
    {
        //锚点
        NSDate *now = [NSDate date];
        int duration = (int)[now timeIntervalSinceDate:_startDate];
        [MobClick event:[NSString stringWithFormat:@"%@zjjy",self.umstr] attributes:nil counter:duration];
    }
    
}

- (void)onClickedIconView
{
    RehabUsersCloundController *cloundController = [[RehabUsersCloundController alloc] initWithIconArray:self.rehab.users];
    [self setnavi];
    [self.navigationController pushViewController:cloundController animated:YES];
    JTNavigationController *jtNav = self.navigationController;
    UINavigationBar *bar = jtNav.navigationBar;
    
    
    bar.barTintColor = [UIColor whiteColor];
    bar.tintColor = [UIColor blackColor];
    [bar setTranslucent:NO];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    cloundController.view.layer.contents = self.view.layer.contents;
    [UMengUtils careForRehabUsers:self.rehab.disease.diseaseName];
    
    //锚点
    if (self.disease.isProTreat) {
        NSDate *now = [NSDate date];
        int duration = (int)[now timeIntervalSinceDate:_startDate];
        [MobClick event:[NSString stringWithFormat:@"%@wcrs",self.umstr] attributes:nil counter:duration];    }else
    {
        //锚点
        NSDate *now = [NSDate date];
        int duration = (int)[now timeIntervalSinceDate:_startDate];
        [MobClick event:[NSString stringWithFormat:@"%@wcrs",self.umstr] attributes:nil counter:duration];
    }
    
    
}

- (void)onClickMyFooter
{
    if (self.rehab.checkedDate.count > 0)
    {
        RehabCalendarController *clendarController = [[RehabCalendarController alloc] initWithRehab:self.rehab];
        [self setnavi];
        [self.navigationController pushViewController:clendarController animated:YES];
//        [UMengUtils careForRehabOrbit:self.rehab.disease.diseaseName];
        [UMengUtils careForRehabUserOrbit:self.rehab.disease.diseaseName];
    }
}

-(IBAction)onClickedAlarmBarItem:(UIBarButtonItem*)sender
{
    AlarmController *viewController = [[AlarmController alloc] init];
    [self setnavi];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.title = NSLocalizedString(@"康复提醒", nil);
}

-(IBAction)onClickedShareButton:(id)sender {
    NSString *title = [NSString stringWithFormat:@"%@", self.rehab.name];
    NSString *url = [NSString stringWithFormat:@"%@/share/program/program.html?userId=%@&id=%@",[ShareData data].shareIP,[WRUserInfo selfInfo].userId,self.rehab.indexId];
    NSString *detail = NSLocalizedString(@"快来试试专业的运动处方,疼痛缓解治疗您的病痛", nil);
    [UMengUtils shareWebWithTitle:title detail:detail url:url image:self.topImageView.image viewController:self];
    [UserViewModel fetchSaveShareType:@"treat" completion:^(NSError *error, id object) {
        
    }];
    [UMengUtils careForRehabShare:self.rehab.disease.diseaseName];
    
    //锚点
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [MobClick event:[NSString stringWithFormat:@"%@fs",self.umstr] attributes:nil counter:duration];

}

- (IBAction)onClickedBeginExerciseButton:(UIButton *)sender
{
    
    if ([sender.titleLabel.text isEqualToString:@"添加方案"]) {
        
        [self checkRehabWithTime:0];
    }
    else
    {
        [self beginRehab];
        [UMengUtils careForRehabBegin:self.rehab.disease.diseaseName];
        
    }
}

- (IBAction)onClickedAssessButton:(UIButton *)sender
{
    AssessController *controller = [[AssessController alloc] initWithAssess:self.rehab.assess];
    //UINavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:controller];
    //[self.navigationController presentViewController:nav animated:YES completion:nil];
    [self setnavi];
    [self.navigationController pushViewController:controller animated:YES];
    controller.title = [NSString stringWithFormat:@"%@%@", self.rehab.disease.diseaseName, NSLocalizedString(@"自我检测", nil)];
    //锚点
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [MobClick event:[NSString stringWithFormat:@"%@jc",self.umstr] attributes:nil counter:duration];}

-(IBAction)didTagVideoThumb:(UIView *)sender
{
    
    
    
    self.networkNotifier = [[NetworkNotifier alloc] initWithController:self];
    __weak __typeof(self)weakself = self;
    
    self.networkNotifier.continueBlock = ^(NSInteger index){
        if (index == 0) {
            
            sender.userInteractionEnabled = NO;
            WRTreatRehabStage *stage = weakself.rehab.stageSet[sender.tag];
            UIWindow *rootView = [UIApplication sharedApplication].keyWindow;
            RehabStageView *stageView = [[RehabStageView alloc] initWithFrame:rootView.bounds treatRehabStage:stage stageSets:weakself.rehab.stageSet isProTreat:[weakself.rehab.disease isProTreat] isplaying:NO];
            stageView.frame = CGRectOffset(stageView.frame, 0, rootView.height);
            __weak __typeof(stageView) weakStageView = stageView;
            stageView.closeEvent = ^(RehabStageView* sender) {
                [UIView animateWithDuration:0.2 animations:^{
                    weakStageView.frame = [Utility moveRect:weakStageView.frame x:-1 y:rootView.height];
                } completion:^(BOOL finished) {
                    [weakStageView removeFromSuperview];
                }];
            };
            [rootView addSubview:stageView];
            [UIView animateWithDuration:0.35 animations:^{
                stageView.frame = [Utility moveRect:stageView.frame x:-1 y:0];
            } completion:^(BOOL finished) {
                sender.userInteractionEnabled = YES;
            }];
            
            //锚点
            if (weakself.disease.isProTreat) {
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"%@dzlb",self.umstr] attributes:nil counter:duration];    }else
                {
                    //锚点
                    NSDate *now = [NSDate date];
                    int duration = (int)[now timeIntervalSinceDate:_startDate];
                    [MobClick event:[NSString stringWithFormat:@"%@dzlb",self.umstr] attributes:nil counter:duration];
                }
            
        }
        else
        {
            weakself.networkNotifier =nil;
        }
    };
    
    
    
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

#pragma mark - UI
-(void)initBarItems
{
    NSMutableArray *itemsArray = [NSMutableArray array];
    if (![self.rehab.shareUrl isEqualToString:@""] && self.rehab.shareUrl != nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"well_icon_share"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(onClickedShareButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [itemsArray addObject:shareItem];
    }
    
    if ([self.rehab.disease.indexId isEqualToString:@"cb888cb9-af32-47a8-8f69-2824b85d7e79"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"测试结果"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button addTarget:self action:@selector(onClickedHistory) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *faqItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.right = button;
        [itemsArray addObject:faqItem];
        
    }
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.rehab.disease.isPro) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"降阶"] forState:UIControlStateNormal];
        [button sizeToFit];
        [button bk_whenTapped:^{
            [self setnavi];
            DownController* down = [DownController new];
            down.rehab = self.rehab;
            NSUInteger stage = 0;
            if (self.rehab.stageSet.count > 0) {
                WRTreatRehabStage *rehabStage = self.rehab.stageSet.firstObject;
                stage = rehabStage.stage;
            }
            if (stage>1) {
                down.candown = YES;
            }
            [self.navigationController pushViewController:
             down animated:YES];
        }];
        UIBarButtonItem *down = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.downleve = button;
        [itemsArray addObject:down];
    }
    
    //    self.right = button;

    
    
 button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"下载图标"] forState:UIControlStateNormal];
    [button sizeToFit];
    self.downLowBTn = button;
   [button bk_whenTapped:^{
       [self setnavi];
       [self.navigationController pushViewController:
        [WRDownlistController new] animated:YES];
   }];
    UIBarButtonItem *faqItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.down = button;
//    self.right = button;
    [itemsArray addObject:faqItem];
    
//    if (self.rehab.disease.isPro) {
//        button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setImage:[UIImage imageNamed:@"降阶"] forState:UIControlStateNormal];
//        [button sizeToFit];
//        [button bk_whenTapped:^{
//            [self setnavi];
//            DownController* down = [DownController new];
//            down.rehab = self.rehab;
//            NSUInteger stage = 0;
//            if (self.rehab.stageSet.count > 0) {
//                WRTreatRehabStage *rehabStage = self.rehab.stageSet.firstObject;
//            }
//            if (stage>1) {
//                down.candown = YES;
//            }
//            [self.navigationController pushViewController:
//             down animated:YES];
//        }];
//        UIBarButtonItem *down = [[UIBarButtonItem alloc] initWithCustomView:button];
//        [itemsArray addObject:down];
//    }
    
    
    if (self.rehab.isSelfRehab) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"自建方案图标"] forState:UIControlStateNormal];
        [button sizeToFit];
        
        [button bk_whenTapped:^{
            [self setnavi];
            CreatTreatController* down = [CreatTreatController new];
            down.indexid = self.rehab.indexId;
            NSMutableArray* arr = [NSMutableArray array];
            for (WRTreatRehabStage* stage in self.rehab.stageSet) {
                FavorContent* fav = [FavorContent new];
                fav.contentId  = stage.indexId;
                fav.type = stage.type;
                fav.collectContent = stage;
                [arr addObject:fav];
                
            }
            down.isadd = arr;
            down.choosearry = arr;
            down.name = self.rehab.disease.diseaseName;
            [self.navigationController pushViewController:
             down animated:YES];
            
        }];
        self.edit = button;
        UIBarButtonItem *down = [[UIBarButtonItem alloc] initWithCustomView:button];
        [itemsArray addObject:down];
    }
    
    
    
    if (itemsArray.count == 0) {
        self.navigationItem.rightBarButtonItems = nil;
    } else {
        self.navigationItem.rightBarButtonItems = itemsArray;
    }
}
#pragma mark -
-(void)onClickedHistory
{
     ProTreatViewModel *model = [[ProTreatViewModel alloc] init];
    [model userGetProTreatStageWithCompletion:^(NSError * error, id object) {
        WRTestResultViewController* reVc = [WRTestResultViewController new];
        reVc.UserHealthStage = model.UserHealthStage;
        reVc.lastarry = model.lastarry;
        reVc.rehab = self.rehab;
        reVc.isCompit = YES;
        [self setnavi];
        [self.navigationController pushViewController:reVc animated:YES];
    }];
}
#pragma mark -
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

-(BOOL)checkIsContiousWithThisDate:(NSDate *)thisDate
{
    BOOL flag = NO;
    if (self.previousDate == nil) {
        self.previousDate = thisDate;
    }
    if ([Utility getDaysFrom:self.previousDate To:thisDate] == 1) {
        flag = YES;
    }
    return flag;
}

/**
 *  检查方案是否过时
 *
 *  @return 是否完成
 */
-(BOOL)hasFinishRehab
{
  return   self.rehab.checkedDate.count>= self.rehab.count/2;
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
        if (day >= self.rehab.count)
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
    
    NSMutableArray* list = [NSMutableArray array];
    for (NSString* index in self.rehab.stageSetCounts) {
        [list addObject:array[index.intValue]];
    }
    
    
    RehabPlayerControllerType type = [self.disease isPro] ? RehabPlayerControllerTypeProTreat : RehabPlayerControllerTypeTreat;
    
    RehabPlayerController *rehabPlayerController = [[RehabPlayerController alloc] initWithVideoSets:list type:type treat:self.rehab.disease.diseaseName];
    rehabPlayerController.completionBlock = ^(NSTimeInterval countTime) {
        if (countTime > 0&&!self.isSelfRehab) {
            //方案超时 无需再打卡
            NSLog(@"dfgegww");

                [weakSelf checkRehabWithTime:countTime];

        }
    };
    rehabPlayerController.completionwithdieaseBlock = ^(NSTimeInterval countTime, WRRehabDisease *disease) {
        if (!self.isSelfRehab) {
            //方案超时 无需再打卡
            NSLog(@"方案超时");
            [weakSelf checkRehabWithTime:countTime];
            [self setnavi];
            [self pushProTreatRehabWithDisease:disease stage:0 upgrade:@"0"];

        }


    };
    rehabPlayerController.rehab =self.rehab;
    rehabPlayerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:rehabPlayerController animated:YES completion:nil];
    
    //锚点
    if (self.disease.isProTreat) {
        NSDate *now = [NSDate date];
        int duration = (int)[now timeIntervalSinceDate:_startDate];
        [MobClick event:[NSString stringWithFormat:@"%@ksdl",self.umstr] attributes:nil counter:duration];
    }
    
}

/**
 *  打卡
 *  快速缓解 第一次打卡 服务端将生成一个 个人方案
 *  @param time 打卡时间
 */
-(void)checkRehabWithTime:(NSInteger)time
{
    __weak __typeof(self) weakSelf = self;

    
    if ([self.rehab.disease isPro]&&time>0 )
    {
        RehabFeedbackController *viewController = [[RehabFeedbackController alloc] initWithQuestions:nil proTreatRehabId:self.rehab.disease.indexId finishedState:NO];
        viewController.rehab =self.rehab;
        viewController.completion = ^() {
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        };
        BOOL biPad = [WRUIConfig IsHDApp];
        if (biPad) {
            viewController.popoverPresentationController.sourceView = self.navigationController.view;
            viewController.popoverPresentationController.sourceRect = self.navigationController.view.bounds;
        }
        UINavigationController *navigationController = [[WRBaseNavigationController alloc] initWithRootViewController:viewController];
        UINavigationController *nav = self.navigationController;
        [nav presentViewController:navigationController animated:YES completion:nil];
    }
    else if(![self.rehab.disease isPro]&&time==0 )
    {
        
        UIView* showview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 131*2+92, 81+324+27)];
        showview.backgroundColor = [UIColor clearColor];
        
        UIImageView* im = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 131*2+92,  81+324-40)];
        [im setImage:[UIImage imageNamed:@"庆祝效果"]];
        
        [showview addSubview:im];
        
        
        UIView* line = [UIView new];
        line.width = 2;
        line.height = 66;
        line.centerX = showview.width*1.0/2;
        line.bottom = showview.height-27;
        line.backgroundColor = [UIColor wr_themeColor];
        [showview addSubview:line];
        
        UIButton* close = [UIButton new];
        close.width = close.height = 27;
        [close setBackgroundImage:[UIImage imageNamed:@"组-7"] forState:0];
        close.centerX = showview.width*1.0/2;
        close.bottom = showview.height;
        [showview addSubview:close];
        
        UIView* bac = [[UIView alloc]initWithFrame:CGRectMake(56.5, 106, 241, 237)];
        bac.backgroundColor = [UIColor whiteColor];
        bac.layer.cornerRadius = WRCornerRadius;
        bac.layer.masksToBounds = YES;
        [showview addSubview:bac];
        
        UIImageView* head = [[UIImageView alloc]initWithFrame:CGRectMake(28, 0, showview.width-56, 76+149-61)];
        [head setImage:[UIImage imageNamed:@"大标题"]];
        [showview addSubview:head];
        
        UILabel* title = [UILabel new];
        title.y = 60;
        title.text = @"小提示";
        title.font = [UIFont boldSystemFontOfSize:15];
        title.textColor = [UIColor wr_titleTextColor];
        [title sizeToFit];
        title.centerX = bac.width*1.0/2;
        [bac addSubview:title];
        
        UILabel* content = [UILabel new];
        content.x = 32.5;
        content.y = title.bottom+13;
        content.text = @"快速定制方案适用于快速缓解疼痛想要进一步康复可以试试定制方案哦！";
        content.font = [UIFont systemFontOfSize:13];
        content.numberOfLines = 0;
        content.textAlignment = NSTextAlignmentCenter;
        content.textColor = [UIColor wr_themeColor];
        content.width = bac.width-32.5*2;
        [content sizeToFit];
        content.width = bac.width-32.5*2;
        [UILabel changeLineSpaceForLabel:content WithSpace:14];
        [bac addSubview:content];
        
        UIButton* prebtn = [UIButton new];
        prebtn.width = 121;
        prebtn.height = 29;
        prebtn.layer.cornerRadius = prebtn.height*1.0/2;
        prebtn.layer.masksToBounds = YES;
        [prebtn setTitle:@"立即试试" forState:0];
        [prebtn setTitleColor:[UIColor whiteColor] forState:0];
        prebtn.backgroundColor = [UIColor wr_themeColor];
        prebtn.titleLabel.font = [UIFont systemFontOfSize:13];
        prebtn.centerX = bac.width*1.0/2;
        prebtn.bottom = bac.height-20;
        [bac addSubview:prebtn];
        
        
        
        
        
        
        JCAlertView* ALART = [[JCAlertView alloc]initWithCustomView:showview dismissWhenTouchedBackground:NO];
        
        
        [close bk_whenTapped:^{
            [ALART dismissWithCompletion:^{
                
            }];
        }];
        
        
        WRRehabDisease* dis;
        for (WRRehabDisease* dise in  [ShareData data].treatDisease) {
            if ([dise.diseaseName isEqualToString:self.rehab.disease.diseaseName]) {
                dis = dise;
            }
        }
        WRRehabDisease* redis;
        for (WRRehabDisease* dise in [ShareData data].proTreatDisease) {
            if ([dise.specialty isEqualToString:dis.specialty]) {
                redis = dise;
            }
        }
        
        WRRehab* rehabpro;
        for (WRRehab* rehab in [ShareUserData userData].proTreatRehab) {
            if ([rehab.disease.diseaseName isEqualToString:redis.diseaseName]) {
                rehabpro = rehab;
            }
        }
        if (redis&&!rehabpro) {
            [ALART show];
            
        }

        
        [prebtn bk_whenTapped:^{
            if (redis) {
                [ALART dismissWithCompletion:^{
                    [self setnavi];
                    [self pushProTreatRehabWithDisease:redis stage:1 upgrade:@"1"];
                }];
                
            }
            
            
            
        }];
        
        
    }
    
    
    void(^block)(NSError * _Nullable error, id _Nullable object) = ^(NSError * _Nullable error, id _Nullable object){
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"打卡失败", nil) completion:^{
                [weakSelf checkRehabWithTime:time];
            }];
        } else {
            
            
            if([self.exBTn.titleLabel.text isEqualToString:@"添加方案"])
            {
                [[NSNotificationCenter defaultCenter]  postNotificationName:WRReloadRehabNotification object:nil userInfo:@{@"rehab":weakSelf.rehab}];
//                [AppDelegate show:@"添加方案成功"];
                [self.exBTn setTitle:@"开始锻炼" forState:0];
            }
            
            //
        }
    };
    
    if ([self.rehab.disease isPro]) {
        NSUInteger stage = 0;
        if (self.rehab.stageSet.count > 0) {
            WRTreatRehabStage *rehabStage = self.rehab.stageSet.firstObject;
            stage = rehabStage.stage + 1;
        }
        [ProTreatViewModel userCheckRehab:self.rehab.indexId state:stage interver:(NSInteger)time
                               completion:block];
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
    bool show = YES;
    
    NSArray* arr = self.rehab.operation[@"operation"];
    if (arr.count>0) {
        NSDictionary* op1 = arr[0];
        if (([op1[@"op"] intValue]==0&&![op1[@"op"]isKindOfClass:[NSNull class]])||([op1[@"op"] intValue]==1&&![op1[@"op"]isKindOfClass:[NSNull class]]&&arr.count==1)) {
            if ([[[NSUserDefaults standardUserDefaults ]objectForKey:[NSString stringWithFormat:@"con_%@", self.rehab.indexId]]integerValue]==1) {
                show = NO;
            }
        }
    }
    
    if (show) {
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:self.rehab.operation[@"title"] message:self.rehab.operation[@"content"] preferredStyle:UIAlertControllerStyleAlert];
        for (NSDictionary* dic in arr) {
            switch ([dic[@"op"] integerValue]) {
                    
                case 0:
                {
                    UIAlertAction *repeatAction = [UIAlertAction actionWithTitle:dic[@"text"] style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                        [weakSelf requestNewRehab];
                    }];
                    [controller addAction:repeatAction];
                }
                    break;
                case 1:
                {
                    UIAlertAction *repeatAction = [UIAlertAction actionWithTitle:dic[@"text"] style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                        [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:[NSString stringWithFormat:@"con_%@", self.rehab.indexId]];
                        //                    [weakSelf requestNewRehab];
                    }];
                    [controller addAction:repeatAction];
                }
                    break;
                case 2:
                {
                    UIAlertAction *repeatAction = [UIAlertAction actionWithTitle:dic[@"text"] style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                        [weakSelf repeatRehab];
                    }];
                    [controller addAction:repeatAction];
                }
                    break;
                case 3:
                {
                    UIAlertAction *repeatAction = [UIAlertAction actionWithTitle:dic[@"text"] style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                        [weakSelf createNewRehabWithOldRehab];
                    }];
                    [controller addAction:repeatAction];
                }
                    break;
                    
                    
                default:
                    break;
            }
            
            
            
        }
        
        
        
        
        
        if (IPAD_DEVICE) {
            controller.popoverPresentationController.sourceView = self.navigationController.view;
            controller.popoverPresentationController.sourceRect = self.navigationController.view.bounds;
        }
        [self presentViewController:controller animated:YES completion:nil];
    }
    
    
    
    
}

- (void)createNewRehabWithOldRehab
{
    WRRehabDisease *disease = self.rehab.disease;
    NSUInteger stage = 0;
    if (self.rehab.stageSet.count > 0) {
        WRTreatRehabStage *rehabStage = self.rehab.stageSet.firstObject;
        stage = rehabStage.stage;
    }
    __weak __typeof(self)weakSelf = self;
    
    BOOL isnew = false;
    BOOL cannew = false;
    for (WRRehabDisease* dis in [ShareData data].proTreatDisease)
    {
        if ([dis.indexId isEqualToString:@"cb888cb9-af32-47a8-8f69-2824b85d7e79"]) {
            cannew = YES;
        }
    
    }
    
    if (([disease.diseaseName isEqualToString:@"腰部"]||[disease.diseaseName isEqualToString:@"腰部强化"])&&cannew) {
        disease.indexId = @"cb888cb9-af32-47a8-8f69-2824b85d7e79";
        isnew = YES;
    }
    //5.0.3
//    isnew = NO;
    ProTreatViewModel *model = [[ProTreatViewModel alloc] init];
    [model fetchQuestionsWithCompletion:^(NSError * _Nonnull error, id object) {
        [SVProgressHUD dismiss];
        WRRehab *rehab = object;
        __strong __typeof(model) strongModel = model;
        if (error) {
            [Utility retryAlertWithViewController:self title:error.domain completion:^{
                [weakSelf createNewRehabWithOldRehab];
            }];
        } else {
            if (rehab) {
                rehab.disease.isProTreat = YES;
                RehabController *viewController = [[RehabController alloc] initWithRehab:rehab];
                viewController.title = [NSString stringWithFormat:@"%@ %@", disease.diseaseName, NSLocalizedString(@"定制方案", nil)];
                [self setnavi];
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            } else {
                
                
                
                    WRTestBaseViewController *viewController = [WRTestBaseViewController new];
                    viewController.stage = stage;
                    viewController.title = [NSString stringWithFormat:@"%@%@", disease.diseaseName, NSLocalizedString(@"定制", nil)];
                    viewController.viewmodel = model;
                    viewController.isnew = isnew;
                    viewController.proTreatDisease = self.rehab.disease;
                    [self setnavi];
                    [weakSelf.navigationController pushViewController:viewController animated:YES];
                    
                
            }
        }
    } specialtyId:disease.specialtyId diseaseId:disease.indexId stage:stage indexId:_rehab.indexId upgrde:@""];
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
            
            [[NSNotificationCenter defaultCenter] postNotificationName:WRReloadRehabNotification object:nil userInfo:@{@"rehab":weakSelf.rehab}];
        }
    };
    
    [SVProgressHUD showWithStatus:nil];
    if ([self.rehab.disease isPro])
    {
        [ProTreatViewModel repeatProTreatRehabWithDiseaseId:self.rehab.disease.indexId completion:block];
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
//    [self generaNewProTreatRehabWithDisease:disease stage:stage fromController:self.navigationController rootViewController:[self.class root]];
    [self setnavi];
    [self pushProTreatRehabWithDisease:disease stage:stage upgrade:@"1"];
}


#pragma mark - feedback
-(void)fetchFeedbackQuestions:(ProTreatFinishedState)finishedState {
    if (![SVProgressHUD isVisible]) {
        [SVProgressHUD showWithStatus:nil];
    }
    __weak __typeof(self) weakSelf = self;
    [ProTreatViewModel userGetProTreatFeedbackQuestionsWithDiseaseId:weakSelf.rehab.disease.indexId isPro:[weakSelf.rehab.disease isPro] completion:^(NSError * _Nonnull error, id  _Nullable questionArray) {
        [SVProgressHUD dismiss];
        
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取反馈问题失败", nil) completion:^{
                [weakSelf fetchFeedbackQuestions:finishedState];
            }];
        } else {
            NSArray *array = questionArray;
            if (array && array.count > 0) {
                [weakSelf feedback:array finishedState:finishedState];
            }
        }
    }];
}

-(void)feedback:(NSArray*)questionArray  finishedState:(ProTreatFinishedState)state {
    __weak __typeof(self) weakSelf = self;
    RehabFeedbackController *viewController = [[RehabFeedbackController alloc] initWithQuestions:questionArray proTreatRehabId:self.rehab.disease.indexId finishedState:state];
    viewController.rehab =self.rehab;
    viewController.completion = ^() {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    BOOL biPad = [WRUIConfig IsHDApp];
    if (biPad) {
        viewController.popoverPresentationController.sourceView = self.navigationController.view;
        viewController.popoverPresentationController.sourceRect = self.navigationController.view.bounds;
    }
    UINavigationController *navigationController = [[WRBaseNavigationController alloc] initWithRootViewController:viewController];
    UINavigationController *nav = self.navigationController;
    [nav presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Survey
//显示用户调查
-(BOOL)showSurveyView
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *key = @"survey";
    NSString *isExist = [ud objectForKey:key];
    BOOL flag = (![Utility IsEmptyString:self.rehab.userSurvey]&& [Utility IsEmptyString:isExist] && !self.hasDisplayedReceiveView);
    if (flag)
    {
        NSLog(@"userSurvey url %@",self.rehab.userSurvey);
        
        self.hasDisplayedReceiveView = YES;
        
        __weak __typeof(self)weakself = self;
        
        UIView *superView = self.navigationController.view;//[UIApplication sharedApplication].keyWindow;
        
        ReceiveQuestionnaireView *receiveView = [[ReceiveQuestionnaireView alloc] initWithFrame:self.view.bounds];
        receiveView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85];
        receiveView.clickedChooseBlock = ^(NSInteger index){
            switch (index) {
                case 0:{
                    //立即参与
                    WRWebViewController *webController = [[WRWebViewController alloc] init];
                    webController.title = NSLocalizedString(@"问卷调查", nil);
                    NSURL *url = [NSURL URLWithString:weakself.rehab.userSurvey];
                    [webController.webView loadRequest:[NSURLRequest requestWithURL:url]];
                    [webController createBackBarButtonItem];
                    WRBaseNavigationController *nav = [[WRBaseNavigationController alloc] initWithRootViewController:webController];
                    [weakself.navigationController presentViewController:nav animated:YES completion:nil];
                    [ud setObject:@"YES" forKey:key];
                    break;
                }
                    
                case 1:{
                    //以后再说
                }
                    break;
                case 2:{
                    //残忍拒绝
                    [ud setObject:@"YES" forKey:key];
                }
                    break;
                default:
                    break;
            }
        };
    
        self.surveyView = receiveView;
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [receiveView showWithAnimationInSuperView:superView];
        }];
    }
    return flag;
}

#pragma mark - finally layout
- (UIButton *)createIconButtonWithImage:(NSString *)image title:(NSString *)title
{
    UIImage *img = [UIImage imageNamed:image];
    UIFont *font = [WRUIConfig IsHDApp] ? [UIFont wr_titleFont] : [UIFont wr_textFont];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.imageView.tintColor = [UIColor grayColor];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setImage:img forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button sizeToFit];
    button.frame = [Utility resizeRect:button.frame cx:button.width + 10 height:button.height];
    return button;
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
-(UIView*)createQuestionViewWith:(CGFloat)width
{
   
    CGFloat offset = WRUIOffset, x = offset, y = x, cx;
    
    UIView *panel2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 100)];
    panel2.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] init];
   imageView.frame = CGRectMake(10, 10, width-20 , 80);
    imageView.image = IMAGE(@"问卷入口");
    
     [imageView bk_whenTapped:^{
               
//
         [self.viewModel submitadminWithuserId:[WRUserInfo selfInfo].userId block:^(bool success, NSString *result) {
             if (success) {
            UIViewController *viewController = [annoceViewController new];
            viewController.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:viewController animated:YES];
             }else{
                       [AppDelegate show:result];
              UIViewController *viewController = [resultViewController new];
             viewController.hidesBottomBarWhenPushed=YES;
             [self.navigationController pushViewController:viewController animated:YES];
             }
         }];

         
       

               
           }];
    
   [panel2 addSubview:imageView];
    
    return panel2;
}
-(UIView*)createTopViewWithContainerWith:(CGFloat)width
{
    CGFloat offset = WRUIOffset, x = offset, y = x, cx;
    
    UILabel *label;
    
    UIColor *textColor = [UIColor grayColor];
    UIFont *font = [WRUIConfig IsHDApp] ? [UIFont wr_titleFont] : [UIFont wr_lightFont];
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    panel.backgroundColor = [UIColor whiteColor];
    
    //title
    x = offset, y = offset*2;
//    label = [[UILabel alloc] init];
//    font = [WRUIConfig IsHDApp] ? [UIFont wr_titleFont] : [UIFont wr_lightFont];
//    label.font = [font fontWithBold];
//    label.textColor = textColor;
//    label.text = self.rehab.disease.diseaseName;
//    [label sizeToFit];
//    label.frame = [Utility moveRect:label.frame x:x y:y];
//    [panel addSubview:label];
    
    font = [WRUIConfig IsHDApp] ? [UIFont wr_smallTitleFont] : [UIFont wr_smallFont];
    x = offset;
    cx = panel.width - offset - x;
    label = [[UILabel alloc] init];
    label.font = font;
    label.text = self.rehab.disease.diseaseDetail;
    label.textColor = textColor;
    label.numberOfLines = 5;
    CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = CGRectMake(x, y, cx, size.height);
    [panel addSubview:label];
    
    font = [WRUIConfig IsHDApp] ? [UIFont wr_smallTitleFont] : [UIFont wr_textFont];
    y = label.bottom +  offset;
    x = offset;
    
    UIView *line;
    if ([self.rehab.disease isPro]) {
        line = [[UIView alloc] initWithFrame:CGRectMake(x, y, width - 2 * x, 1)];
        line.backgroundColor = [UIColor wr_lightGray];
        [panel addSubview:line];
        y += offset;
        label = [[UILabel alloc] init];
        label.font = font;
        label.textColor = textColor;
        WRTreatRehabStage* one =nil;
        if(self.rehab.stageSet.count>0) {
            one = self.rehab.stageSet[0];
        }
        
        label.text = [NSString stringWithFormat:@"进阶训练进度(第%ld阶)",one.stage];
        [label sizeToFit];
        label.frame = [Utility moveRect:label.frame x:x y:y];
        [panel addSubview:label];
        
        UIImage *image = [UIImage imageNamed:@"日常任务说明内容"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(label.right + offset, label.top, label.height*image.size.width/image.size.height, label.height);
        [panel addSubview:imageView];
        imageView.userInteractionEnabled = YES;
        [imageView bk_whenTapped:^{
            
            [self showIntroduct];
            
        }];
        
        y = label.bottom + offset;
        label = [[UILabel alloc] init];
        label.font = font;
        label.textColor = [UIColor wr_rehabBlueColor];
        NSInteger count = 0;
//        NSInteger test = 8;
//        if (test>self.rehab.count/2) {
//            count = self.rehab.count/2;
//        } else {
//            count = test;
//        }
        
        if (self.rehab.checkedDate.count>self.rehab.count/2) {
            count = self.rehab.count/2;
        } else {
            count = self.rehab.checkedDate.count;
        }
        label.text = [NSString stringWithFormat:@"%d/%d",(int)count,(int)self.rehab.count/2];
        [label sizeToFit];
        x = width - label.width - 2 * offset;
        label.frame = [Utility moveRect:label.frame x:x y:y];
        [panel addSubview:label];
        
        x = offset;
        UIProgressView *pro = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        pro.frame=CGRectMake(x, label.centerY - 1, width - label.width - 4 * offset , 50);
        pro.trackTintColor=[UIColor wr_lightGray];
        pro.progressTintColor=[UIColor wr_rehabBlueColor];
        [pro setProgress:(float)count/(self.rehab.count/2) animated:NO];
        pro.transform = CGAffineTransformMakeScale(1.0f, 2.0f);
        [panel addSubview:pro];
        
        
        NSArray* arr;
        NSDictionary* dic = self.rehab.operation;
        if (dic.count>0) {
            arr = dic[@"operation"];
        }
        if (arr.count>0) {
            NSDictionary* op1 = arr[0];
            if ([op1[@"op"] intValue]==0&&![op1[@"op"]isKindOfClass:[NSNull class]]) {
                y= pro.bottom;
                y+= 23;
                UIButton* liji = [UIButton new];
                UIImage* im = [UIImage imageNamed:@"立即进阶底"];
                liji.size = im.size;
                [liji setBackgroundImage:im forState:0];
                [liji setTitle:@"立即进阶" forState:0];
                [liji setTitleColor:[UIColor whiteColor] forState:0];
                liji.titleLabel.font = [UIFont systemFontOfSize:16];
                liji.userInteractionEnabled = YES;
                liji.y = y;
                liji.centerX = panel.centerX;
                [panel addSubview:liji];
                [liji bk_whenTapped:^{
                    [self requestNewRehab];
                }];
                y = liji.bottom;
              
            }
            else
            {
                y +=offset;
            }
        }
        else
        {
            y +=offset;
        }
        
        
        y  += offset*2;
        line = [[UIView alloc] initWithFrame:CGRectMake(0, y, width , 5)];
        line.backgroundColor = [UIColor wr_lightGray];
        [panel addSubview:line];
        y += 5;
        
        
        
        
    }else
    {
        y = label.bottom + offset*2;
        line = [[UIView alloc] initWithFrame:CGRectMake(offset, y, width - 2*offset, 1)];
        line.backgroundColor = [UIColor wr_lightGray];
        [panel addSubview:line];
        y += 1;
    }

    
    //        UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(x, y, roundWidth, roundWidth)];
//        roundView.backgroundColor = [UIColor clearColor];
//        roundView.layer.cornerRadius = roundWidth / 2;
//        UIColor *temColor = colorArray[index];
//        roundView.layer.borderColor = temColor.CGColor;
//        roundView.layer.borderWidth = 1;
//        [view addSubview:roundView];
        
//        y = CGRectGetMaxY(roundView.frame) + offset;
//        ExtraSubView *subView = [[ExtraSubView alloc] initWithFrame:CGRectMake(x, y, cx, y) title:titleArray[index] infoString:unitArray[index] textAlign:[textAlign[index] intValue] autoSize:YES];
//        [view addSubview:subView];
//        subView.infoLabel.text = [[@(index == 1 ? count : time) stringValue] stringByAppendingString:unitArray[index]];
        
        //[subView setInfo:[@(index == 1 ? count : time) stringValue]];
//        CGFloat temX = subView.right - (subView.width + roundWidth) / 2;
//        roundView.frame = [Utility moveRect:roundView.frame x:temX y:-1];
//        x = panel.width - cx - offset;
//        view.height = subView.bottom + offset;
//    }
    panel.height = y;
    return panel;
}
-(void)showIntroduct
{
    [PromptViewModel fetchRehaPromptcompletion:^(NSError * _Nonnull error) {
        AppDelegate* app = [UIApplication sharedApplication].delegate;
        NSDictionary* dic = app.probt;
        
    UIView* bac = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW-60, YYScreenSize().height*0.7)];
    bac.backgroundColor = [UIColor whiteColor];
    bac.layer.cornerRadius =  WRCornerRadius;
    
    UIImageView* top = [UIImageView new];
    top.y = 33;
    top.image = [UIImage imageNamed:@"说明图标"];
    [top sizeToFit];
    top.centerX = bac.width*1.0/2;
    [bac addSubview:top];
    
    UILabel* shuoming = [UILabel new];
    shuoming.text = @"说明";
    shuoming.font = [UIFont systemFontOfSize:15];
    shuoming.textColor = [UIColor wr_titleTextColor];
    [shuoming sizeToFit];
    shuoming.y = top.bottom+16;
    shuoming.centerX = bac.width*1.0/2;
    [bac addSubview:shuoming];
    
    UILabel* desc = [UILabel new];
    desc.x = 20;
    desc.width = bac.width-40;
    desc.y = shuoming.bottom+10;
    desc.height = 12;
    desc.text = dic[@"description"];
//    desc.adjustsFontSizeToFitWidth  = YES;
    desc.font = [UIFont systemFontOfSize:12];
    desc.textColor = [UIColor wr_detailTextColor];
    [bac addSubview:desc];
        desc.textAlignment = NSTextAlignmentCenter;
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(20, desc.bottom+10, bac.width-40, 1)];
    line.backgroundColor = [UIColor wr_lineColor];
    [bac addSubview:line];
    
    UILabel* detail = [UILabel new];
    detail.x = 26;
    detail.y = line.bottom+10;
    detail.font = [UIFont systemFontOfSize:WRDetailFont];
    detail.textColor = [UIColor wr_titleTextColor];
    detail.text = dic[@"types"];
    [detail sizeToFit];
    [bac addSubview:detail];
    
    
        UIScrollView* scr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, detail.bottom+10, bac.width, bac.height - 231-72)];
        [bac addSubview:scr];
        NSArray* arr = dic[@"items"];
        CGFloat y=10;
        for (NSDictionary* dict in arr) {
            UIImageView* im = [[UIImageView alloc]initWithFrame:CGRectMake(26, y, 20, 16)];
            [im setImage:[UIImage imageNamed:@"方案过期、方案升阶图标"]];
            [scr addSubview:im];
            
            UILabel* title = [UILabel new];
            title.x = im.right+6;
            title.text = dict[@"title"];
            title.font = [UIFont systemFontOfSize:13];
            title.textColor = [UIColor wr_titleTextColor];
            [title sizeToFit];
            title.bottom = im.bottom;
            [scr addSubview:title];
            y=im.bottom;
            UILabel* body =[UILabel new];
            body.text = dict[@"body"];
            body.textColor= [UIColor wr_detailTextColor];
            body.width = bac.width- 26*2;
            body.font =[UIFont systemFontOfSize:12];
            body.x = 26;
            body.y = im.bottom+10 ;
            body.numberOfLines = 0;
            [body sizeToFit];
            [scr addSubview:body];
            
            
            CGSize s = [body.text sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(bac.width-26*2, MAXFLOAT) lineBreakMode:0];
            y+= s.height+20+10;
            
            
        }
        
        scr.contentSize = CGSizeMake(bac.width, y+20);
        ColorButton* btn = [[ColorButton alloc]initWithFrame:CGRectMake(0, 0, 204, 40) FromColorArray:@[[UIColor colorWithHexString:@"2894ff"],[UIColor colorWithHexString:@"4fd8ff"]] ByGradientType:1];
        btn.width = 204;
        btn.height =40;
        btn.y = scr.bottom+10;
        btn.centerX  = bac.width*1.0/2;
        btn.layer.cornerRadius = 20;
        [btn setTitle:@"确定" forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0 ];
        [bac addSubview:btn];
        
    JCAlertView* jc =[ [JCAlertView alloc]initWithCustomView:bac dismissWhenTouchedBackground:YES];
    [jc show];
        [btn bk_whenTapped:^{
            [jc dismissWithCompletion:nil];
        }];
    }];
}
-(UIView*)createDifficulViewWithContainerWith:(CGFloat)width
{
    CGFloat offset = WRUIOffset, x = offset, y = x, cx;
    
    UILabel *label;
    
    UIColor *textColor = [UIColor grayColor];
    UIFont *font = [WRUIConfig IsHDApp] ? [UIFont wr_titleFont] : [UIFont wr_textFont];
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    panel.backgroundColor = [UIColor whiteColor];
    
    //title
    x = offset, y = offset*2;
    
    label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.text = NSLocalizedString(@"难度", nil);
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:x y:y];
    [panel addSubview:label];
    x = label.right + offset;
    
    CGFloat value = (CGFloat)(self.rehab.disease.difficulty%5)/5;
    cx = MIN(panel.width - offset - x, 120);
    
    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(x, y, cx, label.height) numberOfStars:5];
    starRateView.scorePercent = value;
    starRateView.allowIncompleteStar = NO;
    starRateView.hasAnimation = NO;
    starRateView.userInteractionEnabled = NO;
    [panel addSubview:starRateView];
    
    //    y = starRateView.bottom + offset;
    //    x = offset;
    
    //    时长动作
    NSArray *titleArray = @[NSLocalizedString(@"时长", nil), NSLocalizedString(@"动作", nil), ];
    NSArray *unitArray = @[NSLocalizedString(@"分钟", nil), NSLocalizedString(@"套", nil)];
    
    cx = 45;
    
    __block NSInteger count = 0;
    __block NSInteger time = 0;
    [self.rehab.stageSet enumerateObjectsUsingBlock:^(WRTreatRehabStage*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count++;
        time += obj.mtWellVideoInfo.duration;
    }];
    time /= 60;
    
    //    for (NSInteger index = 0; index < titleArray.count; index++) {
    
    label = [[UILabel alloc] init];
    NSString *text = [[@(time) stringValue] stringByAppendingString:NSLocalizedString(@"分钟", nil)];
    label.text = [NSString stringWithFormat:@"%@： %@", NSLocalizedString(@"时长", nil),text];
    label.textColor = [UIColor grayColor];
    label.font = font;
    [label sizeToFit];
    label.frame = [Utility resizeRect:label.frame cx:label.width height:label.height];
    label.frame = [Utility moveRect:label.frame x:width - label.width - offset y:y];
    [panel addSubview:label];
    y = label.bottom ;
    
    x = offset;
    UIView *line;
    line = [[UIView alloc] initWithFrame:CGRectMake(x, y + 2 * offset, width - 2 * x, 0)];
    line.backgroundColor = [UIColor wr_lightGray];
    [panel addSubview:line];
    panel.height = y;
    return panel;
}

-(UIView *)createVideoThumbScrollViewWithContainerWith:(CGFloat)width
{
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    panel.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [self createIconButtonWithImage:@"" title:NSLocalizedString(@"动作列表", nil)];
    [panel addSubview:button];
    
    button.frame = CGRectMake(WRUIOffset - 5, WRUIOffset, button.width, button.height);
    
    __block NSInteger count = 0;
    [self.rehab.stageSet enumerateObjectsUsingBlock:^(WRTreatRehabStage*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        count++;
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor grayColor];
    label.text = [NSString stringWithFormat:@"共%d个动作",(int)count];
    label.font = [UIFont wr_textFont];
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:button.right y:button.top + (button.height - label.height)/2];
    [panel addSubview:label];
    
    
    
    UILabel* labal = [[UILabel alloc]initWithFrame:CGRectMake(self.view.width-104, 11, 92, 28)];
    labal.text = @"已下载";
    labal.textAlignment = NSTextAlignmentRight;
    labal.textColor = [UIColor wr_grayBorderColor];
    labal.font = [UIFont systemFontOfSize:13];
    [panel addSubview:labal];
    
    

    
    if (![self haveDownVideo]) {
        UIButton* downBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width-104, 11, 92, 28)];
        [downBtn setImage:[UIImage imageNamed:@"下载图标"] forState:0];
        [downBtn setTitle:@"未下载" forState:0];
        [downBtn setTitleColor:[UIColor whiteColor] forState:0];
        downBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        downBtn.backgroundColor = [UIColor wr_rehabBlueColor];
        [panel addSubview:downBtn];
        downBtn.layer.cornerRadius = 14;
        downBtn.layer.masksToBounds =YES;
        downBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        downBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        if ([self ifIndownload]) {
            [downBtn setTitle:@"正在下载" forState:0];
        }
        [downBtn addTarget:self action:@selector(downSel:) forControlEvents:UIControlEventTouchUpInside];
        self.downsate = downBtn;
        
        
        if (self.disease.isProTreat||self.rehab.isSelfRehab) {
            [self.exBTn setTitle:NSLocalizedString(@"开始锻炼", nil) forState:UIControlStateNormal];
        }
        else
        {
            
            [self.exBTn setTitle:NSLocalizedString(@"开始锻炼", nil) forState:UIControlStateNormal];
            NSArray* arr =[ShareUserData userData].treatRehab;
            int i=0;
            for (WRRehab * re in [ShareUserData userData].treatRehab ) {
                if([re.indexId isEqualToString:self.rehab.indexId])
                {
                    i++;
                }
                if([re.indexId isEqualToString:self.rehab.indexId]&&re.state)
                {
                    [self.exBTn setTitle:NSLocalizedString(@"添加方案", nil) forState:UIControlStateNormal];
                }
            }
            if (i==0) {
                [self.exBTn setTitle:NSLocalizedString(@"添加方案", nil) forState:UIControlStateNormal];
                
        
            }
        }
        
        
        if (self.onlinePlays.count == self.rehab.stageSet.count ) {
            NSMutableArray* arr = self.onlinePlays;
            int i=0;
            for (NSString* url in arr) {
                WRTreatRehabStage* stagev = self.rehab.stageSet[i];
                stagev.mtWellVideoInfo.videoUrl = url;
                i++;
            }
        }
        
        
    }
    else
    {
        
        
        NSMutableArray* arr = [[NSUserDefaults standardUserDefaults]objectForKey:self.rehab.indexId];
        int i=0;
        
        for (NSString* url in arr) {
            WRTreatRehabStage* stagev = self.rehab.stageSet[i];
            stagev.mtWellVideoInfo.videoUrl = url;
            i++;
        }
        
        
        [self.exBTn setTitle:@"开始锻炼（本地视频）" forState:0];
    
        
    }
    
    NSMutableArray *titles = [NSMutableArray array];
    [self.rehab.stageSet enumerateObjectsUsingBlock:^(WRTreatRehabStage * stage, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:stage.mtWellVideoInfo.videoName];
    }];
    CGFloat height = [WRVideoThumbControl heightForTitles:titles] + 2*WRUIOffset;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, button.bottom+10, width, height)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    
    CGFloat offset = WRUIOffset, x = offset, y = x, cy,yTem = 0;
    x = offset, y = x, cy = height - 2*y;
    NSInteger index = 0;
    
    UIImage *videoHolderImage = [UIImage imageNamed:@"well_default_video"];
    for(WRTreatRehabStage *stage in self.rehab.stageSet) {
        WRVideoThumbControl *thumbControl = [[WRVideoThumbControl alloc] initWithHeight:cy
                                                                            videoHeight:videoHolderImage.size.height
                                                                                      x:x
                                                                                      y:y
                                                                               imageUrl:stage.mtWellVideoInfo.thumbnailUrl
                                                                                  title:stage.mtWellVideoInfo.videoName];
        thumbControl.tag = index++;
        __weak __typeof(self) weakSelf = self;
        [thumbControl bk_whenTapped:^(void){
            [weakSelf didTagVideoThumb:thumbControl];
        }];
        [scrollView addSubview:thumbControl];
        
        UILabel *label = [[UILabel alloc] init];
        NSInteger sec = stage.mtWellVideoInfo.duration % 60;
        NSInteger min = (stage.mtWellVideoInfo.duration - sec)/60;
        label.text = [NSString stringWithFormat:@"%ld分%ld秒",min,(long)sec];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont wr_textFont];
        [label sizeToFit];
        label.frame = CGRectMake(thumbControl.centerX - label.width/2, thumbControl.bottom, label.width, label.height);
        [scrollView addSubview:label];
        yTem = label.bottom + 2 * offset;
        
        x = CGRectGetMaxX(thumbControl.frame) + offset;
    }
    scrollView.height = yTem;
    scrollView.contentSize = CGSizeMake(x, scrollView.height);
    panel.height = scrollView.bottom+10;
    [panel addSubview:scrollView];
    
    return panel;
}
-(UIView*)createUsersViewWithContainerWidth:(CGFloat)width
{
    WRRehab *rehab = self.rehab;
    
    BOOL biPad = [WRUIConfig IsHDApp];
    
    CGFloat offset = WRUIOffset, x = offset, y = x;
    
    
    UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, 0)] ;
    iconView.backgroundColor = [UIColor whiteColor];
    [iconView bk_whenTapped:^{
        [self onClickedIconView];
    }];
    
    CGFloat imageSize = biPad ? 80 : 20;
    
    NSString *string = [NSString stringWithFormat:@"%d%@", (int)rehab.reviewCount, NSLocalizedString(@"人完成", nil)];
    UIButton *button = [self createIconButtonWithImage:@"" title:string];
    button.frame = CGRectMake(x - 5, y, button.width, button.height);
    [iconView addSubview:button];
    
    y = offset;
    
    x = offset;
    CGFloat xOffset = 1;
    
    UIScrollView *iconScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x+button.width+offset, y, _scrollView.width-(x+button.width+offset), 0)];
    iconScrollView.backgroundColor = [UIColor clearColor];
    iconScrollView.showsVerticalScrollIndicator = NO;
    iconScrollView.showsHorizontalScrollIndicator = NO;
    [iconView addSubview:iconScrollView];
    y = offset;
    x = 0;
    for(NSUInteger index = 0; index < rehab.users.count; index++)
    {
        WRUserInfo* userInfo = rehab.users[index];
        if ((x +imageSize) > (iconView.width - xOffset)) {
            break;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageSize, imageSize)];
        imageView.layer.cornerRadius = imageView.width/2;
        imageView.layer.masksToBounds = YES;
        [imageView setImageWithUrlString:userInfo.headImageUrl holderImage:[WRUIConfig defaultHeadImage]];
        [iconScrollView addSubview:imageView];
        iconScrollView.height = imageView.bottom +  offset;
        x = imageView.right + xOffset;
    }
    iconScrollView.contentSize = CGSizeMake(x, imageSize);
    
    UIImage *image = [[UIImage imageNamed:@"essay_arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:image];
    arrowImageView.tintColor = [UIColor grayColor];
    x = iconView.width - arrowImageView.width - offset;
    y = button.bottom + iconScrollView.height/2 - arrowImageView.height/2;
        arrowImageView.frame = CGRectMake(x, y, arrowImageView.width, arrowImageView.height);
    [iconView addSubview:arrowImageView];
    
    
    iconScrollView.width = iconScrollView.width - (offset*2+arrowImageView.width);
    iconView.height = iconScrollView.bottom+offset ;
    button.centerY = iconScrollView.centerY;
    arrowImageView.centerY = iconScrollView.centerY;

    return iconView;
}

//我的轨迹
-(UIView *)createUserRehabOrbitViewWithContainerWidth:(CGFloat)width
{
    CGFloat offset = WRUIOffset, x = offset, y = x, cx, cy;
    
    __weak __typeof(self)weakself = self;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    containerView.backgroundColor = [UIColor whiteColor];
    [containerView bk_whenTapped:^{
        [weakself onClickMyFooter];
    }];
    
    NSString *text = NSLocalizedString(@"我的轨迹", nil);
    if ([self.rehab.disease isPro]) {
        text = [text stringByAppendingFormat:NSLocalizedString(@"(坚持锻炼%d天,获取专属进阶方案)", nil), (int)self.rehab.count/2];
    }
    
    UIButton *button = [self createIconButtonWithImage:@"" title:text];
    button.frame = CGRectMake(x - 5, y, button.width, button.height);
    [containerView addSubview:button];
    
    y = button.bottom + offset;
    
    x = offset;
    cx = containerView.width - 2*x;
    
    UIScrollView *labelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, containerView.width, 0)];
    labelScrollView.backgroundColor = [UIColor clearColor];
    labelScrollView.showsVerticalScrollIndicator = NO;
    labelScrollView.showsHorizontalScrollIndicator = NO;
    [containerView addSubview:labelScrollView];
    
    NSArray *array = self.rehab.checkedDate;
    BOOL biPad = [WRUIConfig IsHDApp];
    if (array.count > 0)
    {
        cx = biPad ? 80 : 40;
        cy = cx;
        
        NSDate *nowDate = [NSDate date];
        BOOL findToday = NO;
        x = offset;
        y = 0;
        CGFloat yMax = 0;
        for(NSInteger i = 0; i < array.count; i++)
        {
            NSString *dateString = array[i];
            NSString *labelString = [dateString substringWithRange:NSMakeRange(8, 2)];
            NSDate *date = [NSDate dateWithString:dateString];
            UIFont *font = [WRUIConfig IsHDApp] ? [UIFont wr_smallTitleFont] : [UIFont wr_textFont];
            //            [dateArray addObject:date];
            BOOL flag = NO;
            if (!findToday) {
                findToday = ([Utility getDaysFrom:date To:nowDate] == 0);
                flag = findToday;
            }
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
            label.text = labelString;
            label.backgroundColor = [[UIColor wr_rehabBlueColor] colorWithAlphaComponent:1];
            label.textColor = [UIColor whiteColor];
            label.layer.cornerRadius = cx/2;
            label.clipsToBounds = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = font;
            label.tag = i;
            label.userInteractionEnabled = YES;
            if (flag) {
                label.layer.borderColor = [UIColor wr_themeColor].CGColor;
                label.layer.borderWidth = 1;
            }
            x = label.left - offset - 2;
            
            if ([self checkIsContiousWithThisDate:date]) {
                CGFloat lineHeight = 1;
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, label.centerY - lineHeight/2, offset + 2, lineHeight)];
                lineView.backgroundColor = label.backgroundColor;
                [labelScrollView addSubview:lineView];
            }
            self.previousDate = date;
            x = label.right + offset + 2;
            [labelScrollView addSubview:label];
            yMax = label.bottom + offset;
        }
        
        labelScrollView.contentSize = CGSizeMake(array.count * cx + (array.count + 1) * 2 * WRUIOffset, cy);
        UIImage *image = [[UIImage imageNamed:@"essay_arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:image];
        arrowImageView.tintColor = [UIColor grayColor];
        cx = image.size.width;
        cy = image.size.height;
        //        y = button.bottom;
        y = button.bottom + yMax/2 - arrowImageView.size.height/2;
        x = _scrollView.right - cx - offset;
        arrowImageView.frame = CGRectMake(x, y, cx, cy);
        arrowImageView.hidden = (self.rehab.checkedDate.count == 0);
        [containerView addSubview:arrowImageView];
        
        labelScrollView.frame = [Utility resizeRect:labelScrollView.frame cx:_scrollView.width - cx - 3 * offset height:yMax];
        containerView.height = labelScrollView.bottom;
    }
    else
    {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        label.text = NSLocalizedString(@"点击开始锻炼，创造属于自己的轨迹", nil);
        label.textColor = [UIColor grayColor];
        label.font = [UIFont wr_smallFont];
        [label sizeToFit];
        [containerView addSubview:label];
        containerView.height = label.bottom + offset;
    }
    return containerView;
}

//了解更多
-(UIView*)createRelateAriticlesViewWithContainerWidth:(CGFloat)width
{
    WRRehab *rehab = self.rehab;
    
    CGFloat offset = WRUIOffset, x = offset, y = x, cx, cy;
    
    UIView *moreView = [[UIView alloc] initWithFrame:CGRectMake(0, y, _scrollView.width, 0)] ;
    moreView.backgroundColor = [UIColor whiteColor];
    UIView *panel = moreView;
    
    x = offset;
    y = offset;
    UIImage *image = [[UIImage imageNamed:@"essay_arrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cx = panel.width - 3*x - image.size.width;
    
    UIButton *button = [self createIconButtonWithImage:@"" title:@"热文精选"];
    button.frame = CGRectMake(x - 5, y, button.width, button.height);
    [panel addSubview:button];
    
    y = button.bottom + offset;
    NSInteger tag = 0;
    UILabel *label;
    
    for(WRArticle *news in rehab.relate){
//        label = [self createTitleLabelWithTitle:news.title container:panel width:cx];
//        label.frame = [Utility moveRect:label.frame x:x y:y];
//        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor grayColor];
//        label.font = [WRUIConfig IsHDApp] ? [UIFont wr_smallTitleFont] : [UIFont wr_smallFont];
//        label.tag = tag++;
//        label.numberOfLines = 1;
//        label.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
//        label.userInteractionEnabled = YES;
        
        UIView *view = [self createArticleViewWithArticle:news];
        view.tag = tag++;
        view.top = y;
        __weak __typeof(self) weakSelf = self;
        [view bk_whenTapped:^{
            WRArticle *news = weakSelf.rehab.relate[view.tag];
            ArticleDetailController *viewController = [[ArticleDetailController alloc] init];
            [self setnavi];
            [weakSelf.navigationController pushViewController:viewController animated:YES];
            
            
            viewController.currentNews = news;
            [UMengUtils careForRehabArticle:self.rehab.disease.diseaseName articleName:news.title];
            
            //锚点
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"%@rw",self.umstr] attributes:nil counter:duration];
        }];
        [panel addSubview:view];
        
//        cy = label.height - offset;
//        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:image];
//        arrowImageView.tintColor = [UIColor grayColor];
//        CGFloat cx0 = image.size.width / image.size.height * cy;
//        x = moreView.right - cx0 - offset;
//        y = label.centerY - cy/2;
//        arrowImageView.frame = CGRectMake(x, y, cx0, cy);
//        x = offset;
//        [panel addSubview:arrowImageView];
        
        y = view.bottom + offset;
    }
    y += offset;
    moreView.height = y;
    return moreView;
}

- (UIView *)createArticleViewWithArticle:(WRArticle *)news
{
    CGFloat viewH, x, y, offset;
    viewH = 100;
    offset = WRUIOffset;
    x = offset;
    y = offset;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, viewH)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, viewH - 2 * offset, viewH - 2 * offset)];
    [imageView setImageWithUrlString:news.imageUrl holder:@"well_default"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 2;
    label.text = news.title;
    label.font = [UIFont systemFontOfSize:WRDetailFont];
    label.textColor = [UIColor grayColor];
    CGSize size = [label sizeThatFits:CGSizeMake(_scrollView.width - imageView.width - 3 * offset, CGFLOAT_MAX)];
    label.frame = CGRectMake(imageView.right + offset, y, size.width, size.height);
    [view addSubview:label];
    y = label.bottom;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"人数"] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"%d",(int)news.viewCount] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont wr_smallestFont];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [button sizeToFit];
//    button.frame = CGRectMake(_scrollView.right - button.width - offset, y, button.width, button.height);
    button.frame = [Utility resizeRect:button.frame cx:button.width + 2 * offset height:button.height];
    button.frame = [Utility moveRect:button.frame x:_scrollView.width - button.width - offset y:imageView.bottom - button.height];
    [view addSubview:button];
    y = button.bottom;
    
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"%d",(int)news.commentCount] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont wr_smallestFont];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [button sizeToFit];
    //    button.frame = CGRectMake(_scrollView.right - button.width - offset, y, button.width, button.height);
    button.frame = [Utility resizeRect:button.frame cx:button.width + 2 * offset height:button.height];
    button.frame = [Utility moveRect:button.frame x:_scrollView.width - button.width - offset-15-button.width y:imageView.bottom - button.height];
    [view addSubview:button];
    y = button.bottom;
    
    
    
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.bottom + offset, _scrollView.width, 1)];
    line.backgroundColor = [UIColor wr_lightGray];
    [view addSubview:line];
    return view;
}

-(UIButton*)createImageTextButtonWithImage:(UIImage*)image title:(NSString*)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont wr_lightFont];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    return button;
}

- (void)createToolBarViewWithContainer:(UIView*)container
{
    UIImage *image = [UIImage imageNamed:@"well_icon_exercise"];
    CGFloat offset = WRUIOffset,
    cy = image.size.height + 2*offset, x, inset = 0 ,leftInset = 2 * offset, cx;
    x = leftInset;
    UIView *bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, container.width, cy)];
//    bar.backgroundColor = [UIColor yellowColor];
    bar.backgroundColor = [UIColor whiteColor];
    
//    BOOL hasAssess = self.rehab.assess.count > 0;
    cx = container.width - 2 * leftInset;
//    cx = hasAssess?(container.width - 2 * leftInset - inset)/2:container.width - 2 * leftInset;
//    if (hasAssess) {
//        inset = offset;
//        UIButton *assessButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [assessButton setBackgroundImage:[UIImage imageNamed:@"well_rehab_assessBg"] forState:UIControlStateNormal];
//        [assessButton addTarget:self action:@selector(onClickedAssessButton:) forControlEvents:UIControlEventTouchUpInside];
//        [assessButton setTitle:NSLocalizedString(@"自我检测", nil) forState:UIControlStateNormal];
//        [assessButton setTitleColor:[UIColor wr_rehabBlueColor] forState:UIControlStateNormal];
//        assessButton.titleLabel.font = [UIFont wr_lightFont];
//        [assessButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
//        [bar addSubview:assessButton];
//        assessButton.frame = CGRectMake(x, offset, cx, image.size.height + 2 * offset);
//        x = assessButton.right + inset;
//    }
    
//    UIButton *exerciseButton = [self createImageTextButtonWithImage:image title:NSLocalizedString(@"开始锻炼", nil)];
    UIButton *exerciseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [exerciseButton setBackgroundColor:[UIColor wr_rehabBlueColor]];
//    [exerciseButton wr_roundBorderWithColor:[UIColor wr_themeColor]];
//    exerciseButton.backgroundColor = [UIColor wr_themeColor];
//    if ([self haveDownVideo]) {
    
    
    if (self.disease.isProTreat) {
        [exerciseButton setTitle:NSLocalizedString(@"开始锻炼", nil) forState:UIControlStateNormal];
    }
    else
    {
        
        [exerciseButton setTitle:NSLocalizedString(@"开始锻炼", nil) forState:UIControlStateNormal];
        NSArray* arr =[ShareUserData userData].treatRehab;
        int i=0;
        for (WRRehab * re in [ShareUserData userData].treatRehab ) {
            if([re.indexId isEqualToString:self.rehab.indexId])
            {
                i++;
            }
            if([re.indexId isEqualToString:self.rehab.indexId]&&re.state)
            {
                [exerciseButton setTitle:NSLocalizedString(@"添加方案", nil) forState:UIControlStateNormal];
            }
        }
        if (i==0) {
            [exerciseButton setTitle:NSLocalizedString(@"添加方案", nil) forState:UIControlStateNormal];
        }
    }
//    }
//    else
//    {
//     
//        [exerciseButton setTitle:NSLocalizedString(@"开始下载", nil) forState:UIControlStateNormal];
//    }
    
    
    
    [exerciseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exerciseButton.titleLabel.font = [UIFont wr_lightFont];
    [exerciseButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [bar addSubview:exerciseButton];
    exerciseButton.frame = CGRectMake(0, 0, ScreenW, image.size.height + 2*offset);
    [exerciseButton addTarget:self action:@selector(onClickedBeginExerciseButton:) forControlEvents:UIControlEventTouchUpInside];
    self.exBTn = exerciseButton;
    int i= 0;
    if (@available(iOS 11.0, *)) {
        i = 64;
    }
    bar.top = self.view.height - bar.height+i;
    self.barView = bar;
    _scrollView.height = self.view.height - bar.height+i;
    [self.view addSubview:bar];
    
    
}


/**
 *  布局
 */
-(void)layoutWithTreatRehab:(WRRehab*)rehab
{
    BOOL flag = ([NSDate dateWithString:rehab.createTime] != nil);
    flag |= rehab.disease.isProTreat;
    UIScrollView *scrollView = _scrollView;
    
    UIView *container = scrollView;
    [container removeAllSubviews];
    
    const CGFloat offset = WRUIOffset;
    CGFloat y;
    
    UIView *view = [self createTopViewWithContainerWith:container.width];
//    view.top = 44;
//    view.top = _topImageView.bottom;
//    view.top -= 90;
    [container addSubview:view];
    
    
    
    
    
    UIView *view2 = [self createQuestionViewWith:container.width];
    view2.top = view.bottom;
    [container addSubview:view2];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.bottom, container.width , 5)];
    line2.backgroundColor = [UIColor wr_lightGray];
    [container addSubview:line2];
    y = view2.bottom+5;
    
    
    if (rehab.stageSet.count > 0) {
        view = [self createVideoThumbScrollViewWithContainerWith:container.width];
        view.top = y;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(offset, view.bottom, container.width - 2 * offset, 1)];
        line.backgroundColor = [UIColor wr_lightGray];
        [container addSubview:line];
        [container addSubview:view];
        y = view.bottom +1;
    }

    //人完成
    if (self.rehab.reviewCount > 0 && self.rehab.users.count > 0)
    {
        UIView *diffcul = [self createDifficulViewWithContainerWith:container.width];
        diffcul.top = y;
        y +=diffcul.height+1;
        UIView *lineTin = [[UIView alloc] initWithFrame:CGRectMake(offset, diffcul.bottom, container.width - 2*offset, 0)];
        lineTin.backgroundColor = [UIColor wr_lightGray];

        view = [self createUsersViewWithContainerWidth:container.width];
        view.top = y;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, view.bottom, container.width , 5)];
        line.backgroundColor = [UIColor wr_lightGray];
        
        
        [container addSubview:line];
        [container addSubview:lineTin];
        [container addSubview:diffcul];
        [container addSubview:view];
        y = view.bottom + offset;
    }
    
    

    
//    if(flag)
//    {
//        view = [self createUserRehabOrbitViewWithContainerWidth:container.width];
//        view.top = y;
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(offset, view.bottom, container.width - 2 * offset, 5)];
//        line.backgroundColor = [UIColor wr_lightGray];
//        [container addSubview:line];
//        [container addSubview:view];
//        y = view.bottom + offset;
//    }
    
    //了解更多
    if (rehab.relate.count > 0) {
        view = [self createRelateAriticlesViewWithContainerWidth:container.width];
        view.top = y;
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(offset, view.bottom, container.width - 2 * offset, 5)];
//        line.backgroundColor = [UIColor wr_lightGray];
//        [container addSubview:line];
        [container addSubview:view];
        y = view.bottom + offset;
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.width, y );
    if (!self.barView) {
        [self createToolBarViewWithContainer:container];
    }
}

#pragma mark down
- (NSMutableArray *)urls
{
    if (!_urls) {
        self.urls = [NSMutableArray array];
        for (int i = 0; i<self.rehab.stageSet.count; i++) {
            WRTreatRehabStage* stage= self.rehab.stageSet[i];
            [self.urls addObject:stage.mtWellVideoInfo.videoUrl];
            
            //       [self.urls addObject:@"http://localhost/MJDownload-master.zip"];
        }
    }
    return _urls;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        if (alertView.tag==100) {
            JTNavigationController *jtNav = self.navigationController;
            if (jtNav)
            {
                UIViewController *destViewController = nil;
                NSArray *viewControllers = jtNav.viewControllers;
                for(UIViewController *viewController in viewControllers)
                {
                    if ([viewController isKindOfClass:[AddTreatDiseaseBaseContrller class]])
                    {
                        destViewController = viewController;
                        break;
                    }
                }
                if (!destViewController) {
                    for(UIViewController *viewController in viewControllers)
                    {
                        if ([viewController isKindOfClass:[HealthController class]])
                        {
                            destViewController = viewController;
                            break;
                        }
                    }
                }
                if (destViewController) {
                    [self.navigationController popToViewController:destViewController animated:YES];
                }
                else
                {
                    UIViewController *viewController = [self.navigationController popViewControllerAnimated:YES];
                    if (viewController == nil)
                    {
                        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                    
                    
                }
            } else {
                UIViewController *viewController = [self.navigationController popViewControllerAnimated:YES];
                if (viewController == nil)
                {
                    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }
            }
            UINavigationBar *bar = jtNav.navigationBar;
            UINavigationController* navi = self.navigationController;
            
            bar.barTintColor = [UIColor whiteColor];
            bar.tintColor = [UIColor blackColor];
            [bar setTranslucent:NO];
            [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
        }else{
            self.downLowBTn.userInteractionEnabled = NO;
            [self downloadVieo];
            
            CGRect headRect = CGRectMake(0, self.view.size.height*2.0/3, 20, 20);
            //                        headRect.origin.y = rect.origin.y+headRect.origin.y;
            UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.size.width-40)*1.0/2, (self.view.size.height-40-74)*1.0/2, 57, 53)];
            [imageView setImage:[UIImage imageNamed:@"视频-(1)"]];
            //                [self addSubview:imageView];
            
            [self startAnimationWithRect:headRect ImageView:imageView];
            
            self.bageView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0,0,5, 5)];
            self.bageView.font=[UIFont systemFontOfSize:5];
            self.bageView.text = @"";
            [self.down addSubview:self.bageView];
            self.bageView.badgeBackgroundColor=[UIColor redColor];
            self.bageView.textColor=[UIColor whiteColor];
            self.bageView.hidesWhenZero=NO;
            _bageView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
        }
        
        
        
    }
}
- (BOOL)haveDownVideo
{
    NSMutableArray* arr= [NSMutableArray array];
    arr = [[NSUserDefaults standardUserDefaults]objectForKey:self.rehab.indexId];
    
    if (!arr) {
        return NO;
    }
    else
    {
        int i = 0;
        for (NSString* url in  arr) {
           
            
            NSArray *array = [url componentsSeparatedByString:@"Documents/"];
            //获取沙盒路径 拼接信息生成文件
            NSString *localPath2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *newPath = [NSString stringWithFormat:@"%@/%@",localPath2,array[1]];
            
            
        
//            NSString *localPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//            // 要检查的文件目录
//            NSString *filePath = url;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:newPath]) {
                i++;
            }
            
            
            
         
        }
        
        if (i == arr.count) {
            
           return YES;

        }
        else
        {
            return NO;
        }
        
        
        
    }
    

}
- (BOOL)ifIndownload
{
    NSArray *urls = [self urls];
    for (NSString *url in urls) {
        MCDownloadReceipt* re =[ [MCDownloader sharedDownloader]downloadReceiptForURLString:url];
        if (re.state == MCDownloadStateDownloading) {
            return YES;
        }
    }
    return NO;
}
- (void)downloadVieo
{
    NSMutableArray* arr= [NSMutableArray array];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:self.rehab.indexId];
    arr = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:self.rehab.indexId]];
    if (![self haveDownVideo]) {
        
        if(arr)
        {
//        for (NSString* url in arr) {
//            NSString *imageDir = [NSString stringWithFormat:@"%@",url];
//            NSFileManager *fileManager = [NSFileManager defaultManager];
//            [fileManager removeItemAtPath:imageDir error:nil];
//        }
//
//
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:self.rehab.indexId];
            
            _i=0;
//        for (NSString * url in [self urls]) {
//                MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:url];
//                [[MCDownloader sharedDownloader] remove:receipt completed:^{
//                    NSLog(@"删除了");
//                    _i ++;
//                    if (_i==[self urls].count) {
//                        [self downlodad:[NSMutableArray array]];
//
//                    }
//
//                }];
//            }
            NSMutableArray*  arr = [NSMutableArray array];
            [self downlodad:arr];
        }
        else
        {
            NSMutableArray*  arr = [NSMutableArray array];
            [self downlodad:arr];
        }
        
      
    }
    
    
    
    
    
}
static int r = 0;
- (void)downlodad:(NSMutableArray*)arr
{
    NSMutableArray* listarr =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"downlist"]];
    if (!listarr) {
        listarr=[NSMutableArray array];
    }
    NSArray *urls = [self urls];
    WRDownRehab* dr = [WRDownRehab new];
    dr.downlist = urls;
    dr.title = self.rehab.name;
    NSInteger size = 0;
    
    
    
    
    for (WRTreatRehabStage* stage in self.rehab.stageSet) {
        size+=stage.mtWellVideoInfo.size;
    }
    dr.size = size;
    if ([self.rehab.disease isPro]) {
        dr.title = [NSString stringWithFormat:@"%@(定制方案)",self.rehab.disease.diseaseName];
    }
    else
    {
        dr.title = self.rehab.disease.diseaseName;
    }
    dr.indexid = self.rehab.indexId;
    NSLog(@"%@",[dr modelToJSONString]);
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [self.downsate  setTitle:@"正在下载" forState:0];
    [self.exBTn setTitle:@"开始锻炼" forState:0];
    [[WRDownloadArray sharedDownloadArray]addObject:dr];
    self.onlinePlays = [NSMutableArray array];
     r = 0;
    //urls = @[];
    //urls = [urls arrayByAddingObject:@"http://120.25.226.186:32812/resources/videos/minion_02.mp4"];
    for (NSString *url in urls) {
        
        [self.onlinePlays addObject:url];
        
        MCDownloadReceipt *receipt = [[MCDownloader sharedDownloader] downloadReceiptForURLString:url];
        
//        receipt.customFilePathBlock = ^NSString * _Nullable(MCDownloadReceipt * _Nullable receipt) {
//            NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
//            NSString *cacheFolderPath = [cacheDir stringByAppendingPathComponent:@"well"];
//            return [cacheFolderPath stringByAppendingPathComponent:url.lastPathComponent];
//        };
        
        
       receipt.downloaderProgressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
            _re += receivedSize;
            
            _ex += expectedSize;
            
            NSLog(@"%ld/%ld %.1f %ld/s",_re,_ex, _re*200.0/_ex , speed);
                        [self.downsate setTitle:[NSString stringWithFormat:@"完成%.0lf%%",_re*200.0/_ex>100?100:_re*200.0/_ex] forState:0];
           
       };
       receipt.downloaderCompletedBlock = ^(MCDownloadReceipt * _Nullable receipt, NSError * _Nullable error, BOOL finished) {
            NSLog(@"==%@", error.description);
            r++;
            if (!error) {
                if (![arr containsObject:receipt.filePath]) {
                    [arr addObject:receipt.filePath];
                    dict[url] = receipt.filePath;
                }
                //判断是否下载完成（防止重复）
                int i=1;
                for (NSString* url in urls) {
                    if (!dict[url]) {
                        i=0;
                    }
                    
                }
                if (i==1) {
                    [listarr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        NSString* str = obj;
                        if ([str rangeOfString:dr.title].length>0) {
                            
                            [listarr removeObject:str];
                        }
                    }];
                    
                    
                    if (![listarr containsObject:[dr modelToJSONString]]) {
                        [listarr addObject:[dr modelToJSONString]];
                    }
                    self.downLowBTn.userInteractionEnabled = YES;
                    [[NSUserDefaults standardUserDefaults]setObject:listarr forKey:@"downlist"];
                    [AppDelegate show:@"下载完成"];
                    [self.exBTn setTitle:@"开始锻炼(本地视频)" forState:0];
                    self.downsate.hidden=YES;
                    int i=0;
                    for (WRTreatRehabStage* stagev in self.rehab.stageSet ) {
                        NSLog(@"%@",stagev.mtWellVideoInfo.videoUrl);
                        if (![arr containsObject:stagev.mtWellVideoInfo.videoUrl]) {
                            arr[i] = dict[stagev.mtWellVideoInfo.videoUrl];
                            i++;
                        }
                        
                    }
                    i=0;
                    
                    for (NSString* url in arr) {
                        
                        WRTreatRehabStage* stagev = self.rehab.stageSet[i];
                        
                        stagev.mtWellVideoInfo.videoUrl = url;
                        i++;
                        
                    }
                    
                    [[NSUserDefaults standardUserDefaults]setObject:arr forKey:self.rehab.indexId];
                    
                }
                else
                {
//                    if (r == urls.count-1) {
//                        [self downlodad:urls];
//                        r = 0;
//                    }
                    
                    //                [AppDelegate show:@"下载失败"];
                }
            }
            
            //            WRTreatRehabStage* stagev = self.rehab.stageSet[[urls indexOfObject:url]];
            //            stagev.mtWellVideoInfo.videoUrl = receipt.filePath;
            
            
       };
        
        [[MCDownloader sharedDownloader] downloadDataWithURL:[NSURL URLWithString:url] progress:^(NSInteger receivedSize, NSInteger expectedSize, NSInteger speed, NSURL * _Nullable targetURL) {
            
        } completed:^(MCDownloadReceipt *receipt, NSError * _Nullable error, BOOL finished) {
            NSLog(@"==%@", error.description);
        }];
        
        
    }

}



-(void)downSel:(UIButton*)sender
{
    [sender setEnabled:NO];
    if ([sender.titleLabel.text isEqualToString:@"未下载"]) {
        
        if ([self.exBTn.titleLabel.text isEqualToString:@"添加方案"]) {
            
            void(^block)(NSError * _Nullable error, id _Nullable object) = ^(NSError * _Nullable error, id _Nullable object){
                if (error) {
                    [AppDelegate show:@"尚未添加方案"];
                } else {
                    
                    NSInteger size = 0;
                    
                    for (WRTreatRehabStage* stage in self.rehab.stageSet) {
                        size+=stage.mtWellVideoInfo.size;
                    }
                    
                    UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"下载" message:[NSString stringWithFormat:@"请下载方案视频,需要约%.1lfMB的流量。",size*1.0/1024/1024] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开始", nil];
                        [al show];
                        //                [AppDelegate show:@"添加方案成功"];
                    
                        [self.exBTn setTitle:@"开始锻炼" forState:0];
                    
                    
                    //
                }
            };

            
            if (![self.rehab.disease isPro]) {
                [UserViewModel checkRehabWidthIndexId:self.rehab.indexId sportTimeSeconds:0 isProTreat:NO completion:block];
            }
           

        }
        else
        {
            NSInteger size = 0;
            
            for (WRTreatRehabStage* stage in self.rehab.stageSet) {
                size+=stage.mtWellVideoInfo.size;
            }
            
            UIAlertView* al = [[UIAlertView alloc]initWithTitle:@"下载" message:[NSString stringWithFormat:@"请下载方案视频,需要约%.1lfMB的流量。",size*1.0/1024/1024] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"开始", nil];
            [al show];
            //
        }
    }
   
}


//
-(void)startAnimationWithRect:(CGRect)rect ImageView:(UIImageView *)imageView
{
    UIImageView* imageView1=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.width-40)*1.0/2, (self.view.height-64-40)*1.0/2, 57, 53)];
    
        if (!_layer) {
            //        _btn.enabled = NO;
            _layer = [CALayer layer];
            UIImage* im=[UIImage imageNamed:@"视频-(1)"];
            _layer.contents = (__bridge id)im.CGImage;;
            
            _layer.contentsGravity = kCAGravityResizeAspectFill;
            _layer.bounds = CGRectMake(0, 0, 50, 50);
           
            _layer.masksToBounds = YES;
            // 导航64
            _layer.position = CGPointMake(imageView.center.x, CGRectGetMidY(rect)+64);
            //        [_tableView.layer addSublayer:_layer];
            self.path = [UIBezierPath bezierPath];
            [_path moveToPoint:_layer.position];
            //        (SCREEN_WIDTH - 60), 0, 50, 50)
            [_path addQuadCurveToPoint:CGPointMake(self.view.size.width-40, 20) controlPoint:CGPointMake(self.view.size.width/2,rect.origin.y-80)];
            
            [self.view.layer addSublayer:_layer];
            
            //        [_path addLineToPoint:CGPointMake(SCREEN_WIDTH-40, 30)];
        }
        [self groupAnimation];
    
    
    
}


-(void)groupAnimation
{
    //    _tableView.userInteractionEnabled = NO;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = _path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.3f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1];
    expandAnimation.toValue = [NSNumber numberWithFloat:3.0f];
    expandAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.3;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:3.0f];
    narrowAnimation.duration = 0.4f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.f];
    
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation,expandAnimation,narrowAnimation];
    groups.duration = 0.7f;
    groups.removedOnCompletion=NO;
    groups.fillMode=kCAFillModeForwards;
    groups.delegate = self;
    [_layer addAnimation:groups forKey:@"group"];
}




@end
