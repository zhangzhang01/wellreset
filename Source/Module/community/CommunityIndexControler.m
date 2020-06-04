//
//  CommunityIndexControler.m
//  rehab
//
//  Created by yongen zhou on 2018/7/12.
//  Copyright © 2018年 WELL. All rights reserved.
//

#import "CommunityIndexControler.h"
#import "TYCyclePagerView.h"
#import "TYCyclePagerViewCell.h"
#import "EllipsePageControl.h"
#import "ZXSegmentController.h"
#import "CircleController.h"
#import "YSWFrendCell.h"
#import "CommutiDetailController.h"
#import "ComulitModel.h"
#import "CommutiDetailController.h"
#import "ArticleDetailController.h"
#import "WrWebViewController.h"
#import <Masonry/Masonry.h>
#import "WRRefreshHeader.h"
#import <MJRefresh/MJRefresh.h>
#import "JJOptionView.h"
#import "MTFooter.h"
#import "FriendSendController.h"
#import "ComMessageController.h"
#import "CircleDetailController.h"
#import "UINavigationBar+Awesome.h"
#import "JCAlertView.h"
#import "ZJMasonryAutolayoutCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#define kMasonryCell @"kMasonryCell"
@interface CommunityIndexControler()<TYCyclePagerViewDelegate,TYCyclePagerViewDataSource,UITableViewDelegate,UITableViewDataSource,EllipsePageControlDelegate>
@property UITableView* mytableview;
@property NSMutableArray* bannerarr;
@property TYCyclePagerView* pagerView;
@property EllipsePageControl* pageControl;
@property NSMutableArray* dataArr;
@property ComulitModel* viewModel;
@property (nonatomic,weak) ZXSegmentController* segmentControlle;
@property int page;
@property NSString* sort;
@property UIView* cloud;
@property UIButton* joinBtn;
@property UIButton* send;

@end

@implementation CommunityIndexControler
- (void)viewDidLoad
{
    
    _mytableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.view.height-WRTabbarHeight-49) style:UITableViewStylePlain];
    
    [self.view addSubview:_mytableview];
    
//    [self.mytableview registerNib:[UINib nibWithNibName:NSStringFromClass([YSWFrendCell class]) bundle:nil] forCellReuseIdentifier:@"Friend"];
   
    self.mytableview.delegate = self;
    self.mytableview.dataSource = self;
    self.sort = @"";
    self.page = 1;
    self.viewModel = [ComulitModel new];
    [_mytableview registerClass:[ZJMasonryAutolayoutCell class] forCellReuseIdentifier:kMasonryCell];
    self.mytableview.estimatedRowHeight = 50.0;
    self.mytableview.rowHeight = UITableViewAutomaticDimension;
    WRRefreshHeader *header = [[WRRefreshHeader alloc] init];
    __weak __typeof(self)weakSelf = self;
    header.refreshingBlock = ^{
        [weakSelf reload];
        
    };
  
    self.mytableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mytableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mytableview.mj_header =header;
    self.mytableview.mj_footer = [MTFooter footerWithRefreshingBlock:^{
        [weakSelf loadAdd];
    }];
    
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[SDWebImageManager sharedManager] cancelAll];
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    [self.mytableview.mj_header endRefreshing];
    if (self.circleId) {
        UINavigationBar *bar = self.navigationController.navigationBar;
        UINavigationController* navi = self.navigationController;
        bar.barTintColor = [UIColor whiteColor];
        bar.tintColor = [UIColor blackColor];
        [bar setTranslucent:NO];
        [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
        if (IOS11) {
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setShadowImage:nil];
        }
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"push" object:nil];
}

