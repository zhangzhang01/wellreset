//
//  HealthController.m
//  rehab
//
//  Created by yongen zhou on 2017/2/24.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "HealthController.h"
#import "ShareData.h"
#import "ShareUserData.h"
#import "UserViewModel.h"
#import "WRTrainTableViewCell.h"
#import "WRProgressCell.h"
#import "DaliyController.h"
#import "TrainRecordController.h"
#import "AddTreatDiseaseBaseContrller.h"
#import "AskIndexController.h"
#import "WRScene.h"
#import "WRObject.h"
#import "RehabObject.h"
#import "EditTreatController.h"
#import <UMMobClick/MobClick.h>
#import "WrNavigationController.h"
#import "LoginController.h"
#import "ArticleDetailController.h"
#import "PreventViewModel.h"
#import "PreventVideosController.h"
#import "UIViewController+WR.h"
#import "AlarmController.h"
#import "M13BadgeView.h"
#import "UserdaliyViewModel.h"
#import <YYKit/YYKit.h>
#import "GuideView.h"
#import "LocalNoticeSetTableViewController.h"
#import "WRPayController.h"
#import "AskImIndexController.h"
#import "AutoScrollHeaderView.h"
#import "JKScrollFocus.h"
#import "WrWebViewController.h"
#import "WRRefreshHeader.h"
#import "WRCircleNews.h"
#import "JCAlertView.h"
#import "NoDataManager.h"
#import "TreatDiseaseSelectorController.h"
//#import "UIImageView+WR.h"
@interface HealthController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
{
    WRUserInfo *_userInfo;
    NSDate* _startDate;
}
@property(nonatomic, assign) BOOL loadedData;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *rightButton;
@property(nonatomic) UIImageView *headImageView;
@property(nonatomic)PreventViewModel*PrviewModel;
@property(nonatomic)NSArray *imageColors;
@property UITableView* tableView;
@property UserdaliyViewModel* dayviewModel;
@property NSMutableArray* arr;
@property M13BadgeView* bageView;
@property(nonatomic) NSMutableDictionary *notifyFrameDict;
@property(nonatomic) BOOL isguide;
@property BOOL noshow;
@property (nonatomic, strong)JCAlertView* alshow;
@end

