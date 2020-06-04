//
//  GuideCoverViewController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/8.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "GuideCoverViewController.h"
#import "GuideMeViewController.h"
#import "ShareData.h"
#import <YYKit/YYKit.h>
@interface GuideCoverViewController ()
{
    NSDate* _startDate;
}
@property (nonatomic) NSMutableArray<UIButton*>*  ButtonArry;
@property (nonatomic) NSMutableArray<UIImageView*>* IMArry;
@property (nonatomic) UILabel* detailLabel;
@property (nonatomic) UIButton* nextBtn;
@property (nonatomic) NSInteger n;
@end

@implementation GuideCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    self.title = NSLocalizedString(@"基本信息（3/4）", nil);
    
    self.ButtonArry = [NSMutableArray array];
    self.IMArry = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    self.n = self.titleArry.count;
    _startDate = [NSDate new];
    [self layout];
}
- (void)layout
{
    [self.view removeAllSubviews];
    [self createBackBarButtonItem];
    CGFloat bigOffset = WRUIBigOffset+WRUIOffset;
    UILabel* content = [UILabel new];
    content.text = NSLocalizedString(@"定制方案更加针对个人病情噢！", nil);
    content.font = [UIFont systemFontOfSize:WRDetailFont];
    content.textColor = [UIColor grayColor];
    content.textAlignment = NSTextAlignmentCenter;
    [content sizeToFit];
    content.y = WRUIBigOffset;
    content.centerX = self.view.centerX;
    [self.view addSubview:content];
    
    UILabel* wantLabel = [UILabel new];
    wantLabel.text = NSLocalizedString(@"选择方案", nil);
    wantLabel.font = [UIFont systemFontOfSize:WRTitleFont];
    wantLabel.textColor = [UIColor blackColor];
    [wantLabel sizeToFit];
    wantLabel.y = content.bottom + bigOffset;
    wantLabel.centerX = content.centerX;
    [self.view addSubview:wantLabel];
    
    
    
    CGFloat y = bigOffset+wantLabel.bottom;
    for (int i =0; i<self.titleArry.count; i++) {
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
    detailLabal.text = self.fist;
    detailLabal.font = [UIFont systemFontOfSize:WRDetailFont];
    detailLabal.textColor = [UIColor grayColor];
    detailLabal.numberOfLines = 0;
    
    detailLabal.y = y+bigOffset;
    detailLabal.x = WRUIBigOffset;
    detailLabal.width = self.view.width - WRUIDiffautOffset*2;
    detailLabal.centerX = self.view.centerX;
    detailLabal.textAlignment = NSTextAlignmentCenter;
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
    __weak __typeof__(self) weakSelf = self;
    [[self.nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        GuideMeViewController* me = [GuideMeViewController new];
        if (self.n==self.titleArry.count) {
            
        }
        else
        {
            
        NSString* str  = self.titleArry[self.n];
        if(([self.body isEqualToString:@"肩部"]||[self.body isEqualToString:@"腰部"]||[self.body isEqualToString:@"颈椎"])&&[self.titleArry[self.n] isEqualToString:@"定制方案"])
        {
            
            me.ispro =YES;
            NSArray* de =[ShareData data].proTreatDisease;
            if ([self.body isEqualToString:@"肩部"]) {
                self.body = @"肩背部";
            }
            for (WRRehabDisease* de in [ShareData data].proTreatDisease) {
                if ([de.diseaseName isEqualToString:self.body]) {
                    me.re = de;
                }
            }
            //锚点
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"dzfa"] attributes:nil counter:duration];
        }else
        {
            me.ispro =NO;
            NSArray* dee =[ShareData data].treatDisease;
            for (WRRehabDisease* de in [ShareData data].treatDisease) {
                if ([de.diseaseName isEqualToString:self.titleArry[self.n]]) {
                    me.re = de;
                }
            }
            //锚点
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"ksfa"] attributes:nil counter:duration];
        }
            [weakSelf.navigationController pushViewController:me animated:YES];
        }
        
        
        
    }];
    
    
    if (![self.titleArry containsObject:@"定制方案"]) {
        
    }
    
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
    
    self.detailLabel.text = self.detail[self.n]?self.detail[self.n]:self.fist;
    [self.detailLabel sizeToFit];
    _detailLabel.centerX = self.view.centerX;
    self.nextBtn.backgroundColor = [UIColor wr_themeColor];
    self.nextBtn.enabled = YES;
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