- (void)renoti
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"push" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCell) name:@"reloadCom" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushTosender:) name:@"push" object:nil];
}
-(void)reloadCell
{
    self.reloadcell = YES;
    
}
-(void)pushTosender:(NSNotification*)sender
{
    CommunityIndexControler* index = sender.object;
    index.hidesBottomBarWhenPushed = YES;
    [index createBackBarButtonItem];
    [self.navigationController pushViewController:index animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* str = self.title;
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary* dic = app.circle_protocol;
    if (dic) {
        
        
        if (![ud objectForKey:dic[@"MD5"]]) {
            
            UIView* view = [UIView new];
            view.frame = CGRectMake(0, 0, ScreenW, YYScreenSize().height);
            UITextView * text = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, YYScreenSize().height-50)];
            NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithData:[dic[@"text"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            //  [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, string.length)];
            text.attributedText = string;
            [view addSubview:text];
            UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, text.bottom, ScreenW, 50)];
            [btn setTitle:@"我知道了" forState:0];
            [btn setTitleColor:[UIColor whiteColor] forState:0];
            [btn setBackgroundColor:[UIColor wr_themeColor]];
            btn.titleLabel.font = [UIFont systemFontOfSize:18];
            [view addSubview:btn];
            
            JCAlertView* jc = [[JCAlertView alloc]initWithCustomView:view dismissWhenTouchedBackground:NO];
            [jc show];
            [ud setObject:@"1" forKey:dic[@"MD5"]];
            [btn bk_whenTapped:^{
                [jc dismissWithCompletion:^{
                    
                    
                }];
                
            }];
            
        }
        
    }
    
    [self renoti];
    
    
    if (self.circleId) {
        
        _mytableview.frame = CGRectMake(0, 0, ScreenW, self.view.height+30);
        
        [self.navigationController.navigationBar setTranslucent:YES];
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
        //    [self.navigationController.navigationBar setTranslucent:YES];
        // [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
        if (IOS11) {
            [self.navigationController.navigationBar
             setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:38/255.0 green:137/255.0 blue:247/255.0 alpha:0]] forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar
             setShadowImage:[UIImage new]];
        }
        
    }
    
    if (self.dataArr.count>0&&!self.reloadcell) {
        return;
    }
    
    [self.mytableview.tableHeaderView removeAllSubviews];
    for (UIView*v in self.view.subviews) {
        if (![v isKindOfClass:[UITableView class]]) {
            [v removeFromSuperview];
        }
    }
    UIImageView* im = [UIImageView new];
    im.size = CGSizeMake(55, 55);
    [im setImage:[UIImage imageNamed: @"发表动态"]];
    im.userInteractionEnabled = YES;
    [im sizeToFit];
    im.right = ScreenW-27;
    CGFloat h = 57;
    if (IPAD_DEVICE) {
        h = 57;
    }
    //    BOOL isPhoneX = NO;
    if (@available(iOS 11.0, *)) {\
        //      isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            
            h = 49+34+20;
        }else{
            h = 64;
        }
    }
    im.bottom = YYScreenSize().height-35-WRTabbarHeight-h;
    if (self.circleId) {
        im.bottom = YYScreenSize().height-35-WRTabbarHeight;
    }
    [self.view addSubview:im];
    
    
    [im bk_whenTapped:^{
        [MobClick event:@"sqfbdt"];
        FriendSendController * feevc= [FriendSendController new];
        feevc.hidesBottomBarWhenPushed = YES;
        feevc.iffriend = YES;
        feevc.crid = [NSString stringWithFormat:@"%@",self.circleId];
        [self.navigationController pushViewController:feevc animated:YES];
    }];
    [self.send removeFromSuperview];
    self.send = im;
    
    UIImage* image = [UIImage imageNamed:@"通知消息"];
    UIButton*  buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRight setImage:image forState:0];
    buttonRight.imageView.contentMode = UIViewContentModeScaleAspectFill;
    buttonRight.frame = CGRectMake(0, 0, 20, 10);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    if (self.circleId) {
        UIButton* btn = [UIButton new];
        btn.frame = CGRectMake(0, YYScreenSize().height-50, ScreenW, 50);
        btn.backgroundColor = [UIColor wr_themeColor];
        [btn setTitle:@"加入圈子" forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.view addSubview:btn];
        btn.hidden = self.IsJoin;
        [self.joinBtn removeFromSuperview];
        self.joinBtn = btn;
        if (self.IsJoin) {
            self.mytableview.height = YYScreenSize().height;
        }
        
        [buttonRight setImage:[UIImage imageNamed:@"圈子详情"] forState:0];
        
        
        [buttonRight bk_whenTapped:^{
            UIAlertController* al = [UIAlertController alertControllerWithTitle:@"更多" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction* act1 = [UIAlertAction actionWithTitle:@"圈子详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                CircleDetailController* cv = [CircleDetailController new];
                cv.hidesBottomBarWhenPushed = YES;
                cv.circleId = self.circleId;
                [self.navigationController pushViewController:cv animated:YES];
                
                
            }];
            NSString * ti = self.IsJoin?@"退出圈子":@"加入圈子";
            UIAlertAction* act2 = [UIAlertAction actionWithTitle:ti style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.viewModel joinCircle:self.circleId isJoin:self.IsJoin?@"0":@"1" Completion:^(NSError * error) {
                    if (!error) {
                        [AppDelegate show:self.IsJoin?@"退出圈子成功":@"加入圈子成功"];
                        btn.hidden = !self.IsJoin;
                        if (btn.hidden) {
                            self.mytableview.height = YYScreenSize().height;
                        }else
                        {
                            self.mytableview.height = YYScreenSize().height-btn.height;
                        }
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadCom" object:nil];
                    }else
                    {
                        [AppDelegate show:error.domain];
                    }
                }];
            }];
            [al addAction:act1];
            [al addAction:act2];
            UIPopoverPresentationController *popover = al.popoverPresentationController;
            
            if (popover) {
                
                popover.sourceView = buttonRight;
                popover.sourceRect = buttonRight.bounds;
                popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
            }
            
            
            
            
            [self presentViewController:al animated:YES completion:^{
                
            }];
            
        }];
        
        [btn bk_whenTapped:^{
            [self.viewModel joinCircle:self.circleId isJoin:@"1" Completion:^(NSError * error) {
                if (!error) {
                    [AppDelegate show:@"加入圈子成功"];
                    btn.hidden = YES;
                    if (btn.hidden) {
                        self.mytableview.height = YYScreenSize().height;
                    }else
                    {
                        self.mytableview.height = YYScreenSize().height-btn.height;
                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadCom" object:nil];
                    if (self.circleId) {
                        switch ([self.circleId intValue]) {
                            case 6:
                                [MobClick event:@"sqjrytqz"];
                                break;
                            case 7:
                                [MobClick event:@"sqjrjzbqz"];
                                break;
                            case 8:
                                [MobClick event:@"sqjrxgqz"];
                                break;
                            case 9:
                                [MobClick event:@"sqappjyqz"];
                                break;
                                
                            default:
                                break;
                        }
                    }
                    
                }else
                {
                    [AppDelegate show:error.domain];
                }
            }];
        }];
        
        
        
    }
    else
    {
        [buttonRight bk_whenTapped:^{
            [MobClick event:@"sqtz"];
            ComMessageController* message = [ComMessageController new];
            message.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:message animated:YES];
            
        }];
    }
    
    
    
    
    _mytableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 95)];
    if (!self.circleId&&!self.isSelf) {
        [self.viewModel getBannerCompletion:^(NSError * error) {
            _bannerarr = [self.viewModel.bannerArr mutableCopy];
            if (_bannerarr.count>0) {
                [self addPagerView];
                [self addPageControl];
                [self.pagerView reloadData];
            }
            
            [self addSegmentView];
            [self.view bringSubviewToFront:im];
            
        }];
        
        
    }
    else if (self.circleId)
    {
        [self addCircleView];
        
        
    }
    else if (self.isSelf)
    {
        self.mytableview.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0.5)];
        [self reload];
    }
    
    [self.view bringSubviewToFront:im];
}
- (void)reload
{
    self.page = 1;
    self.reloadcell = NO;
    if (!self.circleId&&!self.isSelf) {
        
        
        [self.viewModel getarticleSort:self.sort page:1 rows:10 circleId:@"" isown:@"0" articleId:@"" Completion:^(NSError * error) {
            if (self.viewModel.articleArr.count>0) {
                self.dataArr = self.viewModel.articleArr;
                
                [self.mytableview reloadData];
                [self.mytableview.mj_header endRefreshing];
            }
           
            
        }];
    }
    else if (self.circleId)
    {
        
        [self.viewModel getarticleSort:self.sort page:1 rows:10 circleId:self.circleId isown:@"0" articleId:@"" Completion:^(NSError * error) {
            if (self.viewModel.articleArr.count>0) {
            self.dataArr = self.viewModel.articleArr;
            [self.mytableview reloadData];
            [self.mytableview.mj_header endRefreshing];
            }
        }];
    }
    else if (self.isSelf)
    {
        [self.viewModel getarticleSort:self.sort page:1 rows:10 circleId:@"" isown:@"true" articleId:@"" Completion:^(NSError * error) {
            if (self.viewModel.articleArr.count>0) {
            self.dataArr = self.viewModel.articleArr;
            [self.mytableview reloadData];
            [self.mytableview.mj_header endRefreshing];
            }
        }];
    }
}
- (void)loadAdd
{
    if (!self.circleId&&!self.isSelf) {
        
        
        [self.viewModel getarticleSort:self.sort page:++self.page rows:10 circleId:@"" isown:@"0" articleId:@"" Completion:^(NSError * error) {
            [self.dataArr  addObjectsFromArray:self.viewModel.articleArr.copy];
            if (self.viewModel.articleArr.count>0) {
                [self.mytableview reloadData];
            }
            [self.mytableview.mj_footer endRefreshing];
        }];
    }
    else if (self.circleId)
    {
        
        [self.viewModel getarticleSort:self.sort page:++self.page rows:10 circleId:self.circleId isown:@"0" articleId:@"" Completion:^(NSError * error) {
            [self.dataArr  addObjectsFromArray:self.viewModel.articleArr.copy];
            if (self.viewModel.articleArr.count>0) {
                [self.mytableview reloadData];
            }
            [self.mytableview.mj_footer endRefreshing];
        }];
    }
    else if (self.isSelf)
    {
        [self.viewModel getarticleSort:self.sort page:++self.page rows:10 circleId:@"" isown:@"true" articleId:@"" Completion:^(NSError * error) {
            [self.dataArr  addObjectsFromArray:self.viewModel.articleArr.copy];
            if (self.viewModel.articleArr.count>0) {
                [self.mytableview reloadData];
            }
            
            [self.mytableview.mj_footer endRefreshing];
            
        }];
    }
}

