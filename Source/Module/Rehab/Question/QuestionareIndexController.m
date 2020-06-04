//
//  QuestionareIndexController.m
//  rehab
//
//  Created by Matech on 3/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "QuestionareIndexController.h"
#import "QuestionController.h"
#import "RehabObject.h"
#import "QuestionValueController.h"
#import "QuestionNewOneSeleteController.h"
#import "QuestionNewMutiSeleteController.h"
@interface QuestionareIndexController ()
{
    NSArray *_cellTitleArray, *_cellDetailArray;
    QuestionControllerStyle _style;
}
@property(nonatomic)ProTreatViewModel *viewModel;
@property(nonatomic)WRRehabDisease *proTreatDisease;

@end

@implementation QuestionareIndexController

-(instancetype)initWithProTreatViewModel:(ProTreatViewModel *)viewModel proTreatDisease:(id)disease style:(QuestionControllerStyle)style{
    if(self = [super init]){
        _style = style;
        self.viewModel = viewModel;
        self.proTreatDisease = disease;
        
        _cellTitleArray = @[NSLocalizedString(@"定制方案", nil), NSLocalizedString(@"问题数量", nil)];
        _cellDetailArray = @[self.proTreatDisease.diseaseName, [@(self.viewModel.questionArray.count) stringValue]];
        [self.topImageView setImageWithUrlString:self.proTreatDisease.bannerImageUrl holder:@"well_default_banner"];
        
        [UMengUtils careForProTreat:self.proTreatDisease.diseaseName step:0 state:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"well_main_icon_rehab"];
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    headImageView.tintColor = [UIColor wr_themeColor];
    
    UIView *headerView = [WRUIConfig createCentralWrapWithSubView:headImageView width:self.tableView.frame.size.width];
    self.tableView.tableHeaderView = headerView;
    
    NSString *title = NSLocalizedString(@"开始定制", nil);
    UIButton *button = [UIButton wr_lineBorderButtonWithTitle:title];
    
    CGFloat offset = WRUIBigOffset;
    CGFloat dx = self.tableView.frame.size.width - 2*offset;
    dx = MIN(320, dx);
    button.frame = CGRectMake(0, 0, dx, WRUIButtonHeight);
    [button addTarget:self action:@selector(onClickedStartButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 0)];
    button.center = CGPointMake(footerView.width/2, offset + button.height/2);
    [footerView addSubview:button];
    
    //UIView *line = [[UIView alloc] initWithFrame:CGRectMake(button.left, button.bottom + offset/2, button.width, 1)];
    //line.backgroundColor = [UIColor wr_lightGray];
    //[footerView addSubview:line];
    
    UILabel *label = [UILabel new];
    label.font = [UIFont wr_smallFont];
    label.textColor = [UIColor wr_rehabBlueColor];
    label.numberOfLines = 0;
    label.text = NSLocalizedString(@"请您根据自己的实际情况回答问题，定制专属运动方案", nil);
    CGSize size = [label sizeThatFits:CGSizeMake(button.width, CGFLOAT_MAX)];
    label.frame = CGRectMake(button.left, button.bottom + offset/2, button.width, size.height);
    [footerView addSubview:label];
    
    footerView.frame = [Utility resizeRect:footerView.frame cx:-1 height:label.bottom + offset/2];
    
    self.tableView.tableFooterView = footerView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    
    [WRNetworkService pwiki:@"专业治疗问卷"];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createBackBarButtonItem];
    
        UINavigationBar *bar = self.navigationController.navigationBar;
    
        [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [bar setShadowImage:[UIImage new]];
        bar.barTintColor = [UIColor whiteColor];
        bar.tintColor = [UIColor blackColor];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.tintColor = [UIColor blackColor];
    UINavigationBar *bar = self.navigationController.navigationBar;
    //    [bar lt_setBackgroundColor:[UIColor wr_themeColor]];
    //    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    [bar setShadowImage:[UIImage new]];
    //    bar.barTintColor = [UIColor whiteColor];
    //    bar.tintColor = bar.barTintColor;
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];

}


#pragma mark - UITableView Delegate&Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellTitleArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor wr_themeColor];
        cell.textLabel.font = [UIFont wr_textFont];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = cell.textLabel.font;
    }
    NSUInteger index = indexPath.row;
    cell.textLabel.text = _cellTitleArray[index];
    cell.detailTextLabel.text = _cellDetailArray[index];
    return cell;
}

#pragma mark - 设置分割线顶头
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - IBAction
-(IBAction)onClickedCancelButton:(id)sender {
    __weak __typeof(self) weakSelf = self;
    
    NSString *title = NSLocalizedString(@"定制尚未完成,是否要真的放弃", nil);
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"放弃", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"继续", nil) style:UIAlertActionStyleCancel handler:nil]];
    [weakSelf.navigationController presentViewController:controller animated:YES completion:nil];
}

-(IBAction)onClickedAutoStartButton:(id)sender {
    [self onClickedStartButton:sender];
}

-(IBAction)onClickedStartButton:(id)sender {
//    QuestionController *viewController = [[QuestionController alloc] initWithProTreatViewModel:self.viewModel proTreatDisease:self.proTreatDisease style:_style];
//    viewController.stage = self.stage;
//    viewController.proTreatDisease = self.proTreatDisease;
//    [self.navigationController pushViewController:viewController animated:YES];
    
    WRProTreatQuestion *question = self.viewModel.questionArray[0];
    BOOL bPain = (question.specialState == ProTreatQuestionSpecialTypePain);
    BOOL cValue = (question.specialState == 2);
    if (bPain) {
        QuestionValueController* value = [QuestionValueController new];
        value.pain=YES;
        value.viewModel = self.viewModel;
        value.QusetionArr = self.viewModel.questionArray;
        value.answerArray = [NSMutableArray array];
        value.stage =self.stage;
        value.proTreatDisease = self.proTreatDisease;
        value.index = 0;
        [self.navigationController pushViewController:value animated:YES];
    }else if (cValue)
    {
        QuestionValueController* value = [QuestionValueController new];
        
        value.viewModel = self.viewModel;
        value.QusetionArr = self.viewModel.questionArray;
        value.answerArray = [NSMutableArray array];
        value.stage =self.stage;
        value.proTreatDisease = self.proTreatDisease;
        value.index = 0;
        [self.navigationController pushViewController:value animated:YES];
    }
    else if (question.answerType == ProTreatQuestionTypeMultiSelection) {
        QuestionNewMutiSeleteController* muti = [QuestionNewMutiSeleteController new];
        muti.viewModel = self.viewModel;
        muti.QusetionArr = self.viewModel.questionArray;
        muti.answerArray = [NSMutableArray array];
        muti.stage =self.stage;
        muti.proTreatDisease = self.proTreatDisease;
        muti.index = 0;
        [self.navigationController pushViewController:muti animated:YES];
    }
    else  {
        QuestionNewOneSeleteController* one = [QuestionNewOneSeleteController new];
        one.viewModel = self.viewModel;
        one.QusetionArr = self.viewModel.questionArray;
        one.answerArray = [NSMutableArray array];
        one.index = 0;
        one.stage =self.stage;
        one.proTreatDisease = self.proTreatDisease;
        [self.navigationController pushViewController:one animated:YES];
    }



    
    
    
    
}


@end
