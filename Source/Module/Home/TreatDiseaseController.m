//
//  TreatDiseaseController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/3.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "TreatDiseaseController.h"
#import "RehabObject.h"

#import "WRView.h"
#import "CWStarRateView.h"

#import "PreventVideosController.h"

#import "RehabIndexViewModel.h"
#import "PreventViewModel.h"
#import "ShareUserData.h"
#import "RehabObject.h"
#import "WRObject.h"
#import <YYKit/YYKit.h>
#import "ShareData.h"
@interface TreatDiseaseController ()
{
    NSDate* _startDate;
}
@property(nonatomic)RehabIndexViewModel *viewModel;
@property(nonatomic)PreventViewModel *PrviewModel;

@property(nonatomic)BOOL isLoadedData;
@property(nonatomic)BOOL isLoadedDatapr;
@property(nonatomic)NSArray *imageColors;
@end

@implementation TreatDiseaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isLoadedData = NO;
    _isLoadedDatapr = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    self.imageColors = @[[UIColor colorWithHexString:@"ff892f"], [UIColor colorWithHexString:@"004eff"], [UIColor colorWithHexString:@"ed1e79"], [UIColor colorWithHexString:@"47c0ff"]];
//    if ([ShareData data].treatDisease.count > 0)
//    {
//        [self layout];
//    }
//    else
//    {
        [self loadData];
        [self loadDatapr];
//    }
    
   
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    //self.scrollView.frame =CGRectMake(0, 0, ScreenW, self.view.height);
    [super viewWillAppear:animated];
    [self createBackBarButtonItem];
   
    _startDate = [NSDate new];
    
    if ([ShareData data].treatDisease.count > 0)
    {
        [self layout];
    }
        
    
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    JTNavigationController *jtNav = self.navigationController;
    UINavigationBar *bar = jtNav.navigationBar;
    
    
    bar.barTintColor = [UIColor whiteColor];
    bar.tintColor = [UIColor blackColor];
    [bar setTranslucent:NO];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}
