//
//  ArticleListController.m
//  rehab
//
//  Created by herson on 6/3/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "CateArticleListController.h"
#import "ArticleListViewModel.h"
#import "ArticleCell.h"
#import "FAQListController.h"
#import "ArticleDetailController.h"
//#import <SVPullToRefresh/SVPullToRefresh.h>
#import "UMengUtils.h"
#import "ShareUserData.h"
#import "WRRefreshHeader.h"
#import "WRFAQViewModel.h"
#import "MTFooter.h"
#import "ShareData.h"
#import "JKScrollFocus.h"
#import "ArticleListController.h"
#import "ChallengeController.h"
#import "WRTestBaseViewController.h"
#import "WELLController.h"
#import "CaseController.h"
#import "ChallengeController.h"
#import "SearchViewController.h"
#import "UIButton+WR.h"
#import <YYKit/YYKit.h>
#import "ChatViewController.h"
#import "LoginViewController.h"
#import "AskImIndexController.h"
#import "WrWebViewController.h"
@interface CateArticleListController ()<UISearchBarDelegate>
{
    UIView *_lastBubbleView;
    
    NSMutableArray *_searchResultArray;
    
    NSDate *_startDate;
    UISearchBar* mySearchBar;
}
@property(nonatomic) NSMutableArray *dataList;
@property(nonatomic)ArticleListViewModel *viewModel;
@property(nonatomic, copy)NSString *keyword;
@property(nonatomic)BOOL loadDataflag;
@property(nonatomic)NSMutableDictionary* datadic;
@property(nonatomic)JKScrollFocus* headerScroll;


@end

@implementation CateArticleListController

-(void)dealloc
{
    
    
    
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    NSString *name = (self.category ? _category.name : NSLocalizedString(@"推荐", nil));
//    [UMengUtils careForArticleCategory:name duration:duration];
    [UMengUtils careForDiscoverCategory:name duration:duration];
}

