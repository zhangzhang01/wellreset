//
//  NotiController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/23.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "NotiController.h"
#import "NotiArtCell.h"
#import "NotiAskCell.h"
#import "AskIndexController.h"
#import "WRFAQViewModel.h"
#import "ArticleDetailController.h"
@interface NotiController ()
@property (nonatomic) NSMutableArray* dataarr;
@property CGFloat n ;
@property NSMutableArray* choose;
@property BOOL isedit;
@property UIView* bottomView;
@property NSInteger state;

@end

@implementation NotiController
-(instancetype)init
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
    self = [sb instantiateViewControllerWithIdentifier:@"noti"];
    return self;
}
-(void)viewDidLoad
{
    _dataarr =[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"noti"]] ;
    _choose = [NSMutableArray array];
    [self updateTable];
    _isedit = NO;
    self.tableView.estimatedRowHeight = 80.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    
    UIButton* right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30+4, 15)];
    [right setTitle:@"设置" forState:0];
    [right setTitle:@"取消" forState:UIControlStateSelected];
    [right setTitleColor:[UIColor wr_rehabBlueColor] forState:0];
    [right bk_whenTapped:^{
        _isedit = !_isedit;
        [self.choose removeAllObjects];
        [self.tableView reloadData];
        self.bottomView.hidden = !_isedit;
        right.selected = !right.selected;
        if (_isedit) {
            _state = 0;
        }
        else
        {
            _state = 1;
        }
        
    }];
    right.titleLabel.font = [UIFont systemFontOfSize:WRTitleFont];
    UIBarButtonItem* item  = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;

    UIView* bottom = [[UIView alloc]initWithFrame:CGRectMake(0, YYScreenSize().height-113-64, ScreenW,113) ];
    bottom.backgroundColor = [UIColor whiteColor];
    UIButton* cancel = [UIButton new];
    cancel.x = 47;
    cancel.y = 35;
    cancel.width = (ScreenW - 47*2)*1.0;
    cancel.height = 43;
    cancel.backgroundColor = [UIColor wr_rehabBlueColor];
    [cancel setTitle:@"删除" forState:0];
    [cancel setTitleColor:[UIColor whiteColor] forState:0];
    cancel.layer.cornerRadius = WRCornerRadius;
    cancel.layer.masksToBounds = YES;
    cancel.userInteractionEnabled =YES;
    [cancel bk_whenTapped:^{
        [self.choose enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.dataarr removeObject:obj];
        }];
        [self.tableView reloadData];
        [[NSUserDefaults standardUserDefaults]setObject:self.dataarr forKey:@"noti"];
    }];
    [bottom addSubview:cancel];
    [self.tableView addSubview:bottom];
    self.bottomView = bottom;
    bottom.hidden =YES;
    [self createBackBarButtonItem];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.bottomView.frame = CGRectMake(0, YYScreenSize().height-113-64+scrollView.contentOffset.y, ScreenW,113);
}
-(void)updateTable
{
//    [self.tableView reloadData];
    if (self.dataarr.count > 0) {
        self.tableView.backgroundView.hidden = YES;
    } else {
        if (!self.tableView.backgroundView) {
            self.tableView.backgroundView = [WRUIConfig createNoDataViewWithFrame:self.tableView.bounds title:NSLocalizedString(@"暂无系统通知", nil) image:[UIImage imageNamed:@"暂无消息图标"]];
        }
        self.tableView.backgroundView.hidden = NO;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self updateTable];
    return _dataarr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* noti = _dataarr[indexPath.row];
        if (_isedit&& indexPath.row == _dataarr.count-1 && _state ==0) {
        
        
        CGSize content = self.tableView.contentSize;
        content.height+=113;
        self.tableView.contentSize = content;
            _state = 2;
    }
    

    
    
    if ([noti[@"type"] isEqualToString:@"ask"]) {
        NotiAskCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"notiask"];
        cell.choose.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.choose containsObject:noti]) {
            [cell.choose setImage:[UIImage imageNamed:@"选中图标"]];
        }else
        {
            [cell.choose setImage:[UIImage imageNamed:@"well_icon_radio_gray"]];
        }
        cell.choose.hidden = !_isedit;
        cell.time.text = noti[@"time"];
        cell.content.text = noti[@"body"];
        return cell;

    }
    else
    {
        NotiArtCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"notiart"];
//        [cell.sender removeFromSuperview];
        cell.choose.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.choose containsObject:noti]) {
            [cell.choose setImage:[UIImage imageNamed:@"选中图标"]];
        }else
        {
            [cell.choose setImage:[UIImage imageNamed:@"well_icon_radio_gray"]];
        }
        cell.choose.hidden = !_isedit;
//        cell.time.text = noti[@"time"];
        cell.title.text = noti[@"body"];
        [cell.im setImageWithURL:[NSURL URLWithString:noti[@"imageUrl"]] placeholder:[UIImage imageNamed:@"well_favor_background"]];
        
//        cell.sender.userInteractionEnabled = YES;
        if (noti[@"isOpen"]) {
            cell.sender.layer.cornerRadius = WRCornerRadius;
            cell.sender.layer.masksToBounds =YES;
            cell.sender.layer.borderColor = [UIColor colorWithHexString:@"f1f1f1"].CGColor;
            cell.sender.layer.borderWidth =1;
            [cell.sender setTextColor:[UIColor colorWithHexString:@"f1f1f1"]];
            [cell.sender setText:@"已读"];
            
        }
        else
        {
            cell.sender.layer.cornerRadius = WRCornerRadius;
            cell.sender.layer.masksToBounds =YES;
            cell.sender.layer.borderColor = [UIColor wr_rehabBlueColor].CGColor;
            cell.sender.layer.borderWidth =1;
            [cell.sender setTextColor:[UIColor wr_rehabBlueColor]];
            [cell.sender setText:@"点击查看" ];
            
        }
        if (noti[@"article_uuid"]) {
            cell.sender.hidden = NO;
        }
        else
        {
            cell.sender.hidden = YES;
        }
        return cell;
    }
  
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* noti = _dataarr[indexPath.row];
    if (_isedit) {
        if (![self.choose containsObject:noti]) {
            [self.choose addObject:noti];
        }
        else
        {
            [self.choose removeObject:noti];
        }
        [self.tableView reloadData];
        _state = 0;
    }else
    {
        if ([noti[@"type"] isEqualToString:@"ask"]) {
            [self.navigationController pushViewController:[AskIndexController new] animated:YES];
        }
        
        if (noti[@"article_uuid"]) {
            [WRFAQViewModel userGetFavorStateWithArticleId:noti[@"article_uuid"] completion:^(NSError *error, WRArticle *article) {
                
                UINavigationController* navi  = self.navigationController;                ArticleDetailController* art = [ArticleDetailController new];
                art.hidesBottomBarWhenPushed = YES;
                art.currentNews = article;
                [navi pushViewController:art animated:YES];
                
            }];
            
        }
        
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 0;
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