#pragma mark - getter & setter
-(RehabIndexViewModel*)viewModel
{
    if (!_viewModel) {
        _viewModel = [[RehabIndexViewModel alloc] init];
    }
    return _viewModel;
}
-(PreventViewModel *)PrviewModel {
    if (!_PrviewModel) {
        _PrviewModel = [[PreventViewModel alloc] init];
    }
    return _PrviewModel;
}
#pragma mark - UI
-(void)layout
{
//    if (self.isLoadedData||self.isLoadedDatapr) {
//        return;
//    }
//    self.isLoadedData = YES;
//    self.isLoadedDatapr =YES;
    
    NSMutableSet<NSString*> *codeSets = [NSMutableSet set];
    NSMutableDictionary<NSString*, NSMutableArray<WRRehabDisease*>*> *collections = [NSMutableDictionary dictionary];
    NSMutableArray *allDiseaseArray = [NSMutableArray array];
    [allDiseaseArray addObjectsFromArray:[ShareData data].proTreatDisease];
    [allDiseaseArray addObjectsFromArray:[ShareData data].treatDisease];
    
    
    
    NSMutableArray* classarry = [NSMutableArray array];
    for (WRTreatclass* class in [ShareData data].treatclassArry ) {
        
            [classarry addObject:class];
        
    }
    NSMutableArray *treatarray = [NSMutableArray array];
    
    
    
    
    
    for(WRRehabDisease *obj in allDiseaseArray)
    {
        NSLog(@"order%d",obj.order);
        if (obj.state == DiseaseStateComming) {
            continue;
        }
        
        WRTreatclass* typeclas = nil;
        for (WRTreatclass* class in classarry ) {
            if ([class.classifyName isEqualToString:self.title]) {
                typeclas = class;
            }
        }
        
        for (NSString* str in [obj.classifyId componentsSeparatedByString:@"|"]) {
            if ([str isEqualToString:typeclas.uuid]) {
                [treatarray addObject:obj];
            }
        }
        if (!typeclas)
        {
            continue;
        }
        
        
        
        
        
        
    }
    
    static BOOL have =YES;
    [[ShareUserData userData].proTreatRehab enumerateObjectsUsingBlock:^(WRRehab * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WRRehab* yao = obj;
        if ([yao.disease.indexId isEqualToString:@"cb888cb9-af32-47a8-8f69-2824b85d7e78"]) {
            
            
            have = YES;
        }
    }];
    
    
    
    if (have) {
        
        [allDiseaseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WRRehabDisease* dis = obj;
            if ([dis.indexId isEqualToString:@"cb888cb9-af32-47a8-8f69-2824b85d7e79"]) {
                [allDiseaseArray removeObject:dis];
            }
            
        }];
    }
    else
    {
        [allDiseaseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WRRehabDisease* dis = obj;
            if ([dis.indexId isEqualToString:@"cb888cb9-af32-47a8-8f69-2824b85d7e78"]) {
                [allDiseaseArray removeObject:dis];
            }
            
        }];
    }

        
    
    

    
    if (self.intro.length>0) {
        UILabel* la = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 52)];
        la.text = self.intro;
        la.textColor = [UIColor colorWithHexString:@"959595"];
        la.font = [UIFont systemFontOfSize:12];
        la.backgroundColor = [UIColor colorWithHexString:@"efefef"];
        la.textAlignment = NSTextAlignmentCenter;
        la.numberOfLines = 0;
        [self.view addSubview:la];
        
    }
    
    

    NSMutableArray<WRRehabDisease*> *array = treatarray;
    
    if ([self.XBParam isEqualToString:@"预防"]) {
        CGFloat y= 14;
        if (self.intro.length>0) {
            y = 52+14;
        }
        int index = 0;
        
        for(WRScene *object in self.PrviewModel.scenes)
        {
            UIView* pandel = [[UIView alloc]initWithFrame:CGRectMake(16, y, self.view.width-16*2, 0)];
            NSString *imageName = [NSString stringWithFormat:@"prevent_%d", (index%3 + 1)];
            pandel.layer.cornerRadius = 4;
            pandel.layer.masksToBounds = YES;
            UIImageView* banner = [UIImageView new];
            banner.x = 0;
            banner.y = 0;
            banner.width = pandel.width;
            banner.height = 9*banner.width/16.0;
            banner.image = [UIImage imageNamed:imageName];
            banner.tag =index;
            [pandel addSubview:banner];
            
            UILabel* name = [UILabel new];
            name.text = [NSString stringWithFormat:@"%@",object.name];
            name.font = [UIFont wr_smallTitleFont];
            name.textColor = [UIColor whiteColor];
            [name sizeToFit];
            name.y = WRUIBigOffset+WRUIDiffautOffset;
            name.x = WRUIMidOffset;
            
            [pandel addSubview:name];
            NSArray* arr =@[@"适合在家使用，可预防缓解长期伏案工作，家务等带来的肌肉疲劳酸胀感",@"适合回家路上或公园散步时使用，可帮助预防缓解因长时间保持/重复单一动作（如久坐，久站，玩手机等）的肩颈不适感",@"适合上班期间使用，可帮助预防缓解因长期使用电脑，久坐，久站引起的颈肩腰手的疲劳感。"];
            UILabel* count = [UILabel new];
            count.text = [NSString stringWithFormat:@"%@",arr[index%3]];
            count.font = [UIFont wr_detailFont];
            count.width = pandel.width- (WRUIMidOffset+77);
            count.numberOfLines= 0;
            count.textColor = [UIColor whiteColor];
            count.y = name.bottom+WRUIOffset;
            count.x = WRUIMidOffset;
            [count sizeToFit];
            [pandel addSubview:count];
            
             __weak __typeof(self) weakSelf = self;
            [pandel bk_whenTapped:^{
                [weakSelf onClickedItem:banner];
            }];
            
            [self.scrollView addSubview:pandel];
            pandel.height = 9*banner.width/16.0;
            y += pandel.height+14;
             index++;
        }
       // self.scrollView.frame = self.view.frame;
        self.scrollView.contentSize = CGSizeMake(self.view.width, y+64);
    }
    
    if (array.count > 0)
    {
        
        CGFloat y=14;
        if (self.intro.length>0&&self.intro) {
            y = 52+14;
        }
        for(NSInteger index = 0; index < array.count; index++)
        {
            WRRehabDisease *disease = array[index];
            BOOL isPro = [disease isPro];
            
            if (isPro) {
                
               UIView* prov = [self createPageViewWithProDisease:disease];
                prov.y = y;
               
                [self.scrollView addSubview:prov];
                y += prov.height+7;
                
            }
            else
            {
                UIView* prov = [self createPageViewWithDisease:disease];
                prov.y = y;
                
                [self.scrollView addSubview:prov];
                y += prov.height+7;

            }
            
        }
       // self.scrollView.frame = self.view.frame;
        self.scrollView.contentSize = CGSizeMake(self.view.width, y+64);
    }
    
}