-(instancetype)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
        _startDate = [NSDate date];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        CGFloat h = 181+87;
        if (IPAD_DEVICE) {
            h = ScreenW*181*1.0/375+87;
        }
        self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, h)];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
        
        self.tableView.tableFooterView = [UIView new];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.rowHeight = [ArticleCell defaultHeightWithTableView:self.tableView];
        
        [WRNetworkService pwiki:@"资讯列表"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    UIImage *holder = [UIImage imageNamed:@"well_default_video"];
    if (!self.headerScroll) {
        [WRViewModel getBannerCompletion:^(NSError *error ) {
            CGFloat h = 181;
            if (IPAD_DEVICE) {
                h = ScreenW*181*1.0/375;
            }
            JKScrollFocus *scroller  = [[JKScrollFocus alloc] initWithFrame:CGRectMake(0, 0, self.view.width, h)];
            [self.tableView.tableHeaderView addSubview:scroller];
            scroller.items =[ShareData data].bannerArray;
            scroller.autoScroll = YES;
            
            [scroller downloadJKScrollFocusItem:^(id item, UIImageView *currentImageView) {
                WRBannerInfo *object = item;
                [currentImageView setImageWithUrlString:object.imageUrl holderImage:holder];
                
                currentImageView.contentMode = UIViewContentModeScaleAspectFill;
            }];
            [scroller titleForJKScrollFocusItem:^NSString *(id item, UILabel *currentLabel) {
                WRBannerInfo *object = item;
                return object.title;
            }];
            [scroller didSelectJKScrollFocusItem:^(id item, NSInteger index) {
                
                WRBannerInfo *object = item;
                [self actionWithType:object.type data:object.extraData];
                //锚点
                
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"fxbanner"] attributes:nil counter:duration];
                [UMengUtils careForBannerHome:object.title];
                
                
            }];
            
            self.headerScroll = scroller;
            __weak __typeof__(self) weakSelf = self;
            UIButton* challengBtn = [UIButton new];
            challengBtn.y = h+WRUIBigOffset;
            [challengBtn setBackgroundImage:[UIImage imageNamed:@"挑战"] forState:0];
            challengBtn.width = 25;
            challengBtn.height = 23;
            challengBtn.centerX = (self.view.width-59*2)/2*0+59;
            
            [self.tableView.tableHeaderView addSubview:challengBtn];
            [[challengBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                ChallengeController * base = [ChallengeController new];
                
                base.hidesBottomBarWhenPushed = YES;
                [ weakSelf.navigationController pushViewController:base animated:YES];
                //锚点
                
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"fxtz"] attributes:nil counter:duration];
                
            }];
            UILabel* label = [UILabel new];
            label.text =@"挑战";
            label.font = [UIFont systemFontOfSize:WRDetailFont];
            [label sizeToFit];
            label.textColor = [UIColor darkTextColor];
            label.y =challengBtn.bottom+12;
            label.centerX =challengBtn.centerX;
            [self.tableView.tableHeaderView addSubview:label];
            
            
            UIButton* listBtn = [UIButton new];
            listBtn.y = h+WRUIBigOffset;
            [listBtn setBackgroundImage:[UIImage imageNamed:@"案例"] forState:0];
            listBtn.width = 25;
            listBtn.height = 23;
            listBtn.centerX = (self.view.width-59*2)/2*1+59;
            [self.tableView.tableHeaderView addSubview:listBtn];
            [[listBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                CaseController * base = [CaseController new];
                
                base.hidesBottomBarWhenPushed = YES;
                [ weakSelf.navigationController pushViewController:base animated:YES];
                //锚点
                
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"fxal"] attributes:nil counter:duration];
                
                [MobClick event:@"anli" attributes:nil counter:duration];
                
            }];
            UILabel* listBtnlabel = [UILabel new];
            listBtnlabel.text =@"案例";
            listBtnlabel.font = [UIFont systemFontOfSize:WRDetailFont];
            [listBtnlabel sizeToFit];
            listBtnlabel.textColor = [UIColor darkTextColor];
            listBtnlabel.y =listBtn.bottom+12;
            listBtnlabel.centerX =listBtn.centerX;
            [self.tableView.tableHeaderView addSubview:listBtnlabel];
            
            
            
            UIButton* testBtn = [UIButton new];
            testBtn.y = h+WRUIBigOffset;
            [testBtn setBackgroundImage:[UIImage imageNamed:@"测试"] forState:0];
            testBtn.width = 25;
            testBtn.height = 23;
            testBtn.centerX =(self.view.width-59*2)/3*2+59;
       //    [self.tableView.tableHeaderView addSubview:testBtn];
            [[testBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                WrWebViewController *chatController = nil;
                //            chatController = [[ChatViewController alloc] initWithConversationChatter:@"rudy123" conversationType:0];
                chatController = [[WrWebViewController alloc]init];
                chatController.hidesBottomBarWhenPushed =YES;
                chatController.url =[NSString stringWithFormat:@"http://192.168.11.69/serve/sever.html"];
                
                
                [weakSelf.navigationController pushViewController:chatController animated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
                
            }];
            
            
            UILabel* testlabel = [UILabel new];
            testlabel.text =@"测试";
            testlabel.font = [UIFont systemFontOfSize:WRDetailFont];
            [testlabel sizeToFit];
            testlabel.textColor = [UIColor darkTextColor];
            testlabel.y = testBtn.bottom+12;
            testlabel.centerX =testBtn.centerX;
            //        [self.tableView.tableHeaderView addSubview:testlabel];
            
            
            UIButton* presonBtn = [UIButton new];
            presonBtn.y = h+WRUIBigOffset;
            [presonBtn setBackgroundImage:[UIImage imageNamed:@"专家"] forState:0];
            presonBtn.width = 25;
            presonBtn.height = 23;
            presonBtn.centerX = (self.view.width-59*2)/2*2+59;
            [self.tableView.tableHeaderView addSubview:presonBtn];
            
            UILabel* presonlabel = [UILabel new];
            presonlabel.text =@"专家";
            presonlabel.font = [UIFont systemFontOfSize:WRDetailFont];
            [presonlabel sizeToFit];
            presonlabel.textColor = [UIColor darkTextColor];
            presonlabel.y =presonBtn.bottom+12;
            presonlabel.centerX =presonBtn.centerX;
            [self.tableView.tableHeaderView addSubview:presonlabel];
            [[presonBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                WELLController* well = [WELLController new];
                well.hidesBottomBarWhenPushed =YES;
                [self.navigationController pushViewController:well animated:YES];
                //锚点
                
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"fxzj"] attributes:nil counter:duration];
            }];
            
            
            
            
            UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, h+87-5, self.view.width, 5)];
            line.backgroundColor = [UIColor wr_lineColor];
            [self.tableView.tableHeaderView addSubview:line];
            

        }];
       
       
    }
    
    
    
    
    i=0;
    
    
    
    //    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
}

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
            [self presentProTreatRehabWithDisease:disease stage:0 upgrade:@"0"];
            break;
        }
            
        case BannerActionTypeArticle: {
            WRArticle *object = data;
            ArticleDetailController *viewController = [[ArticleDetailController alloc] init];
            
            viewController.currentNews = object;
            viewController.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:viewController animated:YES];
            
            break;
        }
        case 6:
        {
            NSString* url = data[@"url"];
            if ([url isKindOfClass:[NSString class]]) {
                WrWebViewController* web = [WRWebViewController new];
                web.url = url;
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
            }
            break;
        }
            
        default:{
            break;
        }
    }
}


