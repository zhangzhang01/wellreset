//
//  QuestionDetailView.m
//  rehab
//
//  Created by yefangyang on 2016/12/15.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "QuestionDetailView.h"
#import "GBTagListView.h"
#import <YYKit/YYKit.h>
@interface QuestionDetailView (){
    WRProTreatQuestion *_proTreatQusetion;
    CGRect previousFrame ;
    int totalHeight ;
}
@property(nonatomic)NSMutableSet *anwsersSet;
@property (nonatomic, strong) UIButton *completeButton;
@end

@implementation QuestionDetailView

-(instancetype)initWithFrame:(CGRect)frame initWithProTreatQuestion:question selectedArray:selectedArray{
    if (self = [super initWithFrame:frame]) {
        
        _proTreatQusetion = question;
        
        self.anwsersSet = [NSMutableSet set];
        [self.anwsersSet addObjectsFromArray:selectedArray];
        totalHeight = 0;
        [self layOut];

        self.backgroundColor = [UIColor colorWithHexString:@"0a0a0aaa"];
    }
    
    return self;
}

- (void)layOut
{
    CGFloat offset = WRUIOffset, y = WRUIOffset, x = WRUIOffset, cx, cy, leftInset = 2 *WRUIOffset, topInset = 64;
    cx = self.width - 2 * leftInset;
    cy = self.height - 2 * topInset;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftInset, topInset, cx, cy)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.layer.cornerRadius = 5.0f;
    scrollView.clipsToBounds = YES;
    scrollView = scrollView;
    scrollView.backgroundColor = [UIColor wr_bgColor];
    [self addSubview:scrollView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close_button"] forState:UIControlStateNormal];
    [button sizeToFit];
    x = scrollView.right - button.width/2;
    y = scrollView.top - button.height/2;
    button.frame = [Utility moveRect:button.frame x:x y:y];
    button.tag = -1;
    [self addSubview:button];
    [button addTarget:self action:@selector(onClickedCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    x = offset;
    y = offset;

    UIFont *questionFont = [[[UIFont wr_tinyFont] fontWithBold] fontWithItalic];
    UIColor *questionColor = [UIColor blackColor];
//    CGRect frame = scrollView.frame;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx - 2 * x, cy)];
    labelTitle.numberOfLines = 0;
    NSString *choiceType = (_proTreatQusetion.answerType == ProTreatQuestionTypeSingleSelection)?NSLocalizedString(@"单选", nil):NSLocalizedString(@"多选", nil);
    labelTitle.text = [NSString stringWithFormat:@"%@(%@)",_proTreatQusetion.question, choiceType];
    labelTitle.font = questionFont;
    labelTitle.textColor = questionColor;
    [labelTitle sizeToFit];
    labelTitle.frame = [Utility resizeRect:labelTitle.frame cx:labelTitle.width height:labelTitle.height];
//    CGSize size = [labelTitle sizeThatFits:CGSizeMake(cx - 2 *x, CGFLOAT_MAX)];
//    labelTitle.frame = CGRectMake(x, y, size.width, size.height);
    [scrollView addSubview:labelTitle];
    y = labelTitle.bottom + offset;
    
    //    frame = CGRectMake(x, y, labelTitle.width, labelTitle.height);
    NSMutableArray *tagArray = [NSMutableArray array];
    for (WRProTreatAnswer *answer in _proTreatQusetion.answers) {
        [tagArray addObject:answer.answer];
    }
    GBTagListView *tagView;
    if (_proTreatQusetion.answerType == ProTreatQuestionTypeSingleSelection) {
        tagView = [[GBTagListView alloc] initWithFrame:CGRectMake(x, y, cx - 2 * x, 0) style:tagViewStyleSingle];
    } else {
        tagView = [[GBTagListView alloc] initWithFrame:CGRectMake(x, y, cx - 2 * x, 0) style:tagViewStyleMultiple];
    }
    
    tagView.canTouch = YES;
    tagView.signalTagColor=[UIColor whiteColor];
    [tagView setTagWithTagArray:_proTreatQusetion.answers selectedArray:self.anwsersSet.allObjects];
    
    __weak __typeof(self) weakSelf = self;
    [tagView setDidselectItemBlock:^(NSArray *arr) {
        [weakSelf.anwsersSet removeAllObjects];
        [weakSelf.anwsersSet addObjectsFromArray:arr];
        weakSelf.completeButton.enabled = [weakSelf checkRightBarButtonIsComplete];
        if (weakSelf.completeButton.enabled) {
            weakSelf.completeButton.backgroundColor = [UIColor wr_rehabBlueColor];
        } else {
            weakSelf.completeButton.backgroundColor = [UIColor lightGrayColor];
        }
    }];
    [scrollView addSubview:tagView];
    
//    CGFloat buttonH = 48;
//    y = MAX(tagView.bottom + offset, scrollView.height - buttonH - offset - WRStatusBarHeight - WRNavBarHeight);
    y = MAX(scrollView.height - 44 - offset, tagView.bottom + offset);
    x = 2 * offset;
    cx = scrollView.width - 2 * x;
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeButton setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    completeButton.enabled = NO;
    completeButton.layer.cornerRadius = 5.0f;
    completeButton.backgroundColor = [UIColor lightGrayColor];
    completeButton.frame = CGRectMake(x, y, cx, 44);
    [completeButton addTarget:self action:@selector(onClickedBarButtomItem:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:completeButton];
    self.completeButton = completeButton;
    scrollView.contentSize = CGSizeMake(scrollView.width, completeButton.bottom + offset);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [Utility removeFromSuperViewWithAnimation:self completion:^{

    }];
}

- (BOOL)checkRightBarButtonIsComplete
{
    BOOL isComplete = NO;
    if (self.anwsersSet.count > 0) {
        isComplete = YES;
    }
    return isComplete;
}

- (IBAction)tagBtnClick:(UIButton *)sender
{
    
}

//- (void)setHight:(UIView *)view andHight:(CGFloat)hight
//{
//    CGRect tempFrame = view.frame;
//    tempFrame.size.height = hight;
//    view.frame = tempFrame;
//}
- (IBAction)onClickedBarButtomItem:(UIButton *)sender
{
    /*
    if (_proTreatQusetion.rejectType == ProTreatQuestionRejectTypeYES) {
        if (self.anwsersSet.count >= _proTreatQusetion.rejectAnswerCount) {
            NSString *message = NSLocalizedString(@"很遗憾,WELL的康复方案目前并不适合您,建议您及早就医", nil);
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
            __weak __typeof(self) weakSelf = self;
            [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"停止", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            }]];
            [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"修改", nil) style:UIAlertActionStyleCancel handler:nil]];
            [self.navigationController presentViewController:controller animated:YES completion:nil];
            return;
        }
    }
     */
    __weak __typeof(self)weakself = self;
    BOOL flag = YES;
    if (self.beforeCompletion) {
        flag = self.beforeCompletion(self.anwsersSet.allObjects);
        
    }
    if (flag) {
        [Utility removeFromSuperViewWithAnimation:self completion:^{
            if (weakself.completion) {
                weakself.completion(weakself.anwsersSet.allObjects);
            }
        }];
    }
}


#pragma mark - event
-(IBAction)onClickedCloseButton:(UIButton*)sender
{
    [Utility removeFromSuperViewWithAnimation:self completion:^{
    }];
}


@end