@implementation HealthController
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(PreventViewModel *)PrviewModel {
    if (!_PrviewModel) {
        _PrviewModel = [[PreventViewModel alloc] init];
    }
    return _PrviewModel;
}
-(instancetype)init
{
    if (self = [super init])
    {
        
        
        _userInfo = [WRUserInfo selfInfo];
        _notifyFrameDict = [NSMutableDictionary dictionary];
        __weak __typeof(self) weakSelf = self;
        [@[WRReloadRehabNotification, WRUpdateSelfInfoNotification] enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(notificationHandler:) name:obj object:nil];
        }];
        [@[WRLogInNotification, WRLogOffNotification] enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:obj object:nil];
        }];
        
        
      
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = NSLocalizedString(@"WELL健康", nil);
    
    self.dayviewModel = [UserdaliyViewModel new];
    self.imageColors = @[[UIColor colorWithHexString:@"ff892f"], [UIColor colorWithHexString:@"004eff"], [UIColor colorWithHexString:@"ed1e79"], [UIColor colorWithHexString:@"47c0ff"]];
    
    UIImage* image = [UIImage imageNamed:@"提醒图标"];
    UIButton*  buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(0, 0, 20, 20);
    buttonRight.imageView.contentMode = UIViewContentModeScaleToFill;
    [buttonRight setBackgroundImage:image forState:0];
    [buttonRight addTarget:self action:@selector(onClickedRightBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightItem;
//    self.backButton = buttonRight;
   
    CGFloat h = 57;
    if (IPAD_DEVICE) {
        h = 57;
    }
    //    BOOL isPhoneX = NO;
    if (@available(iOS 11.0, *)) {\
        //      isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;
        if ([[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0) {
            
            h = 49+34+30;
        }else{
            h = 64;
        }
    }
    
     NSLog(@"[ShareUserData userData].rehabCount%ld",[ShareUserData userData].rehabCount);
       // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-h) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.delegate =self;
    [self fetchFData];
    [self updatedaliypoint];
    __weak __typeof(self) weakSelf = self;
    //        [self.tableView addInfiniteScrollingWithActionHandler:^{
    //            [weakSelf loadData];
    //        }];
    WRRefreshHeader *header = [[WRRefreshHeader alloc] init];
    header.refreshingBlock = ^{
        [self fetchData];
        [self loadDatapr];
        [self updateSelfInfo];
        [self updatedaliypoint];
        _startDate = [NSDate new];
    };
    self.tableView.mj_header = header;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    
    
    NSInteger collectionCount = [ShareUserData userData].userPermissions.collection;
    NSLog(@"collectionCount%ld",(long)collectionCount);
    [self fetchData];
    [self loadDatapr];
    [self updateSelfInfo];
    [self updatedaliypoint];
    _startDate = [NSDate new];
    
    
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    [bar lt_setBackgroundColor:[UIColor wr_themeColor]];
    
//    self.tableView.frame = self.view.frame;
    
//    if ([WRUserInfo selfInfo].isLogged) {
//        [ [NSNotificationCenter defaultCenter]postNotificationName:WRLogInNotification object:nil];
//    }
//    else
//    {
//        [ [NSNotificationCenter defaultCenter]postNotificationName:WRLogOffNotification object:nil];
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WRReloadRehabNotification object:nil];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    self.isguide =YES;
    [self userHome];
}
- (void)viewWillDisappear:(BOOL)animated {
  //  self.isguide = NO;
    
//    [[SDWebImageManager sharedManager] cancelAll];
//    
//    [[SDImageCache sharedImageCache] clearDisk];
    
}
-(UIImageView *)headImageView {
    if (!_headImageView) {
//        __weak __typeof(self) weakSelf = self;
        UIImage *defaultHeadImage = [WRUIConfig defaultHeadImage];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:defaultHeadImage];
        imageView.frame = CGRectMake(0, 0, 32, 32);
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = imageView.width/2;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1.f;
        imageView.userInteractionEnabled = YES;
        
        _headImageView = imageView;
        
    }
    return _headImageView;
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    else if (section==1) {
        return 1;
    }
    else if(section==2)
    {
        NSInteger count =_arr.count;
        if (count!=0) {
            return count+2;
        }
        else
            return 1;
    }
    else if(section==3)
        return 1;
    else if(section==4)
        return 1;
    else
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    switch (indexPath.section) {
        case 0:
        {
            WRTrainTableViewCell* traincell = [[WRTrainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"train"];
            traincell.selectionStyle = UITableViewCellSelectionStyleNone;
            ShareUserData* userdata = [ShareUserData userData];
            [traincell.iconimageView setImageWithURL:[NSURL URLWithString:_userInfo.headImageUrl] placeholder:[WRUIConfig defaultHeadImage ]];
            NSString *str =  [_userInfo.name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (str.length<1) {
                str = @"匿名用户";
            }
            traincell.nameLabel.text = str;
            traincell.sign.text = [NSString stringWithFormat:@"%ld天",userdata.rehabDays];
            traincell.complete.text = [NSString stringWithFormat:@"%ld次",userdata.rehabCount];
            traincell.train.text = [NSString stringWithFormat:@"%.0lf分钟",userdata.rehabTime/60.f];
            [traincell layoutSubviews];
            
            return traincell;
        }
            break;
        case 1:
        {
            UITableViewCell* myRehabCell = [self.tableView dequeueReusableCellWithIdentifier:@"imcell"];
            //                    myRehabCell.selectionStyle = UITableViewCellSelectionStyleNone;
            myRehabCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!myRehabCell) {
                myRehabCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imcell"];
                
                
//                AutoScrollHeaderView *header = [[AutoScrollHeaderView alloc] initWithFrame:CGRectMake(x, y, cx, cy) color:[UIColor wr_themeColor]];
//                header.backgroundColor = [UIColor colorWithHexString:@"fdfdfd"];
//                header.clickedEvent = ^(AutoScrollHeaderView* sender, NSInteger index) {
//                    [_mainCollectionView setContentOffset:CGPointMake(index * _mainCollectionView.frame.size.width, 0)];
//                };
//                //        [self.scrollView addSubview:header];
//                _headerView = header;
//                
//                NSInteger labelCount = _categoryArray.count + 1;
//                [_headerView addChannel:NSLocalizedString(@"推荐", nil) labelCount:labelCount];
//                [_categoryArray enumerateObjectsUsingBlock:^(WRCategory*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    [_headerView addChannel:obj.name labelCount:labelCount];
//                }];

                
                
                UIButton * addRehabBtn = [UIButton new];
                
                addRehabBtn.frame = CGRectMake(0, 0, ScreenW, 187*ScreenW*1.0/375);
                
                [addRehabBtn setBackgroundImage:[UIImage imageNamed:@"16.8(1)"] forState:0];
                
                [addRehabBtn bk_whenTapped:^{
                    
                }];
                
                
                [WRViewModel getBannerCompletion:^(NSError *error ) {
                    UIImage *holder = [UIImage imageNamed:@"well_default_video"];
                    JKScrollFocus *scroller  = [[JKScrollFocus alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 187*ScreenW*1.0/375)];
                    scroller.ifnonote = YES;
                    
                    [scroller.noteView setHidden:YES];
                    [myRehabCell.contentView addSubview:scroller];
                    NSMutableArray* ar =[NSMutableArray arrayWithArray:[ShareData data].IndexArray];
//                    if (ar.count>0) {
//                        [ar removeObjectAtIndex:0];
//                    }
                  
                    [ar enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        WRBannerInfo *object  = obj;
//                        if (!object.extraData) {
//                            [ar removeObject:obj];
//                        }
                    }];
                    scroller.items = ar ;
                    
                    
                    
                    scroller.autoScroll = YES;
                    
                    [scroller downloadJKScrollFocusItem:^(id item, UIImageView *currentImageView) {
                        WRBannerInfo *object = item;
//                        if ([scroller.items indexOfObject:item]!=0) {
                            [currentImageView setImageWithUrlString:object.imageUrl holderImage:holder];
//                        }
//                        else
//                        {
//                            [currentImageView setImage:[UIImage imageNamed:@"16.8(1)"]];
//                        }
                        
                        currentImageView.contentMode = UIViewContentModeScaleToFill;
                        
                    }];
                    
                    [scroller titleForJKScrollFocusItem:^NSString *(id item, UILabel *currentLabel) {
                                        
                                        return @"";
                                    }];
                    [scroller didSelectJKScrollFocusItem:^(id item, NSInteger index) {
                        
                        WRBannerInfo *object = item;
                        
//                        if ([scroller.items indexOfObject:item]!=0) {
                            [self actionWithType:object.type data:object.extraData];
//                        }
//                        else
//                        {
//                            AskImIndexController* addVc = [[AskImIndexController alloc]init];
//                            addVc.hidesBottomBarWhenPushed=YES;
//                            [self.navigationController pushViewController:addVc animated:YES];
//                        }
                        
                        //锚点
                        
                        
                        
                        
                    }];
                    [scroller addSubview:scroller.pageControl];
                  
                    [scroller reloadData];

                }];
                
                
                
                    //锚点
//                    NSDate *now = [NSDate date];
//                    int duration = (int)[now timeIntervalSinceDate:_startDate];
//                    [MobClick event:[NSString stringWithFormat:@"sytafa"] attributes:nil counter:duration];
                    
                    
                    
            
            }
            return myRehabCell;
            
    }

    
    
        case 2:
        {
            NSInteger count = self.arr.count;
            if (count!=0) {
                if (indexPath.row==0) {
                    UITableViewCell* myRehabCell = [self.tableView dequeueReusableCellWithIdentifier:@"topCell"];
//                    myRehabCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myRehabCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if (!myRehabCell) {
                        myRehabCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCell"];
                        UILabel* myRehabLabal = [UILabel new];
                        myRehabLabal.text = @"我的方案";
                        myRehabLabal.font = [UIFont systemFontOfSize:WRDetailFont];
                        myRehabLabal.textColor = [UIColor darkTextColor];
                        myRehabLabal.centerY = myRehabCell.centerY;
                        myRehabLabal.x = WRUIOffset;
                        [myRehabLabal sizeToFit];
                        [myRehabCell.contentView addSubview:myRehabLabal];
                        
                        UIButton * addRehabBtn = [UIButton new];
                        [addRehabBtn setTitle:@"添加方案" forState:0] ;
                        addRehabBtn.layer.cornerRadius = 12.5;
                        addRehabBtn.layer.masksToBounds = YES;
                        addRehabBtn.layer.borderColor = [UIColor wr_themeColor].CGColor;
                        addRehabBtn.layer.borderWidth = 1;
                        addRehabBtn.backgroundColor = [UIColor wr_themeColor];
                        addRehabBtn.x =ScreenW-WRUIMidOffset-(WRUILittleOffset*3+10+14*4);
                        addRehabBtn.titleLabel.font = [UIFont systemFontOfSize:WRDetailFont];
                        [addRehabBtn setTitleColor:[UIColor whiteColor] forState:0];
                        addRehabBtn.height = 25;
                        
                        addRehabBtn.width = WRUILittleOffset*3+10+14*4;
                        addRehabBtn.centerY =  myRehabLabal.centerY;

                        
                        [addRehabBtn setImage:[UIImage imageNamed:@"添加方案白色图标"] forState:0];
                        [myRehabCell.contentView addSubview:addRehabBtn];
                        [[addRehabBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                            TreatDiseaseSelectorController* addVc = [[TreatDiseaseSelectorController alloc]init];
                            addVc.hidesBottomBarWhenPushed=YES;
                            [self.navigationController pushViewController:addVc animated:YES];
                            
                            //锚点
                            NSDate *now = [NSDate date];
                            int duration = (int)[now timeIntervalSinceDate:_startDate];
                            [MobClick event:[NSString stringWithFormat:@"sytafa"] attributes:nil counter:duration];


                            
                        }];
                    }
                        return myRehabCell;
                        
                    }
                    else if (indexPath.row==count+1)
                    {
                        UITableViewCell* bottomCell = [self.tableView dequeueReusableCellWithIdentifier:@"bottomCell"];
                        bottomCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                        if (!bottomCell) {
                            bottomCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"bottomCell"];
                            
                            UIButton * edit = [UIButton wr_defaultButtonWithTitle:@"编辑顺序"];
                            [edit setImage:[UIImage imageNamed:@"编辑顺序的图标"] forState:0];
                            [edit setTitle:@"编辑顺序" forState:0];
                            [edit setTitleColor:[UIColor grayColor] forState:0];
                            edit.titleLabel.font = [UIFont wr_detailFont];
                            [edit sizeToFit];
                            edit.centerX = ScreenW/2;
                            edit.centerY = bottomCell.centerY;
                            
                            [[edit rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                                EditTreatController* editvc = [EditTreatController new];
                                editvc.dataarr = self.arr;
                                editvc.hidesBottomBarWhenPushed=YES;
                                
                                [self.navigationController pushViewController:editvc animated:YES];
                                
                                //锚点
                                NSDate *now = [NSDate date];
                                int duration = (int)[now timeIntervalSinceDate:_startDate];
                                [MobClick event:[NSString stringWithFormat:@"sybjsx"] attributes:nil counter:duration];
//                                AskIndexController* index = [AskIndexController new];
//                                
//                                [self.navigationController pushViewController:index animated:YES];
                                
                            }];
                            [bottomCell.contentView addSubview:edit];
                            
                        }
                        return bottomCell;
                    }
                    else
                    {
                        NSString *identifier = [NSString stringWithFormat:@"rehabobject"];
                        
                        WRProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        if (!cell) {
                            cell = [[WRProgressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            
                            
                            
                            
                        }
                        WRRehab *object;
                        NSUInteger index = indexPath.row-1;

                        
                            object = _arr[index];
                            
                            cell.titleLabel.text = object.disease.diseaseName;//[NSString stringWithFormat:@"%@-%@", object.disease.specialty, object.disease.diseaseName];
                            cell.contentLabel.text = [NSString stringWithFormat:@"%@ %.0lf分钟",  object.rehabType,object.duration/60.0];
                        
                            NSDateFormatter* format = [WRDateformatter formatter];
                        if ([object.lastSportTime isKindOfClass:[NSNull class]]||!object.lastSportTime||[object.lastSportTime isEqualToString:@"(null)"]||[object.lastSportTime isEqualToString:@""] ) {
                            cell.trainLabel.text =@"尚未开始训练";
                        }
                        else if (object.isSelfRehab)
                        {
                            cell.trainLabel.text = @"";
                        }
                        else
                        {
                            format = [WRDateformatter formatter];
                            NSDate* date = [format dateFromString:object.lastSportTime];
                            NSString* day = [self compareDate:date];
                            
                            NSDateFormatter* formatnew = [NSDateFormatter new];
                            [formatnew setDateStyle:NSDateFormatterMediumStyle];
                            [formatnew setTimeStyle:NSDateFormatterShortStyle];
                            [formatnew setDateFormat:@"HH:mm"];
                            if ([day isEqualToString:@""]) {
                                [formatnew setDateFormat:[NSString stringWithFormat: @"上次训练 YY年MM月dd日 %@HH:mm",[self getTheTimeBucketWith:date]]];
                                cell.trainLabel.text = [NSString stringWithFormat:@"%@",[formatnew stringFromDate:date]];
                                
                            }
                            else
                            {
                            cell.trainLabel.text = [NSString stringWithFormat:@"上次训练 %@ %@%@",day,[self getTheTimeBucketWith:date],[formatnew stringFromDate:date]];
                            }
                            
                        }
                        
                            [cell.iconimageView setImageWithUrlString:object.disease.bannerImageUrl holder:@"well_default_banner"];
                        cell.iconimageView.contentMode = UIViewContentModeScaleAspectFill;
                            cell.iconimageView.userInteractionEnabled =YES;
                        cell.iconimageView.tag = indexPath.row-1;
                            [cell.iconimageView bk_whenTapped:^{
                                NSLog(@"%ld",(long)cell.iconimageView.tag);
                                WRRehab* re = _arr[cell.iconimageView.tag];
                                if ([re.rehabType isEqualToString:@"专业定制"]) {
                                    [self showNOquestionProTreatRehab:re  stage:0];
                                }
                                else if (re.isSelfRehab)
                                {
                                    [self showCreateTreat];
                                }
                                else
                                {
                                    [self pushTreatRehabWithDisease:re.disease isTreat:YES];
                                }
                                
                                //锚点
                                NSDate *now = [NSDate date];
                                int duration = (int)[now timeIntervalSinceDate:_startDate];
                                [MobClick event:[NSString stringWithFormat:@"sywdfa"] attributes:nil counter:duration];
                            }];
                            
                            
                        
                        return cell;
                        
                    }
                    

            }
            else
            {
                
                UITableViewCell* myRehabCell = [self.tableView dequeueReusableCellWithIdentifier:@"norhab"];
                myRehabCell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (!myRehabCell) {
                    myRehabCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"norhab"];
                    UILabel* myRehabLabal = [UILabel new];
                    myRehabLabal.text = @"我的方案";
                    myRehabLabal.font = [UIFont systemFontOfSize:WRDetailFont];
                    myRehabLabal.textColor = [UIColor darkTextColor];
                    myRehabLabal.y = 18;
                    myRehabLabal.x = WRUIOffset;
                    [myRehabLabal sizeToFit];
                    [myRehabCell.contentView addSubview:myRehabLabal];
                    
                    UIImageView* im = [UIImageView new];
                    im.image = [UIImage imageNamed:@"type_no_rehab"];
                    im.x = 10;
                    im.y = 46;
                    im.width = self.view.width - 20;
                    im.height = 111;
                    [myRehabCell.contentView addSubview:im];
                    
                    UIButton * addRehabBtn = [UIButton new];
                    [addRehabBtn setTitle:@"添加方案" forState:0] ;
                    addRehabBtn.layer.cornerRadius = 12.5;
                    addRehabBtn.layer.masksToBounds = YES;
                    addRehabBtn.layer.borderColor = [UIColor wr_themeColor].CGColor;
                    addRehabBtn.layer.borderWidth = 1;
                    
                    addRehabBtn.backgroundColor = [UIColor wr_themeColor];
                    addRehabBtn.titleLabel.font = [UIFont systemFontOfSize:WRDetailFont];
                    [addRehabBtn setTitleColor:[UIColor whiteColor] forState:0];
                    addRehabBtn.height = 27;
                    
                    addRehabBtn.width = 123;
                    addRehabBtn.centerY =  myRehabLabal.centerY;
                    addRehabBtn.center = CGPointMake(self.view.width/2.0, 181/2.0);
                    
                    [addRehabBtn setImage:[UIImage imageNamed:@"添加方案白色图标"] forState:0];
                    [myRehabCell.contentView addSubview:addRehabBtn];
                    im.userInteractionEnabled =YES;
                    [im bk_whenTapped:^{
                        TreatDiseaseSelectorController* addVc = [[TreatDiseaseSelectorController alloc]init];
                        addVc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:addVc animated:YES];
                        //锚点
                        NSDate *now = [NSDate date];
                        int duration = (int)[now timeIntervalSinceDate:_startDate];
                        [MobClick event:[NSString stringWithFormat:@"sytjfa"] attributes:nil counter:duration];

                        
                    }];
                    [[addRehabBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                        TreatDiseaseSelectorController* addVc = [[TreatDiseaseSelectorController alloc]init];
                        addVc.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:addVc animated:YES];
                        //锚点
                        NSDate *now = [NSDate date];
                        int duration = (int)[now timeIntervalSinceDate:_startDate];
                        [MobClick event:[NSString stringWithFormat:@"sytjfa"] attributes:nil counter:duration];
                        
                    }];
                    
                }
                    return myRehabCell;

                    
                
                
                
            
            }
        }
            break;
        case 4:
        {
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Article"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Article"];
                
                
            }
            [self layoutArticlecell:cell];
            return cell;
        }
            break;
        case 3:
        {
            
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"preArticle"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"preArticle"];
                
                
            }
            [self layoutPrevencell:cell];
            return cell;
        }
            break;
            
        default:
            break;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 165;
    }
    else if (indexPath.section==1) {
        return 187*ScreenW*1.0/375;
    }
    else if(indexPath.section==2)
    {
        NSInteger count =_arr.count;
        if (count!=0) {
            if (indexPath.row==0) {
                return 50;
            }
            else if (indexPath.row == count+1)
            {
                return 50;
            }
            else
            {
                return 115+WRUIBigOffset;
            }
        }
        else
        {
            return 181;
        }
        
    }
    else if(indexPath.section==4)
    {
        return 175+WRUIBigOffset+49;
    }
    else if(indexPath.section==3)
    {
        return 175;
    }
        
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        TrainRecordController* trainVc = [TrainRecordController new];
        trainVc.hidesBottomBarWhenPushed =YES;
        [self.navigationController pushViewController:trainVc animated:YES];
        //锚点
        NSDate *now = [NSDate date];
        int duration = (int)[now timeIntervalSinceDate:_startDate];
        [MobClick event:[NSString stringWithFormat:@"syxldk"] attributes:nil counter:duration];
    }
}