-(void)viewWillDisappear:(BOOL)animated
{
//    [self clear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor wr_themeColor];
    self.datadic = [NSMutableDictionary dictionary];
    self.dataList = [NSMutableArray array];
    self.viewModel = [ArticleListViewModel new];
//    [self loadData];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate&Source
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 67;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 103;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.view.width, 67)];
    //创建一个视图
    WRCategory* cate = [ShareData data].categoryArray[section];
    NSLog(@"----%@",[ShareData data].categoryArray);
    UIImageView* im = [UIImageView new];
    im.x =0;
    
    im.image = [UIImage imageNamed:cate.name];
    im.width =101;
    im.height =35;
    im.centerY = headerView.centerY;
    [headerView addSubview:im];
    
    UIImageView* next = [UIImageView new ];
    [next setImage:[UIImage imageNamed:@"更多图标"]];
    next.x = self.view.width - WRNextWeight -15;
    next.width  = WRNextWeight;
    next.height = WRNextHeight;
    next.centerY = headerView.centerY;
    [headerView addSubview:next];
    
    
    UILabel* la = [UILabel new ];
    la.x =15;
    la.text = cate.name;
    la.font = [UIFont systemFontOfSize:WRDetailFont];
    [la sizeToFit];
    la.textColor = [UIColor whiteColor];
    
    la.centerY = headerView.centerY;
    la.centerX = im.centerX;
    [headerView addSubview:la];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UIButton* button = [[UIButton alloc]initWithFrame:headerView.bounds];
    [headerView addSubview:button];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        ArticleListController* artcleList = [ArticleListController new];
        artcleList.hidesBottomBarWhenPushed =YES;
        artcleList.category = cate;
        artcleList.title = cate.name;
        [self.navigationController pushViewController:artcleList animated:YES];
        
        NSDate *now = [NSDate date];
        int duration = (int)[now timeIntervalSinceDate:_startDate];
        NSString* Id = [cate.typeID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [MobClick event:[NSString stringWithFormat:@"%@",Id] attributes:nil counter:duration];
        
    }];
    
    
    
    
    return headerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [ShareData data].categoryArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WRCategory* cate = [ShareData data].categoryArray[section];
