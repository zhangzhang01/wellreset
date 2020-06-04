 //
//  QuestionController.m
//  rehab
//
//  Created by Matech on 3/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "DLRadioButton.h"
#import "JTNavigationController.h"
#import "RehabController.h"
#import "QuestionController.h"
#import "RehabObject.h"
#import "WRSlider.h"
#import "WToast.h"
#import "WRToolView.h"
//#import "PQFCustomLoaders/PQFCirclesInTriangle.h"
#import "DiagnosticResultController.h"
#import "WRProTreatQuestionDetailController.h"
#import "MyLayout.h"
#import "QuestionDetailView.h"
#import "EFCircularSlider.h"
#import "JXCircleSlider.h"
#import "WRTestResultViewController.h"
#import <YYKit/YYKit.h>
#define NEWQUESTION_ID   @"cb888cb9-af32-47a8-8f69-2824b85d7e79"
#define NEWQUESTION_SP_ID   @"dc20c10b-85f8-45fd-b485-fade4805b88c"
@interface QuestionController ()<UIScrollViewDelegate>
{
    CGRect _buttonFrame;
    NSMutableArray *_questionAnswersArray;
    NSString *_userAnswer;
    
    EFCircularSlider *_painSlider;
    UIView *_painQuestionView;
    UILabel *_painValueLabel;
    UIFont *_questionFont, *_answerFont;
    UIColor *_questionColor, *_answerColor;
    QuestionControllerStyle _style;
}
@property(nonatomic)ProTreatViewModel *viewModel;
@property(nonatomic)NSMutableSet *anwsersSet;//if question equeal  value type, then answer colletion contains value as NSNumber

@property(nonatomic)UIButton *nextButton, *previousButton;
@property(nonatomic)NSUInteger currentIndex;
@property(nonatomic)WRProTreatQuestion *currentQuestion;
@property(nonatomic)UIButton *submitButton;
@property(nonatomic)UITableView *tableView;
@property(nonatomic)UIView *toolbar;
@property (nonatomic, strong) QuestionDetailView *questionView;
@property NSMutableArray* Valuelabalarr;
@property NSMutableArray* QusetionArr;

@property(nonatomic)NSMutableDictionary<NSString*, NSMutableArray<WRProTreatAnswer*>*> *selectedQuestionAnswer;

//@property(nonatomic) PQFCirclesInTriangle* loader;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *answerArray;
@property (nonatomic, strong) NSMutableArray *labelArray;

@property (nonatomic, strong) MyLinearLayout *contentLayout;
@property NSInteger n;
@end

@implementation QuestionController

- (NSMutableArray *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
        _Valuelabalarr = [NSMutableArray array];
        _QusetionArr = [NSMutableArray array];
        self.n=0;
    }
    return _labelArray;
}

-(NSMutableDictionary<NSString *,NSMutableArray<WRProTreatAnswer *> *> *)selectedQuestionAnswer
{
    if (_selectedQuestionAnswer == nil) {
        _selectedQuestionAnswer = [NSMutableDictionary dictionary];
    }
    return _selectedQuestionAnswer;
}

