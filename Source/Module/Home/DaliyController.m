//
//  DaliyController.m
//  rehab
//
//  Created by yongen zhou on 2017/2/28.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "DaliyController.h"
#import "WRObject.h"
#import "WRUserInfo.h"
#import "UIKit+WR.h"
#import "UserdaliyViewModel.h"
#import "JCAlertView.h"
#import "UserBasicInfoController.h"
#import "BindClientViewController.h"
#import "WRUserInfo.h"
#import <YYKit/YYKit.h>
@interface DaliyController ()
{
    UIScrollView *_bgScrooll;
}
@property (nonatomic)WRDaliy * myDaliy;
@property (nonatomic)UserdaliyViewModel* viewmodel;
@property (nonatomic)NSString* alertstr;
@end

@implementation DaliyController
-(instancetype)init
{
    if (self = [super init]) {
        _bgScrooll  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _bgScrooll.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_bgScrooll];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //模拟数据
   [self createBackBarButtonItem];
    [self viewWillAppear:YES];
    self.title =@"日常任务";
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _myDaliy = [WRDaliy new];
    _myDaliy.nextlevelXP = 100;
    _myDaliy.currenLevel = 3;
    _myDaliy.nextLevel = 4;
    _myDaliy.currentXP = 28;
    _myDaliy.hadSignDays =3;
//    _myDaliy.awardArry = @[@"动作收藏+1",@"缓解方案解锁+2",@"每周提问+1"];
    _myDaliy.isFinishData = NO;
    _myDaliy.isBlinkPhone = NO;
    self.viewmodel = [UserdaliyViewModel new];
    
//    _bgScrooll.frame  = self.view.frame;
    
  [self fetchData];
    [self layoutBgscrooll];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - creataCell
-(UIView*)creataTopCell
{
    UIView* pandel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    UIImageView* iconIM = [UIImageView new];
    
    iconIM.width = 42;
    iconIM.height = 42;
    iconIM.x = WRUIDiffautOffset;
    iconIM.y = WRUIDiffautOffset;
    
    [iconIM setImageWithURL:[NSURL URLWithString:[WRUserInfo selfInfo].headImageUrl] placeholder:[WRUIConfig defaultHeadImage]];
    [iconIM wr_roundFill];
    
    UIImageView* levelIM = [UIImageView new];
    [levelIM wr_roundFill];
    NSLog(@"%lf",iconIM.bottom);
    levelIM.width = 20;
    levelIM.height = 20;
    levelIM.bottom = iconIM.bottom;
    levelIM.centerX = iconIM.right-4;
    
    [levelIM setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%ld",self.myDaliy.currenLevel]]];
    
    UILabel* name = [UILabel new];
    name.x = WRUIBigOffset+iconIM.right;
    name.y = WRUIBigOffset;
    name.font = [UIFont systemFontOfSize:WRDetailFont];
    name.textColor = [UIColor wr_titleTextColor];
    name.text = [WRUserInfo selfInfo].name;
    if ([name.text isEqualToString:@""]) {
        name.text = @"WELL健康用户";
    }
    [name sizeToFit];
    
    UIProgressView *pro = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    pro.frame=CGRectMake(iconIM.right + WRUIBigOffset, name.bottom+WRUILittleOffset, self.view.width-4*WRUIBigOffset-iconIM.width, 8);
    pro.trackTintColor=[UIColor wr_lightGray];
    pro.progressTintColor=[UIColor wr_rehabBlueColor];
    [pro setProgress:(float)self.myDaliy.currentXP/self.myDaliy.nextlevelXP animated:YES];
    pro.transform = CGAffineTransformMakeScale(1.0f, 2.0f);
    
    UILabel* XPdetalLabel = [UILabel new];
    XPdetalLabel.x = pro.left;
    XPdetalLabel.y = pro.bottom+WRUILittleOffset;
    XPdetalLabel.font = [UIFont wr_smallestFont];
    XPdetalLabel.textColor = [UIColor darkGrayColor];
    XPdetalLabel.text = [NSString stringWithFormat:@"(升级还需%ldxp)",self.myDaliy.nextlevelXP-self.myDaliy.currentXP];
    [XPdetalLabel sizeToFit];
    
    UILabel* XPLabel = [UILabel new];
    XPLabel.text = [NSString stringWithFormat:@"%ld/%ldXP",self.myDaliy.currentXP,self.myDaliy.nextlevelXP];
    if (self.myDaliy.currenLevel == 10) {
        XPLabel.text = @"Max";
        pro.progress= 1;
        XPdetalLabel.text = @"等级已满";
    }
    XPLabel.font = [UIFont wr_detailFont];
    [XPLabel sizeToFit];
    XPLabel.right = pro.right;
    XPLabel.y = name.top;
    XPLabel.textAlignment = NSTextAlignmentRight;
    
    XPLabel.textColor = [UIColor darkTextColor];
    
    
    
    [pandel addSubview:iconIM];
    [pandel addSubview:levelIM];
    [pandel addSubview:name];
    
    [pandel addSubview:pro];
    [pandel addSubview:XPdetalLabel];
    [pandel addSubview:XPLabel];
    
    pandel.height = XPdetalLabel.bottom+WRUIBigOffset;

    return pandel;
}
-(UIView*)creataAwardCell
{
    UIView* pandel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    
    UIImageView* awardIm = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"奖杯"]];
    awardIm.x = WRUIBigOffset;
    awardIm.y = WRUIBigOffset-WRUILittleOffset;
    awardIm.width = 16;
    awardIm.height = 14;
    [pandel addSubview:awardIm];
    
    UILabel* title = [UILabel new];
    title.x = awardIm.right+WRUIOffset;
    title.y = awardIm.top;
    title.font = [UIFont wr_detailFont];
    title.textColor = [UIColor wr_themeColor];
    title.text = [NSString stringWithFormat:@"LV%ld奖励",_myDaliy.nextLevel];
    [title sizeToFit];
    [pandel addSubview:title];
    
    if (self.myDaliy.currenLevel == 10) {
        title.text = @"LV10奖励";
        [title sizeToFit];
    }
    
    CGFloat offset = WRUIOffset;
    CGFloat y = title.bottom + offset;
    for (int i=0; i<_myDaliy.awardArry.count; i++) {
        UILabel* detailSingle = [UILabel new];
        detailSingle.x = title.left;
        detailSingle.y = y+WRUILittleOffset*i+10*i;
        detailSingle.textColor = [UIColor darkTextColor];
        detailSingle.font = [UIFont systemFontOfSize:WRDetailFont];
        NSDictionary* award = (NSDictionary*) _myDaliy.awardArry[i];
        detailSingle.text = [NSString stringWithFormat:@"%@ %@",award[@"text"],award[@"expression"]] ;
        [detailSingle sizeToFit];
        [pandel addSubview:detailSingle];
        
    }
    pandel.height = y+(WRUILittleOffset+10)*_myDaliy.awardArry.count+WRUIBigOffset-WRUILittleOffset+WRUIBigOffset;
    
    return pandel;
}
-(UIView*)creataTaskCell
{
    UIView* pandel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    UILabel* title = [UILabel new];
    title.x = WRUIBigOffset;
    title.y = WRUIOffset;
    title.textColor = [UIColor darkTextColor];
    title.font = [UIFont systemFontOfSize:13];
    title.text = @"日常任务";
    [title sizeToFit];
    [pandel addSubview:title];
    
    UIImageView* taskIM = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"日常任务说明内容"]];
    taskIM.width = 14;
    taskIM.height =14;
    taskIM.x = title.right+WRUILittleOffset;
    taskIM.centerY = title.centerY;