#pragma mark - ui
-(void)layoutArticlecell:(UITableViewCell*)cell
{
    [cell.contentView removeAllSubviews];
    NSArray* arr = [ShareUserData userData].wechatShareList;
    UILabel* myRehabLabal = [UILabel new];
    myRehabLabal.text = @"推荐阅读";
    myRehabLabal.font = [UIFont systemFontOfSize:WRDetailFont];
    myRehabLabal.textColor = [UIColor darkTextColor];
    myRehabLabal.y = 20;
    myRehabLabal.x = WRUIOffset;
    [myRehabLabal sizeToFit];
    [cell.contentView addSubview:myRehabLabal];
    
    UIScrollView* articleScroll = [UIScrollView new];
    articleScroll.x = 0;
    articleScroll.y = 50;
    articleScroll.width = self.view.width;
    articleScroll.height = 175-50+49;
    [cell.contentView addSubview:articleScroll];
   
    
    
    for (int i=0;i<arr.count;i++ ){
        WRArticle* article = arr[i];
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(WRUIOffset+i*WRUIOffset+200*i, 0, 200, 175-50+49)];
        UIImageView* artIm = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 98)];
        
        [artIm setImageWithURL:[NSURL URLWithString:article.imageUrl] placeholder:[UIImage imageNamed:@"rehab_top_background"]];
        artIm .contentMode = UIViewContentModeScaleAspectFill;
        artIm .clipsToBounds  = YES;
        
        
       
        
        [bgView addSubview:artIm];
        artIm.userInteractionEnabled =YES;
        [artIm bk_whenTapped:^{
            ArticleDetailController * vc = [ArticleDetailController new];
            vc.hidesBottomBarWhenPushed =YES;
            
            [self.navigationController pushViewController:vc animated:YES];
            vc.currentNews = article;
            
            //锚点
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"sytjyd"] attributes:nil counter:duration];
            
        }];
        
        UILabel* artTitle = [UILabel new];
        artTitle.x = 0;
        artTitle.y = artIm.bottom+WRUIOffset;
        artTitle.width = 200;
        artTitle.height = 14;
        artTitle.font = [UIFont wr_textFont];
        artTitle.textAlignment = NSTextAlignmentCenter;
        artTitle.textColor = [UIColor darkGrayColor];
        artTitle.text = article.title;
        
        [bgView addSubview:artTitle];
        
        UILabel* artContent = [UILabel new];
        artContent.x = 0;
        artContent.y = artTitle.bottom;
        artContent.width = 200;
        artContent.height = 14;
        artContent.textAlignment = NSTextAlignmentCenter;
        artContent.font = [UIFont wr_smallestFont];
        artContent.textColor = [UIColor grayColor];
        artContent.text = article.subtitle;
        
        [bgView addSubview:artContent];
        
        [articleScroll addSubview:bgView];
        
        
    }
    articleScroll.contentSize = CGSizeMake((WRUIOffset+200)*arr.count+WRUIOffset*2, 175-50+49);
    
}