- (instancetype)initWithProTreatViewModel:(id)viewModel proTreatDisease:(id)proTreatDisease style:(QuestionControllerStyle)style{
    if(self = [super init]){
        _style = style;
        _questionFont = [[[UIFont wr_tinyFont] fontWithBold] fontWithItalic];
        _questionColor = [UIColor blackColor];
        
        _answerFont = [UIFont wr_smallFont];
        _answerColor = [UIColor lightGrayColor];
        
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.viewModel = viewModel;
        self.proTreatDisease = proTreatDisease;
        self.anwsersSet = [NSMutableSet set];
        _questionAnswersArray = [NSMutableArray array];
        
        CGRect frame = self.view.frame;
        CGFloat y = 0;
        self.
        
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.currentIndex = 0;
        
        self.buttonArray = [NSMutableArray array];
        
//        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//        scrollView.backgroundColor = [UIColor whiteColor];
//        self.view = scrollView;
//        self.scrollView = scrollView;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.backgroundColor = [UIColor wr_lightGray];
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        
        MyLinearLayout *contentLayout = [MyLinearLayout linearLayoutWithOrientation:MyLayoutViewOrientation_Vert];
        contentLayout.wrapContentWidth = NO;
        contentLayout.wrapContentHeight = YES;
        self.contentLayout = contentLayout;
        contentLayout.padding = UIEdgeInsetsMake(10, 10, 74, 10); //设置布局内的子视图离自己的边距.
        contentLayout.frame = CGRectMake(0, 0, scrollView.width, scrollView.height);
        [self.scrollView addSubview:contentLayout];
        
        for (int i = 0; i < self.viewModel.questionArray.count; i++) {
            self.currentIndex++;
            WRProTreatQuestion *question = self.viewModel.questionArray[i];
            BOOL bPain = (question.specialState == ProTreatQuestionSpecialTypePain);
            BOOL cValue = (question.specialState == 2);
            if (bPain) {
                self.currentQuestion = question;
                [self createPainQuestionView];
            }else if (cValue)
            {
                [self.QusetionArr addObject:question];
                [self createValueQuestionView];
            }
            else if (question.answers.count == 2 && question.answerType == ProTreatQuestionTypeSingleSelection) {
                [self createSingleAndTwoAnswerViewWithQuestion:question y:0];
            }
            else  {
                [self createCommonQuestionViewWithQuestion:question y:0];
            }
            
            CGFloat offset =WRUIOffset;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(offset, 0, self.contentLayout.width - 2*offset, 1)];
            view.backgroundColor = [UIColor wr_lightGray];
            view.myTopMargin = offset;
            [self.contentLayout addSubview:view];
        }
        
        y += WRUIOffset;
        UIButton *button = [UIButton wr_lineBorderButtonWithTitle:NSLocalizedString(@"提交", nil)];
        button.myTopMargin = WRUIOffset;
        button.myCenterOffset = CGPointZero;
        CGFloat cx = MIN(280, frame.size.width - 2*WRUIOffset);
        CGFloat  x = (frame.size.width - cx)/2;
        CGFloat cy = WRUIButtonHeight;
        button.frame = CGRectMake(x, y, cx, cy);
        [button addTarget:self action:@selector(onClickedSaveButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentLayout addSubview:button];
        y = CGRectGetMaxY(button.frame) + WRUIOffset;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.contentLayout.height);
        
        
//        self.title = [NSString stringWithFormat:@"%@-问卷(共%@题)",self.proTreatDisease.diseaseName, [@(self.viewModel.questionArray.count) stringValue]];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBackBarButtonItem];
    //    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
    
    _scrollView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
}


#pragma mark - IBAction
- (IBAction)onSegCtrlValueChanged:(UISegmentedControl *)sender
{
    WRProTreatQuestion *question = self.viewModel.questionArray[sender.tag - 100];
    NSMutableArray *selectedArray = [self.selectedQuestionAnswer objectForKey:question.indexId];
    if (selectedArray == nil) {
        selectedArray = [NSMutableArray array];
        [self.selectedQuestionAnswer setObject:selectedArray forKey:question.indexId];
    }
    WRProTreatAnswer *answer = question.answers[sender.selectedSegmentIndex];
    [selectedArray removeAllObjects];
    [selectedArray addObject:answer];
    
}

- (IBAction)logSelectedButton:(DLRadioButton *)radioButton {
    if (radioButton.isMultipleSelectionEnabled) {
        for (DLRadioButton *button in radioButton.otherButtons) {
            if (button.isMultipleSelectionEnabled == NO) {
                button.selected = NO;
            }
        }
    }
    else {
        for (DLRadioButton *button in radioButton.otherButtons) {
            if (button.selected == YES) {
                button.selected = NO;
            }
        }
    }
}

//- (IBAction)handleTapGesture:(UITapGestureRecognizer *)sender
//{
//    NSInteger index = sender.view.tag - 100;
//    WRProTreatQuestion *question = self.viewModel.questionArray[index];
//    WRProTreatQuestionDetailController *questionController = [[WRProTreatQuestionDetailController alloc] initWithProTreatQuestion:question];
//    [self.navigationController pushViewController:questionController animated:YES];
//}

