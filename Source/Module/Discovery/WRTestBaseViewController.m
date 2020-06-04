//
//  WRTestBaseViewController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/10.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRTestBaseViewController.h"
#import "UIKit+WR.h"
#import <YYKit/YYKit.h>
#import "WRTestResultViewController.h"
#import "QuestionNewOneSeleteController.h"
#import "QuestionValueController.h"
#import "QuestionNewMutiSeleteController.h"
#import "QuestionNewResultController.h"
@interface WRTestBaseViewController ()

@end

@implementation WRTestBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    
//    self.title = @"定制方案";
    
    
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setTranslucent:NO];
    self.view.backgroundColor = [UIColor colorWithHexString:@"515151"];
    
    [self.view removeAllSubviews];
    UIScrollView* _bgscroll = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _bgscroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgscroll];
    //    _bgscroll.height =300;
    
    UIImageView * top =[UIImageView new];
    top.image = [UIImage imageNamed:@"腰部专业测试" ];
    top.y =  43;
    top.width = 200;
    top.height = 133;
    
    top.centerX = self.view.centerX;
    [_bgscroll addSubview:top];
    
    
    
    
    
    UILabel* title = [UILabel new];
    title.text =self.viewmodel.Ttitle;
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    title.width = 136;
    title.height =18;
    title.textAlignment = NSTextAlignmentCenter;
    title.y = top.bottom+ 60;
    title.centerX  =self.view.centerX;
    
    
    
    UILabel* titled = [UILabel new];
    titled.text = [NSString stringWithFormat:@"第%ld阶",self.stage==0?1:self.stage];
    titled.font = [UIFont systemFontOfSize:13];
    titled.textColor = [UIColor blackColor];
    titled.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    titled.width = 136;
    titled.height = 13;
    titled.textAlignment = NSTextAlignmentCenter;
    titled.y = title.bottom+12;
    titled.centerX  =self.view.centerX;
    [_bgscroll addSubview:titled];
    
    
    
    
    
    UIView* line = [UIView new];
    line.x = 58;
    line.y =0;
    line.width = self.view.width-58*2;
    line.height =1;
    line.centerY = title.centerY;
    line.backgroundColor = [UIColor colorWithHexString:@"d6d6d6"];
    
    [_bgscroll addSubview:line];
    [_bgscroll addSubview:title];
    CGFloat y = title.bottom;
    UILabel* text = [UILabel new];
    text.x =36;
    text.y =y+44;
    text.width = self.view.width - 36*2;
    text.font = [UIFont systemFontOfSize:15];
    text.numberOfLines =0;
    text.textColor = [UIColor colorWithHexString:@"959595"];
    text.text = [self.viewmodel.desc componentsJoinedByString:@"\n"];
    [text sizeToFit];
    [_bgscroll addSubview:text];
    CGSize size = [text.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(text.width, MAXFLOAT)];
    y+=44;
    y+=size.height;
    
    _bgscroll.contentSize= CGSizeMake(self.view.width, y+100);
    
    
    UIButton* go = [UIButton new];
    go.x = 25;
    go.y = kScreenHeight- 85 -64;
    go.width = self.view.width-25*2;
    go.height = 50;
    go.backgroundColor = [UIColor colorWithHexString:@"4FD8FF"];
    [go setTitle:@"开始评估" forState:0];
    [go setTitleColor:[UIColor whiteColor] forState:0];
    go.titleLabel.font = [UIFont systemFontOfSize:18];
    [go wr_roundBorderWithColor:[UIColor colorWithHexString:@"4FD8FF"]];
    
    [self.view addSubview:go];
    [[go rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        //        [self.navigationController pushViewController:[WRTestResultViewController new] animated:YES];
        //        [self showTestRehabWithDisease:nil completion:^(UIViewController *controller) {
        //            [self.navigationController pushViewController:controller animated:YES];
        //        }];
        
        WRProTreatQuestion *question = self.viewmodel.questionArray[0];
        BOOL bPain = (question.specialState == ProTreatQuestionSpecialTypePain);
        BOOL cValue = (question.specialState == 2);
        if (bPain) {
            QuestionValueController* value = [QuestionValueController new];
            value.pain=YES;
            value.viewModel = self.viewmodel;
            value.QusetionArr = self.viewmodel.questionArray;
            value.answerArray = [NSMutableArray array];
            value.stage =self.stage;
            value.proTreatDisease = self.proTreatDisease;
            value.index = 0;
            value.isnew = self.isnew;
            [self.navigationController pushViewController:value animated:YES];
        }else if (cValue)
        {
            QuestionValueController* value = [QuestionValueController new];
            
            value.viewModel = self.viewmodel;
            value.QusetionArr = self.viewmodel.questionArray;
            value.answerArray = [NSMutableArray array];
            value.stage =self.stage;
            value.proTreatDisease = self.proTreatDisease;
            value.index = 0;
            value.isnew = self.isnew;
            [self.navigationController pushViewController:value animated:YES];
        }
        else if (question.answerType == ProTreatQuestionTypeMultiSelection) {
            QuestionNewMutiSeleteController* muti = [QuestionNewMutiSeleteController new];
            muti.viewModel = self.viewmodel;
            muti.QusetionArr = self.viewmodel.questionArray;
            muti.answerArray = [NSMutableArray array];
            muti.stage =self.stage;
            muti.proTreatDisease = self.proTreatDisease;
            muti.index = 0;
            muti.isnew = self.isnew;
            [self.navigationController pushViewController:muti animated:YES];
        }
        else  {
            QuestionNewOneSeleteController* one = [QuestionNewOneSeleteController new];
            one.viewModel = self.viewmodel;
            one.QusetionArr = self.viewmodel.questionArray;
            one.answerArray = [NSMutableArray array];
            one.index = 0;
            one.stage =self.stage;
            one.proTreatDisease = self.proTreatDisease;
            one.isnew = self.isnew;
            [self.navigationController pushViewController:one animated:YES];
        }
        
        
        
    }];

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
