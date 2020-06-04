//
//  WRProgressViewController.m
//  rehab
//
//  Created by Matech on 3/2/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "GzwTableViewLoading.h"
#import "JTNavigationController.h"
#import "RehabController.h"
#import "SVProgressHUD.h"

#import "WRProgressViewController.h"
#import "WRProTreat.h"
#import "WRProTreatViewModel.h"
#import "WRProgressCell.h"

#import "ShareUserData.h"

@interface WRProgressViewController ()
@property(nonatomic)BOOL flag;
@end

@implementation WRProgressViewController

- (instancetype)init {
    if(self = [super initWithStyle:UITableViewStylePlain]){
        [self defaultStyle];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.buttonNormalColor = [UIColor clearColor];
    self.tableView.buttonHighlightColor = [UIColor clearColor];
    self.tableView.loadedImageName = @"well_default";
    NSString *desc;
    desc = NSLocalizedString(@"您没有进行过健康测试和定制康复", nil);
    self.tableView.descriptionText = desc;
    self.tableView.dataVerticalOffset = -100;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [WRNetworkService pwiki:@"WELL进度"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createBackBarButtonItem];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - UITableView Delegate&Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    count += [ShareUserData userData].proTreatRehab.count + [ShareUserData userData].treatRehab.count;
    return count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image = [UIImage imageNamed:@"well_default_banner"];
    return tableView.frame.size.width*image.size.height/image.size.width;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%d-%d", (int)indexPath.section, (int)indexPath.row];
    
    WRProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WRProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    WRRehab *object;
    NSUInteger index = indexPath.row;
    if (index < [ShareUserData userData].treatRehab.count) {
        object = [ShareUserData userData].treatRehab[index];
    } else {
        object = [ShareUserData userData].proTreatRehab[index - [ShareUserData userData].treatRehab.count];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"%@-%@", object.disease.specialty, object.disease.diseaseName];
    cell.contentLabel.text = [NSString stringWithFormat:@"%@",  object.createTime];
    [cell.imageView setImageWithUrlString:object.disease.bannerImageUrl holder:@"well_default_banner"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WRRehab *object;
    NSUInteger index = indexPath.row;
    if (index < [ShareUserData userData].treatRehab.count) {
        object = [ShareUserData userData].treatRehab[index];
    } else {
        object = [ShareUserData userData].proTreatRehab[index - [ShareUserData userData].treatRehab.count];
    }
    [self showRehab:object];
}

#pragma mark -
-(UILabel*)headerLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor= [UIColor blackColor];
    titleLabel.font = [UIFont wr_titleFont];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

-(void)showRehab:(WRRehab*)rehab
{
    __weak __typeof(self) weakSelf = self;
    if (rehab.disease.isProTreat)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在获取数据", nil)];
        [WRProTreatViewModel userGetProTreatDetailWithData:rehab completion:^(NSError * error, id proTreatRehabDetailDict) {
            [SVProgressHUD dismiss];
            if (error) {
                
            } else {
                NSDictionary *dict = proTreatRehabDetailDict;
                WRRehab *rehab = [[WRRehab alloc] initWithDictionary:dict];
                rehab.disease.isProTreat = YES;
                RehabController *controller = [[RehabController alloc] initWithRehab:rehab];
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }
        }];
    }
    else
    {
        [self pushTreatRehabWithDisease:rehab.disease isTreat:YES];
    }
}

@end
