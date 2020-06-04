//
//  PhoneAskIndexController.m
//  rehab
//
//  Created by yongen zhou on 2017/6/13.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "PhoneAskIndexController.h"

@interface PhoneAskIndexController ()
{
    UIScrollView * _bc;
}
@end

@implementation PhoneAskIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.view.height-64)];
    [self.view addSubview:_bc];
    
    
    
    
    // Do any additional setup after loading the view.
}
- (UIView*)creatBaseInfoView
{
    UIView* panner = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    UILabel* title = [UILabel new];
    title.text = @"";
    
    return panner;
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
