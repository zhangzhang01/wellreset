//
//  QuestionNewMutiSeleteController.m
//  rehab
//
//  Created by yongen zhou on 2017/5/8.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "QuestionNewMutiSeleteController.h"
#import "ProTreatViewModel.h"
#import "QuestionNewOneSeleteController.h"
#import "QuestionValueController.h"
#import "QuestionNewResultController.h"
#import "AddTreatDiseaseBaseContrller.h"
#import "RehabController.h"
#import "HealthController.h"
#import "QuestionDuController.h"
#import "QuestionGifController.h"
#import "SearchResultController.h"
@interface QuestionNewMutiSeleteController ()
{
    UIScrollView* _ba;
    BOOL ifnofirst;
}
@property WRProTreatQuestion* question;
@property WRProTreatAnswer* answer;
@property NSMutableArray* choose;
@property UIButton* btn;
@end

@implementation QuestionNewMutiSeleteController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat height;
    if (IPHONE_X) {
        height = 30;
    }else{
        height = 0;
    }
    _ba = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.view.height-64-51-height)];
    self.choose = [NSMutableArray array];
    [self.view addSubview:_ba];
    
    UIButton* right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30+4, 15)];
    [right setTitle:@"取消" forState:0];
    [right setTitleColor:[UIColor wr_detailTextColor] forState:0];
    [right addTarget:self action:@selector(onClickedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    right.titleLabel.font = [UIFont systemFontOfSize:WRTitleFont];
    UIBarButtonItem* item  = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
    
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    self.question = self.QusetionArr[_index];
    self.title = [NSString stringWithFormat:@"(%ld/%ld)",self.index+1,self.QusetionArr.count];
    if (!ifnofirst) {
        [self layout];
    }
    [self.btn removeFromSuperview];
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, _ba.bottom, ScreenW, 51)];
    btn.backgroundColor = [UIColor wr_lightGray];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    [btn setTitleColor:[UIColor wr_titleTextColor] forState:UIControlStateDisabled];
    [self createBackBarButtonItem];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    btn.enabled =NO;
//    [btn wr_roundBorder];
    if (_isfinish) {
        [btn setTitle:@"确定" forState:0];
    }
    else
    {
        [btn setTitle:@"下一题" forState:0];
    }
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self pushtonext];
    }];
    

    self.btn = btn;
    if (self.choose.count>0) {
        self.btn.enabled = YES;
        self.btn.backgroundColor = [UIColor wr_themeColor];
    }
    else
    {
        [self.btn setEnabled:NO];
        self.btn.backgroundColor = [UIColor wr_lightGray];
    }

    [self.view addSubview:btn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)layout
{
    
    UILabel* title = [UILabel new];
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:18];
    title.textColor = [UIColor colorWithHexString:@"333333"];
    title.x = 17;
    title.y = 27;
    title.width = ScreenW - 2*17;
    title.text = [NSString stringWithFormat:@"%ld、%@",self.index+1,_question.question];
    [title sizeToFit];
    [_ba addSubview:title];
    
    CGFloat y = title.bottom+30;
    for (int i = 0; i<_question.answers.count; i++) {
        UIImageView* im = [[UIImageView alloc]initWithFrame:CGRectMake(31, 17+y, 13, 21)];
        [im setImage:[UIImage imageNamed:@"回答选择默认状态"]];
        im.tag = i+100;
        [_ba addSubview:im];
        
        UILabel* title = [UILabel new];
        title.tag = i+200;
        title.numberOfLines = 0;
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = [UIColor colorWithHexString:@"B5B5B5"];
        title.x = 21+im.right;
        
        
        WRProTreatAnswer* answer = _question.answers[i];
        title.text = answer.answer;
        
        title.width = ScreenW - 65 - 28;
        [title sizeToFit];
        title.width = ScreenW - 65 - 28;
        title.y = 16+y;
        [_ba addSubview:title];
        title.userInteractionEnabled =YES;
        [title bk_whenTapped:^{
            NSInteger index = title.tag;
           
//            [self pushtonext];
            if (![self.choose containsObject:answer]) {
                [title setTextColor:[UIColor colorWithHexString:@"333333"]];
                UIImageView* im = [_ba viewWithTag:index-200+100];
                [im setImage:[UIImage imageNamed:@"回答选择勾选状态"]];
                [self.choose addObject:answer];
            }
            else
            {
                [title setTextColor:[UIColor colorWithHexString:@"B5B5B5"]];
                UIImageView* im = [_ba viewWithTag:index-200+100];
                [im setImage:[UIImage imageNamed:@"回答选择默认状态"]];
                [self.choose removeObject:answer];
                
            }
            
            if (self.choose.count>0) {
                self.btn.enabled = YES;
                self.btn.backgroundColor = [UIColor wr_themeColor];
            }
            else
            {
                [self.btn setEnabled:NO];
                self.btn.backgroundColor = [UIColor wr_lightGray];
            }
            
        }];
        
        
        UIView* line = [UIView new];
        line.x = 26;
        line.y = title.bottom+16;
        line.width = ScreenW-26*2;
        line.height = 1;
        line.backgroundColor = [UIColor wr_lineColor];
        [_ba addSubview:line];
        
        y = line.bottom;
        
    }
    ifnofirst =YES;
    _ba.contentSize = CGSizeMake(ScreenW, y+WRUIOffset);
    
}