-(IBAction)onSliderValueChanged:(JXCircleSlider*)sender
{
    if (sender.tag ==1000) {
        NSInteger angle;
        //    NSLog(@"angle%d",sender.angle);
        //    if (sender.angle>324) {
        //        angle = 360;
        //    } else {
        angle = sender.angle;
        //    }
        _painValueLabel.text = [@(angle*11/360) stringValue];
    }else
    {
        NSInteger angle;
        //    NSLog(@"angle%d",sender.angle);
        //    if (sender.angle>324) {
        //        angle = 360;
        //    } else {
        angle = sender.angle;
        WRProTreatQuestion* q = _QusetionArr[sender.tag];
        UILabel* la = _Valuelabalarr[sender.tag];
        NSInteger i = q.maxValue+1;
        la.text =[@(angle*i/360) stringValue];
        
    }
    
    
    
    
    
}

- (void)didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickedSaveButton:(UIBarButtonItem *)sender
{
    __weak __typeof(self)weakSelf = self;
    if ([self readyToSubmit]) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在定制", nil)];
        NSString* desid =self.proTreatDisease.indexId;
        if (self.newquestion) {
            desid = NEWQUESTION_ID;
        }
        [self.viewModel getProTreatRehabWithCompletion:^(NSError *  error, id  rehab,  NSInteger state, NSString * stateDescription) {
            [SVProgressHUD dismiss];
            if (error)
            {
                UIViewController *viewController = weakSelf.navigationController;
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"定制失败,请检测网络", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"重试", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf onClickedSaveButton:sender];
                }]];
                [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [viewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                }]];
                [viewController presentViewController:controller animated:YES completion:nil];
            }
            else
            {
                WRRehab *treatRehab = rehab;
                if (treatRehab && ![Utility IsEmptyString:treatRehab.createTime])
                {
                    [weakSelf showRehab:treatRehab];
                }
                else
                {
                    if (self.viewModel.UserHealthStage&&self.newquestion) {
                    
                        WRTestResultViewController* reVc = [WRTestResultViewController new];
                        reVc.UserHealthStage = self.viewModel.UserHealthStage;
                        reVc.lastarry = self.viewModel.lastarry;
                        [self.navigationController pushViewController:reVc animated:YES];
                        
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
}

#pragma mark - private method
-(UILabel*)createItemLabelWithQuestion:(WRProTreatQuestion*)question x:(CGFloat)x y:(CGFloat)y cx:(CGFloat)cx text:(NSString*)text
{
    CGFloat offset = WRUIOffset;
    NSInteger index = [self.viewModel.questionArray indexOfObject:question];
    UILabel *label = [UILabel new];
    label.textColor = [UIColor whiteColor];
    label.flexedHeight = NO;
    label.text = text;
    label.font = _answerFont;
    label.backgroundColor = [UIColor wr_rehabBlueColor];
    //[label wr_roundBorderWithColor:[UIColor lightGrayColor]];
    label.layer.cornerRadius = 5.0f;
    label.layer.masksToBounds = YES;
    label.layer.borderColor = label.backgroundColor.CGColor;
    label.layer.borderWidth = 1.0f;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = CGRectMake(x, y, size.width + 2*offset, size.height + offset);
    label.tag = 1000 + index*100 + 1;
    label.myTopMargin = offset;
    label.userInteractionEnabled = YES;
    
    __weak __typeof(self) weakSelf = self;
    [label bk_whenTapped:^{
        
        NSMutableArray *selectedArray = [weakSelf.selectedQuestionAnswer objectForKey:question.indexId];
        if (selectedArray == nil)
        {
            selectedArray = [NSMutableArray array];
            [weakSelf.selectedQuestionAnswer setObject:selectedArray forKey:question.indexId];
        }
        
        QuestionDetailView *questionView = [[QuestionDetailView alloc] initWithFrame:self.view.bounds initWithProTreatQuestion:question selectedArray:selectedArray];
        self.questionView = questionView;
        if (question.rejectType == ProTreatQuestionRejectTypeYES) {
            questionView.beforeCompletion = ^(NSArray<WRProTreatAnswer*> *answers){
                if (answers.count >= question.rejectAnswerCount) {
                    NSString *message = NSLocalizedString(@"很遗憾,WELL的康复方案目前并不适合您,建议您及早就医", nil);
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
                    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:nil]];
                    [weakSelf.navigationController presentViewController:controller animated:YES completion:nil];
                    return NO;
                }
                return YES;
            };

        }

        questionView.completion = ^(NSArray<WRProTreatAnswer*> *answers){
            [selectedArray removeAllObjects];
            [selectedArray addObjectsFromArray:answers];
            [weakSelf updateQuestionAnswer:question];
        };
        [Utility viewAddToSuperViewWithAnimation:questionView superView:self.navigationController.view completion:nil];
 
        
        
//        WRProTreatQuestionDetailController *viewController = [[WRProTreatQuestionDetailController alloc] initWithProTreatQuestion:question selectedArray:selectedArray];
//        viewController.completion = ^(NSArray<WRProTreatAnswer*> *answers){
//            [selectedArray removeAllObjects];
//            [selectedArray addObjectsFromArray:answers];
//            [weakSelf updateQuestionAnswer:question];
//        };
//        [weakSelf.navigationController pushViewController:viewController animated:YES];
        
    }];
    return label;
}

