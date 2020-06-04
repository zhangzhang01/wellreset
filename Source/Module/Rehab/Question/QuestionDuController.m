//
//  QuestionDuController.m
//  rehab
//
//  Created by yongen zhou on 2017/8/15.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "QuestionDuController.h"
#import "WRObject.h"
#import "ProTreatViewModel.h"
#import "QuestionNewMutiSeleteController.h"
#import "QuestionValueController.h"
#import "QuestionNewResultController.h"
#import "AddTreatDiseaseBaseContrller.h"
#import "RehabController.h"
#import "HealthController.h"
//#import "TYCyclePagerView.h"
//#import "TYPageControl.h"
//#import "TYCyclePagerViewCell.h"
#import "QuestionGifController.h"
#import "QuestionDuController.h"
#import "QuestionNewOneSeleteController.h"
#import "SearchResultController.h"
@interface QuestionDuController ()
{
    UIScrollView* _ba;
    BOOL ifnofirst;
}
@property WRProTreatQuestion* question;
@property WRProTreatAnswer* answer;
@property NSInteger  tag;
@property UIButton* btn;


//@property (nonatomic, strong) TYCyclePagerView *pagerView;
//@property (nonatomic, strong) TYPageControl *pageControl;
@property (nonatomic, strong) NSArray *datas;
@property (nonatomic, strong) UIImageView* im;
@property (nonatomic, strong) UILabel* choosestr;
@end

@implementation QuestionDuController

- (void)viewDidLoad {
    [super viewDidLoad];
    _ba = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.view.height-64-51)];
    [self.view addSubview:_ba];
    //    [self layout];
    
    
    UIButton* right = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30+4, 15)];
    [self createBackBarButtonItem];
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
    [_ba removeAllSubviews];
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
    im.y = title.bottom+30;
    im.width = im.height = 170;
    im.layer.cornerRadius = 4;
    im.layer.masksToBounds = YES;
    [_ba addSubview:im];
    im.centerX = _ba.centerX;
    self.im = im;
    
    UIView* line = [UIView new];
    line.x = 30;
    line.y = im.bottom+18;
    line.width = ScreenW - 18*2;
    [_ba addSubview:line];
    
    UIImageView* pin = [UIImageView new];
    pin.x = 63;
    pin.y = line.bottom+15;
    pin.width = 12;
    pin.height = 20;
    [pin setImage:[UIImage imageNamed:@"回答选择勾选状态"]];
    [_ba addSubview:pin];
    
    UILabel* chooseStr = [UILabel new];
    chooseStr.x = pin.right+22;
    chooseStr.height = 15;
    chooseStr.width = ScreenW-63;
    chooseStr.centerY = pin.centerY;
    chooseStr.font = [UIFont boldSystemFontOfSize:15];
    chooseStr.textColor = [UIColor wr_titleTextColor];
    [_ba addSubview:chooseStr];
    self.choosestr = chooseStr;
    
//    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc]init];
//   // pagerView.layer.borderWidth = 1;
//    pagerView.isInfiniteLoop = NO;
//    pagerView.dataSource = self;
//    pagerView.delegate = self;
//
//    [_ba addSubview:pagerView];
//    _pagerView = pagerView;
//    _pagerView.frame = CGRectMake(0, chooseStr.bottom+23-26, CGRectGetWidth(self.view.frame), 78+26*2);
//    _pagerView.clipsToBounds = NO;
    
    
    
    // registerClass or registerNib
//    [pagerView registerClass:[TYCyclePagerViewCell class] forCellWithReuseIdentifier:@"cellId"];
//
//
//
//    TYPageControl *pageControl = [[TYPageControl alloc]init];
    //pageControl.numberOfPages = _datas.count;
//    pageControl.currentPageIndicatorSize = CGSizeMake(8, 8);
    //    pageControl.pageIndicatorImage = [UIImage imageNamed:@"Dot"];
    //    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"DotSelected"];
    //    pageControl.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    //    pageControl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //    pageControl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [pageControl addTarget:self action:@selector(pageControlValueChangeAction:) forControlEvents:UIControlEventValueChanged];