-(void)layoutPrevencell:(UITableViewCell*)cell
{
    
    [cell.contentView removeAllSubviews];
    NSArray* arr = self.PrviewModel.scenes;
    UILabel* myRehabLabal = [UILabel new];
    myRehabLabal.text = @"预防锻炼";
    myRehabLabal.font = [UIFont systemFontOfSize:WRDetailFont];
    myRehabLabal.textColor = [UIColor darkTextColor];
    myRehabLabal.y = 20;
    myRehabLabal.x = WRUIOffset;
    [myRehabLabal sizeToFit];
    [cell.contentView addSubview:myRehabLabal];
    
    UIScrollView* articleScroll = [UIScrollView new];
    articleScroll.x = 0;
    articleScroll.y = 50;
    articleScroll.width = self.view.width;
    articleScroll.height = 175-50+49;
    [cell.contentView addSubview:articleScroll];
    
    
    for (int i=0;i<arr.count;i++ ){
        WRScene * article = arr[i];
        UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(WRUIOffset+i*WRUIOffset+200*i, 0, 200, 175-50+39)];
        UIImageView* artIm = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 98)];
        [artIm setImageWithURL:[NSURL URLWithString:article.attachfilepath] placeholder:[UIImage imageNamed:@"rehab_top_background"]];
        artIm.tag = i;
        artIm .clipsToBounds = YES;
        artIm .contentMode = UIViewContentModeScaleAspectFill;
        [bgView addSubview:artIm];
        artIm.userInteractionEnabled =YES;
        [artIm bk_whenTapped:^{
            [self onClickedItem:artIm];
            
            //锚点
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            switch (i) {
                case 0:
                    [MobClick event:[NSString stringWithFormat:@"syyfjl"] attributes:nil counter:duration];
                    break;
                case 1:
                    [MobClick event:[NSString stringWithFormat:@"syyfls"] attributes:nil counter:duration];
                    break;
                case 2:
                    [MobClick event:[NSString stringWithFormat:@"syyfbgs"] attributes:nil counter:duration];
                    break;
                    
                default:
                    break;

            }
            
           
            
        }];
        
        UILabel* artTitle = [UILabel new];
        artTitle.x = 15;
        artTitle.y = 17;
        artTitle.width = 200;
        artTitle.height = 14;
        artTitle.font = [UIFont wr_textFont];
