//
//  PayController.m
//  rehab
//
//  Created by yongen zhou on 2017/5/26.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "PayController.h"

#import "WrNavigationController.h"
#import "PayCenter.h"
@interface PayController ()
@property NSArray* moneys;
@property NSInteger choose;
@property UIView* bottom;
@property UILabel* count;

@end

@implementation PayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 233)];
    UIImageView* im = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 223)];
    self.tableView.tableFooterView = [UIView new];
    [im setImage:[UIImage imageNamed:@"打裳背景"]];
    [self.tableView.tableHeaderView addSubview:im];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    _moneys = @[@"6",@"18",@"50",@"108"];
    
    self.bottom = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-43, ScreenW, 43)];
    self.bottom.backgroundColor = [UIColor whiteColor];
    [self.bottom wr_setShadow];
    [self.tableView addSubview:self.bottom];
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW-102, 0, 102, 43)];
    btn.backgroundColor = [UIColor wr_themeColor];
    [btn setTitle:@"确认打赏" forState:0];
    [btn setTintColor:[UIColor whiteColor]];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.bottom addSubview:btn];
    UILabel* la = [UILabel new];
    self.count = la;
    la.text = @"打赏金额：6元";
    la.textColor = [UIColor colorWithHexString:@"333333"];
    la.font = [UIFont systemFontOfSize:15];
    [la sizeToFit];
    la.x = 16;
    la.centerY = 43*1.0/2;
    [la setWr_AttributedWithColorRange:NSMakeRange(5, la.text.length-5) Color:[UIColor wr_themeColor] InintTitle:la.text ];
    [btn bk_whenTapped:^{
        [[PayCenter defaultCenter] payForProductWithIdentify:[NSString stringWithFormat:@"well_pay_%@",self.moneys[self.choose]]];
    }];
    [self.bottom addSubview:la];
    [self createBackBarButtonItem];
    // Do any additional setup after loading the view.
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%lf",self.view.height);
    self.bottom.frame = CGRectMake(0, kScreenHeight-43+self.tableView.contentOffset.y, ScreenW, 43);
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar  setTranslucent:YES];
    [self.navigationController.navigationBar lt_setElementsAlpha:1];
    [self.navigationController.navigationBar  setShadowImage:[WrNavigationController imageWithColor:[UIColor clearColor]]];
    //    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar  setTranslucent:NO];
    [self.navigationController.navigationBar lt_reset];
    [self.navigationController.navigationBar  setShadowImage:[WrNavigationController imageWithColor:[UIColor colorWithHexString:@"#eeeeee"]]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    [cell.contentView removeAllSubviews];
    UIImageView* im  = [UIImageView new];
    [im setImage:[UIImage imageNamed:@"金币-拷贝"]];
    im.x = 17;
    im.width = im.height = 24;
    im.centerY = 60*1.0/2;
    [cell.contentView addSubview:im];
    
    UILabel* la = [UILabel new];
    la.x = im.right+10;
    la.font = [UIFont systemFontOfSize:15];
    if (indexPath.row == self.choose) {
        la.textColor = [UIColor wr_themeColor];
    }
    else
    {
        la.textColor = [UIColor colorWithHexString:@"333333"];
    }
    la.text = [NSString stringWithFormat:@"%@元",self.moneys[indexPath.row]];
    [la sizeToFit];
    la.centerY = 60*1.0/2;
    
    [cell.contentView addSubview:la];
    
    UIImageView* im_choose  = [UIImageView new];
    if (indexPath.row == self.choose) {
        [im_choose setImage:[UIImage imageNamed:@"选中圈状态"]];
    }
    else
    {
        [im_choose setImage:[UIImage imageNamed:@"默认点"]];
    }
    
    im_choose.width = im_choose.height = 18;
    im_choose.centerY = 60*1.0/2;
    im_choose.right =ScreenW- 16;
    [cell.contentView addSubview:im_choose];
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.choose = indexPath.row;
    self.count.text = [NSString stringWithFormat:@"打赏金额：%@元",self.moneys[self.choose]];
    [self.count sizeToFit];
    [self.count setWr_AttributedWithColorRange:NSMakeRange(5, self.count.text.length-5) Color:[UIColor wr_themeColor] InintTitle:self.count.text ];
    [self.tableView reloadData];
    //    [[IAPManager sharedInstance] test];
    
}


@end
