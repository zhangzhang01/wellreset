//
//  AddDyController.m
//  rehab
//
//  Created by yongen zhou on 2017/7/25.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "AddDyController.h"

@interface AddDyController ()
{
    UIScrollView* _bac;
}
@end

@implementation AddDyController

- (void)viewDidLoad {
    [super viewDidLoad];
    _bac = [[UIScrollView alloc ]initWithFrame:CGRectMake(0, 0, ScreenW, self.view.height-64)];
    [self.view addSubview:_bac];
    // Do any additional setup after loading the view.
}
-(void)createInfoView
{
    
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