//        artTitle.textAlignment = NSTextAlignmentCenter;
        artTitle.textColor = [UIColor whiteColor];
        artTitle.text = article.name;
        
        [bgView addSubview:artTitle];
        
        [articleScroll addSubview:bgView];
        
        
        
        
    }
     articleScroll.contentSize = CGSizeMake((WRUIOffset+200)*arr.count+WRUIOffset*2, 175-50+49);
    
}


#pragma mark - Control Event
- (IBAction)onClickedLeftBarButtonItem:(UIButton *)sender
{
    DaliyController* daliy = [[DaliyController alloc]init];
    daliy.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:daliy animated:YES];
    //锚点
    
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [MobClick event:[NSString stringWithFormat:@"syrcrw"] attributes:nil counter:duration];
}
- (IBAction)onClickedRightBarButtonItem:(UIButton *)sender
{
    LocalNoticeSetTableViewController* al = [LocalNoticeSetTableViewController new];
    al.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:al animated:YES];
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [MobClick event:[NSString stringWithFormat:@"synztx"] attributes:nil counter:duration];
}
-(IBAction)onClickedItem:(id)sender {
    UIImageView *imageView = sender;
    
    NSInteger index = imageView.tag;
    if (index < self.PrviewModel.scenes.count) {
        WRScene *scene = self.PrviewModel.scenes[index];
        NSLog(@"scene.name%@",scene.name);
        PreventVideosController *viewController = [[PreventVideosController alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController setScene:scene banner:[UIImage imageNamed:[NSString stringWithFormat:@"prevent_banner_%d",(int)(index%self.imageColors.count + 1)]] mostColor:self.imageColors[index%self.imageColors.count]];
    }

}
#pragma mark - Handler
-(void)notificationHandler:(NSNotification*)notification
{
    //重新加载个人方案
    if ([notification.name isEqualToString:WRReloadRehabNotification])
    {
        do {
            NSDictionary *userInfo = notification.userInfo;
            if (userInfo && [userInfo isKindOfClass:[NSDictionary class]])
            {
                WRRehab *rehab = userInfo[@"rehab"];
                if (rehab) {
                    BOOL flag = [[ShareUserData userData] notifyRehab:rehab];
                    if (flag) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:WRUpdateUserRehabNotification object:nil];
                    }
                    break;
                }
            }
            [self reload];
        }while(false);
    }
    if ([notification.name isEqualToString:WRLogInNotification])
    {
        [self userHome];
        [self updateSelfInfo];
        [self fetchData];
        [self loadDatapr];
    
        //        [self reloadData];
        //        [self notifyUserDataChanged];
        NSLog(@"Recv WRLogInNotification");
    }
    else if([notification.name isEqualToString:WRLogOffNotification])
    {
        /**
         *  非法用户 清除其登录信息
         */
        LoginController* login = [LoginController new];
        WrNavigationController * navi = [[WrNavigationController alloc]initWithRootViewController:login];
        
        
        
        
        [self presentViewController:navi animated:NO completion:^{
            
        }];
        
        
        
        [MobClick profileSignOff];
        [[WRUserInfo selfInfo] clear];
        [[ShareUserData userData] clear];
        [self updateSelfInfo];
        //        [self fetchData];
        //        [self reloadData];
        //        [self notifyUserDataChanged];
        NSLog(@"Recv WRLogOffNotification");
    }
    else if([notification.name isEqualToString:WRUpdateSelfInfoNotification])
    {
        [self updateSelfInfo];
    }
}


-(void)userHome
{
    
   
    
    
    
    if ([[WRUserInfo selfInfo] isLogged])
    {
        NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        if(uuid == nil)
        {
            uuid = @"";
        }
        [WRViewModel userHomeWithCompletion:^(NSError * _Nonnull error, id  _Nonnull resultObject) {
            if (error) {
                if (error.code == WRErrorCodeWrongUser) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:WRLogOffNotification object:nil];
                    NSLog(@"User validate error, log off");
                }
            }
            else
            {
                WRCircleNews* news = resultObject;
                NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
                NSString* datestr = [ud objectForKey:@"active"];
                WRDateformatter* forma =[WRDateformatter formatter];
                NSDate* havedate = [forma dateFromString:datestr];
                NSDate* currentdate = [NSDate new];
                
                
                
                if ([[ud objectForKey:@"customeTreat"]intValue]!=1&&[WRUserInfo selfInfo].level>3&&![ShareUserData userData].selfrehab) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您已经升到四级了,您可以从自己收藏的动作中选取喜欢的动作来组成一套自建方案!" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *actionyes = [UIAlertAction actionWithTitle:@"立即试试" style:0 handler:^(UIAlertAction * _Nonnull action) {
                        [self showCreateTreat];
                    }];
                    [alertController addAction:actionCancel];
                    [alertController addAction:actionyes];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [ud setObject:@"1" forKey:@"customeTreat"];
                }
                
              //  news.status = YES;
                if (news.status) {
                  //  datestr = nil;
                    if (!datestr||!(havedate.day==currentdate.day&&havedate.month==currentdate.month)) {
                        UIView* showview=nil;
                        
                        
                        showview = [self createIndexShowwth:news Completion:^(NSError *error) {
                            
                            [self.alshow dismissWithCompletion:^{
                                UINavigationController* navi=  self.tabBarController.viewControllers[2];
                                self.tabBarController.selectedIndex = 2;
                                WrWebViewController* wr = [WrWebViewController new];
                                wr.url = news.url;
                                [navi pushViewController:wr animated:YES];
                            }];
                            
                            
                        } closs:^(NSError *error) {
                            [self.alshow dismissWithCompletion:nil];
                        }];
                        
                        
                        
                            self.alshow = [[JCAlertView alloc]initWithCustomView:showview dismissWhenTouchedBackground:YES];
                            
                        
                        

                        
                        
                    }
                }
            }
            
            
            
            
            
            
        } apnsUUID:uuid];
    }
}

