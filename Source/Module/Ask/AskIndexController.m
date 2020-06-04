//
//  AskIndexController.m
//  rehab
//
//  Created by herson on 2016/11/22.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "AskIndexController.h"

#import "WRRefreshHeader.h"
#import "GuideView.h"
#import "WRView.h"
#import "AutoScrollHeaderView.h"
#import "DDChannelCell.h"
#import "WRPerfectView.h"

#import "ReplyController.h"
#import "WRFAQViewController.h"

#import "AskController.h"

#import "ShareUserData.h"

#import "AskExpertViewModel.h"
#import "WRUserInfo.h"
@interface AskIndexController ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    ReplyController *_indexController;
    ReplyController *_replyViewController;
    ReplyController *_questionViewController;
    AutoScrollHeaderView *_headerView;
    UICollectionView *_mainCollectionView;

    BOOL _loadDataFlag;
    NSArray<NSString*> *_titleArray;
    
}
@property (nonatomic, strong) WRPerfectView *perfectView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;


@end

@implementation AskIndexController

-(instancetype)init {
    if (self = [super init]) {
        _loadDataFlag = NO;
        
        [self createBackBarButtonItem];
    }
    return self;
}

- (UIBarButtonItem *)extracted {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onClickedRightItem:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _titleArray = @[NSLocalizedString(@"用户问答", nil), NSLocalizedString(@"我的提问", nil),NSLocalizedString(@"常见问题", nil)];
    self.navigationItem.rightBarButtonItem = [self extracted];
   
    [WRNetworkService pwiki:@"问答"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationBar *bar = self.navigationController.navigationBar;
//    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    UIImage *image = [[WRUIConfig defaultNavImage] imageByResizeToSize:CGSizeMake(bar.width, 1)];
 //   [bar setShadowImage:image];
    CGFloat cy;
    CGRect frame = self.view.bounds;
    if (_mainCollectionView == nil) {
        CGFloat y = 0;
        cy = frame.size.height - y ;
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
    
    if (_index == 0)
    {
//        if (!_indexController) {
            _indexController = [[ReplyController alloc] initWithFlag:YES withstage:@"0"];
//        }
        cell.viewContolller = _indexController;
    }
    else if (_index == 1)
    {
//        if (!_replyViewController)
//        {
            _replyViewController = [[ReplyController alloc] initWithFlag:NO withstage:@"1"];
//        }
        cell.viewContolller = _replyViewController;
    }
    else
    {
//        if (!_questionViewController)
//        {
            _questionViewController = [[ReplyController alloc] initWithFlag:YES withstage:@"2"];
//        }
        cell.viewContolller = _questionViewController;
    }
    
//    if (cell.viewContolller && ![self.childViewControllers containsObject:cell.viewContolller])
//    {
        [self addChildViewController:cell.viewContolller];
//    }
    
    return cell;
}

#pragma mark - getter & setter

#pragma mark - event
- (IBAction)onSegmentControlValueChange:(UISegmentedControl *)sender
{
    _index = sender.selectedSegmentIndex;
    [_mainCollectionView setContentOffset:CGPointMake(sender.selectedSegmentIndex * _mainCollectionView.frame.size.width, 0) animated:YES];
    [_mainCollectionView reloadData];
}

-(IBAction)onClickedRightItem:(id)sender
{
    WRUserInfo *userInfo = [WRUserInfo selfInfo];
    
        __weak __typeof(self) weakSelf = self;
        [SVProgressHUD show];
        [AskExpertViewModel fetchSelfRemainCountWithCompletion:^(NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
                    [weakSelf onClickedRightItem:sender];
                }];
            }
            else
            {
                NSInteger remainCount = [ShareUserData userData].askExpertRemainCount;
                NSString *text = @"";
                if (remainCount < 0)
                {
                    text = [NSString stringWithFormat:@"需要升到3级才能开始提问,您目前等级为%ld",[WRUserInfo selfInfo].level];
                }
                else if(remainCount == 0)
                {
                    text = NSLocalizedString(@"您本周可提问次数已问完", nil);
                }
                else
                {
                    AskController *viewController = [[AskController alloc] init];
                    [weakSelf.navigationController pushViewController:viewController animated:YES];
                }
                if (![Utility IsEmptyString:text]) {
                    [Utility alertWithViewController:weakSelf.navigationController title:text];
                }
            }
        }];
        
        
        
    
    
}



#pragma mark -
-(void)layout {
    _loadDataFlag = YES;
    
    BOOL biPad = [WRUIConfig IsHDApp];
    CGFloat cy = 30;
    if (biPad) {
        cy = 40;
    }
    
//    if (!_headerView)
//    {
//        AutoScrollHeaderView *header = [[AutoScrollHeaderView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
//        header.textColor = [UIColor grayColor];
//        header.focusTextColor = [UIColor grayColor];
//        header.underLineColor = [UIColor grayColor];
//        header.clickedEvent = ^(AutoScrollHeaderView* sender, NSInteger index) {
//            [_mainCollectionView setContentOffset:CGPointMake(index * _mainCollectionView.frame.size.width, 0) animated:YES];
//            if (index == 0) {
//                [UMengUtils careForExpertList];
//            }
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
    
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:_titleArray];
    segCtrl.tintColor = [UIColor wr_rehabBlueColor];
    [segCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor wr_rehabBlueColor],NSFontAttributeName:[UIFont wr_lightFont]} forState:UIControlStateNormal];
    [segCtrl setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName:[UIFont wr_lightFont]} forState:UIControlStateSelected];
    segCtrl.selectedSegmentIndex = self.index;
    [_mainCollectionView setContentOffset:CGPointMake(self.index * _mainCollectionView.frame.size.width, 0) animated:YES];
    [segCtrl addTarget:self action:@selector(onSegmentControlValueChange:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl = segCtrl;
    self.navigationItem.titleView = segCtrl;
}

@end
