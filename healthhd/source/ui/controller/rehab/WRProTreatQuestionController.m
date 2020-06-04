//
//  WRProTreatQuestionController.m
//  rehab
//
//  Created by Matech on 3/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "DLRadioButton.h"
#import "JTNavigationController.h"
#import "RehabController.h"
#import "WRProTreatQuestionController.h"
#import "WRTreat.h"
#import "WRProTreatQuestionCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "WRProTreatQuestionCell.h"
#import "WRSlider.h"
#import "WToast.h"
#import "WRToolView.h"
#import "PQFCustomLoaders/PQFCirclesInTriangle.h"

@interface WRProTreatQuestionController ()
{
    CGRect _buttonFrame;
    NSMutableArray *_questionAnswersArray;
    NSString *_userAnswer;
    
    WRSlider *_painSlider;
    UIView *_painQuestionView;
    UILabel *_painValueLabel;
}
@property(nonatomic)WRProTreatViewModel *viewModel;
@property(nonatomic)NSMutableSet *anwsersSet;//if question equeal  value type, then answer colletion contains value as NSNumber

@property(nonatomic)UIButton *nextButton, *previousButton;
@property(nonatomic)NSUInteger currentIndex;
@property(nonatomic)WRProTreatQuestion *currentQuestion;
@property(nonatomic)UIButton *submitButton;
@property(nonatomic)UITableView *tableView;
@property(nonatomic)UIView *toolbar;

@property(nonatomic) PQFCirclesInTriangle* loader;


@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSMutableArray *answerArray;
@property (nonatomic, strong) NSMutableArray *labelArray;

@end

@implementation WRProTreatQuestionController

- (NSMutableArray *)labelArray
{
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (instancetype)initWithProTreatViewModel:(id)viewModel proTreatDisease:(id)proTreatDisease{
    if(self = [super init]){
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.viewModel = viewModel;
        self.proTreatDisease = proTreatDisease;
        self.anwsersSet = [NSMutableSet set];
        _questionAnswersArray = [NSMutableArray array];
        
        CGRect frame = self.view.frame;
        CGFloat  y = 0;
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.currentIndex = 0;
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.frame = self.view.bounds;
        _scrollView.pagingEnabled = NO;
        _scrollView.scrollEnabled = YES;
        [self.view addSubview:_scrollView];
        self.buttonArray = [NSMutableArray array];
        
        for (int i = 0; i < self.viewModel.questionArray.count; i++) {
            self.currentIndex++;
            WRProTreatQuestion *question = self.viewModel.questionArray[i];
            BOOL bPain = (question.specialState == ProTreatQuestionSpecialTypePain);
            if (bPain) {
                self.currentQuestion = question;
                UIView *view = [self createPainQuestionView];
                [_scrollView addSubview:view];
                view.top = y;
                view.backgroundColor = [UIColor whiteColor];
                y += view.frame.size.height;
                NSMutableArray *array = [NSMutableArray array];
                DLRadioButton *button = [[DLRadioButton alloc] init];
                [array addObject:button];
                [self.buttonArray addObject:array];
            } else {
                if (question.answerType == ProTreatQuestionTypeSingleSelection) {
                    self.currentQuestion = question;
                    UIView *view = [self createSingleSelectionView];
                    view.top = y;
                    view.backgroundColor = [UIColor whiteColor];
                    y += view.frame.size.height;
                    [_scrollView addSubview:view];
                } else if (question.answerType == ProTreatQuestionTypeMultiSelection){
                    self.currentQuestion = question;
                    UIView *view = [self createMultiSelectionView];
                    view.top = y;
                    view.backgroundColor = [UIColor whiteColor];
                    y += view.frame.size.height;
                    [_scrollView addSubview:view];
                } else {
                    NSLog(@"多余");
                }
            }
        }
        y += WRUIOffset;
        UIButton *button = [UIButton wr_lineBorderButtonWithTitle:NSLocalizedString(@"提交", nil)];
        CGFloat cx = MIN(280, frame.size.width - 2*WRUIOffset);
        CGFloat  x = (frame.size.width - cx)/2;
        CGFloat cy = WRUIButtonHeight;
        button.frame = CGRectMake(x, y, cx, cy);
        [button addTarget:self action:@selector(onClickedSaveButton:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:button];
        y = CGRectGetMaxY(button.frame) + WRUIOffset;
        _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, y + WRUIOffset);
        
        self.title = [NSString stringWithFormat:@"问卷(共%@题)", [@(self.viewModel.questionArray.count) stringValue]];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self createBackBarButtonItem];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    _scrollView.frame = self.view.bounds;
}

#pragma mark - IBAction
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

-(IBAction)onSliderValueChanged:(WRSlider*)sender
{
    _painValueLabel.text = [@((int)sender.value) stringValue];
}

- (void)didTapBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickedSaveButton:(UIBarButtonItem *)sender
{
    __weak __typeof(self)weakSelf = self;
    if ([self readyToSubmit]) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在诊断", nil)];
        [self.viewModel getProTreatRehabWithCompletion:^(NSError *error, id rehab) {
            [SVProgressHUD dismiss];
            if (error || rehab == nil)
            {
                UIViewController *viewController = weakSelf.navigationController;
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"诊断失败,请检测网络", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
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
                [weakSelf showRehab:rehab];
            }
        } stage:self.stage diseaseId:self.proTreatDisease.indexId specialtyId:@""];
    }
}