-(UIView*)createIndexShowwth:(WRCircleNews*)news Completion:(void (^)(NSError*))completion closs:(void (^)(NSError*))closs
{
    CGFloat height =20;
    if (IPHONE_X) {
        height = 80;
    }
    
    
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(10,height,ScreenW-20, SCREEN_HEIGHT-40)];
//    pannel.backgroundColor = [UIColor redColor];
    UIImageView* im = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    im.userInteractionEnabled = YES;
    
    [pannel addSubview:im];
    
    [im sd_setImageWithURL:[NSURL URLWithString:news.contentImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [im sizeToFit];
        CGFloat itemW = ScreenW-20;
        CGFloat itemH = 0;
        //根据image的比例来设置高度
        
        if (image.size.width) {
            
            itemH = image.size.height / image.size.width * itemW;
     
            if (itemH >= itemW) {
                
                itemW = pannel.width;
                
                itemH = image.size.height / image.size.width * itemW;
                
            }
            
        }
//        im.contentMode = UIViewContentModeScaleAspectFit;
        im.frame = CGRectMake(0, 30, itemW, itemH);
        
//        pannel.frame = CGRectMake((ScreenW-im.width)*1.0/2, (YYScreenSize().height-im.height)*1.0/2-40, im.width, im.height+80);
//        CGFloat w = pannel.width*1.0;
       
        
        UIButton* clossbtn = [[UIButton alloc]initWithFrame:CGRectMake(pannel.width/2-25, MaxY(im), 50, 50)];
        clossbtn.centerX = im.width*1.0/2;
        clossbtn.y = im.bottom+30;
        [clossbtn setImage:[UIImage imageNamed:@"弹窗关闭按钮"] forState:0];
        clossbtn.userInteractionEnabled = YES;
        [pannel addSubview:clossbtn];

        
        [clossbtn bk_whenTapped:^{
            closs(nil);
        }];
        
       
        [im bk_whenTapped:^{
            completion(nil);
        }];
        
        NSString *uuid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
        if(uuid == nil)
        {
            uuid = @"";
        }
        
        [WRViewModel userHomeWithCompletion:^(NSError * _Nonnull error, id  _Nonnull resultObject) {
            if (error) {
                if (error.code == WRErrorCodeWrongUser) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:WRLogOffNotification object:nil];
                    NSLog(@"User validate error, log off");
                }
            }
            else
            {
                WRCircleNews* news = resultObject;
                NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
                NSString* datestr = [ud objectForKey:@"active"];
                WRDateformatter* forma =[WRDateformatter formatter];
                NSDate* havedate = [forma dateFromString:datestr];
                NSDate* currentdate = [NSDate new];
                //news.status=YES;
                if (news.status) {
                  //  datestr =nil;
                    
                    if (!datestr||!(havedate.day==currentdate.day&&havedate.month==currentdate.month)) {
                    
                        
                        
                        if (!_noshow) {
//                            self.alshow.size = pannel.size;
                            self.alshow.frame = CGRectMake(0, 0, ScreenW, SCREEN_HEIGHT);
//                            im.frame = CGRectMake(0, 0, ScreenW, 400);
//                            pannel.frame = CGRectMake(10,20,ScreenW-20, SCREEN_HEIGHT-40);
//                            CGPoint p = CGPointMake(ScreenW*1.0/2, YYScreenSize().height*1.0/2);
                            [self.alshow show];
                            
                            _noshow = YES;
                        }
                        
                        
                        [ud setObject:[forma stringFromDate:currentdate] forKey:@"active"];
                        
                        
                    }
                }
            }
            
            
            
            
            
            
        } apnsUUID:uuid];
        
        
        
    }];
    
 

//    UIView* realview = [[UIView alloc]initWithFrame:CGRectMake(0, 100, 257, 0)];
//    realview.layer.cornerRadius = 5;
//    realview.layer.masksToBounds = YES;
//    [pannel addSubview:realview];
   
//
//    UILabel* title = [UILabel new];
//    title.y = 23;
//    title.text = news.title;
//    title.font = [UIFont systemFontOfSize:13];
//    title.textColor = [UIColor colorWithHexString:[news.titleColor uppercaseString]];
//    [title sizeToFit];
//    title.centerX = w/2;
//     CGFloat  y = title.bottom+12;
//    [realview addSubview:title];
//
//    int i= 0;
//    for (NSString* text in [news.content componentsSeparatedByString:@"|"]) {
//        UILabel* title = [UILabel new];
//        title.y = y;
//        title.width = w-50*2;
//        title.x = 50;
//        title.numberOfLines = 0;
//        title.text = text;
//        title.font = [UIFont systemFontOfSize:12];
//        NSString* upstr =[news.contentColor componentsSeparatedByString:@"|"][i];
//        title.textColor = [UIColor colorWithHexString:[upstr uppercaseString]];
//        [title sizeToFit];
//        CGSize s = [title.text sizeWithFont:[UIFont
//                                             systemFontOfSize:12] constrainedToSize:CGSizeMake(title.width, MAXFLOAT)];
//        y+= s.height;
//        i++;
//        [realview addSubview:title];
//    }
//
//    UIButton*btn = [UIButton new];
//    btn.y = y+22;
//    btn.width = 128;
//    btn.height = 34;
//    [btn setTitle:news.btnText forState:0];
//    [btn setTitleColor:[UIColor colorWithHexString:[news.btnTextColor uppercaseString]] forState:0];
//    btn.backgroundColor = [UIColor colorWithHexString:[news.btnBackground uppercaseString]];
//    btn.layer.cornerRadius = 34*1.0/2;
//    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    btn.centerX = w/2;
//    [realview addSubview:btn];
//
//    [btn bk_whenTapped:^{
//        completion(nil);
//    }];
//
    
