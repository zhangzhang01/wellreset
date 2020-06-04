//
//  WRPTFeedbackQuestionsController.m
//  rehab
//
//  Created by Matech on 4/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRPTFeedbackQuestionsController.h"
#import "WRProTreatViewModel.h"
#import "WRSlider.h"
#import "EFCircularSlider.h"

@interface WRPTFeedbackQuestionsController ()
{
    NSArray *_questionArray;
    NSMutableDictionary *_userAnswerDict;
    NSString *_proTreatRehabId;
    ProTreatFinishedState _finishedState;
    NSMutableArray *_sliderArray;
}
@end

@implementation WRPTFeedbackQuestionsController

-(instancetype)initWithQuestions:(NSArray *)questionArray proTreatRehabId:(NSString *)indexId finishedState:(ProTreatFinishedState)state {
    if (self = [super init]) {
        _proTreatRehabId = indexId;
        _sliderArray = [NSMutableArray array];
        _userAnswerDict = [NSMutableDictionary dictionary];
        _questionArray = questionArray;
        _finishedState = state;
        
        [self layout];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"康复效果反馈", nil);
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    [WRNetworkService pwiki:@"康复效果反馈"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - IBActions
-(IBAction)onSliderValueChanged:(UISlider*)sender {
    WRProTreatRehabFeedbackQuestion *question = _questionArray[sender.tag];
    _userAnswerDict[question.indexId] = @((int)(sender.value));
}

-(IBAction)onClickedSubmitButton:(UIButton*)sender {
    for(NSInteger index = 0; index < _sliderArray.count; index++) {
        EFCircularSlider *slider = _sliderArray[index];
        WRProTreatRehabFeedbackQuestion *question = _questionArray[index];
        _userAnswerDict[question.indexId] = @((int)(slider.currentValue));
    }

    if (_userAnswerDict.count != _questionArray.count) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"请填写完整反馈问题", nil)];
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:nil];
    [WRProTreatViewModel userProTreatSubmitFeedbackWithCompletion:^(NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        
        if (error) {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"反馈失败", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
            [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"重试", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf onClickedSubmitButton:sender];
            }]];
            [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf close];
            }]];
            [weakSelf presentViewController:controller animated:YES completion:nil];
        } else {
            [weakSelf close];
        }
    } answers:_userAnswerDict proTreatRehabId:_proTreatRehabId];
}

#pragma mark - 
-(void)layout {
    [self.scrollView removeAllSubviews];
    
    UIView *container = self.scrollView;
    CGRect frame = container.bounds;
    CGFloat offset = WRUIOffset,  x = offset, y = x, cx = 0;
    NSInteger tag = 0;
    for(WRProTreatRehabFeedbackQuestion *question in _questionArray) {
        x = offset;
        cx = frame.size.width - 2*x;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        label.text = [NSString stringWithFormat:@"%d. %@", (int)(tag + 1), question.question];
        label.font = [UIFont wr_labelFont];
        label.textColor = [UIColor lightGrayColor];
        label.numberOfLines = 0;
        [label sizeToFit];
        [container addSubview:label];
        y = CGRectGetMaxY(label.frame) + offset;
        
        /*
        UISlider *slider = [[WRSlider alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        slider.tag = tag;
        slider.maximumValue = question.maxValue;
        slider.minimumValue = question.minValue;
        [slider sizeToFit];
        slider.frame = [Utility resizeRect:slider.frame cx:cx height:-1];
        [slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
         */
        cx = 160;
        x = (frame.size.width - cx)/2;
        EFCircularSlider *slider = [[EFCircularSlider alloc] initWithFrame:CGRectMake(x, y, cx, cx)];
        slider.tag = tag;
        slider.maximumValue = question.maxValue;
        slider.minimumValue = question.minValue;
        slider.currentValue = slider.minimumValue;
        slider.labelFont = [UIFont wr_titleFont];
        slider.handleType = semiTransparentWhiteCircle;
        slider.filledColor = [UIColor wr_themeColor];
        slider.unfilledColor = [UIColor colorWithHexString:@"eeeeee"];
        slider.labelColor = [UIColor wr_themeColor];
        slider.handleColor = [UIColor orangeColor];
        slider.snapToLabels = NO;
        slider.lineWidth = 5;
        [container addSubview:slider];
        [_sliderArray addObject:slider];
        y = CGRectGetMaxY(slider.frame) + offset;
        tag++;
    }
    cx = MIN(320, frame.size.width);
    UIButton *button = [UIButton wr_lineBorderButtonWithTitle:NSLocalizedString(@"提交", nil)];
    cx = cx - 2*WRUIOffset;
    x = (frame.size.width - cx)/2;
    CGFloat cy = WRUIButtonHeight;
    button.frame = CGRectMake(x, y, cx, cy);
    [button addTarget:self action:@selector(onClickedSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:button];
    y = CGRectGetMaxY(button.frame) + offset;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, MAX(y, self.scrollView.bounds.size.height));
}

-(void)close {
    __weak __typeof(self) weakSelf = self;
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.completion) {
            weakSelf.completion();
        }
    }];
}
@end