//    [_pagerView addSubview:pageControl];
//
//    _pageControl = pageControl;
//    _pageControl.frame = CGRectMake(0, CGRectGetHeight(_pagerView.frame)-26, CGRectGetWidth(_pagerView.frame), 26);
//    [self loadData];
//    _pagerView.layout.layoutType = TYCyclePagerTransformLayoutLinear;
//    [_pagerView setNeedUpdateLayout];
    
    
}
- (void)loadData {
//    NSMutableArray *datas = [NSMutableArray array];
//    datas = self.question.answers;
//    _datas = [datas copy];
//    _pageControl.numberOfPages = _datas.count;
//    [_pagerView reloadData];
}
//- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
//    return _datas.count;
//}

//- (UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
//    TYCyclePagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndex:index];
//    WRProTreatAnswer* answer = self.datas[index];
//    [cell.im setImageURL:[NSURL URLWithString:answer.img]];
//    cell.im.layer.borderWidth =0;
//    cell.label.textColor = [UIColor wr_detailTextColor];
//    if (index == _pagerView.curIndex) {
//        cell.im.layer.borderWidth =1;
//        cell.im.layer.borderColor = [UIColor redColor].CGColor;
//        cell.label.textColor = [UIColor redColor];
//    }
//
//
//    cell.label.text = [NSString stringWithFormat:@"%@", answer.angle];
//    return cell;
//}
//
//
//- (TYCyclePagerViewLayout *)layoutForPagerView:(TYCyclePagerView *)pageView {
//    TYCyclePagerViewLayout *layout = [[TYCyclePagerViewLayout alloc]init];
//    layout.itemSize = CGSizeMake(67, 67+10+20);
//    layout.itemSpacing = 12;
//    layout.minimumScale = 0.9;
//    layout.itemHorizontalCenter = YES;
//    layout.layoutType = TYCyclePagerTransformLayoutLinear;
//    return layout;
//}
//
//- (void)pagerView:(TYCyclePagerView *)pageView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
//    _pageControl.currentPage = toIndex;
//    self.answer = self.question.answers[toIndex];
//    [self.im setImageURL:[NSURL URLWithString:self.answer.img]];
//    self.choosestr.text = self.answer.desc;
//    NSRange r= [self.answer.desc rangeOfString:self.answer.angle];
//    [self.choosestr setWr_AttributedWithColorRange:r Color:[UIColor redColor] InintTitle:self.choosestr.text];
//     [self.pagerView reloadData];
//
//    NSLog(@"%ld ->  %ld",fromIndex,toIndex);
//}
//-(void)pagerView:(TYCyclePagerView *)pageView didSelectedItemCell:(__kindof UICollectionViewCell *)cell atIndex:(NSInteger)index
//{
//    [self.pagerView reloadData];
//    [pageView scrollToItemAtIndex:index animate:YES];
//
//
//}

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
        if (!arr) {
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
        
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"继续", nil) style:UIAlertActionStyleCancel handler:nil]];
    [weakSelf.navigationController presentViewController:controller animated:YES completion:nil];
}
//- (void)pageControlValueChangeAction:(TYPageControl *)sender {
//    NSLog(@"pageControlValueChangeAction: %ld",sender.currentPage);
//}

- (void)pushtonext
{
    
    
    
    WRProTreatQuestion *question = self.viewModel.questionArray[_index];
    BOOL bPain = (question.specialState == ProTreatQuestionSpecialTypePain);
    NSMutableArray *answerArray = [NSMutableArray array];
    if (bPain) {
        
        NSMutableArray *amountArray = [NSMutableArray array];
        NSUInteger index = 0;
        int value = [self.answer.answer intValue];
        if (self.isnew) {
     //       index = value-1>0?value-1:0;
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
                   // if (value >= [standardArray[0] integerValue] && value <= [standardArray[1] integerValue]) {
                  //      index = i;
                   // }
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
        
     //   UILabel* la = _painValueLabel;
        int value = [self.answer.answer intValue];;
        
        NSLog(@"index%lu",(unsigned long)index);
        //            NSLog(@"standardArray%@",amountArray);
        //            if (value >= 4 && value <= 7) {
        //                index = 1;
        //            } else if(value > 7)
        //            {
        //                index = 2;
        //            }
        
       [answerArray addObject:self.answer.answer];
        
    }
    
    WRProTreatAnswer* an =  [WRProTreatAnswer new];
    an.answer = self.answer.angle;
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


@end
