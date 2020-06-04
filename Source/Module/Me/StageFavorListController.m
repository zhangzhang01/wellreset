//
//  StageFavorListController.m
//  rehab
//
//  Created by herson on 2016/11/22.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "StageFavorListController.h"
#import "WRViewModel+Common.h"
#import "BaseCell.h"
#import "ArticleCell.h"
#import "ArticleDetailController.h"
#import "UIViewController+WR.h"
#import "GzwTableViewLoading.h"
#import "UMengUtils.h"
#import "WRRefreshHeader.h"
#import "RehabStageView.h"
#import "CWStarRateView.h"
#import "WRRehabStageController.h"
#import "CreatTreatController.h"
@interface StageFavorListController ()
{
    BOOL _flag;
    NSDate *_startDate;
}
@property(nonatomic) NSMutableArray *dataArray;
@property(nonatomic) UIButton* custom;
@property(nonatomic) NSMutableArray* choosearry;
@property(nonatomic) UIButton* gocreate;
@end

@implementation StageFavorListController

-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForMeWithType:@"favor" duration:duration];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    
    _startDate = [NSDate date];
    
    _dataArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    [self defaultStyle];
    __weak __typeof(self)weakself = self;
    self.tableView.buttonNormalColor = [UIColor clearColor];
    self.tableView.buttonHighlightColor = [UIColor clearColor];
    self.tableView.loadedImageName = @"well_default";
    NSString *desc = NSLocalizedString(@"没有收藏", nil);
    self.tableView.descriptionText = desc;
    self.tableView.dataVerticalOffset = -100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [WRRefreshHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    //    [self reloadFavor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:WRLogOffNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:WRLogInNotification object:nil];
    [WRNetworkService pwiki:@"动作收藏"];
    self.choosearry = [NSMutableArray array];
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenW-(57+27),YYScreenSize().height-(29+57)-64, 57, 57)];
    [btn setImage:[UIImage imageNamed:@"自定义图标"] forState:UIControlStateNormal];
    if (!self.chooes&&[WRUserInfo selfInfo].level>3) {
       [self.view addSubview:btn];
    }
    
    self.gocreate=btn;
    [btn bk_whenTapped:^{
        [self showCreateTreat];
    }];
    
    if (self.chooes) {
    btn = [[UIButton alloc]initWithFrame:CGRectMake(0,YYScreenSize().height-57-64, ScreenW, 57)];
    [btn setTitle:@"添加" forState:0];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.backgroundColor = [UIColor wr_themeColor];
    
        [self.view addSubview:btn];
    
    

    [btn bk_whenTapped:^{
        
        for (UIViewController* vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[CreatTreatController class]] ) {
                CreatTreatController* c = vc;
                c.isadd =YES;
                c.choosearry = self.choosearry;
                [self.navigationController popToViewController:c animated:YES];
            }
        }
    }];
    }
    
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_flag) {
        _flag = YES;
        //        [self loadData];
        [self reloadFavor];
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
        return 90;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.gocreate.y = YYScreenSize().height-(29+57)-64+scrollView.contentOffset.y;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier;
    id object = self.dataArray[indexPath.row];
//    identifier = [FillImageWithCenterTitleCell className];
    identifier = [@(indexPath.row) stringValue];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier ];
        //cell.textLabel.textColor = [UIColor whiteColor];
        //cell.detailTextLabel.hidden = YES;
    }
    [cell.contentView removeAllSubviews];
    FavorContent *content = object;
    WRTreatRehabStage *stage = (WRTreatRehabStage*)content.collectContent;
    UIImageView* im = [[UIImageView alloc]initWithFrame:CGRectMake(16, 0, 87, 49)];
    im.centerY = 90.f/2;
    
    [cell.contentView addSubview:im];
    
    [im setImageWithUrlString:stage.mtWellVideoInfo.thumbnailUrl holder:@"well_default_video"];
    
    UILabel* title = [UILabel new];
    title.x = im.right+20;
    title.y = 27;
    title.font = [UIFont systemFontOfSize:15];
    title.text = stage.mtWellVideoInfo.videoName;
    title.textColor = [UIColor wr_titleTextColor];
    [title sizeToFit];
    [cell.contentView addSubview:title];
    
    UILabel* detail = [UILabel new];
    detail.y = title.bottom+5;
    detail.font = [UIFont systemFontOfSize:13];
    if (stage.time>60) {
       
        detail.text = [NSString stringWithFormat:@"%.lf分钟%.ld秒",stage.time*1.0/60,stage.time%60];
    }
    else
    {
        detail.text = [NSString stringWithFormat:@"%.lf秒",stage.time*1.0];
    }
    detail.textColor = [UIColor wr_detailTextColor];
    [detail sizeToFit];
    detail.x = 16;
  //[cell.contentView addSubview:detail];
    
    CGFloat value = (CGFloat)(stage.difficulty%5)/5;
    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(im.right+20, title.bottom+8, 70, 14) numberOfStars:5];
    starRateView.scorePercent = value;
    starRateView.allowIncompleteStar = NO;
    starRateView.hasAnimation = NO;
    starRateView.userInteractionEnabled = NO;
   // [cell.contentView addSubview:starRateView];
    
    if (self.chooes) {
        UIImageView* chooseim = [UIImageView new];
        chooseim.width = 24;
        chooseim.height = 24;
        chooseim.centerY = 90*1.0/2;
        chooseim.right = ScreenW-16;
        if ([self.choosearry containsObject:content]) {
            [chooseim setImage:[UIImage imageNamed:@"选择勾选"]];
        }
        else
        {
            [chooseim setImage:[UIImage imageNamed:@"选择默认"]];
        }
        [cell.contentView addSubview:chooseim];
    }
    else
    {
        UIImageView* chooseim = [UIImageView new];
        chooseim.width = 24;
        chooseim.height = 24;
        chooseim.centerY = 90*1.0/2;
        chooseim.right = ScreenW-16;
     
        [chooseim setImage:[UIImage imageNamed:@"爱心"]];
       
        [cell.contentView addSubview:chooseim];
        [chooseim bk_whenTapped:^{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定取消收藏该动作" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                    
                    [WRViewModel operationWithType:OperationTypeFavor indexId:stage.indexId
                                        actionType:OperationActionTypeDelete
                                       contentType:[content.type isEqualToString:@"proTreatStage"]? OperationContentTypeProTreatStage:OperationContentTypeTreatStage
                                        completion:^(NSError * _Nonnull error) {
                                            if (error) {
                                                
                                                NSString *errorText = error.domain;
                                                [SVProgressHUD showErrorWithStatus:errorText];
                                            } else {
                                                [self loadData];
                                            }
                                        }];
            
                }];
                [alertController addAction:actionCancel];
                [self presentViewController:alertController animated:YES completion:nil];
            
            
            
            
            
        }];
    }
    
    
   // cell.detailTextLabel.text = content.createTime;
