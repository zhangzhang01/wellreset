//
//  GuideMeViewController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/6.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "GuideMeViewController.h"
#import "MainTabBarController.h"
#import "UserViewModel.h"
#import "HealthController.h"
#import "WRUserInfo.h"
#import "BirthdayField.h"
#import <YYKit/YYKit.h>
@interface GuideMeViewController ()
@property (nonatomic) NSInteger sex;
@property (nonatomic) UIButton* sex0btn , *sex1btn;
@property (nonatomic) UILabel * sex0la , *sex1la;
@property (nonatomic) UITextField* weight;
@property (nonatomic) UITextField* height;
@property (nonatomic) UITextField* brithday;
@property WRUserInfo* userInfo;
@property NSArray* imageColors;

@end

@implementation GuideMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    
    [self layout];
    self.userInfo = [WRUserInfo selfInfo];
    self.imageColors = @[[UIColor colorWithHexString:@"ff892f"], [UIColor colorWithHexString:@"004eff"], [UIColor colorWithHexString:@"ed1e79"], [UIColor colorWithHexString:@"47c0ff"]];
    UIButton* right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30+4, 15)];
    [right setTitle:@"跳过" forState:0];
    [right setTitleColor:[UIColor wr_rehabBlueColor] forState:0];
    [right bk_whenTapped:^{
        [self exitforitem];
    }];
    right.titleLabel.font = [UIFont systemFontOfSize:WRTitleFont];
    UIBarButtonItem* item  = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
    
     // Do any additional setup after loading the view.
}
-(void) onClickedBackButton:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)layout
{
    CGFloat y = 45;
    UIView* heightView = [self createFiedViewWith:@"身高" And:@"(厘米)"];
    heightView.y = y;
    [self.view addSubview:heightView];
    
    y+= heightView.height+37;

    UIView* weight = [self createFiedViewWith:@"体重" And:@"(公斤)"];
    weight.y =y;
    [self.view addSubview:weight];
    
     y+= heightView.height+20;

    UIView* sexview = [self creatChooseSexView];
    sexview.y = y;
    [self.view addSubview:sexview];
    
    y+= sexview.height + 34;
    
    UIView* birthday = [self createFiedViewWith:@"出生日期" And:@""];
    birthday.y = y;
    [self.view addSubview:birthday];
    y+= birthday.height + 34;
    
    
    UIButton*  nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height-43-40-64, 281, 43)];
    [nextBtn setTitle:NSLocalizedString(@"开启WELL健康",nil) forState:0];
    [nextBtn setBackgroundColor:[UIColor wr_themeColor]];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:0];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:WRBigButtonFont];
    nextBtn.centerX = self.view.centerX;
    
    
    [self.view addSubview:nextBtn];
    
    [[nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        
        
        [self exitforitem];
       
        
    }];

    
    
    
}
-(void)exitforitem
{
    [ self.navigationController dismissViewControllerAnimated:YES completion:nil ];
    [self onClickedSubmitButton:nil];
    if (self.re) {
        if (_ispro) {
            MainTabBarController *tabbarController = [[MainTabBarController alloc] init];
            AppDelegate* app = [UIApplication sharedApplication].delegate;
            app.window.rootViewController = tabbarController;
            
            UINavigationController* navi = tabbarController.viewControllers[0];
            HealthController* health  =navi.viewControllers.firstObject;
            
            [health pushProTreatRehabWithDisease:self.re stage:0 upgrade:@"0"];
        }
        else
        {
            MainTabBarController *tabbarController = [[MainTabBarController alloc] init];
            AppDelegate* app = [UIApplication sharedApplication].delegate;
            app.window.rootViewController = tabbarController;
            WRUserInfo* info = [WRUserInfo selfInfo];
            //                [[NSNotificationCenter defaultCenter] postNotificationName:WRLogInNotification object:nil];
            UINavigationController* navi = tabbarController.viewControllers[0];
            HealthController* health  =navi.viewControllers.firstObject;
            [health presentTreatRehabWithDisease:self.re isTreat:NO];
        }
        
    }
    else
    {
        MainTabBarController *tabbarController = [[MainTabBarController alloc] init];
        AppDelegate* app = [UIApplication sharedApplication].delegate;
        app.window.rootViewController = tabbarController;
        WRUserInfo* info = [WRUserInfo selfInfo];
        //            [[NSNotificationCenter defaultCenter] postNotificationName:WRLogInNotification object:nil];
        UINavigationController* navi = tabbarController.viewControllers[0];
        HealthController* health  =navi.viewControllers.firstObject;
        WRScene *scene = self.scene;
        NSLog(@"scene.name%@",scene.name);
        [NSThread sleepForTimeInterval:1];
        PreventVideosController *viewController = [[PreventVideosController alloc] init];
//        [NSThread sleepForTimeInterval:1];
        [health.navigationController pushViewController:viewController animated:YES];
        [viewController setScene:scene banner:[UIImage imageNamed:[NSString stringWithFormat:@"prevent_banner_%d",(int)(_index%self.imageColors.count + 1)]] mostColor:self.imageColors[_index%self.imageColors.count]];
        
    }

}

