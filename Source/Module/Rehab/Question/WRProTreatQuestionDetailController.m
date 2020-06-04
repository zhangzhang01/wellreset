//
//  WRProTreatQuestionDetailController.m
//  rehab
//
//  Created by yefangyang on 16/9/12.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRProTreatQuestionDetailController.h"
#import "RehabObject.h"
#import "WRProTreatQuestionCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
#import "GBTagListView.h"
#import <YYKit/YYKit.h>
#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       10.0f
#define BOTTOM_MARGIN      10.0f
#define KBtnTag            1000
@interface WRProTreatQuestionDetailController (){
    WRProTreatQuestion *_proTreatQusetion;
    CGRect previousFrame ;
    int totalHeight ;

}
@property(nonatomic)NSMutableSet *anwsersSet;
@property (nonatomic, strong) UIButton *completeButton;

@end

@implementation WRProTreatQuestionDetailController

- (instancetype)initWithProTreatQuestion:(WRProTreatQuestion *)proTreatQuestion selectedArray:(NSMutableArray *)selectedArray
{
    if (self = [super init]) {
        _proTreatQusetion = proTreatQuestion;
        self.navigationItem.title = NSLocalizedString(@"问题", nil);
        /*
        if (_proTreatQusetion.answerType == ProTreatQuestionTypeSingleSelection) {
            self.navigationItem.title = NSLocalizedString(@"单选", nil);
        } else {
             self.navigationItem.title = NSLocalizedString(@"多选", nil);
        }
         */
        
        self.anwsersSet = [NSMutableSet set];
        [self.anwsersSet addObjectsFromArray:selectedArray];
        totalHeight = 0;
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onClickedBarButtomItem:)];
//        self.navigationItem.rightBarButtonItem.enabled = [self checkRightBarButtonIsComplete];
        [self layOut];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
}

- (void)layOut
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView = scrollView;
    scrollView.backgroundColor = [UIColor wr_bgColor];
    [self.view addSubview:scrollView];
    UIFont *questionFont = [[[UIFont wr_tinyFont] fontWithBold] fontWithItalic];
    UIColor *questionColor = [UIColor blackColor];
    
    CGFloat offset = WRUIOffset, y, x = WRUIOffset, cx, cy = 44;
    y = offset;
    CGRect frame = scrollView.frame;
    cx = frame.size.width - 2 * offset;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
    labelTitle.numberOfLines = 0;
    NSString *choiceType = (_proTreatQusetion.answerType == ProTreatQuestionTypeSingleSelection)?NSLocalizedString(@"单选", nil):NSLocalizedString(@"多选", nil);
    labelTitle.text = [NSString stringWithFormat:@"%@(%@)",_proTreatQusetion.question, choiceType];
    labelTitle.font = questionFont;
    labelTitle.textColor = questionColor;
    CGSize size = [labelTitle sizeThatFits:CGSizeMake(frame.size.width - 2 *offset, CGFLOAT_MAX)];
    labelTitle.frame = CGRectMake(offset, y, size.width, size.height);
    [scrollView addSubview:labelTitle];
    y = labelTitle.bottom + offset;
    
