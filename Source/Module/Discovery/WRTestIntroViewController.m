//
//  WRTestIntroViewController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/13.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRTestIntroViewController.h"
#import <YYKit/YYKit.h>
@interface WRTestIntroViewController ()

@end

@implementation WRTestIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView* _bgscroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _bgscroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgscroll];
    CGFloat y = 0;
    NSArray* titleArr = @[@"健康度（满分100）",@"功能度（满分100）",@"力量度（满分100）",@"持久度（满分100）",@"灵活度（满分100）"];
    NSArray* contentarr = @[@"表示该部位的健康程度",@"表示该部位的功能恢复程度",@"表示该部位的肌肉能量大小",@"表示该部位的肌肉耐力程度",@"表示该部位的关节活动程度"];
    for (int i =0; i<5; i++) {
        UILabel* point = [[UILabel alloc]init];
        point.text = @"●";
        point.textColor = [UIColor wr_titleTextColor];
        point.font = [UIFont systemFontOfSize:12];
        point.x = 20;
        point.y = y+20;
        [point sizeToFit];
        [_bgscroll addSubview:point];
        
        UILabel* title = [UILabel new];
        title.text = titleArr[i];
        title.font = [UIFont systemFontOfSize:WRTitleFont];
        title.textColor = [UIColor wr_titleTextColor];
        [title sizeToFit];
        title.x = point.right+ WRUIOffset;
        title.centerY = point.centerY;
        [_bgscroll addSubview:title];
        [title setWr_AttributedWithColorRange:NSMakeRange(3, title.text.length-3) Color:[UIColor wr_detailTextColor] FontRange:NSMakeRange(3, title.text.length-3) Font:[UIFont systemFontOfSize:13] InitTitle:title.text];
         
        UILabel* contentL = [UILabel new];
        contentL.text = contentarr[i];
        contentL.font = [UIFont systemFontOfSize:WRDetailFont];
        contentL.textColor = [UIColor wr_detailTextColor];
        contentL.numberOfLines = 0;
        contentL.x = 21;
        contentL.y = title.bottom+ 18;
        contentL.width = self.view.width -42;
        [contentL sizeToFit];
        [_bgscroll addSubview:contentL];
        
        

        y+=105;
    }
    _bgscroll .contentSize = CGSizeMake(self.view.width, y+64);
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
