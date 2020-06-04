//
//  FavorIndexController.m
//  rehab
//
//  Created by herson on 2016/11/22.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "FavorIndexController.h"
#import "WRRefreshHeader.h"

#import "WRView.h"
#import "AutoScrollHeaderView.h"
#import "DDChannelCell.h"

#import "FavorListController.h"
#import "StageFavorListController.h"
#import "CreatTreatController.h"
@interface FavorIndexController ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    FavorListController *_favorController;
    StageFavorListController *_stageFavorController;
    
    AutoScrollHeaderView *_headerView;
    UICollectionView *_mainCollectionView;
    
    
    BOOL _loadDataFlag;
    NSArray<NSString*> *_titleArray;
}
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@implementation FavorIndexController

-(instancetype)initWithContentType:(id)type {
    if (self = [super init]) {
        _loadDataFlag = NO;
        
        [self createBackBarButtonItem];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self createBackBarButtonItem];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _titleArray = @[NSLocalizedString(@"文章收藏", nil), NSLocalizedString(@"动作收藏", nil)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
    
    CGFloat cy;
    CGRect frame = self.view.bounds;
    if (_mainCollectionView == nil) {
        CGFloat y = 0;
        cy = frame.size.height - y;
        CGRect frame = CGRectMake(0, y, self.view.width, cy);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        collectionView.backgroundColor = [UIColor whiteColor];
        
        collectionView.showsVerticalScrollIndicator = YES;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        [collectionView registerClass:[DDChannelCell class] forCellWithReuseIdentifier:@"Cell"];
        
        collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern"]];
        
        flowLayout.itemSize = collectionView.bounds.size;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        collectionView.pagingEnabled = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        
        [self.view addSubview:collectionView];
        
        _mainCollectionView = collectionView;
        
        [self layout];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    [_headerView syncWithScrollViewDidScroll:scrollView];
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
    return _titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDChannelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == 0)
    {
        if (!_favorController) {
            _favorController = [[FavorListController alloc] init];
        }
        cell.viewContolller = _favorController;
    }
    else if (indexPath.row == 1)
    {
        if (!_stageFavorController)
        {
            _stageFavorController = [[StageFavorListController alloc] init];
        }
        cell.viewContolller = _stageFavorController;
    }
    
    if (cell.viewContolller && ![self.childViewControllers containsObject:cell.viewContolller])
    {
        [self addChildViewController:cell.viewContolller];
    }
    
    return cell;
}

#pragma mark - getter & setter

#pragma mark -
-(void)layout {
    _loadDataFlag = YES;
    
    BOOL biPad = [WRUIConfig IsHDApp];
    CGFloat cy = 30;
    if (biPad) {
        cy = 40;
    }
    
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:_titleArray];
    segCtrl.tintColor = [UIColor wr_rehabBlueColor];
    [segCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor wr_rehabBlueColor],NSFontAttributeName:[UIFont wr_lightFont]} forState:UIControlStateNormal];
    [segCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont wr_lightFont]} forState:UIControlStateSelected];
    segCtrl.selectedSegmentIndex = 0;
    [segCtrl addTarget:self action:@selector(onSegmentControlValueChange:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl = segCtrl;
    self.navigationItem.titleView = segCtrl;
    
//    if (!_headerView)
//    {
//        AutoScrollHeaderView *header = [[AutoScrollHeaderView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
//        header.textColor = [UIColor grayColor];
//        header.focusTextColor = [UIColor grayColor];
//        header.underLineColor = [UIColor grayColor];
//        header.clickedEvent = ^(AutoScrollHeaderView* sender, NSInteger index) {
//            [_mainCollectionView setContentOffset:CGPointMake(index * _mainCollectionView.frame.size.width, 0) animated:YES];
//        };
//        _headerView = header;
//        
//        NSArray<NSString*> *titleArray = _titleArray;
//        [titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [_headerView addChannel:obj labelCount:titleArray.count];
//        }];
//        [_headerView sizeToFit];
//        self.navigationItem.titleView = header;
//    }
//    
//    [_headerView scrollToIndex:0 needUpdate:YES];
}

#pragma mark - event
- (IBAction)onSegmentControlValueChange:(UISegmentedControl *)sender
{
    [_mainCollectionView setContentOffset:CGPointMake(sender.selectedSegmentIndex * _mainCollectionView.frame.size.width, 0) animated:YES];
}

@end