- (void)createSingleAndTwoAnswerViewWithQuestion:(WRProTreatQuestion*)question y:(CGFloat)y
{
    CGFloat offset = WRUIOffset;
    CGFloat cx = self.scrollView.width - 2*offset;
    CGFloat x = offset;
    
    NSInteger index = [self.viewModel.questionArray indexOfObject:question];
    UILabel *label = [UILabel new];
    label.text = [NSString stringWithFormat:@"%d.%@", (int)(index + 1), question.question];
    label.font = _questionFont;
    label.numberOfLines = 0;
    label.textColor = _questionColor;
    CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = CGRectMake(x, y, cx, size.height);
    label.tag = 1000 + index*100;
    label.flexedHeight = YES;
    label.myTopMargin = (index == 0) ? 0 : 2*offset;
    [self.contentLayout addSubview:label];
    [self.labelArray addObject:label];
    
    y += offset;
    cx = MIN(self.scrollView.width - 2 * offset, 400);
    NSMutableArray *array = [NSMutableArray array];
    for (WRProTreatAnswer *treat in question.answers) {
        [array addObject:treat.answer];
    }
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:array];
    if (_style == QuestionControllerNew) {
        NSMutableArray *selectedArray = [self.selectedQuestionAnswer objectForKey:question.indexId];
        if (selectedArray == nil)
        {
            selectedArray = [NSMutableArray array];
            [self.selectedQuestionAnswer setObject:selectedArray forKey:question.indexId];
        }
        for (int i = 0; i<question.answers.count; i++) {
            WRProTreatAnswer *treat = question.answers[i];
            if ([question.oldRehabAnswers isEqualToString:treat.indexId]) {
                segment.selectedSegmentIndex = i;
                [selectedArray addObject:treat];
            }
        }
    }
    segment.tag = 100 + index;
    segment.myTopMargin = offset;
    segment.width = cx;
    segment.tintColor = [UIColor wr_rehabBlueColor];
    [segment sizeToFit];
    segment.width = MAX(segment.width, self.contentLayout.width/2);
    [segment addTarget:self action:@selector(onSegCtrlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentLayout addSubview:segment];
}

