//
//  FAQListController
//  rehab
//
//  Created by Matech on 3/3/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "FAQListController.h"
#import "FAQCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "FAQListController.h"
#import "UIView+SDAutoLayout.h"


@interface FAQListController ()<UISearchBarDelegate>
{
    UIView *_lastBubbleView;
    NSMutableArray *_searchResultArray;
    __weak WRRehab* _rehab;
    NSDate *_startDate;
}

@property(nonatomic, copy)NSString *keyword;

@end

@implementation FAQListController

- (void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForRehabFaq:_rehab.disease.diseaseName duration:duration];
}

-(instancetype)initWithRehab:(WRRehab *)rehab
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _rehab = rehab;
        _startDate = [NSDate date];
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.layoutMargins = UIEdgeInsetsZero;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultStyle];
    /*
    UISearchBar *searchBar =[[UISearchBar alloc] initWithFrame:self.tableView.frame];
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    searchBar.tintColor = [UIColor whiteColor];
    searchBar.barTintColor = [UIColor wr_themeColor];
    [searchBar sizeToFit];
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
     */
    //self.navigationController.hidesBarsOnSwipe = YES;
    
    [self createBackBarButtonItem];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar lt_reset];
    /*
     self.navigationController.navigationBar.barTintColor = [UINavigationBar appearance].barTintColor;
     self.navigationController.navigationBar.tintColor = [UINavigationBar appearance].tintColor;
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
     */
}


#pragma mark - UITableView Delegate&Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _rehab.faq.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:tableView.bounds.size.width];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = WRCellIdentifier;
    FAQCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FAQCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    WRFAQ *object = [_rehab.faq objectAtIndex:indexPath.row];
    cell.titleLabel.text = [object.question stringByReplacingOccurrencesOfString:@"$" withString:_rehab.disease.diseaseName];
    cell.contentLabel.text = [object.answer stringByReplacingOccurrencesOfString:@"$" withString:_rehab.disease.diseaseName];
    [cell setupAutoHeightWithBottomView:cell.contentLabel bottomMargin:WRUIOffset];
    
    //return [self.tableView cellHeightForIndexPath:indexPath model:str keyPath:@"text" cellClass:[TestCell2 class] contentViewWidth:[self cellContentViewWith]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
}

#pragma mark - UISearchBarDelegate
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    [searchBar setShowsCancelButton:NO animated:YES];
    
    searchBar.text = @"";
    if ([Utility IsEmptyString:self.keyword]) {
        
    } else {
        self.keyword = @"";
        [self clear];
        [self loadData];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //[searchBar setShowsCancelButton:NO animated:YES];
    NSString *keyword = self.keyword;
    if ([searchBar.text isEqualToString:keyword]) {
        
    } else {
        self.keyword = searchBar.text;
        [self clear];
        [self loadData];
    }
    [self.view endEditing:YES];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
#pragma mark -

-(IBAction)onClickedSearch:(id)sender {
    
}

#pragma mark -
-(void)clear {
    [self reloadData];
}

-(void)reloadData {
    [self.tableView reloadData];
}

-(void)loadData {
    NSString *keyword = self.keyword;
    if (!keyword) {
        keyword = @"";
    }
}

@end
