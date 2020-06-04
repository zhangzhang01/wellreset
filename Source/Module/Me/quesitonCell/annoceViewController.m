//
//  annoceViewController.m
//  rehab
//
//  Created by matech on 2019/12/13.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "annoceViewController.h"
#import "firstReportViewController.h"
@interface annoceViewController ()

@end

@implementation annoceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] init];
      imageView.frame = CGRectMake(0, 0, ScreenW , SCREEN_HEIGHT);
       imageView.image = IMAGE(@"1评估须知.jpg");
    [imageView bk_whenTapped:^{
        UIViewController *viewController = [firstReportViewController new];
                  viewController.hidesBottomBarWhenPushed=YES;
                  [self.navigationController pushViewController:viewController animated:YES];
        
    }];
    
    
    
    [self.view addSubview:imageView];
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