// cell.textLabel.text = stage.mtWellVideoInfo.videoName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //FavorContent *content = self.dataArray[indexPath.row];
    //WRTreatRehabStage *stage = (WRTreatRehabStage*)content.collectContent;
    /*
    WRRehabStageController *viewController = [[WRRehabStageController alloc] initWithTreatRehabStage:stage stageSets:@[stage] isProTreat:NO];
    [self.navigationController pushViewController:viewController animated:YES];
     */
    if (_chooes) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSMutableArray *array = [NSMutableArray array];
        for(FavorContent *content in self.dataArray)
        {
            [array addObject:content];
        }
        FavorContent *stage = array[indexPath.row];
        
        if ([self.choosearry containsObject:stage]) {
            [self.choosearry removeObject:stage];
        }
        else
        {
            [self.choosearry addObject:stage];
        }
        [self.tableView reloadData];
    }
    else
    {
    NSMutableArray *array = [NSMutableArray array];
    for(FavorContent *content in self.dataArray)
    {
        [array addObject:content.collectContent];
    }
    WRTreatRehabStage *stage = array[indexPath.row];
    UIView *rootView = [UIApplication sharedApplication].keyWindow;
    RehabStageView *stageView = [[RehabStageView alloc] initWithFrame:rootView.bounds treatRehabStage:stage stageSets:array isProTreat:NO isplaying:NO];
    stageView.frame = CGRectOffset(stageView.frame, 0, rootView.height);
    __weak __typeof(stageView) weakStageView = stageView;
    __weak __typeof(self)weakself = self;
    stageView.closeEvent = ^(RehabStageView* sender) {
        [weakself reloadFavor];
        [UIView animateWithDuration:0.35 animations:^{
            weakStageView.frame = [Utility moveRect:weakStageView.frame x:-1 y:rootView.height];
        } completion:^(BOOL finished) {
            [weakStageView removeFromSuperview];
        }];
    };
    [rootView addSubview:stageView];
    [UIView animateWithDuration:0.35 animations:^{
        stageView.frame = [Utility moveRect:stageView.frame x:-1 y:0];
    }];
    }
}

#pragma mark -
-(void)updateTableView
{
    if ([self tableView:self.tableView numberOfRowsInSection:0] == 0) {
        self.title = NSLocalizedString(@"没有收藏", nil);
        if (!self.tableView.backgroundView) {
            self.tableView.backgroundView = [WRUIConfig createNoDataViewWithFrame:self.tableView.bounds title:NSLocalizedString(@"还没有收藏任何动作呢！\n最有效的那个动作必须好好保存起来哦。", nil) image:[UIImage imageNamed:@"well_favor_background"]];
        }
        self.tableView.backgroundView.hidden = NO;
        
    } else {
        self.title = NSLocalizedString(@"收藏", nil);
        self.tableView.backgroundView.hidden = YES;
    }
    [self.tableView reloadData];
}

- (void)reloadFavor
{
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadData {
    if ([WRUserInfo selfInfo].isLogged) {
        __weak __typeof(self) weakSelf = self;
        [WRViewModel userGetCollectionListWithCompletion:^(NSError * _Nullable error, id _Nullable resultObject) {
            [weakSelf.tableView.mj_header endRefreshing];
            if (error) {
                [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
                    [weakSelf loadData];
                }];
            } else {
                weakSelf.dataArray = resultObject;
                [weakSelf updateTableView];
                
            }
        } type:OperationContentTypeStage];
    } else {
        self.dataArray = [NSMutableArray array];
        [self.tableView.mj_header endRefreshing];
        [self updateTableView];
    }
}

@end
