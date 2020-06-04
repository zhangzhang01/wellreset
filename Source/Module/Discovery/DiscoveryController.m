//
//  DiscoveryController.m
//  rehab
//
//  Created by herson on 6/15/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "DiscoveryController.h"
#import <YYKit/YYKit.h>
#import "WRRefreshHeader.h"
#import "GuideView.h"
#import "WRView.h"
#import "AutoScrollHeaderView.h"
#import "DDChannelCell.h"
#import "ShareData.h"
#import "AbuSearchView.h"
#import "ArticleCategoryController.h"
#import "MasterTeamController.h"
#import "ArticleDetailController.h"
#import "CateArticleListController.h"
#import "ChallengeController.h"
#import "SearchViewController.h"
#define recomment_key @"recomment"

@interface DiscoveryController ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UISearchBarDelegate,AbuSearchViewDelegate>
{
    BOOL _loadDataFlag;
    AutoScrollHeaderView *_headerView;
    UICollectionView *_mainCollectionView;
    NSDate * _startDate;
    ArticleCategoryController *_categoryController;
    UIImageView *_bgImageView;
    UISearchBar* mySearchBar;
}
@property (nonatomic, strong) AbuSearchView * searchView;
@property(nonatomic)NSMutableArray *guideControls;
@property(nonatomic)NSMutableDictionary *viewControllers;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation DiscoveryController

-(instancetype)init {
    if (self = [super init]) {
        _loadDataFlag = NO;
        
//        [self createBackBarButtonItem];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UMengUtils careForDiscover];
   
//    [self.navigationController.navigationBar addSubview:self.searchView];
    
    
//    mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenW-30, 26)];
//    //    [mySearchBar becomeFirstResponder];
//    mySearchBar.backgroundColor=[UIColor colorWithHexString:@"#e5e5e5"];
//    mySearchBar.barTintColor=[UIColor colorWithHexString:@"#e5e5e5"];
//    mySearchBar.delegate = self;
//    mySearchBar.layer.cornerRadius=13;
//    mySearchBar.layer.masksToBounds=YES;
//    mySearchBar.userInteractionEnabled = YES;
//    mySearchBar.delegate =self;
//    for (UIView *view in mySearchBar.subviews)
//    {
//        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
//            [view.subviews objectAtIndex:1].backgroundColor=[UIColor colorWithHexString:@"#e5e5e5"];
//            break;
//        }
//    }
//    [mySearchBar setPlaceholder:@"查找方案、话题、文章"];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-30, 26)];
    titleView.layer.cornerRadius=13;
    titleView.layer.masksToBounds=YES;//allocate titleView




    [titleView addSubview:self.searchView];
    self.navigationItem.titleView = titleView;

//    self.navigationController.navigationBar.translucent = NO;
    
//    if (self.navigationItem.rightBarButtonItem == nil) {
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onClickedSearchControl:)];
//    }
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    UIImage *image = [[WRUIConfig defaultNavImage] imageByResizeToSize:CGSizeMake(bar.width, 1)];
//    [bar setShadowImage:image];
    
    CGFloat cy;
    CGRect frame = self.view.bounds;
    if (_mainCollectionView == nil) {
//        CGFloat tabHeight = self.tabBarController.tabBar.height;
        CGFloat y = 0;
        cy = frame.size.height - y;
//        CGRect frame = CGRectMake(0, y, self.tabBarController.tabBar.width, cy);
        CGRect frame = CGRectMake(0, y, self.view.width, cy);
//        CGRect frame = self.view.bounds;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
    
        collectionView.showsVerticalScrollIndicator = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [collectionView registerClass:[DDChannelCell class] forCellWithReuseIdentifier:@"Cell"];
        
        /*
         UIImage *image = [UIImage imageNamed:@"main_discovery_bg"];
         CGFloat cx = self.view.width;
         CGFloat cy = image.size.height*cx/image.size.width;
         UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cx, cy)];
         imageView.image = image;
         imageView.alpha = 0.65;
         collectionView.backgroundView = imageView;
        */
        
//        collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern"]];
        collectionView.backgroundColor = [UIColor whiteColor];
        
        flowLayout.itemSize = collectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:collectionView];
        
        _mainCollectionView = collectionView;
    }
