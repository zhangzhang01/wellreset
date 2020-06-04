//
//  SearchViewController.m
//  rehab
//
//  Created by yefangyang on 2016/11/10.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "SearchViewController.h"
#import "WNXSearchTextField.h"
#import "SVProgressHUD.h"
#import "SearchViewModel.h"
#import "WRProgressCell.h"
#import "ArticleCell.h"
#import "ShareUserData.h"
#import "ArticleDetailController.h"
#import "GBTagListView.h"
#import <YYKit/YYKit.h>

@interface SearchViewController ()<UITextFieldDelegate, UISearchBarDelegate>{
    NSString *_keyword;
    NSDate *_startDate;
}
@property(nonatomic, nonnull)SearchViewModel *viewModel;
@property(nonatomic, nonnull)SearchViewModel *hotViewModel;
@property (nonatomic, weak) WNXSearchTextField *searchTF;
@property (nonatomic, strong) UISearchBar *customSearchBar;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation SearchViewController

- (SearchViewModel *)hotViewModel
{
    if (!_hotViewModel) {
        _hotViewModel = [[SearchViewModel alloc] init];
    }
    return _hotViewModel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
    
    __weak __typeof(self)weakself = self;
    [self.hotViewModel searchHotWordWithCompletion:^(NSError *error) {
        if (error) {
            
        } else{
            [weakself reloadTableView];
        }
    }];
}

- (void)reloadTableView
{
    __weak __typeof(self)weakself = self;
    if ([self.viewModel isEmpty] || !self.viewModel) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WRUIOffset, WRUIOffset, self.view.width - 2 * WRUIOffset, 34)];
        titleLabel.text = NSLocalizedString(@"搜索热词：", nil);
        titleLabel.textColor = [UIColor grayColor];
        [headView addSubview:titleLabel];
        
        GBTagListView *hotView = [[GBTagListView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + WRUIOffset , self.view.width, 0) style:tagViewStyleSingle];
        [headView addSubview:hotView];
//        hotView.backgroundColor = [UIColor wr_lightWhite];
        hotView.canTouch = YES;
        hotView.signalTagColor=[UIColor whiteColor];
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i<weakself.hotViewModel.hotWords.count; i++) {
            WRHotWord *hotWord = weakself.hotViewModel.hotWords[i];
            WRProTreatAnswer *model = [[WRProTreatAnswer alloc] init];
            model.answer = hotWord.searchKey;
            [array addObject:model];
        }
        [hotView setTagWithTagArray:array selectedArray:[NSArray array]];
        
        [hotView setDidselectItemBlock:^(NSArray *arr) {
            if (arr.count>0) {
                WRProTreatAnswer *model = arr[0];
                weakself.customSearchBar.text = model.answer;
                [weakself searchKeyword:model.answer];
                [UMengUtils careForSearchHot:model.answer];
            }
        }];
        headView.height = CGRectGetMaxY(hotView.frame);
//        self.tableView.backgroundView = hotView;
        self.tableView.tableHeaderView = headView;
    } else {
        self.tableView.tableHeaderView = nil;
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _startDate = [NSDate date];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBackBarButtonItem];
    [self setNavigationItem];
    [self createRightItem];
    self.tableView.tableFooterView = [UIView new];
    [UMengUtils careForSearch];
}

- (void)setNavigationItem
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0,self.view.width - 140 , 44)];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.delegate = self;
    searchBar.placeholder = NSLocalizedString(@"搜索", nil);
    searchBar.tintColor = [UIColor grayColor];
    searchBar.barTintColor = [UIColor clearColor];
    searchBar.showsCancelButton = NO;
    self.navigationItem.titleView = searchBar;
    [searchBar becomeFirstResponder];
    self.customSearchBar = searchBar;
    searchBar.backgroundColor=[UIColor colorWithHexString:@"#e5e5e5"];
    searchBar.barTintColor=[UIColor colorWithHexString:@"#e5e5e5"];
    for (UIView *view in searchBar.subviews)
    {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [view.subviews objectAtIndex:1].backgroundColor=[UIColor colorWithHexString:@"#e5e5e5"];
            break;
        }
    }
    searchBar.layer.cornerRadius=13;
    [self removeSearchBarFrame:searchBar];
}

- (void)createRightItem
{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"搜索", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onClickedRightItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

/**
 *  解决uisearchbar闪烁问题
 */
- (void)removeSearchBarFrame:(UISearchBar *)searchBar
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if ([searchBar respondsToSelector : @selector (barTintColor)]) {
        float  iosversion7_1 = 7.1 ;
        if (version >= iosversion7_1)
        {
            //iOS7.1
            
            [[[[searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [searchBar setBackgroundColor:[UIColor clearColor]];
        }
        else
        {
            //iOS7.0
            [searchBar setBarTintColor:[UIColor clearColor]];
            [searchBar setBackgroundColor:[UIColor clearColor]];
        }
    }
    else
    {
        //iOS7.0 以下
        
        [[searchBar.subviews objectAtIndex:0] removeFromSuperview ];
        [searchBar setBackgroundColor :[ UIColor clearColor]];
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

#pragma mark - IBAction
- (IBAction)onClickedRightItem:(UIBarButtonItem *)sender
{
    NSString *text = self.customSearchBar.text;
    [self.customSearchBar endEditing:YES];
    if (text.length > 10) {
        text = [text substringWithRange:NSMakeRange(0, 10)];
    }
    [UMengUtils careForSearchCommon:text];
    [self searchKeyword:text];
}

-(void)onClickedBackButton:(UIBarButtonItem *)sender
{
    [self.customSearchBar resignFirstResponder];
    [super onClickedBackButton:sender];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *text = searchBar.text;
    [searchBar endEditing:YES];
    searchBar.showsCancelButton = NO;
    if (text.length > 10) {
        text = [text substringWithRange:NSMakeRange(0, 10)];
    }
    [self searchKeyword:text];
}


#pragma mark - network
-(void)searchKeyword:(NSString*)keyword
{
    [self.customSearchBar endEditing:YES];
    __weak __typeof(self) weakSelf = self;
    UIViewController *fromController = weakSelf.navigationController;
    
    [SVProgressHUD show];
    [SearchViewModel searchKeywords:keyword completion:^(NSError * _Nullable error, SearchViewModel * _Nullable viewModel) {
        [SVProgressHUD dismiss];
        if (error) {
            [Utility retryAlertWithViewController:fromController title:NSLocalizedString(@"搜索失败", nil) completion:^{
                [weakSelf searchKeyword:keyword];
            }];
        } else {
            if ([viewModel isEmpty]) {
                self.viewModel = viewModel;
                [self reloadTableView];
                [Utility alertWithViewController:fromController title:NSLocalizedString(@"没有相关结果", nil)];
            } else {
                _keyword = keyword;
                self.viewModel = viewModel;
                self.tableView.tableFooterView = [UIView new];
                [self reloadTableView];
            }
        }
    }];
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
    id data = [self getDataWithIndexPath:indexPath];
    NSString *identifier = [@(indexPath.section) stringValue];
    if ([data isKindOfClass:[WRRehabDisease class]]) {
        identifier = [WRRehabDisease className];
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
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
                [self pushTreatRehabWithDisease:disease isTreat:YES];
            } else {
                [self pushProTreatRehabWithDisease:disease stage:0 upgrade:@"0"];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
