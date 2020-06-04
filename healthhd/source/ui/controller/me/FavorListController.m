//
//  FavorListController.m
//  rehab
//
//  Created by 何寻 on 7/12/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "FavorListController.h"
#import "WRViewModel.h"
#import "BaseCell.h"
#import "ArticleCell.h"
#import "ArticleDetailController.h"
#import "UIViewController+WR.h"
#import "GzwTableViewLoading.h"
#import "UMengUtils.h"

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    
    _startDate = [NSDate date];
    
    _dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self defaultStyle];
    
    self.tableView.buttonNormalColor = [UIColor clearColor];
    self.tableView.buttonHighlightColor = [UIColor clearColor];
    self.tableView.loadedImageName = @"well_default";
    NSString *desc = NSLocalizedString(@"您没有任何收藏", nil);
    self.tableView.descriptionText = desc;
    self.tableView.dataVerticalOffset = -100;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_flag) {
        _flag = YES;
        [self loadData];
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
        [self.navigationController pushViewController:viewController animated:YES];
        viewController.currentNews = news;
    } else {
        [self pushTreatRehabWithDisease:object isTreat:YES];
    }
}

#pragma mark -
-(void)updateTableView
{
    [self.tableView reloadData];
}

-(void)loadData {
    __weak __typeof(self) weakSelf = self;
    self.tableView.loading = YES;
    [WRViewModel userGetFavorListWithCompletion:^(NSError * _Nullable error, id _Nullable resultObject) {
        weakSelf.tableView.loading = NO;
        if (error) {
            
        } else {
            [weakSelf.dataArray addObjectsFromArray:resultObject];
            [weakSelf updateTableView];
        }
    }];
}

@end
