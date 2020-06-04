//
//  QuestionNewResultController.m
//  rehab
//
//  Created by yongen zhou on 2017/5/10.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "QuestionNewResultController.h"
#import "QuestionNewOneSeleteController.h"
#import "QuestionNewMutiSeleteController.h"
#import "QuestionValueController.h"
#import "WRTestResultViewController.h"
#import "RehabController.h"
#import "DiagnosticResultController.h"
#define NEWQUESTION_ID   @"cb888cb9-af32-47a8-8f69-2824b85d7e79"
#define NEWQUESTION_SP_ID   @"dc20c10b-85f8-45fd-b485-fade4805b88c"
#import "AddTreatDiseaseBaseContrller.h"
#import "RehabController.h"
#import "HealthController.h"
#import "QuestionDuController.h"
#import "QuestionGifController.h"
#import "SearchResultController.h"
@interface QuestionNewResultController ()
{
    UIScrollView* _ba;
}
@end

@implementation QuestionNewResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请确认";
    
    CGFloat height;
    if (IPHONE_X) {
        height = 30;
    }else{
        height = 0;
    }
    
    _ba = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.view.height-64-80-height)];
    [self.view addSubview:_ba];
    
    UIButton* right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30+4, 15)];
    [right setTitle:@"取消" forState:0];
    [right setTitleColor:[UIColor wr_detailTextColor] forState:0];
    [right addTarget:self action:@selector(onClickedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    right.titleLabel.font = [UIFont systemFontOfSize:WRTitleFont];
    UIBarButtonItem* item  = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
    [self createBackBarButtonItem];
    item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor whiteColor]] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedBackButton:)];
    self.navigationItem.leftBarButtonItem = item;
    // Do any additional setup after loading the view.
}

-(void)onClickedBackButton:(UIBarButtonItem *)sender
{
    return;
}

