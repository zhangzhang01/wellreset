//
//  WRReplyTableViewController.m
//  rehab
//
//  Created by Matech on 3/14/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "ReplyController.h"
#import "AskExpertViewModel.h"
#import "QuestionCell.h"
#import "MTFooter.h"
#import "WRRefreshHeader.h"
#import "WRReplyDetailController.h"
#import "WRAskDetailController.h"
#import <MJRefresh/MJRefresh.h>
#import "questionTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#define kMasonryCellw @"questionTableViewCell"
@interface ReplyController ()
@property(nonatomic)BOOL isIndex;
@property(nonatomic)NSString* stage;
@property NSMutableArray* dataArr;
@property NSArray* titlestageArray;
@property UITableView* mytableview;
@property NSArray* titledetailArray;

@property(nonatomic)AskExpertViewModel *viewModel;

@property int page;

@end

@implementation ReplyController

-(instancetype)initWithFlag:(BOOL)isIndex withstage:(NSString *)stage{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        _isIndex = isIndex;
         _stage = stage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _titlestageArray = [NSArray arrayWithObjects:@"什么是WELL健康？",@"物理治疗是什么？",@"我患有几种疾病，可以同时做多套运动吗？",@"这些动作每天要锻炼多久呢？",@"我可以依照自己的意愿选择是否进行康复训练吗？",@"我没有病，只是想预防，可以锻炼吗？",@"锻炼完肌肉酸痛才有效果吗？",@"早上锻炼好，还是晚上呢？",@"当我放假或者太忙于工作时我可以短时间暂停一下训练吗？",@"我是否应该在除针对性训练外，进行一些常规训练?",@"可以自己调整拉伸保持时间吗？",@"定制的动作可以更改吗？",@"我可以在任何地方进行康复训练吗？",@"我感觉我一开始的训练很有效果，但后来改进效果变慢了，这是为什么呢？",@"我的症状没有得到改善应该怎么做？",@"怎样可以方案升阶？", nil];
    
    _titledetailArray = [NSArray arrayWithObjects:@"WELL健康是指由中英康复治疗专家团队设计开发的智能康复手机APP。患者通过WELL健康APP，可以定制针对性的运动康复⽅案，并达到缓解疼痛、提高生活质量的效果。目前，WELL健康可面向骨骼肌肉类慢性疾病患者，如腰椎间盘突出症、腰椎病、颈椎病、肩周炎、鼠标手、网球肘、膝关节疼痛等，及涉及到体态调整的相关疾病患者，如O型腿、X型腿、扁平足、高低肩等，提供针对性性的运动康复方案。",@"根据英国注册物理治疗师协会的定义，物理治疗通常是指通过运动康复训练、手法治疗、健康教育与指导，帮助因受伤、疾病、残疾造成活动功能障碍的人最大限度地恢复身体功能，提高其独立生活与工作的能力。",@"可以同时定制多套运动方案进行锻炼，建议动作之间多进行休息，防止身体太疲劳。",@"通常建议每套方案每天3组，每组10次。随着身体慢慢适应运动量，可逐渐增加动作次数和强度。例如，每个动作增加2次。如果练习过程或第二天出现不适或疼痛加剧，可降低动作强度和减少动作次数。如还是出现不适建议及时停止锻炼此动作。",@"可以的。您可以仔细感受和观察比较身体在康复锻炼前中后的反应，然后根据身体感受适当增减动作强度和次数。例如：锻炼完之后感觉非常轻松，说明这个动作适合您。但如果锻炼后感觉非常疲劳，那么下次锻炼时可适当降低运动强度或减少次数，或延长锻炼间的休息时间。",@"可以的。APP内有专门的腰痛和颈椎疼痛的预防方案，建议添加APP内的预防方案进行锻炼。",@"锻炼完肌肉出现轻微酸痛，通常是因为身体还没有适应动作强度，这是正常的。但如果练习完出现剧烈疼痛，则可能是动作强度太大或动作不准确所致。这时建议降低动作强度，如还是无法改善应及时停止运动。",@"任何时候锻炼效果都是一样的，不过如果您每天要重复多组运动，建议将时间分隔开，让肌肉得到足够的休息和恢复。例如，每天重复锻炼3组，每组十次，那么您可以在早中晚分开三次锻炼。",@"是可以的。如在康复期，如果实在太忙，建议坚持至少每天1次的康复锻炼。如果是在康复后疼痛已基本消失，建议坚持每周1-2次肌肉拉伸和3-4次的肌肉强化训练。",@"尽可能地保持活跃和健康对您的身体永远都有益处。一些柔韧的、低强度的锻炼可能会更容易开始，您可以请教一下专业的物理治疗师给您更进一步的建议。",@"肌肉拉伸保持时间最好不要超过30秒。如果动作需要保持拉伸，最好按照方案规定的时间来，如果症状比较严重可以适当减少保持时间。如果动作没有说需要保持，就不用保持，以防造成运动损伤。",@"您好，目前定制方案后无法自己手动更改方案。如需修改方案，建议联系客服【客服微信号：WELL-one】。",@"是的，可以。您可以在站着、走着或躺着的时候进行康复训练。但康复训练的动作有时候会涉及到躺下或者坐下的动作，此时您应选择合理的位置去做康复训练。",@"改进效果变慢是一件常见的事情。当您一开始进行肌肉训练时，尤其是在您虚弱的时候，您会感觉很快就有效果，虽然一段时间后改善的速率就会变慢，但是您此时更应该加强练习来继续保持训练效果。",@"可联系【WELL健康】的康复助手微信（微信号：WELL-one）检查和测试您练习的方法是否正确。",@"连续打卡14天（要求至少每天打开一次APP完成一次锻炼）后，APP会自动弹出运动方案升阶提示。届时，您只要按照提示进行操作即可。", nil];
    __weak __typeof(self)weakSelf = self;
    self.viewModel = [[AskExpertViewModel alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[questionTableViewCell class] forCellReuseIdentifier:kMasonryCellw];
    self.page = 1;
    _mytableview = self.tableView;
//    self.tableView.rowHeight = 100;
    // Do any additional setup after loading the view.
    WRRefreshHeader *header = [[WRRefreshHeader alloc] init];
    header.refreshingBlock = ^{
        [weakSelf onRefresh];
    };
    self.tableView.mj_header = header;
    [self loadData];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.mj_footer = [MTFooter footerWithRefreshingBlock:^{
        [weakSelf loadAdd];
    }];
}
- (void)loadAdd
{
    if ([_stage isEqualToString:@"0"]) {


        [self.viewModel fetchIndexDatapage:++self.page pageSize:20 WithBlock:^(NSError * _Nonnull error) {
           
                [self.dataArr  addObjectsFromArray:self.viewModel.dataArray];
                NSLog(@"%ld",self.viewModel.dataArray.count);
                NSLog(@"%ld",self.dataArr.count);
           
           
            if (self.viewModel.dataArray.count>0) {
                [self.tableView reloadData];
            }
            [self.tableView.mj_footer endRefreshing];
        }];
    }else
    {
         [self.tableView.mj_footer endRefreshing];
        
    }

    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate&Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_stage isEqualToString:@"2"]) {
        return self.titlestageArray.count;
      
    }else{
        
         return self.dataArr.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_stage isEqualToString:@"2"]) {
       
        questionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMasonryCellw];
        
        
        [self configureCell:cell atIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.weakSelf = self;
        return cell;
    }else{
       
        static NSString *identifier = @"cell";
        QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.model = self.dataArr[indexPath.row];
        return cell;
        
        
      
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([_stage isEqualToString:@"2"])
    {
      
        // 计算缓存cell的高度
        return [self.tableView fd_heightForCellWithIdentifier:kMasonryCellw cacheByIndexPath:indexPath configuration:^(questionTableViewCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
            
        }];
    }else{
        
        // 取出模型
        WRExpertReply *model = self.dataArr[indexPath.row];
        model.cellWidth = tableView.width;
        return model.cellHeight;
        
      
    }
  
}
#pragma mark - 给cell赋值
- (void)configureCell:(questionTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    // 采用计算frame模式还是自动布局模式，默认为NO，自动布局模式
    //        cell.fd_enforceFrameLayout = NO;
//   
       [cell setValueWithTitle:_titlestageArray[indexPath.row] withDetail:_titledetailArray[indexPath.row]];
    
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = indexPath.row;
    WRExpertReply *object = self.dataArr[index];
    if ([_stage isEqualToString:@"0"]) {
        WRReplyDetailController *viewController = [[WRReplyDetailController alloc] init];
        viewController.model = object;
        [self.navigationController pushViewController:viewController animated:YES];
        viewController.title = self.title;

    }
    if ([_stage isEqualToString:@"1"])
    {
        WRAskDetailController *viewController = [[WRAskDetailController  alloc] init];
        viewController.model = object;
        [self.navigationController pushViewController:viewController animated:YES];
        viewController.title = self.title;
    }else{
        
    }
    
}

