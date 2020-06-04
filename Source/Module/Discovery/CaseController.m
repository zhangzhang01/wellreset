//
//  CaseController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/18.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "CaseController.h"
#import "CaseCell.h"
#import "WRObject.h"
#import "CaseViewModel.h"
#import "WRObject.h"
#import "ArticleDetailController.h"
@interface CaseController ()
@property (nonatomic) NSMutableArray* caseArr;
@property (nonatomic) CaseViewModel* viewModel;
@end

@implementation CaseController
-(instancetype)init
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
    
    self = [sb instantiateViewControllerWithIdentifier:@"case"];
    return self;

}
-(void)viewDidLoad
{
    [self createBackBarButtonItem];
    self.title =@"案例";
}
-(void)viewWillAppear:(BOOL)animated
{
    _viewModel = [CaseViewModel new];
    [self fetchadata];
}
-(void)fetchadata
{
    
    self.viewModel;
    [self.viewModel fetchCasesWithCompletion:^(NSError *error) {
        self.caseArr = self.viewModel.caseArray;
        [self.tableView reloadData];
    } ];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _caseArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CaseCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"case"];
    [cell layout:self.caseArr[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 275;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WRcase* caseid = self.caseArr[indexPath.row];
    WRArticle* ar = [WRArticle new];
    ar.uuid = caseid.uuid;
    ar.title = caseid.title;
    ar.contentUrl = caseid.content_url;
    ArticleDetailController* arvc = [ArticleDetailController new];
    arvc.currentNews = ar;
    [self.navigationController pushViewController:arvc animated:YES];
    
}





@end
