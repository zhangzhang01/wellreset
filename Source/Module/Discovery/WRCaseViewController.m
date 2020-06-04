//
//  WRCaseViewController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/13.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRCaseViewController.h"

@interface WRCaseViewController ()
@property (nonatomic)NSMutableArray* dataArr;
@end

@implementation WRCaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView* _bg  = [[UIScrollView alloc]initWithFrame:self.view.frame];
    CGFloat  y;
    for (int i = 0; i<_dataArr.count; i++) {
        
        
    }
    
    CGSize size = CGSizeMake(self.view.width,y);
    [self.view addSubview:_bg];
    
    // Do any additional setup after loading the view.
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