-(UIView*)createFiedViewWith:(NSString*)title And:(NSString*)detail
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 47, self.view.width, 30)];
    
    UILabel* heightLabel = [UILabel new];
    heightLabel.x = 70;
    heightLabel.y = 0;
    heightLabel.text = title;
    heightLabel.font = [UIFont systemFontOfSize:WRTitleFont];
    heightLabel.textColor = [UIColor blackColor];
    [heightLabel sizeToFit];
    [pannel addSubview:heightLabel];
    
    if (![detail isEqualToString:@""]&&detail) {
        UILabel* detailLabel = [UILabel new];
        detailLabel.text = detail;
        detailLabel.font = [UIFont systemFontOfSize:WRDetailFont];
        detailLabel.textColor = [UIColor blackColor];
        [detailLabel sizeToFit];
        detailLabel.x = heightLabel.right+WRUILittleOffset;
        detailLabel.bottom = heightLabel.bottom;
        [pannel addSubview:detailLabel];
        
    }
    if ([title isEqualToString:@"出生日期"]) {
        BirthdayField* field = [BirthdayField  new];
        [field  setUpText];
        field.x = 55+heightLabel.right;
        field.y = heightLabel.bottom - 13 -10;
        field.width = self.view.width-100- 57;
        field.height = 13+20;
        field.textColor = [UIColor blackColor];
        field.font = [UIFont systemFontOfSize:WRDetailFont];
        [pannel addSubview:field];
        if([title isEqualToString:@"出生日期"])
        {
            self.brithday =field;
        }
        
    }
    else
    {
    UITextField* field = [UITextField new];
    field.x = 55+heightLabel.right;
    field.y = heightLabel.bottom - 13 -10;
    field.width = self.view.width-100- 57;
    field.height = 13+20;
    field.textColor = [UIColor blackColor];
    field.font = [UIFont systemFontOfSize:WRDetailFont];
    field.placeholder = @"未填写";
    if ([title isEqualToString:@"身高"]) {
        
        self.height =field;
        field.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if([title isEqualToString:@"体重"])
    {
        self.weight =field;
        field.keyboardType = UIKeyboardTypeNumberPad;
    }
     
        
    [pannel addSubview:field];
    }
    
    UIView* line = [UIView new];
    line.x = 50;
    line.y = 30-1;
    line.width = self.view.width-100;
    line.height = 1;
    line.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:line];
    
    
    return pannel;
}

