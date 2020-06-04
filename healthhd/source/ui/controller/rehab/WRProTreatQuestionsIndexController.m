//
//  WRProTreatQuestionsIndexController.m
//  rehab
//
//  Created by Matech on 3/12/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRProTreatQuestionsIndexController.h"
#import "WRProTreatQuestionController.h"
#import "WRProTreat.h"

@interface WRProTreatQuestionsIndexController ()
{
    NSArray *_cellTitleArray, *_cellDetailArray;
}
@property(nonatomic)WRProTreatViewModel *viewModel;
@property(nonatomic)WRRehabDisease *proTreatDisease;

@end

@implementation WRProTreatQuestionsIndexController

-(instancetype)initWithProTreatViewModel:(WRProTreatViewModel *)viewModel proTreatDisease:(id)disease {
    if(self = [super init]){
        
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
    CGFloat dx = self.tableView.frame.size.width - 2*WRUIBigOffset;
    dx = MIN(320, dx);
    button.frame = CGRectMake(0, 0, dx, WRUIButtonHeight);
    [button addTarget:self action:@selector(onClickedStartButton:) forControlEvents:UIControlEventTouchUpInside];
    UIView *footerView = [WRUIConfig createCentralWrapWithSubView:button width:self.tableView.frame.size.width offset:0];
    self.tableView.tableFooterView = footerView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView reloadData];
    
    [WRNetworkService pwiki:@"专业治疗问卷"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self createBackBarButtonItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
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
    
    NSString *title = NSLocalizedString(@"诊断尚未完成,是否要真的放弃", nil);
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
    WRProTreatQuestionController *viewController = [[WRProTreatQuestionController alloc] initWithProTreatViewModel:self.viewModel proTreatDisease:self.proTreatDisease];
    viewController.stage = self.stage;
    viewController.proTreatDisease = self.proTreatDisease;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
