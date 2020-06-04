//
//  WRFAQViewController.m
//  rehab
//
//  Created by Matech on 3/3/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRFAQViewController.h"
#import "WRFAQViewModel.h"
#import "WRFAQCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
//#import "WRFAQDetailViewController.h"

@interface WRFAQViewController ()<UISearchBarDelegate>
{
    UIView *_lastBubbleView;
    NSMutableArray *_searchResultArray;
}
@property(nonatomic)WRFAQViewModel *viewModel;
@property(nonatomic, copy)NSString *keyword;
@end

@implementation WRFAQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self defaultStyle];
    // Do any additional setup after loading the view.
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(onClickedSearch:)];
    self.viewModel = [[WRFAQViewModel alloc] init];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    /*
    UISearchBar *searchBar =[[UISearchBar alloc] initWithFrame:self.tableView.frame];
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    [searchBar sizeToFit];
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    */
    //self.navigationController.hidesBarsOnSwipe = YES;
    
    [self loadData];
    [WRNetworkService pwiki:@"FAQ"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate&Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:tableView.bounds.size.width];
    NSLog(@"cellheight%f",[self cellHeightForIndexPath:indexPath cellContentViewWidth:tableView.bounds.size.width]);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = WRCellIdentifier;
    WRFAQCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WRFAQCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    WRFAQ *object = [self.viewModel.dataArray objectAtIndex:indexPath.row];
    [cell setContent:object];
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    WRFAQ *object = [self.viewModel.dataArray objectAtIndex:indexPath.row];
//    [UMengUtils careForWellFaq:object.question];
//    WRFAQDetailViewController *viewController = [[WRFAQDetailViewController alloc] initWithFAQ:object];
//    [self.navigationController pushViewController:viewController animated:YES];
//    viewController.title = NSLocalizedString(@"详情", nil);
//}

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
    [self.viewModel clearData];
    [self reloadData];
}

-(void)reloadData {
    [self.tableView reloadData];
}

-(void)loadData {
    __weak __typeof(self) weakSelf = self;
    NSString *keyword = self.keyword;
    if (!keyword) {
        keyword = @"";
    }
    [self.viewModel fetchDataWithBlock:^(NSError * error) {
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
                [weakSelf loadData];
            }];
            NSLog(@"%@", error.debugDescription);
        } else {
            [weakSelf reloadData];
        }
    } keyword:keyword];
}

@end
