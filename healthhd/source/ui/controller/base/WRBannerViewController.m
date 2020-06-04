//
//  WRBannerViewController.m
//  rehab
//
//  Created by Matech on 4/25/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRBannerViewController.h"

@interface WRBannerViewController ()

@end

@implementation WRBannerViewController

-(instancetype)init {
    if(self = [super init]){
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldBounce = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _alphaMemory = 0;
    
    UIImage *image = [self bannerPlaceHolderImage];
    CGRect frame = self.tableView.bounds;
    _topContentInset = frame.size.width*image.size.height/image.size.width;
    
    [self.view addSubview:self.tableView];
    [self createScaleImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];

    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin) forBarMetrics:UIBarMetricsDefault];
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
    if (_alphaMemory == 0) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    else {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.alphaBlock) {
        self.alphaBlock(_alphaMemory);
    }
    
    if (_alphaMemory < 1) {
        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
        /*
         [UIView animateWithDuration:0.15 animations:^{
         [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
         //            self.navigationController.navigationBar.tintColor = [UIColor blackColor];
         }];
         */
    }
}

#pragma mark - 创建tableView
- (UITableView *)tableView
{
    if (!_tableView) {
        UIImage *image = [self bannerPlaceHolderImage];
        CGRect bounds = self.view.bounds;
        CGFloat height = bounds.size.width*image.size.height/image.size.width;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.contentInset = UIEdgeInsetsMake(height + _topContentInset, 0, 0, 0);
        _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(height + _topContentInset, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

- (void)createScaleImageView
{
    UIImage *image = [self bannerPlaceHolderImage];
    CGRect frame = self.tableView.bounds;
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width*image.size.height/image.size.width)];
    _topImageView.backgroundColor = [UIColor whiteColor];
    _topImageView.image = image;
    [self.view insertSubview:_topImageView belowSubview:_tableView];
}

#pragma mark - 设置分割线顶头
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WRCellIdentifier];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y + _tableView.contentInset.top;//注意
    //    NSLog(@"%lf", offsetY);
    
    /*
     if (offsetY > _topContentInset && offsetY <= _topContentInset * 2) {
     
     _statusBarStyleControl = YES;
     if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
     [self setNeedsStatusBarAppearanceUpdate];
     }
     self.navigationController.navigationBar.tintColor = [UIColor blackColor];
     
     _alphaMemory = offsetY/(_topContentInset * 2) >= 1 ? 1 : offsetY/(_topContentInset * 2);
     
     [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
     
     }
     else if (offsetY <= _topContentInset) {
     
     _statusBarStyleControl = NO;
     if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
     [self setNeedsStatusBarAppearanceUpdate];
     }
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
     
     _alphaMemory = 0;
     [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
     }
     else if (offsetY > _topContentInset * 2) {
     _alphaMemory = 1;
     [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
     }
     */
    if (self.shouldBounce) {
        if (offsetY < 0) {
            _topImageView.transform = CGAffineTransformMakeScale(1 + offsetY/(-500), 1 + offsetY/(-500));
        }
        CGRect frame = _topImageView.frame;
        frame.origin.y = 0;
        _topImageView.frame = frame;
    }
}

-(UIImage *)bannerPlaceHolderImage {
    return [UIImage imageNamed:@"well_default_banner"];
}

@end