#pragma mark -
-(void)updateTable
{
    [self.tableView reloadData];
    if (self.dataArr.count > 0) {
        self.tableView.backgroundView.hidden = YES;
    } else {
        if (!self.tableView.backgroundView) {
            self.tableView.backgroundView = [WRUIConfig createNoDataViewWithFrame:self.tableView.bounds title:NSLocalizedString(@"暂无提问", nil) image:[UIImage imageNamed:@"暂无提问图标"]];
        }
        self.tableView.backgroundView.hidden = NO;
    }
}

-(void)onRefresh
{
    [self.viewModel clearData];
    [self.tableView reloadData];
    [self loadData];
}

-(void)loadData {
    
    self.page = 1;
    __weak __typeof(self) weakSelf = self;
    if (self.viewModel.isLastPage) {
        NSLog(@"last page");
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    if ([_stage isEqualToString:@"0"]) {
        [self.viewModel fetchIndexDatapage:1 pageSize:20 WithBlock:^(NSError * _Nonnull error) {
            if (error) {
                [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
                    [weakSelf loadData];
                }];

            } else {
                self.dataArr = self.viewModel.dataArray;
                [weakSelf updateTable];
                [self.tableView.mj_header endRefreshing];
//                if (!weakSelf.tableView.mj_footer) {
//                    weakSelf.tableView.mj_footer = [MTFooter footerWithRefreshingBlock:^{
//                        [weakSelf loadData];
//                    }];
//                }
                
//                if (weakSelf.viewModel.isLastPage) {
//                    NSLog(@"last page");
//                    weakSelf.tableView.mj_footer = nil;
//                }

            }
        }];
    } else if([_stage isEqualToString:@"1"]) {
        
            [self.viewModel fetchDataWithBlock:^(NSError * _Nonnull error) {
                if (error) {
                    [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
                        [weakSelf loadData];
                    }];
                    
                } else {
                    if ([_stage isEqualToString:@"1"]) {
                        
                        self.dataArr = self.viewModel.dataArray;
                        for(WRExpertReply *reply in weakSelf.viewModel.dataArray)
                        {
                            reply.userName = [WRUserInfo selfInfo].name;
                            reply.headImage = [WRUserInfo selfInfo].headImageUrl;
                        }
                    }
                    [weakSelf updateTable];
                }
            }];
       
        
        
    }else{
        
        [self.dataArr removeAllObjects];
        [self.viewModel clearData];
        [self.tableView reloadData];
        
       
    }
//    [weakSelf.tableView.mj_footer endRefreshing];
    [weakSelf.tableView.mj_header endRefreshing];
}
@end