- (UIView*)creatChooseSexView
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 47, self.view.width, 75)];
    UILabel* heightLabel = [UILabel new];
    heightLabel.x = 70;
    heightLabel.y = 30;
    heightLabel.text = @"性别";
    heightLabel.font = [UIFont systemFontOfSize:WRTitleFont];
    heightLabel.textColor = [UIColor blackColor];
    [heightLabel sizeToFit];
    [pannel addSubview:heightLabel];

    

        
    UIButton* sex0Btn = [UIButton new];
    sex0Btn.x = heightLabel.right + 51 ;
    sex0Btn.y = 20;
    sex0Btn.width = 37;
    sex0Btn.height = 37;
    [sex0Btn setImage:[UIImage imageNamed: @"男"] forState:0];
    [pannel addSubview:sex0Btn];
    self.sex0btn = sex0Btn;
    
    UILabel* sex0La = [UILabel new];
    sex0La.text = @"男";
    sex0La.font = [UIFont wr_smallestFont];
    sex0La.textColor = [UIColor wr_themeColor];
    [sex0La sizeToFit];
    sex0La.y = 2;
    sex0La.hidden =YES;
    sex0La.centerX = sex0Btn.centerX;
    [pannel addSubview:sex0La];
    self.sex0la = sex0La;
    
    UIButton* sex1Btn = [UIButton new];
    sex1Btn.x = heightLabel.right + 51 + 29 + 51;
    sex1Btn.y = 20;
    sex1Btn.width = 37;
    sex1Btn.height = 37;
    [sex1Btn setImage:[UIImage imageNamed: @"女"] forState:0];
    [pannel addSubview:sex1Btn];
    self.sex1btn = sex1Btn;
    

    UILabel* sex1La = [UILabel new];
    sex1La.text = @"女";
    sex1La.font = [UIFont wr_smallestFont];
    sex1La.textColor = [UIColor wr_themeColor];
    [sex1La sizeToFit];
    sex1La.y = 2;
    sex1La.hidden =YES;
    sex1La.centerX = sex1Btn.centerX;
    [pannel addSubview:sex1La];
    self.sex1la = sex1La;
    
    __weak __typeof__(self) weakSelf = self;
    
    [[sex0Btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [weakSelf.sex0btn setImage:[UIImage imageNamed:@"男选中"] forState:0];
        [weakSelf.sex1btn setImage:[UIImage imageNamed:@"女"] forState:0];
        weakSelf.sex1la.hidden =YES;
        weakSelf.sex0la.hidden =NO;
    }];
    [[sex1Btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [weakSelf.sex1btn setImage:[UIImage imageNamed:@"女选中"] forState:0];
        [weakSelf.sex0btn setImage:[UIImage imageNamed:@"男"] forState:0];
        weakSelf.sex0la.hidden =YES;
        weakSelf.sex1la.hidden =NO;
    }];
    
    UIView* line = [UIView new];
    line.x = 50;
    line.y = 75-1;
    line.width = self.view.width-100;
    line.height = 1;
    line.backgroundColor = [UIColor wr_lineColor];
    [pannel addSubview:line];
    
    return pannel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickedSubmitButton:(id)sender {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    WRUserInfo *selfInfo = [WRUserInfo selfInfo];
    [WRUserInfo selfInfo].sex = _sex;
    [WRUserInfo selfInfo].weight = [_weight.text integerValue];
    [WRUserInfo selfInfo].height = [_height.text integerValue];
    [WRUserInfo selfInfo].birthDay = [_brithday text]?[_brithday text]:@"";
    [[WRUserInfo selfInfo]save];
    
    self.userInfo =[WRUserInfo selfInfo];
    NSString *value = _userInfo.name;
   
    if(selfInfo.sex != _userInfo.sex) {
        params[@"sex"] = @(_userInfo.sex);
    }
    
    value = _userInfo.birthDay;
    if(![Utility IsEmptyString:value] && ![value isEqualToString:selfInfo.birthDay]) {
        params[@"birthDay"] = value;
    }
    
   
    
    if( _userInfo.height!=0) {
        params[@"height"] = @(_userInfo.height);
    }
    if(_userInfo.weight!=0) {
        params[@"weight"] = @(_userInfo.weight);
    }
    
    if (params.count == 0) {
        [Utility showToast:NSLocalizedString(@"并没有修改任何信息", nil) position:ToastPositionBottom];
    } else {
        __weak __typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在提交请求", nil)];
        [WRViewModel modifySelfBasicInfo:params completion:^(NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            if (error) {
                NSString *errorString = error.domain;
                if ([Utility IsEmptyString:errorString]) {
                    errorString = NSLocalizedString(@"修改信息失败,请检查网络", nil);
                }
                [Utility retryAlertWithViewController:weakSelf title:errorString completion:^{
                    [weakSelf onClickedSubmitButton:sender];
                }];
            } else {
                for (NSString *item in params.allKeys) {
                    [UMengUtils careForMeModify:item];
                }
                //                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"修改成功", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                //                [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //                    [weakSelf.navigationController popViewControllerAnimated:YES];
                //                }]];
                //                [weakSelf presentViewController:controller animated:YES completion:nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:WRUpdateSelfInfoNotification object:nil];
            }
        }];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    if (self.type==0) {
        self.title = @"完善资料（4／4）";
        
    }else
    {
        self.title = @"完善资料（3／3)";
    }
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