- (void)addSegmentView
{
    
    [self.viewModel getCirclesCompletion:^(NSError * error, NSArray *crArry) {
        CircleController* c1 = [CircleController new];
        c1.viewModel = self.viewModel;
        CircleController* c2 = [CircleController new];
        c2.viewModel = self.viewModel;
        c2.isSelf = YES;
        
        NSArray* names = @[@"推荐圈子",@"我的圈子"];
        NSArray* controllers = @[c1,c2];
        
        ZXSegmentController* segmentController = [[ZXSegmentController alloc] initWithControllers:controllers
                                                                                   withTitleNames:names
                                                                                 withDefaultIndex:0
                                                                                   withTitleColor:[UIColor colorWithHexString:@"#333333"]
                                                                           withTitleSelectedColor:[UIColor colorWithHexString:@"#333333"]
                                                                                  withSliderColor:[UIColor wr_themeColor]];
        [self addChildViewController:segmentController];
        
        
        
        [self.mytableview.tableHeaderView addSubview:segmentController.view];
        
        self.mytableview.tableHeaderView.height = 346+45+10;
        [c1 viewWillAppear:YES];
        
        [segmentController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(67+68);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(190);
        }];
        
        UIView* line = [UIView new];
        line.x = 0;
        line.y = 67+68+199;
        line.width = ScreenW;
        line.height = 10;
        line.backgroundColor = [UIColor wr_lineColor];
        [self.mytableview.tableHeaderView addSubview:line];
        [_cloud  removeFromSuperview];
        _cloud = nil;
        UIView* cloud = [UIView new];
        cloud.x = 0;
        cloud.y = 67+68+199+10;
        cloud.width = ScreenW;
        cloud.height = 45;
        cloud.backgroundColor = [UIColor whiteColor];
        cloud.layer.borderColor = [UIColor wr_lineColor].CGColor;
        cloud.layer.borderWidth = 0.5;
        [self.view addSubview:cloud];
        _cloud = cloud;
        [self.view bringSubviewToFront:self.send];
        
        UILabel* la = [UILabel new];
        la.text = @"社区动态";
        la.font = [UIFont systemFontOfSize:WRTitleFont];
        la.textColor = [UIColor wr_titleTextColor];
        la.x=15;
        [la sizeToFit];
        la.centerY = 45*1.0/2;
        [cloud addSubview:la];
        
        JJOptionView* op = [[JJOptionView alloc]init];
        op.width = 100;
        op.height = 15;
        op.right =ScreenW- 15;
        op.centerY = 45*1.0/2;
        op.titleFontSize = 14;
        op.borderColor = [UIColor clearColor];
        op.title = @"全部";
        op.dataSource = @[@"全部",@"热门",@"我的圈子"];
        op.selectedBlock = ^(JJOptionView * _Nonnull optionView, NSInteger selectedIndex) {
            switch (selectedIndex) {
                case 0:
                    self.sort = @"";
                    break;
                case 1:
                    self.sort = @"hot";
                    break;
                case 2:
                    self.sort = @"user";
                    break;
                    
                default:
                    break;
            }
            [self reload];
            [MobClick event:@"sqqb"];
        };
        [self reload];
        [cloud addSubview:op];
    }];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    if ([self.mytableview isEqual:scrollView]) {
        _cloud.y = 67+68+199+10-scrollView.contentOffset.y<0?0:67+68+199+10-scrollView.contentOffset.y;
    }
   
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //获取可见范围内的cell的数组，如果这个Cell没有数据就去加载数据
  
}

