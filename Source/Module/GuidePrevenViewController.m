//
//  GuidePrevenViewController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/7.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "GuidePrevenViewController.h"
#import "GuideMeViewController.h"
#import "PreventViewModel.h"
#import <YYKit/YYKit.h>
@interface GuidePrevenViewController ()
{
    NSDate* _startDate;
}
@property (nonatomic) NSMutableArray<UIButton*>*  ButtonArry;
@property (nonatomic) NSMutableArray<UIImageView*>* IMArry;
@property (nonatomic) UILabel* detailLabel;
@property (nonatomic) UIButton* nextBtn;
@property (nonatomic) PreventViewModel* viewModel;
@property (nonatomic) NSArray* titleArry;
@property (nonatomic) NSInteger n;
@end

@implementation GuidePrevenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"基本信息（2/3）", nil);
    self.n = 3;
    self.titleArry = @[@"在家里",@"在路上",@"上班时"];
    
    self.ButtonArry = [NSMutableArray array];
    self.IMArry = [NSMutableArray array];
    self.viewModel = [PreventViewModel new];
    [self fetch];
     [self createBackBarButtonItem];
    
//    [self layout];
    // Do any additional setup after loading the view.
}
-(void)fetch
{
    [self.viewModel fetchDataWithCompletion:^(NSError *error) {
        if (!error) {
            [self layout];
        }
    }];
}
- (void)layout
{
    
    [self.view  removeAllSubviews];
    CGFloat bigOffset = WRUIBigOffset+WRUIOffset;
    UILabel* content = [UILabel new];
    content.text = NSLocalizedString(@"欢迎您使用预防方案\n请选择适合您锻炼的场景。", nil);
    content.font = [UIFont systemFontOfSize:WRDetailFont];
    content.textColor = [UIColor grayColor];
    [content sizeToFit];
    content.textAlignment = NSTextAlignmentCenter;
    content.y = WRUIBigOffset;
    content.centerX = self.view.centerX;
    [self.view addSubview:content];
    
    UILabel* wantLabel = [UILabel new];
    wantLabel.text = NSLocalizedString(@"选择场景", nil);
    wantLabel.font = [UIFont systemFontOfSize:WRTitleFont];
    wantLabel.textColor = [UIColor blackColor];
    [wantLabel sizeToFit];
    wantLabel.y = content.bottom + bigOffset;
    wantLabel.centerX = content.centerX;
    [self.view addSubview:wantLabel];
    
    
    
    CGFloat y = bigOffset+wantLabel.bottom;
    for (int i =0; i<3; i++) {
        UIButton*  recoverBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, y, 224, 43)];
        [recoverBtn setTitle:self.titleArry[i] forState:0];
        [recoverBtn setBackgroundColor:[UIColor wr_buttonDeffaultColor]];
        recoverBtn.tag = 100+i;
        [recoverBtn setTitleColor:[UIColor whiteColor] forState:0];
        recoverBtn.titleLabel.font = [UIFont systemFontOfSize:WRMidButtonFont];
        recoverBtn.centerX = self.view.centerX;
        [recoverBtn addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        [self.ButtonArry addObject:recoverBtn];
        [self.view addSubview:recoverBtn];
        
        
        
        UIImageView* recoverIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"选中图标"]];
        recoverIM.width = 16;
        recoverIM.height =16;
        recoverIM.right = recoverBtn.left - WRUIDiffautOffset;
        recoverIM.centerY = recoverBtn.centerY;
        recoverIM.hidden =YES;
        [self.IMArry addObject:recoverIM];
        [self.view addSubview:recoverIM];
        y += 36+43;

    }
    
    y-= 43;
    
    UILabel* detailLabal = [UILabel new];
    
    detailLabal.font = [UIFont systemFontOfSize:WRDetailFont];
    detailLabal.textColor = [UIColor grayColor];
    [detailLabal sizeToFit];
    detailLabal.y = y+bigOffset;
    detailLabal.x = WRUIBigOffset;
    detailLabal.textAlignment = NSTextAlignmentCenter;
    self.detailLabel = detailLabal;
    detailLabal.width = self.view.width - WRUIDiffautOffset*2;
    
    detailLabal.numberOfLines = 0;
    [self.view addSubview:detailLabal];
    
    UIButton*  nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height-43-40, 281, 43)];
    [nextBtn setTitle:NSLocalizedString(@"下一步",nil) forState:0];
    [nextBtn setBackgroundColor:[UIColor wr_buttonDeffaultColor]];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:WRBigButtonFont];
    nextBtn.centerX = self.view.centerX;
    self.nextBtn = nextBtn;
    
    [self.view addSubview:nextBtn];
    
    [[self.nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        if (self.n != 3) {
            GuideMeViewController* me = [GuideMeViewController new];
            me.index = self.n;
            me.type = 1;
            me.scene = self.viewModel.scenes[self.n];
            [self.navigationController pushViewController:me animated:YES];
            //锚点
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            switch (self.n) {
                case 0:
                     [MobClick event:[NSString stringWithFormat:@"jiazhong"] attributes:nil counter:duration];
                    break;
                case 1:
                    [MobClick event:[NSString stringWithFormat:@"lushang"] attributes:nil counter:duration];
                    break;
                case 2:
                    [MobClick event:[NSString stringWithFormat:@"shangban"] attributes:nil counter:duration];
                    break;
                    
                default:
                    break;
            }
            
            
        }
    }];
}
-(void)chooseType:(UIButton*)sender
{
    for (UIButton* btn in self.ButtonArry) {
        btn.backgroundColor = [UIColor wr_buttonDeffaultColor];
    }
    for (UIImageView* im in self.IMArry) {
        im.hidden=YES;
    }
    
    self.n = sender.tag-100;
    sender.backgroundColor = [UIColor wr_themeColor];
    UIImageView* senderIm = self.IMArry[self.n];
    senderIm.hidden = NO;
    
    switch (self.n) {
        case 0:
            _detailLabel.text = @"在家里小提示\n更方便在家中锻炼，注意力集中会让效果更好哦~";
            [_detailLabel sizeToFit];
            _detailLabel.centerX = self.view.centerX;
            
            break;
        case 1:
            _detailLabel.text = @"在路上小提示\n让你等车、坐车或走路时也能练习的超便利方案哦~";
            [_detailLabel sizeToFit];
            _detailLabel.centerX = self.view.centerX;
            
            break;
        case 2:
            _detailLabel.text = @"在上班小提示\n上班休息时锻炼一下，既不太花时间，又能远离久坐病哦~";
            [_detailLabel sizeToFit];
            _detailLabel.centerX = self.view.centerX;
            
            
            break;
            
        default:
            break;
    }

    self.nextBtn.backgroundColor = [UIColor wr_themeColor];
    self.nextBtn.enabled = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    _startDate = [NSDate new];
}
-(void) onClickedBackButton:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
