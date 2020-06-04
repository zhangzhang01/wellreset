//
//  ImlistController.m
//  rehab
//
//  Created by yongen zhou on 2017/6/28.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "ImlistController.h"
#import "PayImViewModel.h"
#import "OrderCell.h"
#import "OrderDetailController.h"
@interface ImlistController ()<UITableViewDelegate,UITableViewDataSource>
@property NSMutableArray* dataarry;
@property PayImViewModel* viewModel;
@end

@implementation ImlistController
-(instancetype)init
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"imlist"];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [PayImViewModel new];
     [self createBackBarButtonItem];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
 
    [self.viewModel fetchOrderlistcompletion:^(NSError * _Nonnull error) {
        self.dataarry = self.viewModel.orderlist;
        [self.tableView reloadData];
        [self updateTableView];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataarry.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRImOrder* order = self.dataarry[indexPath.row];
    if (order.type ==1) {
        return 96;
    }
    else
    {
        return 122;
    }
}
-(void)updateTableView
{
    if ([self tableView:self.tableView numberOfRowsInSection:0] == 0) {
//        self.title = NSLocalizedString(@"没有收藏", nil);
        if (!self.tableView.backgroundView) {
            self.tableView.backgroundView = [WRUIConfig createNoDataViewWithFrame:self.tableView.bounds title:NSLocalizedString(@"暂无订单", nil) image:[UIImage imageNamed:@"暂无订单"]];
        }
        self.tableView.backgroundView.hidden = NO;
        
    } else {
//        self.title = NSLocalizedString(@"收藏", nil);
        self.tableView.backgroundView.hidden = YES;
    }
    [self.tableView reloadData];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WRImOrder* order = self.dataarry[indexPath.row];
    if (order.type ==1) {
        OrderCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"sinorder"];
        [cell loadwith:order];
        return cell;
    }
    else
    {
        OrderCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"longorder"];
        [cell loadwith:order];
        return cell;
    }

    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
WRImOrder* order = self.dataarry[indexPath.row];
    OrderDetailController* vc = [OrderDetailController new];
    vc.orderId = order.indexId;
    vc.Listorder = order;
    [self.navigationController pushViewController:vc animated:YES];
}
/*
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
