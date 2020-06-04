//
//  ComMessageController.m
//  rehab
//
//  Created by yongen zhou on 2018/10/19.
//  Copyright © 2018年 WELL. All rights reserved.
//

#import "ComMessageController.h"
#import "ComulitModel.h"
#import "WRMesCell.h"
#import "WRRefreshHeader.h"
#import "FCAlertView.h"
#import "CommutiDetailController.h"
@interface ComMessageController ()
@property NSMutableArray* dataarr;
@property ComulitModel* viewModel;
@end

@implementation ComMessageController
-(instancetype)init
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
    
    self = [sb instantiateViewControllerWithIdentifier:@"mess"];
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [ComulitModel new];
    self.tableView.estimatedRowHeight = 37.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    WRRefreshHeader *header = [[WRRefreshHeader alloc] init];
    __weak __typeof(self)weakSelf = self;
    header.refreshingBlock = ^{
        [weakSelf reload];
        
    };
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self createBackBarButtonItem];
    
    UIImage* image = [UIImage imageNamed:@"删除-3"];
    UIButton*  buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(0, 0, 20, 20);
    buttonRight.imageView.contentMode = UIViewContentModeScaleToFill;
    [buttonRight setBackgroundImage:image forState:0];
    [buttonRight addTarget:self action:@selector(onClickedRightBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)onClickedRightBarButtonItem:(UIButton*)sender
{
//    UIAlertView* al = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"确定全部清空吗" cancelButtonTitle:@"确认" otherButtonTitles:@"取消" handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
//        if (buttonIndex==0) {
//            [self.viewModel deletComentId:[self.dataarr JSONString] Completion:^(NSError * error) {
//                [AppDelegate show:@"删除成功"];
//            }];
//        }
//    }];
//
//    [al show];
    
     FCAlertView *alert = [[FCAlertView alloc] init];
    [alert showAlertInView:self withTitle:NSLocalizedString(@"提示", nil) withSubtitle:NSLocalizedString(@"确定全部清空吗", nil) withCustomImage:nil withDoneButtonTitle:NSLocalizedString(@"取消", nil) andButtons:nil];
    [alert addButton:NSLocalizedString(@"确定", nil) withActionBlock:^{
       
        
        
        [self.viewModel deletComentId:[self.dataarr JSONString] Completion:^(NSError * error) {
            [self.dataarr removeAllObjects];
            [self.tableView reloadData];
            [AppDelegate show:@"删除成功"];
                        }];
        
    }];
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self reload];
}

-(void)reload
{
    [self.viewModel getMessageCompletion:^(NSError * error) {
        self.dataarr = self.viewModel.messageArr;
        [self.tableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataarr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WRMessage* mes = self.dataarr[indexPath.row];
    if ([mes.action isEqualToString:@"comment"]) {
        WRMesCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"comment"];
        [cell loadWith:mes];
        return cell;
    }
    else
    {
        WRMesCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"upvote"];
        [cell loadWith:mes];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRMessage* mes = self.dataarr[indexPath.row];
    [self.viewModel getarticleSort:@"" page:1 rows:10 circleId:@"" isown:@"" articleId:mes.rltUUID Completion:^(NSError * error) {
        CommutiDetailController* detail = [CommutiDetailController new];
        detail.article = self.viewModel.articleArr[0];

        detail.UUID = mes.rltUUID;
        [self.navigationController pushViewController:detail animated:YES];
        
    }];
}




@end
