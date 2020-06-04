//
//  SearchResultController.m
//  rehab
//
//  Created by herson on 2016/10/7.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "SearchResultController.h"
#import "WRProgressCell.h"
#import "ArticleCell.h"
#import "ArticleDetailController.h"
#import "ShareUserData.h"
#import <YYKit/YYKit.h>
@interface SearchResultController (){
    NSDate *_startDate;
    NSString *_keyword;
}
@property(nonatomic, nonnull)SearchViewModel *viewModel;
@end

@implementation SearchResultController

//-(void)dealloc
//{
//    NSDate *now = [NSDate date];
//    int duration = (int)[now timeIntervalSinceDate:_startDate];
//    [UMengUtils careForSearch:_keyword];
//}

-(instancetype)initWithViewModel:(SearchViewModel *)viewModel keyword:(NSString *)keyword
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _startDate = [NSDate date];
        _keyword = keyword;
        self.viewModel = viewModel;
        self.tableView.tableFooterView = [UIView new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"搜索结果", nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource&Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableArray<NSString*> *array = [NSMutableArray array];
    if (self.viewModel.treatDiseases.count > 0) {
        [array addObject:NSLocalizedString(@"快速定制", nil)];
    }
    if (self.viewModel.proTreatDiseases.count > 0) {
        [array addObject:NSLocalizedString(@"专业定制", nil)];
    }
    if (self.viewModel.articles.count > 0) {
        [array addObject:NSLocalizedString(@"资讯", nil)];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
    label.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    label.font = [UIFont wr_detailFont];
    label.textColor = [UIColor grayColor];
    label.text = [NSString stringWithFormat:@"   %@",array[section]];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 0;
    if (self.viewModel.treatDiseases.count > 0) {
        count++;
    }
    if (self.viewModel.proTreatDiseases.count > 0) {
        count++;
    }
    if (self.viewModel.articles.count > 0) {
        count++;
    }
    return count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = [NSMutableArray array];
    if (self.viewModel.treatDiseases.count > 0) {
        [array addObject:self.viewModel.treatDiseases];
    }
    if (self.viewModel.proTreatDiseases.count > 0) {
        [array addObject:self.viewModel.proTreatDiseases];
    }
    if (self.viewModel.articles.count > 0) {
        [array addObject:self.viewModel.articles];
    }
    NSArray *dataArray = array[section];
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self getDataWithIndexPath:indexPath];
    if ([data isKindOfClass:[WRRehabDisease class]]) {
        UIImage *image = [UIImage imageNamed:@"well_default_banner"];
        return tableView.frame.size.width*image.size.height/image.size.width + 2 * WRUIOffset;
    }
    else
    {
        return [ArticleCell defaultHeightWithTableView:tableView];
    }
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSMutableArray<NSString*> *array = [NSMutableArray array];
//    if (self.viewModel.treatDiseases.count > 0) {
//        [array addObject:NSLocalizedString(@"普通定制", nil)];
//    }
//    if (self.viewModel.proTreatDiseases.count > 0) {
//        [array addObject:NSLocalizedString(@"专业定制", nil)];
//    }
//    if (self.viewModel.articles.count > 0) {
//        [array addObject:NSLocalizedString(@"资讯", nil)];
//    }
//    return array[section];
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [@(indexPath.section) stringValue];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    id data = [self getDataWithIndexPath:indexPath];
    if (!cell) {
        if ([data isKindOfClass:[WRRehabDisease class]]) {
            cell = [[WRProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        else if([data isKindOfClass:[WRArticle class]])
        {
            cell = [[ArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    }
    if ([data isKindOfClass:[WRRehabDisease class]]) {
        WRRehabDisease *disease = data;
        WRProgressCell *progressCell = (WRProgressCell*)cell;
        progressCell.titleLabel.text = disease.diseaseName;
        [progressCell.iconimageView setImageWithUrlString:disease.bannerImageUrl holder:@"well_default_banner"];
    }
    else if([data isKindOfClass:[WRArticle class]])
    {
        WRArticle *article = data;
        ArticleCell *articleCell = (ArticleCell*)cell;
        [articleCell setContent:article];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id data = [self getDataWithIndexPath:indexPath];
    if ([data isKindOfClass:[WRRehabDisease class]]) {
        if (![self checkUserLogState:self.navigationController]) {
            return;
        }
        
        __weak __typeof(self) weakSelf = self;
        
        if ([weakSelf checkUserLogState:nil]) {
            WRRehabDisease *disease = data;
            if (![disease isPro]) {
                [self.navigationController presentTreatRehabWithDisease:disease isTreat:YES];
            } else {
                [self.navigationController presentProTreatRehabWithDisease:disease stage:0 upgrade:@"0"];
            }
        }
    }
    else
    {
        WRArticle *object = data;
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
}

#pragma mark -
-(id)getDataWithIndexPath:(NSIndexPath*)indexPath
{
    NSMutableArray *array = [NSMutableArray array];
    if (self.viewModel.treatDiseases.count > 0) {
        [array addObject:self.viewModel.treatDiseases];
    }
    if (self.viewModel.proTreatDiseases.count > 0) {
        [array addObject:self.viewModel.proTreatDiseases];
    }
    if (self.viewModel.articles.count > 0) {
        [array addObject:self.viewModel.articles];
    }
    NSArray *dataArray = array[indexPath.section];
    return dataArray[indexPath.row];
}
@end