#pragma mark - private method
- (UIView *)createSingleSelectionView
{
    NSMutableArray *buttonArray = [NSMutableArray array];
    WRProTreatQuestion *question = self.currentQuestion;
    CGRect frame = self.view.frame;
    CGFloat offset = WRUIOffset, y = offset, smallOffset = 5;
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(offset, y, frame.size.width - 2 * offset, 44)];
    labelTitle.text = [NSString stringWithFormat:@"%d.%@",(int)self.currentIndex,question.question];
    labelTitle.font = [[UIFont wr_lightFont] fontWithBold];
    labelTitle.textColor = [UIColor blackColor];
    CGSize size = [labelTitle sizeThatFits:CGSizeMake(frame.size.width - 2 *offset, CGFLOAT_MAX)];
    labelTitle.frame = CGRectMake(offset, y, size.width, size.height);
    [containView addSubview:labelTitle];
    [self.labelArray addObject:labelTitle];
    y = labelTitle.bottom + offset;
    NSArray *answers = question.answers;
    DLRadioButton *firstRadioButton = [[DLRadioButton alloc] init];
    NSMutableArray *otherButtons = [NSMutableArray new];
    for (int i = 0; i < answers.count; i++)
    {
        WRProTreatAnswer *answer = answers[i];
        CGRect buttonFrame = CGRectMake(labelTitle.left, y, frame.size.width - 2 * offset, 32);
        DLRadioButton *radioButton = [self createRadioButtonWithFrame:buttonFrame
                                                                Title:answer.answer
                                                                Color:[UIColor lightGrayColor]];
        [containView addSubview:radioButton];
        [radioButton setIcon:[UIImage imageNamed:@"well_icon_grayradio"]];
        [radioButton setIconSelected:[UIImage imageNamed:@"well_icon_radio_grayfocus"]];
        [buttonArray addObject:radioButton];
        [radioButton sizeToFit];
        radioButton.frame = [Utility resizeRect:radioButton.frame cx:-1 height:(radioButton.height + smallOffset)];
        y = radioButton.bottom + smallOffset;
        if (i == 0) {
            firstRadioButton = radioButton;
        } else {
            [otherButtons addObject:radioButton];
        }
    }
    [self.buttonArray addObject:buttonArray];
    firstRadioButton.otherButtons = otherButtons;
    containView.height = CGRectGetMaxY(containView.subviews.lastObject.frame);
    return containView;
}

- (DLRadioButton *)createRadioButtonWithFrame:(CGRect) frame Title:(NSString *)title Color:(UIColor *)color
{
    DLRadioButton *radioButton = [[DLRadioButton alloc] initWithFrame:frame];
    radioButton.titleLabel.font = [UIFont systemFontOfSize:14];
    radioButton.titleLabel.numberOfLines = 2;
    [radioButton setTitle:title forState:UIControlStateNormal];
    [radioButton setTitleColor:color forState:UIControlStateNormal];
    radioButton.iconColor = color;
    radioButton.indicatorColor = color;
    radioButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [radioButton addTarget:self action:@selector(logSelectedButton:) forControlEvents:UIControlEventTouchUpInside];
    return radioButton;
}

