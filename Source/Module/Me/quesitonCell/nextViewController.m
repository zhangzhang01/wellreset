//
//  nextViewController.m
//  rehab
//
//  Created by matech on 2019/11/13.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "nextViewController.h"
#import "FCAlertView.h"
#import "mainReportViewController.h"
@interface nextViewController ()

@end

@implementation nextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     UIImageView *backimageV =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, SCREEN_HEIGHT-50)];
        backimageV.image = [UIImage imageNamed:@"问卷结束背景"];
    //    backimageV.backgroundColor = [UIColor redColor];
    backimageV.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:backimageV];
    self.navigationItem.hidesBackButton = YES;
   UILabel * titleLabel = [UILabel zj_labelWithFontSize:20 textColor:[UIColor blackColor] superView:self.view constraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(120);
            make.left.equalTo(self.view).offset(10);
            make.right.mas_equalTo(-10);
            make.height.mas_equalTo(50);
        }];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"感谢参与第一份问卷答题！";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton* offerButton = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT-150, ScreenW-30, 50)];
        //    [clearButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
    [offerButton addTarget:self action:@selector(nextofferButton:) forControlEvents:UIControlEventTouchUpInside];
    offerButton.layer.cornerRadius = 25.0;
    offerButton.layer.masksToBounds = YES;
    offerButton.backgroundColor = COLOR(140, 211, 251, 1);
    [offerButton setTitle:@"继续下一份问卷" forState:UIControlStateNormal];
    [offerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:offerButton];
    
    UIButton* clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27, 47)];
    [clearButton setTitleColor:COLOR_grayColor forState:UIControlStateNormal];
     [clearButton setTitle:@"退出" forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(backButton:) forControlEvents:UIControlEventTouchUpInside];
    clearButton.hidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)backButton:(UIButton *)button
{
    FCAlertView *alert = [[FCAlertView alloc] init];
        [alert showAlertInView:self withTitle:NSLocalizedString(@"提示", nil) withSubtitle:NSLocalizedString(@"要退出此次问卷调查吗?\n退出后所选记录清除！", nil) withCustomImage:nil withDoneButtonTitle:NSLocalizedString(@"取消", nil) andButtons:nil];
        [alert addButton:NSLocalizedString(@"退出", nil) withActionBlock:^{
          
            
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
           
            
            
            
        }];
        alert.colorScheme = [UIColor wr_themeColor];
    
  
   
}
-(void)nextofferButton:(UIButton *)button
{
    mainReportViewController *vc = [[mainReportViewController alloc]init];
    vc.tag = @"0";
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