- (void)addCircleView
{
    [self.viewModel  getCircleDetail:self.circleId Completion:^(NSError * error ) {
        
        UIView* bac = [[UIView alloc]initWithFrame:CGRectMake(0, -20, ScreenW, 180)];
        if (iPhone5) {
            bac.y=-64;
            self.mytableview.tableHeaderView.height = 180+44;
        }else
        {
            self.mytableview.tableHeaderView.height = 180;
        }
        
        [self.mytableview.tableHeaderView addSubview:bac];
        
        UIImageView* im = [UIImageView new];
        im.frame = bac.bounds;
        [im setImageWithURL:[NSURL URLWithString:self.viewModel.circle.background]];
        [bac addSubview:im];
        UILabel* title = [UILabel new];
        title.x = 16;
        title.y = 110;
        title.text = self.viewModel.circle.name;
        title.font = [UIFont boldSystemFontOfSize:18];
        title.textColor = [UIColor whiteColor];
        [title sizeToFit];
        
        UILabel* detail = [UILabel new];
        detail.x = 16;
        detail.y = title.bottom+15;
        detail.text = [NSString stringWithFormat:@"成员%ld人     动态%ld条",self.viewModel.circle.usercnt,self.viewModel.circle.articlecnt];
        detail.textColor = [UIColor whiteColor];
        detail.font = [UIFont systemFontOfSize:WRDetailFont];
        [detail sizeToFit];
        [bac addSubview:title];
        [bac addSubview:detail];
        // self.joinBtn.hidden = self.viewModel.circle.isJoin;
        [self reload];
        
        
    }];
}
- (void)addPagerView {
    if (!_pagerView) {
        TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
        pagerView.frame = CGRectMake(0, -15, ScreenW, (ScreenW-27*2)*100.0/332+30);
        //pagerView.layer.borderWidth = 1;
        pagerView.isInfiniteLoop = YES;
        pagerView.autoScrollInterval = 4.0;
        pagerView.dataSource = self;
        pagerView.delegate = self;
        
        
        // registerClass or registerNib
        [pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
        [_pagerView removeFromSuperview];
        _pagerView =nil;
        [self.mytableview.tableHeaderView addSubview:pagerView];
        _pagerView = pagerView;
    }
    [_pagerView removeFromSuperview];
    [self.mytableview.tableHeaderView addSubview:_pagerView];
    
}
- (void)addPageControl {
    
    _pageControl = [[EllipsePageControl alloc] initWithFrame:CGRectMake(0, (ScreenW-27*2)*100.0/332+30-15,ScreenW,15)];
    _pageControl.numberOfPages = self.bannerarr.count;
    _pageControl.otherColor=[[UIColor colorWithHexString:@"#4bb7fa"]colorWithAlphaComponent:0.3];
    _pageControl.currentColor=[UIColor colorWithHexString:@"#4bb7fa"];
    _pageControl.delegate=self;
    _pageControl.tag=8888;
    for (UIView* v in self.mytableview.tableHeaderView.subviews) {
        if ([v isKindOfClass:[EllipsePageControl class]]) {
            [v removeFromSuperview];
        }
    }
    [self.mytableview.tableHeaderView addSubview:_pageControl];
    
    
}
-(void)ellipsePageControlClick:(EllipsePageControl *)pageControl index:(NSInteger)clickIndex{
    [_pagerView scrollToItemAtIndex:index animate:YES];
}

#pragma mark - TYCyclePagerViewDataSource
- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return _bannerarr.count;
}
- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
    layout.itemSize = CGSizeMake(ScreenW-27*2, (ScreenW-27*2)*100.0/332);
    layout.itemSpacing = 10;
    layout.minimumScale = 0.9;
    layout.layoutType = TYCyclePagerTransformLayoutLinear;
    layout.itemHorizontalCenter = YES;
    
    return layout;
}
- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [_pageControl setCurrentPage:toIndex];
    TYCyclePagerViewCell *fromcell = [pageView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:toIndex];
    
    
    
    
    
    TYCyclePagerViewCell *oldcell = [pageView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:fromIndex];
    
    
    //shadowLayer0.shadowColor = [UIColor clearColor].CGColor;
    //[oldcell.layer addSublayer:shadowLayer0];
    
    
    
    //[_pageControl setCurrentPage:newIndex animate:YES];
    TYCyclePagerViewCell *cell  = [pageView curIndexCell];
    //    [cell.im setImageWithURL:[NSURL URLWithString:ba.imageUrl] placeholder:nil];
    