//
//
//
//
//    realview.height = btn.bottom+22;
//    pannel.height = realview.height+100;
//    //pannel.backgroundColor = [UIColor redColor];
//
//
//
//
//    im = [[UIImageView alloc]initWithFrame:realview.bounds];
//
//    [im sd_setImageWithURL:[NSURL URLWithString:news.contentImageUrl] completed:^(UIImage *image, NSError *error, EMSDImageCacheType cacheType, NSURL *imageURL) {
//
//        im.contentMode = UIViewContentModeScaleToFill;
//        CGFloat top = 40;
//        CGFloat left = 40;
//        CGFloat bottom = 40;
//        CGFloat right = 40;
//
//        // 设置端盖的值
//        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
//        // 设置拉伸的模式
//        UIImageResizingMode mode = UIImageResizingModeStretch;
//
//        // 拉伸图片
//        UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
//        [im setImage:newImage];
//
//    }];
//
//    [realview addSubview:im];
//    [realview sendSubviewToBack:im];
//
    
    
    
    
    
    
    
    return pannel;
}

-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Network
-(void)fetchData {
    if (![[WRUserInfo selfInfo] isLogged]) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    [UserViewModel fetchPersonDataWithCompletion:^(NSError *error) {
        [_tableView.mj_header endRefreshing];
        //        [_scrollView.mj_header endRefreshing];
        if (error) {
            //添加提示视图
//            self.tableView.errorType = NoDataTypeRequestError;
//             __weak typeof(self)weakSelf = self;
//            self.tableView.nodataBlock = ^{
//
//                 [self fetchData];
//                [weakSelf.tableView removeNoDataView];
//            };
        } else {
            NSArray* arrl = [ShareUserData userData].proTreatRehab;
            weakSelf.loadedData = YES;
            NSMutableArray* arr = [NSMutableArray array];
            NSMutableArray* rehabarr=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"rehab"]];
            
            
            
            for (WRRehab* re in [ShareUserData userData].treatRehab ) {
                if (!re.state) {
                    [arr addObject:re];
                    if (![rehabarr containsObject: re.indexId]) {
                        [rehabarr insertObject:re.indexId atIndex:0];
                    }
                }else
                {
                    if ([rehabarr containsObject: re.indexId] ) {
                        [rehabarr removeObject:re.indexId];
                    }
                }
            }
            for (WRRehab* re in  [ShareUserData userData].proTreatRehab) {
                if (!re.state) {
                    [arr addObject:re];
                    if (![rehabarr containsObject: re.indexId]) {
                        [rehabarr insertObject:re.indexId atIndex:0];
                    }
                }
                else
                {
                    if (![rehabarr containsObject: re.indexId] ) {
                        [rehabarr removeObject:re.indexId];
                    }
                }
            }
            
            if ([ShareUserData userData].selfrehab) {
                WRRehab* re=[ShareUserData userData].selfrehab;
                
                if (!re.state) {
                    [arr addObject:re];
                    if (![rehabarr containsObject: re.indexId]) {
                        [rehabarr insertObject:re.indexId atIndex:0];
                    }
                }
                else
                {
                    if (![rehabarr containsObject: re.indexId] ) {
                        [rehabarr removeObject:re.indexId];
                    }
                }
                
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:rehabarr forKey:@"rehab"];
            NSMutableArray* result = [NSMutableArray array];
            for (int i=0;i<rehabarr.count;i++){
                for (WRRehab* re in arr) {
                    if ([re.indexId isEqualToString:rehabarr[i]]) {
                        [result addObject:re ];
                    }
                }
            }
            self.arr =result;
            
            
            
            
           [weakSelf.tableView reloadData];
            if (self.isguide) {
               // [self showGuideView];
            }
            
            //            [weakSelf layout];
            NSLog(@"[ShareUserData userData].rehabCount%ld",[ShareUserData userData].rehabCount);
        }
    }];
}

-(void)fetchFData {
    if (![[WRUserInfo selfInfo] isLogged]) {
        return;
    }
    
    __weak __typeof(self) weakSelf = self;
    [UserViewModel fetchPersonFDataWithCompletion:^(NSError *error) {
        //        [_scrollView.mj_header endRefreshing];
        if (error) {
            //            [weakSelf layout];
        } else {
            weakSelf.loadedData = YES;
            NSMutableArray* arr = [NSMutableArray array];
            NSMutableArray* rehabarr=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"rehab"]];
            
            
            
            for (WRRehab* re in [ShareUserData userData].treatRehab ) {
                if (!re.state) {
                    [arr addObject:re];
                    if (![rehabarr containsObject: re.indexId]) {
                        [rehabarr insertObject:re.indexId atIndex:0];
                    }
                }else
                {
                    if ([rehabarr containsObject: re.indexId] ) {
                        [rehabarr removeObject:re.indexId];
                    }
                }
            }
            for (WRRehab* re in  [ShareUserData userData].proTreatRehab) {
                if (!re.state) {
                    [arr addObject:re];
                    if (![rehabarr containsObject: re.indexId]) {
                        [rehabarr insertObject:re.indexId atIndex:0];
                    }
                }
                else
                {
                    if (![rehabarr containsObject: re.indexId] ) {
                        [rehabarr removeObject:re.indexId];
                    }
                }
            }
            if ([ShareUserData userData].selfrehab) {
                WRRehab* re=[ShareUserData userData].selfrehab;
                
                if (!re.state) {
                    [arr addObject:re];
                    if (![rehabarr containsObject: re.indexId]) {
                        [rehabarr insertObject:re.indexId atIndex:0];
                    }
                }
                else
                {
                    if (![rehabarr containsObject: re.indexId] ) {
                        [rehabarr removeObject:re.indexId];
                    }
                }
                
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:rehabarr forKey:@"rehab"];
            NSMutableArray* result = [NSMutableArray array];
            for (int i=0;i<rehabarr.count;i++){
                for (WRRehab* re in arr) {
                    if ([re.indexId isEqualToString:rehabarr[i]]) {
                        [result addObject:re ];
                    }
                }
            }
            self.arr =result;
            
            [weakSelf.tableView reloadData];
            if (self.isguide) {
             //   [self showGuideView];
            }
            
            //            [weakSelf layout];
            NSLog(@"[ShareUserData userData].rehabCount%ld",[ShareUserData userData].rehabCount);
        }
    }];
}



-(void)loadDatapr {
    __weak __typeof(self) weakSelf = self;
    [self.PrviewModel fetchDataWithCompletion:^(NSError *error) {
        if (error) {
//            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
//                [weakSelf loadDatapr];
//            }];
        } else {
            
            [weakSelf.tableView reloadData];
        }
    }];
}

