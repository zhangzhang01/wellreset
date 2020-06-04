
//
//  GuidIndexViewController.m
//  rehabhd
//
//  Created by yongen zhou on 2017/3/6.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "GuidIndexViewController.h"
#import "WRBodySelectorController.h"
#import "GuidePrevenViewController.h"
#import "UserViewModel.h"
#import <YYKit/YYKit.h>
@interface GuidIndexViewController ()
{
    NSDate* _startDate;
}
@property (nonatomic) UIButton* recoverBtn;
@property (nonatomic) UIImageView* recoverIm;
@property (nonatomic) UIButton* prevenBtn;
@property (nonatomic) UIImageView* prevenIm;
@property (nonatomic) UILabel* detailLabel;
@property (nonatomic) UIButton* nextBtn;
@property (nonatomic) UserViewModel* viewmodel;

@property (nonatomic) NSInteger n;
@end

@implementation GuidIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"请选择目的", nil);
    self.n = 2;
   
    _viewmodel =[[UserViewModel alloc]init];
    [self fetchrehab];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor whiteColor]] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedBackButton:)];
    self.navigationItem.leftBarButtonItem = item;
    // Do any additional setup after loading the view.
}
-(void)onClickedBackButton:(UIBarButtonItem *)sender
{
    return;
}
- (void)layout
{
    
    CGFloat bigOffset = WRUIBigOffset+WRUIOffset;
    UILabel* content = [UILabel new];
    content.text = NSLocalizedString(@"WELL健康为您效劳\n全面提供个性化、安全、有效的运动方案。", nil);
    content.font = [UIFont systemFontOfSize:WRDetailFont];
    content.textColor = [UIColor grayColor];
    content.numberOfLines = 2;
    content.textAlignment = NSTextAlignmentCenter;
    content.width = self.view.width - WRUIDiffautOffset*2;
    [content sizeToFit];
    content.y = WRUIBigOffset;
    content.centerX = self.view.centerX;
    [self.view addSubview:content];
    
    UILabel* wantLabel = [UILabel new];
    wantLabel.text = NSLocalizedString(@"我要", nil);
    wantLabel.font = [UIFont systemFontOfSize:WRTitleFont];
    wantLabel.textColor = [UIColor blackColor];
    [wantLabel sizeToFit];
    wantLabel.y = content.bottom + bigOffset;
    wantLabel.centerX = content.centerX;
    [self.view addSubview:wantLabel];
    
    UIButton*  recoverBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, bigOffset+wantLabel.bottom, 224, 43)];
    [recoverBtn setTitle:NSLocalizedString(@"康复",nil) forState:0];
    [recoverBtn setBackgroundColor:[UIColor wr_buttonDeffaultColor]];
    [recoverBtn setTitleColor:[UIColor whiteColor] forState:0];
    recoverBtn.titleLabel.font = [UIFont systemFontOfSize:WRMidButtonFont];
    recoverBtn.centerX = self.view.centerX;
    self.recoverBtn = recoverBtn;

    [self.view addSubview:recoverBtn];
    
    UIImageView* recoverIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"选中图标"]];
    recoverIM.height = 16;
    recoverIM.width = 16;
    recoverIM.right = recoverBtn.left - WRUIDiffautOffset;
    recoverIM.centerY = recoverBtn.centerY;
    recoverIM.hidden =YES;
    self.recoverIm = recoverIM;
    [self.view addSubview:recoverIM];

    UIButton*  prevenBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, bigOffset+recoverBtn.bottom, 224, 43)];
    [prevenBtn setTitle:NSLocalizedString(@"预防",nil) forState:0];
    [prevenBtn setBackgroundColor:[UIColor wr_buttonDeffaultColor]];
    [recoverBtn setTitleColor:[UIColor whiteColor] forState:0];
    prevenBtn.titleLabel.font = [UIFont systemFontOfSize:WRMidButtonFont];
    prevenBtn.centerX = self.view.centerX;
    self.prevenBtn = prevenBtn;
    
    [self.view addSubview:prevenBtn];
    
    UIImageView* prevenIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"选中图标"]];
    prevenIM.height = 16;
    prevenIM.width = 16;
    prevenIM.right = prevenBtn.left - WRUIDiffautOffset;
    prevenIM.centerY = prevenBtn.centerY;
    prevenIM.hidden = YES;
    self.prevenIm = prevenIM;
    [self.view addSubview:prevenIM];
    
    UILabel* detailLabal = [UILabel new];
    detailLabal.text = @"";
    detailLabal.font = [UIFont systemFontOfSize:WRDetailFont];
    detailLabal.numberOfLines = 0;
    detailLabal.textAlignment = NSTextAlignmentCenter;
    detailLabal.textColor = [UIColor grayColor];
    detailLabal.y = prevenBtn.bottom+bigOffset;
    detailLabal.width = self.view.width - WRUIBigOffset*2;
    [detailLabal sizeToFit];
    detailLabal.centerX = self.view.centerX;
    
    self.detailLabel = detailLabal;
    [self.view addSubview:detailLabal];
    
    UIButton*  nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height-43-40-64, 281, 43)];
    [nextBtn setTitle:NSLocalizedString(@"下一步",nil) forState:0];
    [nextBtn setBackgroundColor:[UIColor wr_buttonDeffaultColor]];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:WRBigButtonFont];
    nextBtn.centerX = self.view.centerX;
    self.nextBtn = nextBtn;
    
    [self.view addSubview:nextBtn];
    
    
    
}
-(void)action
{
    __weak __typeof__(self) weakSelf = self;
    [[self.recoverBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        weakSelf.n = 0;
        weakSelf.recoverBtn.backgroundColor = [UIColor wr_themeColor];
        weakSelf.prevenBtn.backgroundColor = [UIColor wr_buttonDeffaultColor];
        weakSelf.recoverIm.hidden = NO;
        weakSelf.prevenIm.hidden = YES;
        weakSelf.title = @"基本信息（1/4）";
        weakSelf.detailLabel.text = @"康复小提示：\n如果您已出现疼痛、麻木等症状，康复方案能助您重获健康。";
        weakSelf.detailLabel.textAlignment = NSTextAlignmentCenter;
        weakSelf.detailLabel.numberOfLines = 0;
        weakSelf.detailLabel.width = self.view.width - WRUIDiffautOffset*2;
        [weakSelf.detailLabel sizeToFit];
        
        weakSelf.detailLabel.centerX = self.view.centerX;
        weakSelf.nextBtn.backgroundColor = [UIColor wr_themeColor];
        weakSelf.nextBtn.enabled = YES;
    }];
    
    [[self.prevenBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        weakSelf.n = 1;
        weakSelf.prevenBtn.backgroundColor = [UIColor wr_themeColor];
        weakSelf.recoverBtn.backgroundColor = [UIColor wr_buttonDeffaultColor];
        weakSelf.recoverIm.hidden = YES;
        weakSelf.prevenIm.hidden = NO;
        weakSelf.title = @"基本信息（1/3）";
        weakSelf.detailLabel.text = @"预防小提示：\n运动方案助你及时预防，远离骨骼肌肉慢性病。";
        weakSelf.detailLabel.numberOfLines = 0;
        weakSelf.detailLabel.width = self.view.width - WRUIDiffautOffset*2;
        weakSelf.detailLabel.textAlignment = NSTextAlignmentCenter;
        [weakSelf.detailLabel sizeToFit];
        
        weakSelf.detailLabel.centerX = self.view.centerX;
        weakSelf.nextBtn.backgroundColor = [UIColor wr_themeColor];
        weakSelf.nextBtn.enabled = YES;
    }];
    
    [[self.nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        if (weakSelf.n != 2) {
            if (weakSelf.n==0) {
                [weakSelf.navigationController pushViewController:[WRBodySelectorController new] animated:YES];
                //锚点
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"kangfu"] attributes:nil counter:duration];
            }
            else
            {
                [weakSelf.navigationController pushViewController:[GuidePrevenViewController new] animated:YES];
                //锚点
                NSDate *now = [NSDate date];
                int duration = (int)[now timeIntervalSinceDate:_startDate];
                [MobClick event:[NSString stringWithFormat:@"yufang"] attributes:nil counter:duration];
            }
        }
    }];
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fetchrehab
{
    [UserViewModel fetchPersonDataWithCompletion:^(NSError *error){
        [self layout];
        [self action];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    _startDate = [NSDate new];
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