- (UIView*)createPageViewWithProDisease:(WRRehabDisease*)disease
{
    UIView* pandel = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.view.width-15*2, 0)];

    UIImageView* banner = [UIImageView new];
    banner.x = 0;
    banner.y = 0;
    banner.width = self.view.width-15*2;
    banner.height = 9*banner.width/16.0;
    [banner setImageWithURL:[NSURL URLWithString:disease.bannerImageUrl2]];
    [pandel addSubview:banner];
    
    banner.layer.cornerRadius = 4;
    banner.layer.masksToBounds = YES;
    
    
    
    UILabel* name = [UILabel new];
    name.text = [NSString stringWithFormat:@"%@个人方案",disease.diseaseName];
    name.font = [UIFont wr_smallTitleFont];
    name.textColor = [UIColor whiteColor];
    [name sizeToFit];
    name.y = WRUIBigOffset+WRUIDiffautOffset;
    name.x = WRUIMidOffset;
    [pandel addSubview:name];
    
    
    UILabel* count = [UILabel new];
    count.text = [NSString stringWithFormat:@"根据您%@的症状智能定制适合您的康复方案",disease.diseaseName];
    count.font = [UIFont wr_detailFont];
    [count sizeToFit];
    count.width = pandel.width- (WRUIMidOffset+77);
    count.numberOfLines= 0;
    count.textColor = [UIColor whiteColor];
    count.y = name.bottom+WRUIOffset;
    count.x = WRUIMidOffset;
    [pandel addSubview:count];
    
    
     count = [UILabel new];
    count.text = [NSString stringWithFormat:@"%ld人已参加",disease.count];
    count.font = [UIFont wr_detailFont];
    count.textColor = [UIColor whiteColor];
    [count sizeToFit];
    count.y = banner.height+WRUILittleOffset-50-count.height;
    count.x = WRUIMidOffset;
    [pandel addSubview:count];
    
//    UIButton* add = [UIButton new];
//    [add setTitle:@"添加个人定制方案" forState:0 ];
//    [add setTitleColor:[UIColor whiteColor] forState:0];
//    add.backgroundColor =[UIColor wr_themeColor];
//    add.titleLabel.font = [UIFont wr_smallestFont];
//    add.width = 132;
//    add.height = 27;
//    add.centerX = pandel.width*1.0/2;
//    add.y = count.bottom+WRUIBigOffset+WRUIOffset;
//    add.userInteractionEnabled = YES;
//    [add setImage:[UIImage imageNamed:@"添加方案白色图标"] forState:0];
//    add.layer.cornerRadius = 13.5;
//    add.layer.masksToBounds = YES;
//    add.layer.borderColor = [UIColor wr_themeColor].CGColor;
//    add.layer.borderWidth = WRBorderWidth;
//    [pandel addSubview: add];
    
    
    __weak __typeof(self) weakSelf = self;
    [pandel bk_whenTapped:^{
        [weakSelf actionOnDisease:disease];
    }];
//    [add bk_whenTapped:^{
//        [weakSelf actionOnDisease:disease];
//    }];
    