-(void)createCommonQuestionViewWithQuestion:(WRProTreatQuestion*)question y:(CGFloat)y
{
    NSMutableArray *selectedArray = [self.selectedQuestionAnswer objectForKey:question.indexId];
    if (selectedArray == nil)
    {
        selectedArray = [NSMutableArray array];
        [self.selectedQuestionAnswer setObject:selectedArray forKey:question.indexId];
    }
    
    CGFloat offset = WRUIOffset;
    CGFloat cx = self.scrollView.width - 2*offset;
    CGFloat x = offset;
    
    NSInteger index = [self.viewModel.questionArray indexOfObject:question];
    UILabel *label = [UILabel new];
    label.text = [NSString stringWithFormat:@"%d.%@", (int)(index + 1), question.question];
    label.font = _questionFont;
    label.numberOfLines = 0;
    label.textColor = _questionColor;
    CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = CGRectMake(x, y, cx, size.height);
    label.tag = 1000 + index*100;
    label.flexedHeight = YES;
    label.myTopMargin = (index == 0) ? 0 : 2*offset;
    [self.contentLayout addSubview:label];
    [self.labelArray addObject:label];
    
    y += offset;
    if (_style == QuestionControllerNew) {
//        label.text = question.oldRehabAnswers;
        NSArray *anArray = [question.oldRehabAnswers componentsSeparatedByString:@"|"];
        for (int i = 0; i < anArray.count; i++) {
            label = [UILabel new];
            label.flexedHeight = NO;
            for (WRProTreatAnswer *answer in question.answers) {
                if ([anArray[i] isEqualToString:answer.indexId]) {
                    label.text = answer.answer;
                    [selectedArray addObject:answer];
                }
            }
            label.font = _answerFont;
            label.numberOfLines = 0;
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor wr_rehabBlueColor];
            
            label.layer.cornerRadius = 5.0f;
            label.layer.masksToBounds = YES;
            label.layer.borderColor = label.backgroundColor.CGColor;
            label.layer.borderWidth = 0.8f;
            
            label.textAlignment = NSTextAlignmentCenter;
            size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
            label.frame = CGRectMake(x, y, size.width + 2*offset, size.height + offset + 4);
            label.tag = 1000 + index*100 + 1;
            label.myTopMargin = offset;
            label.userInteractionEnabled = YES;
            [self.contentLayout addSubview:label];
            
            __weak __typeof(self) weakSelf = self;
            [label bk_whenTapped:^{
                QuestionDetailView *questionView = [[QuestionDetailView alloc] initWithFrame:self.view.bounds initWithProTreatQuestion:question selectedArray:selectedArray];
                self.questionView = questionView;
                if (question.rejectType == ProTreatQuestionRejectTypeYES) {
                    questionView.beforeCompletion = ^(NSArray<WRProTreatAnswer*> *answers){
                        if (answers.count >= question.rejectAnswerCount) {
                            NSString *message = NSLocalizedString(@"很遗憾,WELL的康复方案目前并不适合您,建议您及早就医", nil);
                            UIAlertController *controller = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
                            [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:nil]];
                            [weakSelf.navigationController presentViewController:controller animated:YES completion:nil];
                            return NO;
                        }
                        return YES;
                    };
                    
                }
                
                questionView.completion = ^(NSArray<WRProTreatAnswer*> *answers){
                    [selectedArray removeAllObjects];
                    [selectedArray addObjectsFromArray:answers];
                    [weakSelf updateQuestionAnswer:question];
                };
                
                [Utility viewAddToSuperViewWithAnimation:questionView superView:self.navigationController.view completion:nil];
                //        WRProTreatQuestionDetailController *viewController = [[WRProTreatQuestionDetailController alloc] initWithProTreatQuestion:question selectedArray:selectedArray];
                //        viewController.completion = ^(NSArray<WRProTreatAnswer*> *answers){
                //            [selectedArray removeAllObjects];
                //            [selectedArray addObjectsFromArray:answers];
                //            [weakSelf updateQuestionAnswer:question];
                //        };
                //        [weakSelf.navigationController pushViewController:viewController animated:YES];
                
            }];
            
            y += label.height;
        }
    } else {
        label = [UILabel new];
        label.flexedHeight = NO;
        label.text = NSLocalizedString(@"点击选择", nil);
        label.font = _answerFont;
        label.numberOfLines = 0;
        label.textColor = _answerColor;
        label.backgroundColor = [UIColor wr_lightWhite];
        
        label.layer.cornerRadius = 5.0f;
        label.layer.masksToBounds = YES;
        label.layer.borderColor = label.textColor.CGColor;
        label.layer.borderWidth = 0.8f;
        
        label.textAlignment = NSTextAlignmentCenter;
        size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y, size.width + 2*offset, size.height + offset + 4);
        label.tag = 1000 + index*100 + 1;
        label.myTopMargin = offset;
        label.userInteractionEnabled = YES;
        [self.contentLayout addSubview:label];
        
        __weak __typeof(self) weakSelf = self;
        [label bk_whenTapped:^{
            
            QuestionDetailView *questionView = [[QuestionDetailView alloc] initWithFrame:self.view.bounds initWithProTreatQuestion:question selectedArray:selectedArray];
            self.questionView = questionView;
            if (question.rejectType == ProTreatQuestionRejectTypeYES) {
                questionView.beforeCompletion = ^(NSArray<WRProTreatAnswer*> *answers){
                    if (answers.count >= question.rejectAnswerCount) {
                        NSString *message = NSLocalizedString(@"很遗憾,WELL的康复方案目前并不适合您,建议您及早就医", nil);
                        UIAlertController *controller = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
                        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:nil]];
                        [weakSelf.navigationController presentViewController:controller animated:YES completion:nil];
                        return NO;
                    }
                    return YES;
                };
                
            }
            
            questionView.completion = ^(NSArray<WRProTreatAnswer*> *answers){
                [selectedArray removeAllObjects];
                [selectedArray addObjectsFromArray:answers];
                [weakSelf updateQuestionAnswer:question];
            };
            [Utility viewAddToSuperViewWithAnimation:questionView superView:self.navigationController.view completion:nil];
        }];
    }
}