//    [taskIM sizeToFit];
    [pandel addSubview:taskIM];
    taskIM.userInteractionEnabled =YES;
    
    
    
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(WRUILittleOffset, title.bottom+WRUIOffset, self.view.width-2*WRUILittleOffset, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [pandel addSubview:line];
    
    CGFloat offset = line.bottom+WRUIBigOffset-WRUILittleOffset;
    NSInteger count = self.myDaliy.taskarry.count;
    NSString* signDay;
    if (5-self.myDaliy.hadSignDays>0) {
        signDay =[NSString stringWithFormat:@"连续签到（%ld天）",5-self.myDaliy.hadSignDays];
        
    }
    else
    {
        signDay =[NSString stringWithFormat:@"连续签到"];
    }
    
    
    
    
    
    
    NSMutableArray* taskarry = [NSMutableArray array];
    NSMutableArray* taskxparry = [NSMutableArray array];
    
    
    NSMutableArray* taskIsfinshArry = [NSMutableArray array];
    NSMutableArray* stringarr =[NSMutableArray array];
    
    
    
    
    for (NSDictionary* dic in self.myDaliy.taskarry ) {
        
        if ([dic[@"title"]isEqualToString:@"信息完善"]&&[dic[@"state"] boolValue])
        {
//            if ([WRUserInfo selfInfo].height!=0&&[WRUserInfo selfInfo].weight!=0) {
//                [taskarry addObject:dic[@"title"]];
//                [taskxparry addObject:dic[@"experience"]];
//                [taskIsfinshArry addObject:dic[@"state"]];
//                
//                [stringarr addObject:dic[@"detail"]];
//
//            }
//            else
//            {
//                
//            }
            
        }
        else if([dic[@"title"]isEqualToString:@"绑定手机"]&&[dic[@"state"] boolValue])
        {}
        else
        {
        [taskarry addObject:dic[@"title"]];
        [taskxparry addObject:dic[@"experience"]];
        [taskIsfinshArry addObject:dic[@"state"]];
            
            
        }
        
        [stringarr addObject:dic[@"detail"]];
    }
    
    [taskIM bk_whenTapped:^{
        [JCAlertView showOneButtonWithTitle:@"日常任务说明" Message:[stringarr componentsJoinedByString:@"\n\r"] ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:nil];
    }];
    
    count = taskarry.count;
    
    for (int i=0; i<count; i++) {
        UILabel * taskLabal = [UILabel new];
        taskLabal.x = WRUIBigOffset;
        taskLabal.y = offset+i*(WRUIBigOffset+12);
        taskLabal.textColor = [UIColor darkTextColor];
        taskLabal.font = [UIFont systemFontOfSize:WRTitleFont];
        taskLabal.text = [NSString stringWithFormat:@"%d、%@",i+1,taskarry[i]];
        [taskLabal sizeToFit];
        [pandel addSubview:taskLabal];
        
        UILabel * taskFinishLabel = [UILabel new];
        NSNumber* boolN = taskIsfinshArry[i];
        taskFinishLabel.textColor = [UIColor darkTextColor];
        taskFinishLabel.font = [UIFont systemFontOfSize:WRTitleFont];
        bool isFinsh = [boolN boolValue];
        if (isFinsh)
        {
            taskFinishLabel.text = @"已完成";
            taskFinishLabel.textColor = [UIColor wr_themeColor];
        }
        else
        {
            taskFinishLabel.text = @"未完成";
            
        }
        [taskFinishLabel sizeToFit];
        taskFinishLabel.right=pandel.width-WRUIBigOffset;
        taskFinishLabel.centerY = taskLabal.centerY;
        
        UILabel * taskxpLabel = [UILabel new];
        
        taskxpLabel.textColor = [UIColor darkTextColor];
        taskxpLabel.font = [UIFont systemFontOfSize:WRTitleFont];
        taskxpLabel.text = taskxparry[i];
    
        
        [taskxpLabel sizeToFit];
        taskxpLabel.right=taskFinishLabel.left-10;
        taskxpLabel.centerY = taskLabal.centerY;
        [pandel addSubview:taskxpLabel];
        
        
        taskFinishLabel.textAlignment = NSTextAlignmentRight;
        
        [pandel addSubview:taskFinishLabel];
        
        
        
        
        if ([taskarry[i] isEqualToString:@"信息完善"]||[taskarry[i] isEqualToString:@"绑定手机"]) {
            UIButton* FinishDataBtn = [UIButton new];
            FinishDataBtn.x = taskLabal.right+WRUIOffset;
            FinishDataBtn.y = taskLabal.top;
            FinishDataBtn.width = 57;
            FinishDataBtn.height = 18.5;
            FinishDataBtn.layer.cornerRadius = WRCornerRadius;
            FinishDataBtn.layer.masksToBounds = YES;
            FinishDataBtn.layer.borderColor = [UIColor wr_themeColor].CGColor;
            FinishDataBtn.layer.borderWidth = WRBorderWidth;
            FinishDataBtn.centerY = taskLabal.centerY;
            FinishDataBtn.titleLabel.font  = [UIFont wr_smallestFont];
            [FinishDataBtn setTitleColor:[UIColor darkTextColor] forState:0];
            if ([taskarry[i] isEqualToString:@"信息完善"])
            {
                [FinishDataBtn setTitle:@"立即完善" forState:0];
                [[FinishDataBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                    [self.navigationController pushViewController:[UserBasicInfoController new] animated:YES];
                }];
            }
            else
            {
                [FinishDataBtn setTitle:@"立即绑定" forState:0];
                [[FinishDataBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                    [self.navigationController pushViewController:[BindClientViewController new] animated:YES];
                }];
            }
            
            [pandel addSubview:FinishDataBtn];
        }
    }
    pandel.height = offset+count*(WRUIBigOffset+12)+WRUIBigOffset;
    return pandel;
}

