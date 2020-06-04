//
//  QuestionGifController.m
//  rehab
//
//  Created by yongen zhou on 2017/8/23.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "QuestionGifController.h"
#import "ProTreatViewModel.h"
#import "JXCircleSlider.h"
#import "MyLayout.h"
#import "QuestionNewOneSeleteController.h"
#import "QuestionNewMutiSeleteController.h"
#import "QuestionNewResultController.h"
#import "AddTreatDiseaseBaseContrller.h"
#import "QuestionValueController.h"
#import "RehabController.h"
#import "HealthController.h"
#import "QuestionDuController.h"
#import "SearchResultController.h"
                                                                                                                                                                                                                                                     
@interface QuestionGifController ()
{
    UIScrollView* _ba;
    BOOL ifnofirst;
    UILabel *_painValueLabel;
    NSTimer *_timer;
}
@property WRProTreatQuestion* question;
@property WRProTreatAnswer* answer;
@property NSMutableArray* choose;
@property UIButton* btn;
@property JXCircleSlider* slider;
@property(nonatomic)NSInteger currentTimeValue;

@end

@implementation QuestionGifController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ba = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.view.height-64-51)];
    [self.view addSubview:_ba];
    
    UIButton* right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30+4, 15)];
    [self createBackBarButtonItem];
    [right setTitle:@"取消" forState:0];
    [right setTitleColor:[UIColor wr_detailTextColor] forState:0];
    [right addTarget:self action:@selector(onClickedCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    right.titleLabel.font = [UIFont systemFontOfSize:WRTitleFont];
    UIBarButtonItem* item  = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
    //    [self layout];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    btn.backgroundColor = [UIColor wr_themeColor];
    [btn setTitleColor:[UIColor whiteColor] forState:0];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    //    [btn wr_roundBorder];
    if (_isfinish) {
        [btn setTitle:@"确定" forState:0];
        
    }
    else
    {
        [btn setTitle:@"下一题" forState:0];
    }
    [btn bk_whenTapped:^{
        [self pushtonext];
    }];
    [self.view addSubview:btn];
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
    
    
    UIImageView* im = [UIImageView new];
    im.width = 202;
    im.height =115;
    im.y = title.bottom+25;
    [im sd_setImageWithURL:[NSURL URLWithString:self.question.imageId]];
    im.centerX = _ba.centerX;
   // [_ba addSubview:im];
    
    NSURL *resourceUrl = [NSBundle mainBundle].resourceURL;
    NSString *html = self.question.imageId;
    UIWebView *webView = [UIWebView new];
    webView.scalesPageToFit = YES;
    webView.layer.cornerRadius = 4;
    webView.layer.masksToBounds =YES;
    webView.width = 202;
    webView.height =115;
    webView.y = title.bottom+25;
    webView.centerX = _ba.centerX;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:html]]];
    [_ba addSubview:webView];
    
    
    
    
    
    UILabel* dtitle = [UILabel new];
    dtitle.numberOfLines = 0;
    dtitle.font = [UIFont systemFontOfSize:13];
    dtitle.textColor = [UIColor wr_titleTextColor];
    dtitle.x = 17;
    dtitle.y = 23+im.bottom;
    dtitle.width = ScreenW - 2*17;
    dtitle.text = [NSString stringWithFormat:@"%@",[self.question.desc stringByReplacingOccurrencesOfString:@"||" withString:@"\n"]];
    [dtitle sizeToFit];
    [_ba addSubview:dtitle];
    
    
    
    JXCircleSlider *slider = [[JXCircleSlider alloc] initWithFrame:CGRectMake((ScreenW-161)*1.0/2, _ba.height-15-161-36, 161, 161)];
    
    slider.myTopMargin = 10;
    slider.tag = 1000;
    slider.myLeftMargin = slider.myRightMargin = 0;
    [slider changeAngle: 0];
    [slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_ba addSubview:slider];
    self.slider  = slider;
    
    ifnofirst =YES;
    
    UILabel *label = [UILabel new];
    label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor wr_rehabBlueColor];
    label.font = [UIFont boldSystemFontOfSize:56];
    label.text = @"0";
    
    label.flexedHeight = YES;
    label.myTopMargin = 3;
    CGSize size = [label sizeThatFits:CGSizeMake(ScreenW, CGFLOAT_MAX)];
    label.frame = CGRectMake(0, 0, ScreenW, size.height);
    label.textAlignment = NSTextAlignmentCenter;
    label.center = slider.center;
    [_ba addSubview:label];
    _painValueLabel = label;
    
    
    
    
    if (self.question.answerType == ProTreatQuestionTypeGif) {
        
    
    
    UIButton* go = [UIButton new];
    go.width = go.height = 54;
    go.right = ScreenW-31;
    go.y = _ba.height -88-36;
    [go setImage:[UIImage imageNamed:@"1暂停"] forState:0];
    [_ba addSubview:go];
    
    
    UILabel* Gtitle = [UILabel new];
    Gtitle.numberOfLines = 0;
    Gtitle.font = [UIFont systemFontOfSize:10];
    Gtitle.textColor = [UIColor wr_detailTextColor];
    Gtitle.x = go.x;
    Gtitle.y = 10+go.bottom;
    Gtitle.width = go.width;
    Gtitle.height = 10;
    Gtitle.text = @"开始";
    Gtitle.textAlignment = NSTextAlignmentCenter;
    [_ba addSubview:Gtitle];
    
    [go bk_whenTapped:^{
        if ([go.imageView.image isEqual: [UIImage imageNamed:@"1暂停"]]) {
            [go setImage:[UIImage imageNamed:@"开始"] forState:0];
            Gtitle.text = @"停止";
            self.slider.userInteractionEnabled = NO;
            self.currentTimeValue = 0;
            if (_timer == nil) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerProc) userInfo:nil repeats:YES];
                [_timer fire];
            }
            
        }
        else
        {
            [go setImage:[UIImage imageNamed:@"1暂停"] forState:0];
            Gtitle.text = @"开始";
            self.slider.userInteractionEnabled = YES;
            [_timer invalidate];
            _timer = nil;
            
        }
        
        
    }];
    
    
    UIButton* stop = [UIButton new];
    stop.width = stop.height = 54;
    stop.left = 31;
    stop.y = _ba.height -88-36;
    [stop setImage:[UIImage imageNamed:@"重置"] forState:0];
    [_ba addSubview:stop];
    
    
    UILabel* stitle = [UILabel new];
    stitle.numberOfLines = 0;
    stitle.font = [UIFont systemFontOfSize:10];
    stitle.textColor = [UIColor wr_detailTextColor];
    stitle.x = stop.x;
    stitle.y = 10+stop.bottom;
    stitle.width = stop.width;
    stitle.height = 10;
    stitle.text = @"重置";
    stitle.textAlignment = NSTextAlignmentCenter;
    [_ba addSubview:stitle];
    
    [stop bk_whenTapped:^{
        
        [go setImage:[UIImage imageNamed:@"1暂停"] forState:0];
        Gtitle.text = @"开始";
        self.slider.userInteractionEnabled = YES;
         [_timer invalidate];
        [self.slider changeAngle:0];
        _timer = nil;
        self.currentTimeValue = 0;
    }];

    
    }
    
    
    
}
-(void)timerProc
{
    self.currentTimeValue++;
    if (self.currentTimeValue>=self.question.maxValue)
    {
        
        [self.slider changeAngle:360];
        
    }
    else
    {
        [self.slider changeAngle:360*_currentTimeValue*1.0/self.question.maxValue];
    }
    
}
- (void)onSliderValueChanged:(JXCircleSlider*)sender
{
    if (self.pain) {
        NSInteger angle;
        //    NSLog(@"angle%d",sender.angle);
        //    if (sender.angle>324) {
        //        angle = 360;
        //    } else {
        angle = sender.angle;
        //    }
        _painValueLabel.text = [@(angle*11/360) stringValue];
    }
    else
    {
        NSInteger angle;
        //    NSLog(@"angle%d",sender.angle);
        //    if (sender.angle>324) {
        //        angle = 360;
        //    } else {
        angle = sender.angle;
        WRProTreatQuestion* q = self.question;
        UILabel* la = _painValueLabel;
        NSInteger i = q.maxValue+1;
        la.text =[@(angle*i/360) stringValue];
        
    }
    
    
    
    
}
- (void)pushtonext
{
    
    
    
    WRProTreatQuestion *question = self.viewModel.questionArray[_index];
    BOOL bPain = (question.specialState == ProTreatQuestionSpecialTypePain);
    NSMutableArray *answerArray = [NSMutableArray array];
    if (bPain) {
        
        NSMutableArray *amountArray = [NSMutableArray array];
        NSUInteger index = 0;
        int value = [_painValueLabel.text intValue];
        if (self.isnew) {
            index = value-1>0?value-1:0;
        }
        else
        {
            for (int i = 0; i<_question.answers.count; i++) {
                WRProTreatAnswer *treatAnswer = _question.answers[i];
                NSString *regStr = @"(\\d+)-(\\d+)";
                NSString *src = treatAnswer.answer;
                NSRange range = [src rangeOfString:regStr options:NSRegularExpressionSearch];
                NSString *standard = [src substringWithRange:range];
                NSArray *standardArray = [standard componentsSeparatedByString:@"-"];
                [amountArray addObject:standardArray];
                if (standardArray.count == 2) {
                    if (value >= [standardArray[0] integerValue] && value <= [standardArray[1] integerValue]) {
                        index = i;
                    }
                }
            }
        }
        WRProTreatAnswer *answer = _question.answers[index];
        [answerArray addObject:answer.indexId];
        
    }
    else
    {
        //        NSMutableArray *amountArray = [NSMutableArray array];
        NSUInteger index = 0;
        //                    int value = (int)_painSlider.currentValue;
        
        UILabel* la = _painValueLabel;
        int value = [la.text intValue]==0?1:[la.text intValue];
        
        NSLog(@"index%lu",(unsigned long)index);
        //            NSLog(@"standardArray%@",amountArray);
        //            if (value >= 4 && value <= 7) {
        //                index = 1;
        //            } else if(value > 7)
        //            {
        //                index = 2;
        //            }
        
        [answerArray addObject:[NSNumber numberWithInt:value]];
        
    }
    
    WRProTreatAnswer* an = [WRProTreatAnswer new];
    an.answer = _painValueLabel.text;
    
    [self.answerArray setObject:@[an] atIndexedSubscript:_index];
    
    
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