-(void)updateSelfInfo
{
    if (self.tableView&&[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) {
       [self.tableView reloadData];
    }
    
}
-(void)updatedaliypoint
{
    [self.dayviewModel fetchUserdaliyWithCompletion:^(NSError *error) {
        if (!error) {
            
            WRDaliy* day =self.dayviewModel.myDaliy;
            int i=0;
            for (NSDictionary* dic in day.taskarry ) {
                if (![dic[@"state"] boolValue]) {
                    i++;
                }
            }
            if (day.isDaliy) {
                UIImage *image = [UIImage imageNamed:@"日常任务"];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, 0, 20, 20);
                
                [button setBackgroundImage:image forState:0];
                [button addTarget:self action:@selector(onClickedLeftBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
                UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
                self.navigationItem.leftBarButtonItem = leftItem;
                self.backButton = button;
            }
            
            
            if (i>0) {
                
                self.bageView = [[M13BadgeView alloc] initWithFrame:CGRectMake(0,0,10, 10)];
                self.bageView.font=[UIFont systemFontOfSize:9];
                self.bageView.text = [NSString stringWithFormat:@"%d",i];
                [self.backButton addSubview:self.bageView];
                self.bageView.badgeBackgroundColor=[UIColor redColor];
                self.bageView.textColor=[UIColor whiteColor];
                self.bageView.hidesWhenZero=YES;
                _bageView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight;
            }
            else
            {
                [self.bageView removeFromSuperview];
            }
        }
    }];
}
-(void)reload {
    if ([WRUserInfo selfInfo].isLogged) {
        
    } else {
        self.loadedData = YES;
    }
}
-(void)loadData
{
   
//    [self userHome];
//    [self updateSelfInfo];
//    [self fetchData];
//    [self loadDatapr];
    
    
    
}

#pragma mark -
- (NSDate *)getCustomDateWithHour:(NSInteger)hour withDate:(NSDate*)date
{
    //获取当前时间
    NSDate * destinationDateNow = date;
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];
    
    //设置当前的时间点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}
//获取时间段
-(NSString *)getTheTimeBucketWith:(NSDate*)date
{
    //    NSDate * currentDate = [self getNowDateFromatAnDate:[NSDate date]];
    
    NSDate * currentDate = date;
    if ([currentDate compare:[self getCustomDateWithHour:0 withDate:date]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:9 withDate:date]] == NSOrderedAscending)
    {
        return @"早上";
    }
    else if ([currentDate compare:[self getCustomDateWithHour:9 withDate:date]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:11 withDate:date]] == NSOrderedAscending)
    {
        return @"上午";
    }
    else if ([currentDate compare:[self getCustomDateWithHour:11 withDate:date]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:13 withDate:date]] == NSOrderedAscending)
    {
        return @"中午";
    }
    else if ([currentDate compare:[self getCustomDateWithHour:13 withDate:date]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:18 withDate:date]] == NSOrderedAscending)
    {
        return @"下午";
    }
    else
    {
        return @"晚上";
    }
}
-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
   
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }
    else
    {
        return @"";
    }
}

- (void
   )navigationController:(UINavigationController *)navigationController
willShowViewController:(UIViewController *)viewController animated:(BOOL
                                                                    )animated
{
    [viewController viewWillAppear:animated];
}

- (void
   )navigationController:(UINavigationController *)navigationController
didShowViewController:(UIViewController *)viewController animated:(BOOL
                                                                   )animated 
{
    [viewController viewDidAppear:animated];
}


static NSString *kGuideVersionKey = @"homeGuide";
-(void)showGuideView
{
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kGuideVersionKey];
    if (lastVersion && lastVersion.floatValue > 0.0) {
        
    } else {
        NSArray* guideTitles = @[
                                 
                                 NSLocalizedString(@"这里可以看自己的训练记录哦～", nil),
                                 NSLocalizedString(@"日常任务都在这里哦～", nil),
                                 NSLocalizedString(@"在这里可以添加自己的方案哦～", nil),
                                 
                                 
                                 ];
        [[NSUserDefaults standardUserDefaults] setObject:@"1.0" forKey:kGuideVersionKey];
        
        NSMutableArray *rects = [NSMutableArray array];
        for(NSInteger i = 0; i < 3; i++)
        {
            CGRect r;
            switch (i) {
                    
                case 0:
                {
                  r=  CGRectMake(0, 64, 100, 42);
                    
                }
                    break;
                case 2:
                {
                    if (self.arr.count>0) {
                        NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:2];
                        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:path];
                        CGRect rnew= cell.frame;
                        rnew.origin.y+= 64;
                        rnew.origin.x+= ScreenW -100;
                        rnew.size.width = 80;
                        r= rnew;
                        
                    }
                    else
                    {
                        NSIndexPath * path = [NSIndexPath indexPathForRow:0 inSection:2];
                        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:path];
                        CGRect rnew= cell.frame;
                        rnew.origin.y+=64;
                        rnew.origin.x=0;
                        rnew.size.width =ScreenW;
                        r= rnew;
                    
                    }
                    
                }
                    break;
                case 1:
                {
                    r=  CGRectMake(0, 20, 100, 42);
                    
                }
                    break;
                


                    
                    
                default:
                    break;
                
            }
            [rects addObject:[NSValue valueWithCGRect:r]];
        }
        GuideView *guide = [GuideView new];
        NSMutableArray *array = [NSMutableArray arrayWithArray:rects];
//        [array addObject:[NSValue valueWithCGRect:CGRectMake(0, 20, 50, 44)]];
        UIView *view = [[UIApplication sharedApplication].delegate window].rootViewController.view;
        [guide showInView:view maskFrames:array labels:guideTitles];
    }
}


-(void)actionWithType:(BannerActionType)type data:(id)data {
    switch (type) {
        case BannerActionTypeTreat:
        case BannerActionTypeProTreat:
        case BannerActionTypeArticle:
        {
            if (![self checkUserLogState:nil]) {
                return;
            }
            break;
        }
            
        default:
            break;
    }
    
    switch (type) {
        case BannerActionTypeUnknown: {
            break;
        }
            
        case BannerActionTypeTreat: {
            [self presentTreatRehabWithDisease:data isTreat:YES];
            break;
        }
        case BannerActionTypeProTreat: {
            WRRehabDisease *disease = data;
            [self presentProTreatRehabWithDisease:disease stage:0 upgrade:@"0"];
            break;
        }
            
        case BannerActionTypeArticle: {
            WRArticle *object = data;
            ArticleDetailController *viewController = [[ArticleDetailController alloc] init];
            
            viewController.currentNews = object;
            viewController.hidesBottomBarWhenPushed =YES;
            [self.navigationController pushViewController:viewController animated:YES];
            
            break;
        }
        case 6:
        {
            NSString* url = data[@"url"];
            if ([url isKindOfClass:[NSString class]]) {
                WrWebViewController* web = [WrWebViewController new];
                web.url = [NSString stringWithFormat:@"%@?userId=%@",url,[WRUserInfo selfInfo].userId];
                web.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:web animated:YES];
            }else{
                AskImIndexController* askim = [AskImIndexController new];
                askim.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:askim animated:YES];
            }
            
            break;
        }
            
        default:{
            break;
        }
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