- (UIView *)createMultiSelectionView
{
    NSMutableArray *buttonArray = [NSMutableArray array];
    WRProTreatQuestion *question = self.currentQuestion;
    CGRect frame = self.view.frame;
    CGFloat offset = WRUIOffset, y = offset ,smallOffset = 5;
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(offset, y, frame.size.width - 2 *offset, 0)];
    labelTitle.numberOfLines = 0;
    labelTitle.text = [NSString stringWithFormat:@"%d.%@",(int)self.currentIndex,question.question];
    labelTitle.font = [[UIFont wr_lightFont] fontWithBold];
    labelTitle.textColor = [UIColor blackColor];
    [containView addSubview:labelTitle];
    [self.labelArray addObject:labelTitle];
    CGSize size = [labelTitle sizeThatFits:CGSizeMake(frame.size.width - 2 *offset, CGFLOAT_MAX)];
    labelTitle.frame = CGRectMake(offset, y, size.width, size.height);
    [labelTitle sizeToFit];
    y = CGRectGetMaxY(labelTitle.frame) + offset;
    NSArray *answers = question.answers;
    DLRadioButton *firstRadioButton = [[DLRadioButton alloc] init];
    NSMutableArray *otherButtons = [NSMutableArray new];
    for (int i = 0; i < answers.count; i++) {
        NSString *tagStr = [NSString stringWithFormat:@"%02d%02d",(int)self.currentIndex,i];
        WRProTreatAnswer *answer = answers[i];
        CGRect buttonFrame = CGRectMake(labelTitle.left, y, frame.size.width - 2 *offset, 32);
        if (answer.type == ProTreatAnswerTypeExclusive) {
            firstRadioButton = [self createRadioButtonWithFrame:buttonFrame
                                                          Title:answer.answer
                                                          Color:[UIColor lightGrayColor]];
            firstRadioButton.tag = [tagStr intValue];
            firstRadioButton.multipleSelectionEnabled = NO;
            [firstRadioButton setIcon:[UIImage imageNamed:@"well_icon_grayuncheck"]];
            [firstRadioButton setIconSelected:[UIImage imageNamed:@"well_icon_graycheck"]];
            [containView addSubview:firstRadioButton];
            [buttonArray addObject:firstRadioButton];
            [firstRadioButton sizeToFit];
            firstRadioButton.frame = [Utility resizeRect:firstRadioButton.frame cx:-1 height:(firstRadioButton.height + smallOffset)];
            y = firstRadioButton.bottom + smallOffset;
        } else {
            DLRadioButton *radioButton = [self createRadioButtonWithFrame:buttonFrame
                                                                    Title:answer.answer
                                                                    Color:[UIColor lightGrayColor]];
            radioButton.multipleSelectionEnabled = YES;
            radioButton.tag = [tagStr intValue];
            [radioButton setIcon:[UIImage imageNamed:@"well_icon_grayuncheck"]];
            [radioButton setIconSelected:[UIImage imageNamed:@"well_icon_graycheck"]];
            radioButton.iconSquare = YES;
            [containView addSubview:radioButton];
            [otherButtons addObject:radioButton];
            radioButton.otherButtons = otherButtons;
            [buttonArray addObject:radioButton];
            [radioButton sizeToFit];
            radioButton.frame = [Utility resizeRect:radioButton.frame cx:-1 height:(radioButton.height + smallOffset)];
            y = radioButton.bottom + smallOffset;
        }
    }
    [self.buttonArray addObject:buttonArray];
    firstRadioButton.otherButtons = otherButtons;
    containView.height = CGRectGetMaxY(containView.subviews.lastObject.frame);
    return containView;
    
}

- (UIView*)createPainQuestionView
{
    WRProTreatQuestion *question = self.currentQuestion;
    UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    
    containView.backgroundColor = [UIColor whiteColor];
    CGRect frame = self.view.frame;
    CGFloat offset = WRUIOffset,  x = offset, y = x, cx = frame.size.width - 2*x;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
    label.text = [NSString stringWithFormat:@"%d.%@", (int)(self.currentIndex), question.question];
    label.numberOfLines = 0;
    label.font = [[UIFont wr_lightFont] fontWithBold];
    CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    label.frame = CGRectMake(x, y, size.width, size.height);
    [containView addSubview:label];
    [self.labelArray addObject:label];
    y = CGRectGetMaxY(label.frame) + offset;
    
    WRSlider *slider = [[WRSlider alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
    slider.maximumValue = 10;
    slider.minimumValue = 0;
    [slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider sizeToFit];
    [containView addSubview:slider];
    _painSlider = slider;
    y = CGRectGetMaxY(slider.frame) + offset;
    
    x = offset;
    cx = frame.size.width - 2*x;
    label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont wr_textFont];
    label.text = 0;
    label.text = @"0";
    [label sizeToFit];
    label.frame = CGRectMake(x, y, cx, label.frame.size.height);
    [containView addSubview:label];
    _painValueLabel = label;
    containView.height = CGRectGetMaxY(label.frame) + offset;
    return containView;
}

- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait &&
        [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

-(BOOL)readyToSubmit {
    self.answerArray = [NSMutableArray array];
    NSUInteger answerIndex = 0;
    for (int m = 0; m < self.viewModel.questionArray.count; m++) {
        NSMutableArray *answerArray = [NSMutableArray array];
        NSMutableArray *array = self.buttonArray[m];
        WRProTreatQuestion *question = self.viewModel.questionArray[m];
        for (int n = 0; n < array.count; n++) {
            DLRadioButton *button = array[n];
            BOOL bPain = (question.specialState == ProTreatQuestionSpecialTypePain);
            if (bPain) {
                NSUInteger index = 0;
                int value = (int)_painSlider.value;
                if (value >= 4 && value <= 7) {
                    index = 1;
                } else if(value > 7)
                {
                    index = 2;
                }
                WRProTreatAnswer *answer = question.answers[index];
                [answerArray addObject:answer.indexId];
                
            } else {
                WRProTreatAnswer *answer = question.answers[n];
                if (button.selected == YES) {
                    [answerArray addObject:answer.indexId];
                }
            }
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
    UIViewController *viewController = self.navigationController.presentingViewController;
    [viewController dismissViewControllerAnimated:YES completion:^{
        RehabController *proTreatRehabDetailController = [[RehabController alloc] initWithRehab:rehab];
        WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:proTreatRehabDetailController];
        [viewController presentViewController:nav animated:YES completion:^{
            
        }];
        proTreatRehabDetailController.title = [NSString stringWithFormat:@"%@ %@", self.proTreatDisease.diseaseName, NSLocalizedString(@"定制方案", nil)];
    }];
}
@end