//    for (WRRehab* re in [ShareUserData userData].proTreatRehab)
//    {
//        if ([re.disease.indexId isEqualToString:disease.indexId]&&!re.state) {
//            UIImageView* hastrea = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"已经添加Bar"]];
//            hastrea.right = banner.right;
//            hastrea.top = banner.top;
//            [pandel addSubview:hastrea];
//            [pandel bk_whenTapped:^{
//                [weakSelf actionOnDiseasewithhas:re];
//            }];
//            UILabel* count = [UILabel new];
//            count.text = @"已添加";
//            count.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]-4];
//            count.textColor = [UIColor whiteColor];
//            [count sizeToFit];
//            count.center = hastrea.center;
//            count.x += 12;
//            count.y -= 12;
//            CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI_4);
//            [count setTransform:transform];
//
//            [pandel addSubview:count];
//
//            [pandel bk_whenTapped:^{
//                [weakSelf actionOnDiseasewithhas:re];
//            }];
//            [add bk_whenTapped:^{
//                [weakSelf actionOnDiseasewithhas:re];
//            }];
//
//        }
//    }
    
    
    pandel.height = banner.height+WRUILittleOffset;
    return pandel;
}
- (UIView*)createPageViewWithDisease:(WRRehabDisease*)disease
{
    UIView* pandel = [[UIView alloc]initWithFrame:CGRectMake(15, 0, self.view.width-15*2, 0)];
    
    UIImageView* banner = [UIImageView new];
    banner.x = 0;
    banner.y = 0;
    banner.width = self.view.width-15*2;
    banner.height = 9*banner.width/16.0;
    [banner setImageWithURL:[NSURL URLWithString:disease.bannerImageUrl2]];
    [pandel addSubview:banner];
    
    banner.layer.cornerRadius = 4;
    banner.layer.masksToBounds = YES;
    
    
    UILabel* name = [UILabel new];
    name.text = [NSString stringWithFormat:@"%@",disease.diseaseName];
    name.font = [UIFont wr_smallTitleFont];
    name.textColor = [UIColor whiteColor];
    [name sizeToFit];
    name.y = WRUIBigOffset+WRUIDiffautOffset;
    name.x = WRUIMidOffset;
    [pandel addSubview:name];
    
    CGFloat value = (CGFloat)(disease.difficulty%5)/5;
    CWStarRateView *starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(WRUIMidOffset, name.bottom+WRUIOffset, 78,10) numberOfStars:5 backgroundImage:[UIImage imageNamed:@"star_deffault"] foregroundImage:[UIImage imageNamed:@"star"]];
    starRateView.scorePercent = value;
    starRateView.allowIncompleteStar = NO;
    starRateView.hasAnimation = NO;
    starRateView.userInteractionEnabled = NO;
    [pandel addSubview:starRateView];
    
    UILabel* count = [UILabel new];
    
    count.text = [NSString stringWithFormat:@"%.0lf分钟",disease.duration/60.0];
    count.font = [UIFont wr_detailFont];
    [count sizeToFit];
    count.textColor = [UIColor whiteColor];
    count.y = starRateView.bottom+WRUIOffset;
    count.x = WRUIMidOffset;
    [pandel addSubview:count];
    
    UILabel* join = [UILabel new];
    join.text = [NSString stringWithFormat:@"%ld人已参加",disease.clicks];
    join.font = [UIFont wr_detailFont];
    [join sizeToFit];
    join.textColor = [UIColor whiteColor];
    join.y = count.bottom+WRUIBigOffset*2;
    join.x = WRUIMidOffset;
    [pandel addSubview:join];
    
    __weak __typeof(self) weakSelf = self;
    [pandel bk_whenTapped:^{
        [weakSelf actionOnDisease:disease];
    }];
    
    pandel.height = banner.height+WRUILittleOffset;
    for (WRRehab* re in [ShareUserData userData].treatRehab)
    {
        if ([re.disease.indexId isEqualToString:disease.indexId]&&!re.state) {
            UIImageView* hastrea = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"已经添加Bar"]];
            hastrea.right = banner.right;
            hastrea.top = banner.top;
            [pandel addSubview:hastrea];
            [pandel bk_whenTapped:^{
                [weakSelf actionOnDiseasewithhas:re];
            }];
            UILabel* count = [UILabel new];
            count.text = @"已添加";
            count.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]-4];
            count.textColor = [UIColor whiteColor];
            [count sizeToFit];
            count.center = hastrea.center;
            count.x += 12;
            count.y -= 12;
            CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI_4);
            [count setTransform:transform];
            
            [pandel addSubview:count];

        }
    }
    
    return pandel;
    
 
}