//    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
}
- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{
    WRBanner* ba = _bannerarr[index];
    TYCyclePagerViewCell *fromcell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
    fromcell.layer.cornerRadius = 5;
    fromcell.layer.masksToBounds = NO;
 
    
   
    
    
    fromcell.layer.shadowOffset = CGSizeMake(0, 5);
    fromcell.layer.shadowOpacity = 0.8;
    fromcell.layer.shadowColor = [UIColor colorWithHexString:@"85abd9ff"].CGColor;
    
//    [_pageControl setCurrentPage:newIndex animate:YES];
    fromcell.imageV.contentMode = UIViewContentModeScaleToFill;
    [fromcell.imageV setImageWithURL:[NSURL URLWithString:ba.imageUrl] placeholder:[UIImage imageNamed:@"16：9banner"]];
    
    return fromcell;
}
-(void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
{
    [MobClick event:@"sqbanner"];
    WRBanner* ba = _bannerarr[index];
    if (ba.type==14) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在获取数据", nil)];
        [self.viewModel getarticleSort:@"" page:1 rows:10 circleId:@"" isown:@"" articleId:ba.dynamic_id Completion:^(NSError * error) {
            if(self.viewModel.articleArr.count>0){
                CommutiDetailController* detail = [CommutiDetailController new];
                detail.article = self.viewModel.articleArr[0];
                detail.UUID = ba.dynamic_id;
                detail.hidesBottomBarWhenPushed = YES;
                [SVProgressHUD dismiss];
                [self.navigationController pushViewController:detail animated:YES];
            }
        }];
        
    }
    else if (ba.type==15)
    {
        ArticleDetailController* art = [[ArticleDetailController alloc]init];
        WRArticle* ar = [WRArticle new];
        ar.uuid = ba.dynamic_id;
        art.currentNews = ar;
        ar.contentUrl = ba.url;
        art.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:art animated:YES];
    }
    else if (ba.type==16)
    {
        WrWebViewController* web = [WrWebViewController new];
        web.url = ba.url;
        web.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:web animated:YES];
    }
    [pageView scrollToItemAtIndex:index animate:YES];
}
-(void)pagerViewDidScroll:(TYCyclePagerView *)pageView
{
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
// 允许长按菜单
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
        
        return YES;
 
}
// 点击指定的cell 出现Menu菜单
- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
   
            
            return YES;
 
}
// 执行复制操作
- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    
        if (action == @selector(copy:)) {
             ZJMasonryAutolayoutCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard]; // 粘贴板
            [pasteBoard setString:cell.contentLab.text];
        }
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRCOMArticle * f = self.dataArr[indexPath.row];


    //模拟数据变动