//    frame = CGRectMake(x, y, labelTitle.width, labelTitle.height);
    NSMutableArray *tagArray = [NSMutableArray array];
    for (WRProTreatAnswer *answer in _proTreatQusetion.answers) {
        [tagArray addObject:answer.answer];
    }
    GBTagListView *tagView;
    if (_proTreatQusetion.answerType == ProTreatQuestionTypeSingleSelection) {
            tagView = [[GBTagListView alloc] initWithFrame:CGRectMake(x, y, cx, 0) style:tagViewStyleSingle];
    } else {
            tagView = [[GBTagListView alloc] initWithFrame:CGRectMake(x, y, cx, 0) style:tagViewStyleMultiple];
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
            weakSelf.completeButton.backgroundColor = [UIColor wr_themeColor];
        } else {
            weakSelf.completeButton.backgroundColor = [UIColor lightGrayColor];
        }
    }];
    [scrollView addSubview:tagView];
    
    CGFloat buttonH = 48;
    y = MAX(tagView.bottom + offset, scrollView.height - buttonH - offset - WRStatusBarHeight - WRNavBarHeight);
    x = 2 * offset;
    cx = scrollView.width - 2 * x;
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeButton setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    completeButton.enabled = NO;
    completeButton.layer.cornerRadius = 5.0f;
    completeButton.backgroundColor = [UIColor lightGrayColor];
    completeButton.frame = CGRectMake(x, y, cx, cy);
    [completeButton addTarget:self action:@selector(onClickedBarButtomItem:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:completeButton];
    self.completeButton = completeButton;
    scrollView.contentSize = CGSizeMake(scrollView.width, completeButton.bottom + offset);
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

- (void)setHight:(UIView *)view andHight:(CGFloat)hight
{
    CGRect tempFrame = view.frame;
    tempFrame.size.height = hight;
    view.frame = tempFrame;
}
- (IBAction)onClickedBarButtomItem:(UIButton *)sender
{
    if (self.completion) {
        self.completion(self.anwsersSet.allObjects);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        NSString *text = [NSString stringWithFormat:@"%@", _proTreatQusetion.question];
//        return [tableView cellHeightForIndexPath:indexPath
//                                           model:text
//                                         keyPath:@"model"
//                                       cellClass:[WRProTreatQuestionTitleCell class]
//                                contentViewWidth:tableView.bounds.size.width];
//    }
//    else {
//        WRProTreatAnswer *answer = _proTreatQusetion.answers[indexPath.row - 1];
//        return [tableView cellHeightForIndexPath:indexPath model:answer keyPath:@"model" cellClass:[WRProTreatQuestionCell class] contentViewWidth:tableView.bounds.size.width];
//    }
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return _proTreatQusetion.answers.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString *identifier = WRCellIdentifier;
//    if (indexPath.row == 0) {
//        identifier = @"title";
//    }
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        if([identifier isEqualToString:@"title"]){
//            cell = [[WRProTreatQuestionTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        } else {
//            cell = [[WRProTreatQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//    }
//    
//    NSInteger index = indexPath.row;
//    if (index == 0)
//    {
//        WRProTreatQuestionTitleCell *titleCell = (WRProTreatQuestionTitleCell*)cell;
//        titleCell.model = [NSString stringWithFormat:@"%@", _proTreatQusetion.question];
//    }
//    else
//    {
//        WRProTreatQuestionCell *questionCell = (WRProTreatQuestionCell*)cell;
//        WRProTreatAnswer *answer = _proTreatQusetion.answers[index - 1];
//        BOOL flag = [self.anwsersSet containsObject:answer];
//        NSString *imageName = flag?@"well_icon_check":@"well_icon_uncheck";
//        if (_proTreatQusetion.answerType == ProTreatQuestionTypeSingleSelection) {
//            imageName = flag?@"well_icon_radio_focus":@"well_icon_radio";
//        }
//        questionCell.model = answer;
//        questionCell.imageView.image = [UIImage imageNamed:imageName];
//    }
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSInteger index = indexPath.row;
//    if (index > 0) {
//        WRProTreatAnswer *answer = _proTreatQusetion.answers[index - 1];
//        
//        BOOL exist = [self.anwsersSet containsObject:answer];
//        
//        if (_proTreatQusetion.answerType == ProTreatQuestionTypeSingleSelection)
//        {
//            if(!exist) {
//                [self.anwsersSet removeAllObjects];
//                [self.anwsersSet addObject:answer];
//                [tableView reloadData];
//            }
//        } else {
//            if (answer.type == ProTreatAnswerTypeExclusive) {
//                [self.anwsersSet removeAllObjects];
//                [self.anwsersSet addObject:answer];
//            } else {
//                for(WRProTreatAnswer *answer in _proTreatQusetion.answers)
//                {
//                    if (answer.type == ProTreatAnswerTypeExclusive) {
//                        [self.anwsersSet removeObject:answer];
//                        break;
//                    }
//                }
//                
//                if (exist) {
//                    [self.anwsersSet removeObject:answer];
//                } else {
//                    [self.anwsersSet addObject:answer];
//                }
//            }
//            [tableView reloadData];
//        }
//    }
//
//}



@end