#pragma mark - action
-(void)actionOnDisease:(WRRehabDisease*)disease
{
    if ([disease isPro]) {
        
        
        
        if ([disease.diseaseName isEqualToString:@"颈椎"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"jbdz"] attributes:nil counter:duration];
            self.umstr =@"jbdz";
        }
        else if ([disease.diseaseName isEqualToString:@"肩背部"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"jianbdz"] attributes:nil counter:duration];
            self.umstr =@"jianbdz";
        }
        else if ([disease.diseaseName isEqualToString:@"腰部"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"ybdj"] attributes:nil counter:duration];
            self.umstr =@"ybdz";

        }

        
        WRRehab* rehab =nil;
        for (WRRehab* re in [ShareUserData userData].proTreatRehab) {
            if ([disease.indexId isEqualToString:re.disease.indexId]) {
                rehab =  re;
                
            }
        }
        
        if (rehab) {
            
            [self showNOquestionProTreatRehab:rehab stage:0];
        }
        else
        {
            [self pushProTreatRehabWithDisease:disease stage:0 upgrade:@"0"];
        }
        
        
        
        [UMengUtils careForRehabDiseaseSelect:disease.diseaseName isPro:[@(1) stringValue]];
    }
    else
    {
        if ([self.XBParam isEqualToString:@"颈"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
        
            [MobClick event:[NSString stringWithFormat:@"jbks"] attributes:nil counter:duration];

            self.umstr =@"jbks";
        }
        else if ([self.XBParam isEqualToString:@"肩"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"jianbks"]attributes:nil counter:duration];
            self.umstr =@"jianbks";
        }
        else if ([self.XBParam isEqualToString:@"腰"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"ybks"] attributes:nil counter:duration];
            self.umstr =@"ybks";
        }
        else if ([self.XBParam isEqualToString:@"四肢"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"szks"] attributes:nil counter:duration];
            self.umstr =@"szks";
        }

        
        
        [self pushTreatRehabWithDisease:disease isTreat:YES];
        [UMengUtils careForRehabDiseaseSelect:disease.diseaseName isPro:[@(0) stringValue]];
    }
}
-(void)actionOnDiseasewithhas:(WRRehab*)disease ;
{
    if ([disease. disease isPro]) {
        
        if ([disease.disease.diseaseName isEqualToString:@"颈椎"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"jbdz"] attributes:nil counter:duration];
            self.umstr =@"jbdz";
        }
        else if ([disease.disease.diseaseName isEqualToString:@"肩背部"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"jianbdz"] attributes:nil counter:duration];
            self.umstr =@"jianbdz";
        }
        else if ([disease.disease.diseaseName isEqualToString:@"腰部"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"ybdz"] attributes:nil counter:duration];
            self.umstr =@"ybdz";
            
        }
        
        
        [self showNOquestionProTreatRehab:disease stage:0];
       // [self pushProTreatRehabWithDisease:disease.disease stage:0 upgrade:@"1"];
        [UMengUtils careForRehabDiseaseSelect:disease.disease.diseaseName isPro:[@(1) stringValue]];
        //锚点
        
        
        
        
    }
    else
    {
        
        if ([self.XBParam isEqualToString:@"颈"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"jbks"] attributes:nil counter:duration];
            self.umstr =@"jbks";
        }
        else if ([self.XBParam isEqualToString:@"肩"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"jianbks"] attributes:nil counter:duration];
            self.umstr =@"jbks";
        }
        else if ([self.XBParam isEqualToString:@"腰"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"ybks"] attributes:nil counter:duration];
            self.umstr =@"ybks";
        }
        else if ([self.XBParam isEqualToString:@"四肢"]) {
            NSDate *now = [NSDate date];
            int duration = (int)[now timeIntervalSinceDate:_startDate];
            [MobClick event:[NSString stringWithFormat:@"szks"] attributes:nil counter:duration];
            self.umstr =@"szks";
        }
        
       [self pushTreatRehabWithDisease:disease.disease isTreat:YES];
     
        [UMengUtils careForRehabDiseaseSelect:disease.disease.diseaseName isPro:[@(0) stringValue]];
        //锚点
        
        
    }
}




-(IBAction)onClickedItem:(id)sender {
    UIImageView *imageView = sender;
    
    NSInteger index = imageView.tag;
    if (index < self.PrviewModel.scenes.count) {
        WRScene *scene = self.PrviewModel.scenes[index];
        NSLog(@"scene.name%@",scene.name);
        PreventVideosController *viewController = [[PreventVideosController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController setScene:scene banner:[UIImage imageNamed:[NSString stringWithFormat:@"prevent_banner_%d",(int)(index%self.imageColors.count + 1)]] mostColor:self.imageColors[index%self.imageColors.count]];
    }
}
#pragma mark - 

#pragma mark - LoadData
-(void)loadData
{
    __weak __typeof(self) weakSelf = self;
    [self.viewModel fetchDataWithCompletion:^(NSError *error) {
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取数据失败", nil) completion:^{
                [weakSelf loadData];
            }];
        } else {
            [self layout];
        }
    }];
}
-(void)loadDatapr {
    __weak __typeof(self) weakSelf = self;
    [self.PrviewModel fetchDataWithCompletion:^(NSError *error) {
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
                [weakSelf loadDatapr];
            }];
        } else {
            
            [weakSelf layout];  
        }
    }];
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
