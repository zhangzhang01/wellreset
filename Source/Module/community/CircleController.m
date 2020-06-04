//
//  CircleController.m
//  rehab
//
//  Created by yongen zhou on 2018/8/28.
//  Copyright © 2018年 WELL. All rights reserved.
//

#import "CircleController.h"
#import "WRObject.h"
#import "ComulitModel.h"
#import "CommunityIndexControler.h"
@interface CircleController ()

@end

@implementation CircleController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.viewModel = [ComulitModel new];
    
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    
        if(self.isSelf)
        {
            [self creatCircleViewWith:self.viewModel.myCircleArr];
        }
        else
        {
            [self creatCircleViewWith:self.viewModel.circleArr];
        }
   
    
}
- (void)creatCircleViewWith:(NSArray*)arr
{
    [self.view removeAllSubviews];
    for (int i=0; i < (arr.count>4?4:arr.count) ; i++) {
        int row = i / 2;
        int col = i % 2;
        WRCircle* circle = arr[i];
        UIView* cellView = [UIView new];
        CGFloat cellW = (ScreenW - 30 - 10)*1.0/2;
        CGFloat cellX = 15 + col * (cellW + 10);
        CGFloat cellY = 18 + row * (51 + 10);
        cellView.frame = CGRectMake(cellX, cellY, cellW, 51);
        [self.view addSubview:cellView];
        
        UIImageView* im = [[UIImageView alloc]init];
        [im setImageWithURL:[NSURL URLWithString:circle.headimg]];
        im.contentMode = UIViewContentModeScaleAspectFill;
        im.frame = cellView.bounds;
        cellView.clipsToBounds = YES;
        
        [im setImageWithURL:[NSURL URLWithString:circle.headimg]];
        [cellView addSubview:im];
        
        UILabel* titleim = [UILabel new];
        titleim.frame = cellView.bounds;
        titleim.text = circle.name;
        titleim.font = [UIFont boldSystemFontOfSize:WRTitleFont];
        if (ScreenW<375) {
           titleim.font = [UIFont boldSystemFontOfSize:13];
        }
        titleim.textAlignment = NSTextAlignmentCenter;
        titleim.textColor = [UIColor whiteColor];
        [cellView addSubview:titleim];
        
        [cellView bk_whenTapped:^{
            CommunityIndexControler * index = [CommunityIndexControler new];
            for (WRCircle * cle in self.viewModel.myCircleArr) {
                if ([cle.uuid isEqualToString:circle.uuid] ) {
                    index.IsJoin = YES;
                }
            }
            if (index.IsJoin) {
                [MobClick event:@"sqwdqz"];
            }
            else
            {
                [MobClick event:@"sqtzqz"];
            }
            
            index.circleId = circle.uuid;
        
            index.hidesBottomBarWhenPushed = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"push" object:index];
           // [self.navigationController pushViewController:index animated:YES];
        }];
        
        // 添加到view 中
        

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
