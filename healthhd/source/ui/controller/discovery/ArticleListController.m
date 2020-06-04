//
//  ArticleListController.m
//  rehab
//
//  Created by 何寻 on 6/3/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "ArticleListController.h"
#import "WRNewsListViewModel.h"
#import "ArticleCell.h"
#import "FAQListController.h"
#import "ArticleDetailController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "UMengUtils.h"
#import "ShareUserData.h"
#import "WRRefreshHeader.h"

@interface ArticleListController ()<UISearchBarDelegate>
{
    UIView *_lastBubbleView;
    
    NSMutableArray *_searchResultArray;
    
    NSDate *_startDate;
}
@property(nonatomic)WRNewsListViewModel *viewModel;
@property(nonatomic, copy)NSString *keyword;
@property(nonatomic)BOOL loadDataflag;
@end

@implementation ArticleListController

-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    NSString *name = (self.category ? _category.name : NSLocalizedString(@"推荐", nil));
    [UMengUtils careForArticleCategory:name duration:duration];
}

-(instancetype)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
        _startDate = [NSDate date];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableHeaderView = [UIView new];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.rowHeight = [ArticleCell defaultHeightWithTableView:self.tableView];
        
        [WRNetworkService pwiki:@"资讯列表"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor wr_themeColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate&Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = WRCellIdentifier;
    ArticleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    WRArticle *object = self.dataList[indexPath.row];
    [cell setContent:object];
    
    cell.badgeView.hidden = [[ShareUserData userData].redArticleArray containsObject:object.uuid];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WRArticle *object = self.dataList[indexPath.row];
    [[ShareUserData userData].redArticleArray addObject:object.uuid];
    [[ShareUserData userData] save];
    object.viewCount++;
    ArticleDetailController *viewController = [[ArticleDetailController alloc] init];
    [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
    viewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.currentNews = object;
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Event
-(IBAction)onClickedRightBarButtonItem:(UIBarButtonItem*)sender {
    UIViewController *viewController = [[FAQListController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.title = sender.title;
}


#pragma mark - Getter & Setter
-(void)setDataList:(NSArray<WRArticle *> *)dataList {
    [self clear];
    _dataList = dataList;
    [self reloadData];
}


-(void)setCategory:(WRCategory *)category {
    if ((_category && [_category.indexId isEqualToString:category.indexId]) || (category == nil && self.loadDataflag)) {
        
    } else {
        [self clear];
        
        _category = category;
        self.viewModel = [[WRNewsListViewModel alloc] init];
        self.dataList = self.viewModel.dataArray;
        __weak __typeof(self) weakSelf = self;
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            [weakSelf loadData];
        }];
        
        WRRefreshHeader *header = [[WRRefreshHeader alloc] init];
        header.refreshingBlock = ^{
            [weakSelf onRefresh];
        };
        self.tableView.mj_header = header;
        
        [self loadData];
    }
}

#pragma mark -
-(void)clear {
    if (self.dataList) {
        _dataList = nil;
        [self reloadData];
    } else {
        [self.viewModel clearData];
        [self reloadData];
    }
}

-(void)reloadData {
    [self.tableView reloadData];
}

-(void)loadData {
    if (self.viewModel.isLastPage) {
        NSLog(@"last page");
        return;
    }
    __weak __typeof(self) weakSelf = self;
    NSString *indexId = @"";
    if (self.category) {
        indexId = self.category.indexId;
    }
    [self.viewModel fetchNewsListWithTypeId:indexId completion:^(NSError * error) {
        if (error) {
            NSLog(@"%@", error.debugDescription);
        } else {
            weakSelf.loadDataflag = YES;
            [weakSelf reloadData];
        }
        [weakSelf.tableView setShowsInfiniteScrolling:!weakSelf.viewModel.isLastPage];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

-(void)onRefresh
{
    [self.viewModel clearData];
    [self.tableView reloadData];
    [self loadData];
}

@end