- (void)pushtonext
{
    NSMutableArray *answerArray = [NSMutableArray array];
    WRProTreatQuestion *question1 = self.viewModel.questionArray[_index];
    NSMutableArray<WRProTreatAnswer *> *array = self.choose;
    [array enumerateObjectsUsingBlock:^(WRProTreatAnswer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [answerArray addObject:obj.indexId];
    }];
    
    
    
    
    
        [self.answerArray setObject:array atIndexedSubscript:_index];
    
    
    NSString *answer1 =  [answerArray componentsJoinedByString:@"|"];
    [self.viewModel setAnswer:answer1 index:_index];
    
    
    //跳转
    
    if (!self.isfinish) {
        if (self.index!=self.QusetionArr.count-1) {
            
            
            
            WRProTreatQuestion *question = self.QusetionArr[_index+1];
            BOOL bPain = (question.specialState == ProTreatQuestionSpecialTypePain);
            BOOL cValue = (question.specialState == 2);
            if (bPain) {
                QuestionValueController* value = [QuestionValueController new];
                value.pain=YES;
                value.viewModel = self.viewModel;
                value.QusetionArr = self.QusetionArr;
                value.answerArray = self.answerArray;
                value.index = self.index+1;
                value.proTreatDisease = self.proTreatDisease;
                value.stage  = self.stage;
                value.isnew = self.isnew;
                [self.navigationController pushViewController:value animated:YES];
            }else if (cValue&&question.answerType != ProTreatQuestionTypeFlowImage&&question.answerType != ProTreatQuestionTypeGif&&question.answerType != ProTreatQuestionTypeGifNotimer)
            {
                QuestionValueController* value = [QuestionValueController new];
                
                value.viewModel = self.viewModel;
                value.QusetionArr = self.QusetionArr;
                value.answerArray = self.answerArray;
                value.index = self.index+1;
                value.proTreatDisease = self.proTreatDisease;
                value.stage  = self.stage;
                value.isnew = self.isnew;
                [self.navigationController pushViewController:value animated:YES];
            }
            else if (question.answerType == ProTreatQuestionTypeMultiSelection) {
                QuestionNewMutiSeleteController* muti = [QuestionNewMutiSeleteController new];
                muti.viewModel = self.viewModel;
                muti.QusetionArr = self.QusetionArr;
                muti.answerArray = self.answerArray;
                muti.index = self.index+1;
                muti.proTreatDisease = self.proTreatDisease;
                muti.stage  = self.stage;
                muti.isnew = self.isnew;
                [self.navigationController pushViewController:muti animated:YES];
            }
            else if (question.answerType == ProTreatQuestionTypeFlowImage) {
                QuestionDuController * muti = [QuestionDuController new];
                muti.viewModel = self.viewModel;
                muti.QusetionArr = self.QusetionArr;
                muti.answerArray = self.answerArray;
                muti.index = self.index+1;
                muti.proTreatDisease = self.proTreatDisease;
                muti.stage  = self.stage;
                muti.isnew = self.isnew;
                [self.navigationController pushViewController:muti animated:YES];
            }
            else if (question.answerType == ProTreatQuestionTypeGif||question.answerType == ProTreatQuestionTypeGifNotimer) {
                QuestionGifController * muti = [QuestionGifController  new];
                muti.viewModel = self.viewModel;
                muti.QusetionArr = self.QusetionArr;
                muti.answerArray = self.answerArray;
                muti.index = self.index+1;
                muti.proTreatDisease = self.proTreatDisease;
                muti.stage  = self.stage;
                muti.isnew = self.isnew;
                [self.navigationController pushViewController:muti animated:YES];
            }
            else  {
                QuestionNewOneSeleteController* one = [QuestionNewOneSeleteController new];
                one.viewModel = self.viewModel;
                one.QusetionArr = self.QusetionArr;
                one.answerArray = self.answerArray;
                one.index = self.index+1;
                one.proTreatDisease = self.proTreatDisease;
                one.stage  = self.stage;
                one.isnew = self.isnew;
                [self.navigationController pushViewController:one animated:YES];
            }
        }
        else
        {
            QuestionNewResultController* result = [QuestionNewResultController new];
            result.viewModel = self.viewModel;
            result.QusetionArr = self.QusetionArr;
            result.answerArray = self.answerArray;
            result.proTreatDisease = self.proTreatDisease;
            result.stage  = self.stage;
            result.isnew = self.isnew;
            [self.navigationController pushViewController:result animated:YES];
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
    
}
-(IBAction)onClickedCancelButton:(id)sender {
    __weak __typeof(self) weakSelf = self;
    
    NSString *title = NSLocalizedString(@"定制尚未完成,是否要真的放弃", nil);
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"放弃", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSArray* arr;
        for (UIViewController* vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[AddTreatDiseaseBaseContrller class ]]||[vc isKindOfClass:[RehabController class]]||[vc isKindOfClass:[HealthController class]]||[vc isKindOfClass:[SearchResultController class]]) {
                arr= [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"继续", nil) style:UIAlertActionStyleCancel handler:nil]];
    [weakSelf.navigationController presentViewController:controller animated:YES completion:nil];
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