-(void)viewDidAppear:(BOOL)animated
{
  UIView* qa = [self createQandA];
    [_ba addSubview:qa];
    _ba.contentSize = CGSizeMake(ScreenW, qa.bottom);
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, _ba.bottom+30, ScreenW, 80-30)];
    btn.backgroundColor = [UIColor wr_themeColor];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btn wr_roundBorder];
       [btn setTitle:@"确定" forState:0];
    
    [btn bk_whenTapped:^{
        [self suerSumit];
    }];
    [self.view addSubview:btn];
    
    UILabel* la = [[UILabel alloc]initWithFrame:CGRectMake(0, _ba.bottom, ScreenW, 30)];
    la.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    la.textColor = [UIColor colorWithHexString:@"7d7d7d"];
    la.textAlignment = NSTextAlignmentCenter;
    la.text = @"点击问题可以修改答案";
    la.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:la];

}
- (UIView*)createQandA
{
    
    [_ba removeAllSubviews];
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
    CGFloat y=0;
    for (int i=0;i<self.QusetionArr.count;i++) {
        UIView* bac = [[UIView alloc]initWithFrame:CGRectMake(10,y+10, ScreenW-20, 0)];
        bac.backgroundColor = [UIColor whiteColor];
        bac.layer.cornerRadius =  WRCornerRadius;
        bac.layer.masksToBounds = YES;
        bac.layer.borderColor = [UIColor wr_rehabBlueColor].CGColor;
        bac.layer.borderWidth = 1;
        WRProTreatQuestion* q = self.QusetionArr[i];
        NSArray* arr = self.answerArray[i];
        NSMutableString* answer = [NSMutableString stringWithFormat:@""];
        NSMutableArray* ans = [NSMutableArray array];
        bac.userInteractionEnabled = YES;
        [bac bk_whenTapped:^{
            [self showView:i];
        }];
        for (WRProTreatAnswer* a in arr) {
            
            [ans addObject:a.answer];
        }
        [answer  appendString:[ans componentsJoinedByString:@"\n"]];
        UILabel* la = [UILabel new ];
        la.textColor = [UIColor wr_titleTextColor];
        la.font = [UIFont systemFontOfSize:18];
        la.width = bac.width-30;
        la.x = 15;
        la.y = 15;
        la.numberOfLines = 0;
        la.text = [NSString stringWithFormat:@"%d、%@",i+1,q.question];
        [la sizeToFit];
        [bac addSubview:la];
        y=la.bottom;
        for (WRProTreatAnswer* a in arr) {
            
            
            
            
            UILabel* an = [UILabel new ];
            an.textColor = [UIColor wr_themeColor];
            an.font = [UIFont systemFontOfSize:16];
            an.width = bac.width-30;
            an.x = 52;
            an.y = y+15;
            an.numberOfLines = 0;
            an.text = a.answer;
            [an sizeToFit];
            [bac addSubview:an];
            
            
            
            UIImageView* im = [UIImageView new];
            
            [im setImage:[UIImage imageNamed:@"形状-3"]];
            im.width = 9;
            im.height =15;
            [im sizeToFit];
            im.right = an.left-12;
            im.y = y+15;
                               
                               
            [bac addSubview:im];
            y = an.bottom;
        }
        
        
        bac.height = y+15;
        
        y = bac.bottom;
        [pannel addSubview:bac];
    }
    pannel.height = y+20;
    
    return pannel;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showView:(NSInteger)index
{

    
    
            
            
            
            WRProTreatQuestion *question = self.QusetionArr[index];
            BOOL bPain = (question.specialState == ProTreatQuestionSpecialTypePain);
            BOOL cValue = (question.specialState == 2);
            if (bPain) {
                QuestionValueController* value = [QuestionValueController new];
                value.pain=YES;
                value.viewModel = self.viewModel;
                value.QusetionArr = self.QusetionArr;
                value.answerArray = self.answerArray;
                value.index = index;
                value.isfinish = YES;
                value.isnew = self.isnew;
                [self.navigationController pushViewController:value animated:YES];
            }else if (cValue&&question.answerType != ProTreatQuestionTypeFlowImage&&question.answerType != ProTreatQuestionTypeGif&&question.answerType != ProTreatQuestionTypeGifNotimer)
            {
                QuestionValueController* value = [QuestionValueController new];
                
                value.viewModel = self.viewModel;
                value.QusetionArr = self.QusetionArr;
                value.answerArray = self.answerArray;
                value.index = index;
                value.isfinish = YES;
                [self.navigationController pushViewController:value animated:YES];
            }
            else if (question.answerType == ProTreatQuestionTypeMultiSelection) {
                QuestionNewMutiSeleteController* muti = [QuestionNewMutiSeleteController new];
                muti.viewModel = self.viewModel;
                muti.QusetionArr = self.QusetionArr;
                muti.answerArray = self.answerArray ;
                muti.index = index;
                muti.isfinish = YES;
                [self.navigationController pushViewController:muti animated:YES];
            }
            else if (question.answerType == ProTreatQuestionTypeFlowImage) {
                QuestionDuController * muti = [QuestionDuController new];
                muti.viewModel = self.viewModel;
                muti.QusetionArr = self.QusetionArr;
                muti.answerArray = self.answerArray;
                muti.index = index;
                muti.proTreatDisease = self.proTreatDisease;
                muti.stage  = self.stage;
                muti.isnew = self.isnew;
                muti.isfinish = YES;
                [self.navigationController pushViewController:muti animated:YES];
            }
            else if (question.answerType == ProTreatQuestionTypeGif||question.answerType == ProTreatQuestionTypeGifNotimer) {
                QuestionGifController * muti = [QuestionGifController  new];
                muti.viewModel = self.viewModel;
                muti.QusetionArr = self.QusetionArr;
                muti.answerArray = self.answerArray;
                muti.index = index;
                muti.proTreatDisease = self.proTreatDisease;
                muti.stage  = self.stage;
                muti.isnew = self.isnew;
                muti.isfinish = YES;
                [self.navigationController pushViewController:muti animated:YES];
            }

            else  {
                QuestionNewOneSeleteController* one = [QuestionNewOneSeleteController new];
                one.viewModel = self.viewModel;
                one.QusetionArr = self.QusetionArr;
                one.answerArray = self.answerArray;
                one.index = index;
                one.isfinish = YES;
                [self.navigationController pushViewController:one animated:YES];
            }
    
}
-(void)suerSumit
{
    __weak __typeof(self)weakSelf = self;
   
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在定制", nil)];
        NSString* desid =self.proTreatDisease.indexId;
        if (self.isnew) {
            desid = NEWQUESTION_ID;
        }
        [self.viewModel getProTreatRehabWithCompletion:^(NSError *  error, id  rehab,  NSInteger state, NSString * stateDescription) {
            [SVProgressHUD dismiss];
            if (error)
            {
                UIViewController *viewController = weakSelf.navigationController;
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"定制失败,请检测网络", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"重试", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf suerSumit];
                }]];
                [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [viewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }]];
                [viewController presentViewController:controller animated:YES completion:nil];
            }
            else
            {
                WRRehab *treatRehab = rehab;
                
                if (self.viewModel.UserHealthStage&&self.isnew) {
                    WRTestResultViewController* reVc = [WRTestResultViewController new];
                    reVc.UserHealthStage = self.viewModel.UserHealthStage;
                    reVc.lastarry = self.viewModel.lastarry;
                    reVc.rehab = rehab;
                    [self.navigationController pushViewController:reVc animated:YES];
                }
                else
                {
                    if (treatRehab && ![Utility IsEmptyString:treatRehab.createTime])
                    {
                        [weakSelf showRehab:rehab];
                    }
                    else
                    {
                        [weakSelf showDiagnosticResult:stateDescription];
                    }
                }
                
                
                
                if (rehab) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:WRReloadRehabNotification object:nil userInfo:@{@"rehab":rehab}];
                }
                
            }
        } stage:self.stage diseaseId:desid specialtyId:NEWQUESTION_SP_ID];
    

}
-(void)showRehab:(WRRehab*)rehab
{
    RehabController *proTreatRehabDetailController = [[RehabController alloc] initWithRehab:rehab];
    [self.navigationController pushViewController:proTreatRehabDetailController animated:YES];
    proTreatRehabDetailController.title = [NSString stringWithFormat:@"%@ %@", self.proTreatDisease.diseaseName, NSLocalizedString(@"定制方案", nil)];
}

-(void)showDiagnosticResult:(NSString*)diagnosticResult
{
    __weak __typeof(self) weakSelf = self;
    DiagnosticResultController *viewController = [[DiagnosticResultController alloc] initWithDisease:weakSelf.proTreatDisease diagnosticDescription:diagnosticResult];
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
    
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
