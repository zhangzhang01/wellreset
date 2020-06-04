//
//  ProgressController.m
//  rehab
//
//  Created by Matech on 3/2/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "GzwTableViewLoading.h"
#import "JTNavigationController.h"
#import "RehabController.h"
#import "SVProgressHUD.h"

#import "ProgressController.h"
#import "RehabObject.h"
#import "ProTreatViewModel.h"
#import "WRProgressCell.h"
#import "WRRefreshHeader.h"
#import "ShareUserData.h"
#import "Masonry/Masonry.h"

@interface ProgressController ()
@property(nonatomic)BOOL flag;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger progressCount;

@end

@implementation ProgressController

- (instancetype)init {
    if(self = [super initWithStyle:UITableViewStylePlain]){
        [self defaultStyle];
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
        footerView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = footerView;
        [@[WRUpdateUserRehabNotification] enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProgress:) name:obj object:nil];
        }];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"我的方案", nil);
    
    _dataArray = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.buttonNormalColor = [UIColor clearColor];
    self.tableView.buttonHighlightColor = [UIColor clearColor];
    self.tableView.loadedImageName = @"well_default";
    
    NSString *desc;
    desc = NSLocalizedString(@"您没有进行过健康测试和定制康复", nil);
    self.tableView.descriptionText = desc;
    self.tableView.dataVerticalOffset = -100;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;

    __weak __typeof(self)weakself = self;
    
    self.tableView.mj_header = [WRRefreshHeader headerWithRefreshingBlock:^{
        [weakself fetchData];
    }];
    [self.tableView.mj_header beginRefreshing];
    [WRNetworkService pwiki:@"WELL进度"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self createBackBarButtonItem];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - UITableView Delegate&Source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _progressCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
            UIImage *image = [UIImage imageNamed:@"well_default_banner"];
            return tableView.frame.size.width*image.size.height/image.size.width + 2 * WRUIOffset;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = [ShareUserData userData].proTreatRehab.count + [ShareUserData userData].treatRehab.count;
    NSString *identifier = [NSString stringWithFormat:@"%d-%d", (int)indexPath.section, (int)indexPath.row];

    WRProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[WRProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (count != 0) {
        WRRehab *object;
        NSUInteger index = indexPath.row;
        if (index < [ShareUserData userData].treatRehab.count) {
            object = [ShareUserData userData].treatRehab[index];
        } else {
            object = [ShareUserData userData].proTreatRehab[index - [ShareUserData userData].treatRehab.count];
        }
        cell.titleLabel.text = object.disease.diseaseName;//[NSString stringWithFormat:@"%@-%@", object.disease.specialty, object.disease.diseaseName];
        cell.contentLabel.text = [NSString stringWithFormat:@"%@",  object.createTime];
        [cell.iconimageView setImageWithUrlString:object.disease.bannerImageUrl holder:@"well_default_banner"];
    }
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
//    [UMengUtils careForMeRehab:object.disease.diseaseName];
    [UMengUtils careForRehab:object.disease.diseaseName];
}

#pragma mark -
-(UILabel*)headerLabel {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor= [UIColor blackColor];
    titleLabel.font = [UIFont wr_titleFont];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

- (void)reloadProgress:(NSNotification*)notification
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Network
-(void)fetchData
{
    __weak __typeof(self) weakSelf = self;
    [ProTreatViewModel userGetWellWithCompletion:^(NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (error) {
            [Utility retryAlertWithViewController:weakSelf title:NSLocalizedString(@"加载数据失败", nil) completion:^{
                [weakSelf.tableView.mj_header beginRefreshing];
            }];
        } else {
            [weakSelf loadProgressData];
        }
    }];
}
- (void)loadProgressData
{
    _progressCount = 0;
    if ([WRUserInfo selfInfo].isLogged) {
        _progressCount = [ShareUserData userData].proTreatRehab.count + [ShareUserData userData].treatRehab.count;
    }
    
    if (_progressCount == 0) {
        if (!self.tableView.backgroundView) {
            self.tableView.backgroundView = [WRUIConfig createNoDataViewWithFrame:self.tableView.bounds title:NSLocalizedString(@"没有方案", nil) image:[UIImage imageNamed:@"well_rehab_background"]];
        }
        self.tableView.backgroundView.hidden = NO;
    } else {
        self.tableView.backgroundView.hidden = YES;
    }
    [self.tableView reloadData];
}

-(void)showRehab:(WRRehab*)rehab
{
    __weak __typeof(self) weakSelf = self;
    if (rehab.disease.isProTreat)
    {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在获取数据", nil)];
        [ProTreatViewModel userGetProTreatDetailWithData:rehab completion:^(NSError * error, id proTreatRehabDetailDict) {
            [SVProgressHUD dismiss];
            if (error) {
                [Utility retryAlertWithViewController:[weakSelf.class root] title:NSLocalizedString(@"获取数据失败", nil) completion:^{
                    [weakSelf showRehab:rehab];
                }];
            } else {
                NSDictionary *dict = proTreatRehabDetailDict;
                WRRehab *rehab = [[WRRehab alloc] initWithDictionary:dict];
                rehab.disease.isProTreat = YES;
                RehabController *controller = [[RehabController alloc] initWithRehab:rehab];
                [weakSelf.navigationController pushViewController:controller animated:YES];
                /*
                 WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:controller];
                 [[weakSelf.class root] presentViewController:nav animated:YES completion:nil];
                 */
            }
        }];
    }
    else
    {
        [self pushTreatRehabWithDisease:rehab.disease isTreat:YES];
    }
}


@end