#pragma mark - layout
-(void)layoutBgscrooll
{
    CGFloat y = 0;
    UIView* topview = [self creataTopCell];
    [_bgScrooll addSubview:topview];
    y += topview.height;
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(WRUILittleOffset, y, self.view.width-2*WRUILittleOffset, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [_bgScrooll addSubview:line];
    y+= 1;
    
    UIView* awardV = [self creataAwardCell];
    awardV.top = y;
    [_bgScrooll addSubview:awardV];
    y += awardV.height;
    
    UIView* Bigline = [[UIView alloc]initWithFrame:CGRectMake(WRUILittleOffset, y, self.view.width-2*WRUILittleOffset, 3)];
    Bigline.y = y;
    Bigline.backgroundColor = [UIColor colorWithHexString:@"ededed"];
    [_bgScrooll addSubview:Bigline];
    y+= 5;
    
    UIView* taskV = [self creataTaskCell];
    taskV.top = y;
    [_bgScrooll addSubview:taskV];
    y += taskV.height;
    
    _bgScrooll.contentSize = CGSizeMake(self.view.width, y);
    [_bgScrooll layoutSubviews];
}
-(void)updateDaliy
{
    [_bgScrooll removeAllSubviews];
    [self layoutBgscrooll];
}
-(void)fetchData
{
    __weak __typeof(self) weakSelf = self;
    [self.viewmodel fetchUserdaliyWithCompletion:^(NSError *error) {
    
        self.myDaliy = self.viewmodel.myDaliy;
        [self updateDaliy];
    }];
}
@end