- (void)createPainQuestionView
{
    WRProTreatQuestion *question = self.currentQuestion;
    
    CGRect frame = self.contentLayout.frame;
    CGFloat offset = WRUIOffset, x = offset, cx = frame.size.width - 2*x;
    UILabel *label = [UILabel new];
    label.text = [NSString stringWithFormat:@"%d.%@", (int)(self.currentIndex), question.question];
    label.font = _questionFont;
    label.numberOfLines = 0;
    label.textColor = _questionColor;
    label.flexedHeight = YES;
    label.myTopMargin = 2 * offset;
    CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = CGRectMake(x, 0, cx, size.height);
    [self.labelArray addObject:label];
    [self.contentLayout addSubview:label];
    
    
    
    JXCircleSlider *slider = [[JXCircleSlider alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    slider.myTopMargin = 10;
    slider.tag = 1000;
    slider.myLeftMargin = slider.myRightMargin = 0;
    [slider changeAngle: 0];
    [slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentLayout addSubview:slider];
    
    label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor wr_selectItemColor];
    label.font = [_questionFont fontWithBold];
    label.text = @"0";
    
    label.flexedHeight = YES;
    label.myTopMargin = 3;
    size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = CGRectMake(x, 0, cx, size.height);
    [self.contentLayout addSubview:label];
    _painValueLabel = label;
    
    if (_style == QuestionControllerNew) {
      
        for (int i = 0; i<question.answers.count; i++) {
            WRProTreatAnswer *treat = question.answers[i];
            if ([question.oldRehabAnswers isEqualToString:treat.indexId]) {
                NSArray *painArray = [treat.answer componentsSeparatedByString:@"-"];
                NSString *painValue = painArray[0];
                [slider changeAngle: [painValue intValue] * 360 /11];
                _painValueLabel.text = painValue;
            }
        }
    }
}
- (void)createValueQuestionView
{
    WRProTreatQuestion *question =_QusetionArr[self.n];
    
    CGRect frame = self.contentLayout.frame;
    CGFloat offset = WRUIOffset, x = offset, cx = frame.size.width - 2*x;
    UILabel *label = [UILabel new];
    label.text = [NSString stringWithFormat:@"%d.%@", (int)(self.currentIndex), question.question];
    label.font = _questionFont;
    label.numberOfLines = 0;
    label.textColor = _questionColor;
    label.flexedHeight = YES;
    label.myTopMargin = 2 * offset;
    CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = CGRectMake(x, 0, cx, size.height);
    [self.labelArray addObject:label];
    [self.contentLayout addSubview:label];
    
    
    
    JXCircleSlider *slider = [[JXCircleSlider alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    slider.myTopMargin = 10;
    slider.tag = self.n;
    slider.myLeftMargin = slider.myRightMargin = 0;
    [slider changeAngle: 0];
    [slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.contentLayout addSubview:slider];
    
    label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor wr_selectItemColor];
    label.font = [_questionFont fontWithBold];
    label.text = @"0";
    label.flexedHeight = YES;
    label.myTopMargin = 3;
    size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = CGRectMake(x, 0, cx, size.height);
    
    [self.contentLayout addSubview:label];
    
    [_Valuelabalarr addObject:label];
    self.n++;
    if (_style == QuestionControllerNew) {
        
        for (int i = 0; i<question.answers.count; i++) {
            WRProTreatAnswer *treat = question.answers[i];
            if ([question.oldRehabAnswers isEqualToString:treat.indexId]) {
                NSArray *painArray = [treat.answer componentsSeparatedByString:@"-"];
                NSString *painValue = painArray[0];
                [slider changeAngle: [painValue intValue] * 360 /(question.maxValue+1)];
                UILabel* la = _Valuelabalarr[self.n];
                la.text = painValue;
            }
        }
    }
}

-(void)updateQuestionAnswer:(WRProTreatQuestion*)question
{
    NSInteger index = [self.viewModel.questionArray indexOfObject:question];
    
    NSInteger tag = 1000 + index*100;
    UILabel *titleLabel = [self.contentLayout viewWithTag:tag];
    NSInteger viewIndex = [self.contentLayout.subviews indexOfObject:titleLabel];
    viewIndex++;
    NSMutableArray *answers = self.selectedQuestionAnswer[question.indexId];
    for(NSInteger index = 0; ; index++)
    {
        tag++;
        UILabel *label = [self.contentLayout viewWithTag:tag];
        if (label) {
            [label removeFromSuperview];
        }
        if (index < answers.count) {
            WRProTreatAnswer *answer = answers[index];
            label = [self createItemLabelWithQuestion:question x:titleLabel.left y:0 cx:titleLabel.width text:answer.answer];
            label.tag = tag;
            [self.contentLayout insertSubview:label atIndex:(viewIndex++)];
        } else {
            if (!label) {
                break;
            }
        }
    }
}

-(BOOL)readyToSubmit {
    self.answerArray = [NSMutableArray array];
    NSUInteger answerIndex = 0;
    for (int m = 0; m < self.viewModel.questionArray.count; m++) {
        NSMutableArray *answerArray = [NSMutableArray array];
        
        WRProTreatQuestion *question = self.viewModel.questionArray[m];
        BOOL bPain = (question.specialState == ProTreatQuestionSpecialTypePain);
        BOOL cValue = (question.specialState == 2);
        if (bPain) {
            NSMutableArray *amountArray = [NSMutableArray array];
            NSUInteger index = 0;
//                    int value = (int)_painSlider.currentValue;
            int value = [_painValueLabel.text intValue];
            if (_newquestion) {
                WRProTreatAnswer *treatAnswer = question.answers[value];
                [answerArray addObject:treatAnswer.indexId];
            }
           else
           {
               for (int i = 0; i<question.answers.count; i++) {
                   WRProTreatAnswer *treatAnswer = question.answers[i];
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
               NSLog(@"index%lu",(unsigned long)index);
               //            NSLog(@"standardArray%@",amountArray);
               //            if (value >= 4 && value <= 7) {
               //                index = 1;
               //            } else if(value > 7)
               //            {
               //                index = 2;
               //            }
               WRProTreatAnswer *answer = question.answers[index];
               [answerArray addObject:answer.indexId];
           }
            
        }
        else if (cValue) {
            NSMutableArray *amountArray = [NSMutableArray array];
            NSUInteger index = 0;
            //                    int value = (int)_painSlider.currentValue;
            NSInteger n = 0;
            n = [self.QusetionArr indexOfObject:question];
            UILabel* la = self.Valuelabalarr[n];
            int value = [la.text intValue];
           
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
        else {
            NSMutableArray<WRProTreatAnswer *> *array = self.selectedQuestionAnswer[question.indexId];
            [array enumerateObjectsUsingBlock:^(WRProTreatAnswer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [answerArray addObject:obj.indexId];
            }];
            
        }
        
        [self.answerArray addObject:answerArray];
        NSString *answer =  [answerArray componentsJoinedByString:@"|"];
        [self.viewModel setAnswer:answer index:answerIndex++];
    }
    
    for (int i = 0; i < self.viewModel.userAnswerArray.count; i++) {
        NSString *string = self.viewModel.userAnswerArray[i];
        UILabel *label = self.labelArray[i];
        if ([string isEqualToString:@""]) {
            label.textColor = [UIColor redColor];
        } else {
            label.textColor = [UIColor lightGrayColor];
        }
    }
    
    NSString *errorString = nil;
    do {
        BOOL flag = YES;
        for (NSString *string in self.viewModel.userAnswerArray) {
            if ([string isEqualToString:@""]) {
                errorString = @"请填写完整试卷";
                flag = NO;
                break;
            }
        }
        
        if (!flag) {
            break;
        }
        return YES;
    }while(NO);
    [SVProgressHUD showErrorWithStatus:errorString];
    return NO;
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
@end
