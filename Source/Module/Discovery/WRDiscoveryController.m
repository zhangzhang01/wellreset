//
//  DiscoveryController.m
//  rehab
//
//  Created by 何寻 on 6/15/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRDiscoveryController.h"
#import "ArticleDetailController.h"
#import "ArticleListController.h"
#import "WRRefreshHeader.h"
#import "GuideView.h"
#import "WRView.h"
#import "AutoScrollHeaderView.h"
#import "DDChannelCell.h"
#import "ShareData.h"
#import <YYKit/YYKit.h>
#define recomment_key @"recomment"

@interface WRDiscoveryController ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    BOOL _loadDataFlag;
    AutoScrollHeaderView *_headerView;
    UICollectionView *_mainCollectionView;
}

@property(nonatomic)NSMutableArray *guideControls;
@property(nonatomic)NSMutableDictionary *viewControllers;
@property(nonatomic, weak) NSArray<WRCategory*> *categoryArray;

@end

@implementation WRDiscoveryController

-(instancetype)init {
    if (self = [super init]) {
    
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.frame = self.view.bounds;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self fetchData];
}

#pragma mark - Event
-(void)layout {
    _loadDataFlag = YES;
    __weak __typeof(self) weakSelf = self;
    self.categoryArray = [ShareData data].categoryArray;
    
    [self.categoryArray enumerateObjectsUsingBlock:^(WRCategory * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ArticleListController *vc = weakSelf.viewControllers[obj.indexId];
        if (!vc) {
            vc = [[ArticleListController alloc] init];
            weakSelf.viewControllers[obj.indexId] = vc;
        }
    }];

    ArticleListController *vc = [[ArticleListController alloc] init];
    weakSelf.viewControllers[recomment_key] = vc;
        
    CGRect frame = self.scrollView.bounds;
    BOOL biPad = [WRUIConfig IsHDApp];
    CGFloat x = 0, y = 0, cx = frame.size.width, cy = 30;
    if (biPad) {
        cy = 60;
    }
    if (!_headerView) {
        AutoScrollHeaderView *header = [[AutoScrollHeaderView alloc] initWithFrame:CGRectMake(x, y, cx, cy) color:[UIColor wr_themeColor]];
        header.backgroundColor = [UIColor colorWithHexString:@"fdfdfd"];
        header.clickedEvent = ^(AutoScrollHeaderView* sender, NSInteger index) {
            [_mainCollectionView setContentOffset:CGPointMake(index * _mainCollectionView.frame.size.width, 0)];
        };
//        [self.scrollView addSubview:header];
        _headerView = header;
        
        NSInteger labelCount = _categoryArray.count + 1;
        [_headerView addChannel:NSLocalizedString(@"推荐", nil) labelCount:labelCount];
        [_categoryArray enumerateObjectsUsingBlock:^(WRCategory*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_headerView addChannel:obj.name labelCount:labelCount];
        }];
    }
    
    if (_mainCollectionView == nil) {
        CGFloat tabHeight = self.tabBarController.tabBar.height;
        cy = frame.size.height - 64  - WRTabbarHeight-WRTabbarHeight;
        CGRect frame = CGRectMake(0, 0, _headerView.width, cy);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[DDChannelCell class] forCellWithReuseIdentifier:@"Cell"];
        
        flowLayout.itemSize = collectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        [self.scrollView addSubview:collectionView];
        
        _mainCollectionView = collectionView;
        _mainCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    }
    [_headerView scrollToIndex:0 needUpdate:YES];
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_headerView syncWithScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_mainCollectionView]) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [_headerView syncWithScrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark -



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count = 0;
    if (_categoryArray) {
        count = _categoryArray.count + 1;
    }
    return count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    WRCategory *category = nil;
    NSString *key = recomment_key;
    if (indexPath.row > 0) {
        category = _categoryArray[indexPath.row - 1];
        key = category.indexId;
    }
    
    ArticleListController *newsListController = self.viewControllers[key];
    newsListController.category = category;
    cell.viewContolller = newsListController;
    
    if ([self.childViewControllers containsObject:cell.viewContolller]) {
        
    } else {
        [self addChildViewController:cell.viewContolller];
    }
    
    return cell;
}
-(CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        CGSize size = {self.view.width, 150};
        return size;
    }
    else
    {
        CGSize size = {self.view.width, 50};
        return size;
    }
}

#pragma mark -
-(NSMutableDictionary *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSMutableDictionary dictionary];
    }
    return _viewControllers;
}

-(void)fetchData {
    if (_loadDataFlag) {
        return;
    }
    [self loadData];
}

-(void)loadData {
    __weak __typeof(self) weakSelf = self;
    [WRViewModel getDiscoveryIndexData:^(NSError * _Nonnull error) {
        if (error) {
            
        } else {
            [weakSelf layout];
        };
    }];
}

@end