//    [self loadData];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
       SearchViewController * cha = [SearchViewController new];
        cha.hidesBottomBarWhenPushed=YES;
        [searchBar endEditing:YES];
        [self.navigationController pushViewController:cha animated:YES];
    
    //锚点
    
        NSDate *now = [NSDate date];
        int duration = (int)[now timeIntervalSinceDate:_startDate];
    [MobClick event:[NSString stringWithFormat:@"fxss"] attributes:nil counter:duration];

    
    
    
}
#pragma mark - 懒加载
- (AbuSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[AbuSearchView alloc]initWithFrame:CGRectMake(0,0, ScreenW-30, 26)];
        _searchView.delegate = self;
        _searchView.placeholder = @"查找方案、话题、文章";
    }
    return _searchView;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_loadDataFlag) {
        [self fetchData];
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    [_headerView syncWithScrollViewDidScroll:scrollView];
//    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
//    _segmentedControl.selectedSegmentIndex = index;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_mainCollectionView]) {
//        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSUInteger index = scrollView.contentOffset.x / scrollView.width;
            _segmentedControl.selectedSegmentIndex = index;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    [_headerView syncWithScrollViewDidEndScrollingAnimation:scrollView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = 0;
    if ([ShareData data].categoryArray && _loadDataFlag) {
        count = 1;
    }
    return count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    WRCategory *category = nil;

    if (indexPath.row == 0) {
        CateArticleListController *newsListController = self.viewControllers[recomment_key];
        newsListController.isRecommand = YES;
        newsListController.category = category;
        cell.viewContolller = newsListController;
        newsListController.view.backgroundColor = [UIColor clearColor];
    } else if (indexPath.row == 1) {
        if (!_categoryController) {
            _categoryController = [[ArticleCategoryController alloc] init];
        }
        cell.viewContolller = _categoryController;
    } else {
        MasterTeamController *masterController = [[MasterTeamController alloc] init];
        cell.viewContolller = masterController;
    }
    if ([self.childViewControllers containsObject:cell.viewContolller]) {
        
    } else {
        [self addChildViewController:cell.viewContolller];
    }
    
    return cell;
}

#pragma mark - getter & setter
-(NSMutableDictionary *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSMutableDictionary dictionary];
    }
    return _viewControllers;
}

#pragma mark -
-(void)layout {
    _loadDataFlag = YES;
    
    CateArticleListController *vc = [[CateArticleListController alloc] init];
    vc.isRecommand = YES;
    vc.rootController = self;
    self.viewControllers[recomment_key] = vc;
//    CGRect frame = self.view.bounds;
    BOOL biPad = [WRUIConfig IsHDApp];
    CGFloat cy = 30;
    if (biPad) {
        cy = 40;
    }
    
    
    
    
    
//    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"专题", nil), NSLocalizedString(@"推荐", nil)]];
//    segCtrl.tintColor = [UIColor whiteColor];
//    [segCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor wr_rehabBlueColor],NSFontAttributeName:[UIFont wr_lightFont]} forState:UIControlStateSelected];
//    [segCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont wr_lightFont]} forState:UIControlStateNormal];
//    segCtrl.selectedSegmentIndex = 0;
//    [segCtrl addTarget:self action:@selector(onSegmentControlValueChange:) forControlEvents:UIControlEventValueChanged];
//    _segmentedControl = segCtrl;
//    self.navigationItem.titleView = segCtrl;
    
    /*
    if (!_headerView) {
        
        AutoScrollHeaderView *header = [[AutoScrollHeaderView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        header.textColor = [UIColor grayColor];
        header.focusTextColor = [UIColor grayColor];
        header.underLineColor = [UIColor grayColor];
        header.clickedEvent = ^(AutoScrollHeaderView* sender, NSInteger index) {
            [_mainCollectionView setContentOffset:CGPointMake(index * _mainCollectionView.frame.size.width, 0) animated:YES];
            if (index == 2) {
                [UMengUtils careForExpertList];
            }
        };
        _headerView = header;
        
        NSArray<NSString*> *titleArray = @[NSLocalizedString(@"专题", nil), NSLocalizedString(@"推荐", nil)];
        [titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_headerView addChannel:obj labelCount:titleArray.count];
        }];
        [_headerView sizeToFit];
        self.navigationItem.titleView = header;
    }
    
    [_headerView scrollToIndex:0 needUpdate:YES];
    
    */
}

- (IBAction)onSegmentControlValueChange:(UISegmentedControl *)sender
{
    [_mainCollectionView setContentOffset:CGPointMake(sender.selectedSegmentIndex * _mainCollectionView.frame.size.width, 0) animated:YES];
}

- (void)fetchData {
    if (_loadDataFlag) {
        return;
    }
    [self loadData];
}

-(void)loadData {
    __weak __typeof(self) weakSelf = self;
    [WRViewModel getDiscoveryIndexData:^(NSError * _Nonnull error) {
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
                [weakSelf loadData];
            }];
        } else {
            [weakSelf layout];
            [_mainCollectionView reloadData];
        };
    }];
}

@end