//    YSWFrendCell* cell = [self.mytableview dequeueReusableCellWithIdentifier:@"Friend"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    NSMutableArray* arr = [NSMutableArray array];
//    [cell.zan bk_whenTapped:^{
//        [self.viewModel upvoteArticle:f.uuid Completion:^(NSError * error) {
//            if (!error) {
//                if (!f.isupvote) {
//                    [cell.zan setImage:[UIImage imageNamed:@"点赞效果-1"
//                                        ]forState:0];
//
//                    [cell.zan setTitle:[NSString stringWithFormat:@"%d",f.upvote+1] forState:0];
//                }
//
//
//            }
//
//        }];
//    }];
//
//    [cell loadcellWith:f];
//
//    return cell;

    
    ZJMasonryAutolayoutCell *cell = [tableView dequeueReusableCellWithIdentifier:kMasonryCell];
    [self configureCell:cell atIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.zan.tag = indexPath.row;
    cell.ping.tag = indexPath.row;
    cell.weakSelf = self;
   
//    [cell.zan bk_whenTapped:^{
//                [self.viewModel upvoteArticle:f.uuid Completion:^(NSError * error) {
//                    if (!error) {
//                        if (!f.isupvote) {
//                            [cell.zan setImage:[UIImage imageNamed:@"点赞效果-1"
//                                                ]forState:0];
//
//                            [cell.zan setTitle:[NSString stringWithFormat:@"%ld",f.upvote+1] forState:0];
//                        }
//
//
//                    }
//
//                }];
//    }];
    cell.block = ^(NSInteger index) {
        WRCOMArticle * model = self.dataArr[index];
        [self.viewModel upvoteArticle:model.uuid Completion:^(NSError * error) {
                                if (!error) {
                                    if (!model.isupvote) {
                                        [cell.zan setImage:[UIImage imageNamed:@"点赞效果-1"
                                                            ]forState:0];
                                        model.isupvote = YES;
                                        [cell.zan setTitle:[NSString stringWithFormat:@"%ld",model.upvote+1] forState:0];
                                    }
                                    
//                                    else
//                                    {
//                                        
//                                        [cell.zan setImage:[UIImage imageNamed:@"点赞-1"
//                                                            ]forState:0];
//                                        
//                                        [cell.zan setTitle:[NSString stringWithFormat:@"%ld",model.upvote-1] forState:0];
//                                    }
            
            
                                }
            
                            }];
        
        
        
    };
    cell.pingblock = ^(NSInteger index) {
        WRCOMArticle* friend = self.dataArr[index];
        CommutiDetailController* pushVc = [CommutiDetailController new];
        
        pushVc.article = friend;
        pushVc.UUID = friend.uuid;
        pushVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pushVc animated:YES];
    };

    return cell;
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{


    
    // 计算缓存cell的高度
    return [self.mytableview fd_heightForCellWithIdentifier:kMasonryCell cacheByIndexPath:indexPath configuration:^(ZJMasonryAutolayoutCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
       
    }];


}
#pragma mark - 给cell赋值
- (void)configureCell:(ZJMasonryAutolayoutCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
//        cell.fd_enforceFrameLayout = NO;
    cell.model = self.dataArr[indexPath.row];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"sqdt"];
    if (self.circleId) {
        switch ([self.circleId intValue]) {
            case 6:
                [MobClick event:@"sqgdbytj"];
                break;
            case 7:
                [MobClick event:@"sqjzbjlq"];
                break;
            case 8:
                [MobClick event:@"sqbpbwdxg"];
                break;
            case 9:
                [MobClick event:@"sqsyjyjlq"];
                break;
                
            default:
                break;
        }
    }
    
    WRCOMArticle* friend = self.dataArr[indexPath.row];
    CommutiDetailController* pushVc = [CommutiDetailController new];
    
    pushVc.article = friend;
    pushVc.UUID = friend.uuid;
    pushVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pushVc animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.isSelf) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRCOMArticle* friend = self.dataArr[indexPath.row];
    [self.viewModel deletArticle:friend.uuid Completion:^(NSError * error)  {
        if (error) {
            [AppDelegate show:error.domain];
        }
        else
        {
          
            [AppDelegate show:@"删除成功"];
            
            [self reload];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"reload" object:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
    
    [[SDWebImageManager sharedManager] cancelAll];
    
    [[SDImageCache sharedImageCache] clearDisk];
    
}


@end