//    NSLog(@"=====+++%@",cate);
//    NSMutableArray* arry = [self.datadic allKeysForObject:cate.indexId];
//    NSArray*  arr;
//    if (arry.count>0) {
//        arr = [arry[0]mutableCopy];
//    }
//
    
    return cate.wtArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"new"];
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"new"];
    }
    
        WRCategory* cate = [ShareData data].categoryArray[indexPath.section];
//        NSMutableArray* arry = [self.datadic allKeysForObject:cate.indexId];
//        if(arry.count==1)
//        {
//          NSArray*  arr= arry[0];
//            if (arr.count>0) {
                WRArticle *object = cate.wtArray[indexPath.row];
                [cell setContent:object];
                cell.titleLabel.textColor = [[ShareUserData userData].redArticleArray containsObject:object.uuid]?[UIColor lightGrayColor]:[UIColor blackColor];
//            }
    
//        }
    
    
    
//    cell.badgeView.hidden = [[ShareUserData userData].redArticleArray containsObject:object.uuid];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WRCategory* cate = [ShareData data].categoryArray[indexPath.section];
//    NSMutableArray* arry = [self.datadic allKeysForObject:cate.indexId][0];
    WRArticle *object = cate.wtArray[indexPath.row];
//    WRArticle *object = arry[indexPath.row];
    if (self.isRecommand) {
            [UMengUtils careForDiscoverRecommendArticle:object.title];
    }
    [[ShareUserData userData].redArticleArray addObject:object.uuid];
    [[ShareUserData userData] save];
    object.viewCount++;
    
    ArticleDetailController *viewController = [[ArticleDetailController alloc] init];
    [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.currentNews = object;
    [(self.rootController ? self.rootController : self).navigationController pushViewController:viewController animated:YES];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    //锚点
    
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    NSString* Id = [cate.typeID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    [MobClick event:[NSString stringWithFormat:@"%@",Id] attributes:nil counter:duration];
}

#pragma mark - Event
-(IBAction)onClickedRightBarButtonItem:(UIBarButtonItem*)sender {
    UIViewController *viewController = [[FAQListController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.title = sender.title;
}


#pragma mark - Getter & Setter





#pragma mark -
-(void)clear {
    [self.datadic removeAllObjects];
    i=0;
}

-(void)reloadData {
//    __weak __typeof(self)weakself = self;
//    if (!self.tableView.mj_footer) {
//        self.tableView.mj_footer = [MTFooter footerWithRefreshingBlock:^{
//            [weakself loadData];
//        }];
//    }
    [self.tableView reloadData];
}
static int i;
-(void)loadData {
    
    __weak __typeof(self) weakSelf = self;
    
    self.viewModel.pageNOPublic = 2;
//    self.datadic;
//    self.dataList;
    WRCategory * cate = [ShareData data].categoryArray[i];
//        [self.viewModel fetchNewsIndexcompletion:^(NSError * _Nonnull error)
//        {
//            if (error) {
//                NSLog(@"%@", error.debugDescription);
//            } else {
//
//                NSArray* articleArr = weakSelf.viewModel.dataArray;
//                for (WRCategory* cate in [ShareData data].categoryArray ) {
//                    if (![cate.name isEqualToString:@"案例"]&&![[self.datadic allValues ] containsObject:cate.indexId]) {
//                        NSMutableArray* arr = [NSMutableArray array];
//                        for (WRArticle* atr in articleArr) {
//                            if ([atr.typeId isEqualToString:cate.indexId]) {
//                                [arr addObject:atr];
//                            }
//
//                        }
//                        [self.datadic setObject:cate.indexId forKey:arr];
//                    }
//                }
    
//                [self.tableView reloadData];
    
                
                
                
                
                
                
//            }
            //        [weakSelf.tableView setShowsInfiniteScrolling:!weakSelf.viewModel.isLastPage];
            
//        }];


    
}

//-(void)onRefresh
//{
//    [self.viewModel clearData];
//    [self.tableView reloadData];
////    [self loadData];
//}

@end
