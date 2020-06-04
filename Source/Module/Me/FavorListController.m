//
//  FavorListController.m
//  rehab
//
//  Created by herson on 7/12/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "FavorListController.h"
#import "WRViewModel+Common.h"
#import "BaseCell.h"
#import "ArticleCell.h"
#import "ArticleDetailController.h"
#import "UIViewController+WR.h"
#import "GzwTableViewLoading.h"
#import "UMengUtils.h"
#import "WRRefreshHeader.h"
#import <YYKit/YYKit.h>

@interface FavorListController ()
{
    BOOL _flag;
    NSDate *_startDate;
}
@property(nonatomic) NSMutableArray *dataArray;
@end

@implementation FavorListController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForMeWithType:@"favor" duration:duration];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    
    _startDate = [NSDate date];
    
    _dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self defaultStyle];
    __weak __typeof(self)weakself = self;
    self.tableView.buttonNormalColor = [UIColor clearColor];
    self.tableView.buttonHighlightColor = [UIColor clearColor];
    self.tableView.loadedImageName = @"well_default";
    NSString *desc = NSLocalizedString(@"您没有任何收藏", nil);
    self.tableView.descriptionText = desc;
    self.tableView.dataVerticalOffset = -100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [WRRefreshHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    //    [self reloadFavor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:WRLogOffNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:WRLogInNotification object:nil];
    [WRNetworkService pwiki:@"文章收藏"];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_flag) {
        _flag = YES;
        //        [self loadData];
        [self reloadFavor];
    }
}

#pragma mark - UITableView delegate&dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = self.dataArray[indexPath.row];
    if ([object isKindOfClass:[WRArticle class]]) {
        return [ArticleCell defaultHeightWithTableView:tableView];
    } else {
        return [BaseCell defaultHeightForTableView:tableView];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    id object = self.dataArray[indexPath.row];
    if ([object isKindOfClass:[WRArticle class]]) {
        identifier = [ArticleCell className];
    } else {
        identifier = [BaseCell className];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[NSClassFromString(identifier) alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if ([cell isKindOfClass:[ArticleCell class]]) {
        ArticleCell *newsCell = (ArticleCell*)cell;
        newsCell.badgeView.hidden = YES;
        [newsCell setContent:object];
    } else {
        WRRehabDisease *disease = object;
        [cell.imageView setImageWithUrlString:disease.imageUrl holder:@"well_default_4_3"];
        cell.detailTextLabel.numberOfLines = 0;
        cell.textLabel.text = disease.diseaseName;
        cell.detailTextLabel.text = disease.diseaseDetail;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = self.dataArray[indexPath.row];
    if ([object isKindOfClass:[WRArticle class]]) {
        WRArticle *news = object;
        news.viewCount++;
        [tableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        ArticleDetailController *viewController = [[ArticleDetailController alloc] init];
        WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];
        [self.navigationController pushViewController:viewController animated:YES];
        viewController.currentNews = news;
//        [UMengUtils careForMeFavor:news.title];
    } else {
//        WRRehabDisease *disease = object;
        [self pushTreatRehabWithDisease:object isTreat:YES];
//        [UMengUtils careForMeFavor:disease.diseaseName];
    }
}

#pragma mark -
-(void)updateTableView
{
    if ([self tableView:self.tableView numberOfRowsInSection:0] == 0) {
        self.title = NSLocalizedString(@"没有收藏", nil);
        if (!self.tableView.backgroundView) {
            self.tableView.backgroundView = [WRUIConfig createNoDataViewWithFrame:self.tableView.bounds title:NSLocalizedString(@"这里还是空空的哦！\n快快将您喜欢的文章收藏起来吧。", nil) image:[UIImage imageNamed:@"well_favor_background"]];
        }
        self.tableView.backgroundView.hidden = NO;
        
    } else {
        self.title = NSLocalizedString(@"收藏", nil);
        self.tableView.backgroundView.hidden = YES;
    }
    [self.tableView reloadData];
}

- (void)reloadFavor
{
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadData {
    if ([WRUserInfo selfInfo].isLogged) {
        __weak __typeof(self) weakSelf = self;
        [WRViewModel userGetCollectionListWithCompletion:^(NSError * _Nullable error, id _Nullable resultObject) {
            [weakSelf.tableView.mj_header endRefreshing];
            if (error) {
                [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
                    [weakSelf loadData];
                }];
            } else {
                weakSelf.dataArray = resultObject;
                [weakSelf updateTableView];
                
            }
        } type:OperationContentTypeArticle];
    } else {
        self.dataArray = [NSMutableArray array];
        [self.tableView.mj_header endRefreshing];
        [self updateTableView];
    }
   
}

@end
