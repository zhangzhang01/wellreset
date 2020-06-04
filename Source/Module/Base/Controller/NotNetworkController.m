//
//  NotNetworkController.m
//  rehab
//
//  Created by yongen zhou on 2017/4/5.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "NotNetworkController.h"
#import "Masonry/Masonry.h"
@interface NotNetworkController ()

@end

@implementation NotNetworkController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    
    self.view =[WRUIConfig createNoDataViewWithFrame:self.view.bounds title:NSLocalizedString(@"网络状态等待提升", nil) image:[UIImage imageNamed:@"无网络数据图标"] button:@"查看解决方案" block:^{
        UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
        UIViewController* vc = [sb instantiateViewControllerWithIdentifier:@"novc"];

        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    
    
       // Do any additional setup after loading the view.
}
-(void)onClickedBackButton:(UIBarButtonItem *)sender
{
    if (self.didSelectedBack) {
        self.didSelectedBack();
    }
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
