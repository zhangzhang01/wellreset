//
//  TreatDiseaseSelectorController.m
//  rehab
//
//  Created by herson on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "TreatDiseaseSelectorController.h"

#import "RehabObject.h"

#import "WRView.h"

#import "ShareData.h"
#import "RehabIndexViewModel.h"
#import "WRBodySelectorController.h"
#import "CreatTreatController.h"
#import "TreatDiseaseController.h"
#import "ShareUserData.h"
@interface TreatDiseaseSelectorController()

@property(nonatomic)RehabIndexViewModel *viewModel;
@property(nonatomic)BOOL isLoadedData;

@end

@implementation TreatDiseaseSelectorController

-(void)viewDidLoad
{
    [super viewDidLoad];
    _isLoadedData = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    [WRNetworkService pwiki:@"康复"];
    if ([ShareData data].treatDisease.count > 0)
    {
        
        [self layout];
    }
    else
    {
        [self loadData];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"添加方案", nil);
//    self.navigationItem.title = NSLocalizedString(@"康复", nil);
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    [bar lt_setBackgroundColor:[UIColor whiteColor]];
//    [bar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    UIImage *image = [[WRUIConfig defaultNavImage] imageByResizeToSize:CGSizeMake(bar.width, 1)];
//    [bar setShadowImage:image];

//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
//    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:19]}];
    
    [self createBackBarButtonItem];
//    [self createTitleViewWithTitle:NSLocalizedString(@"康复", nil)];
    
    if ([ShareData data].treatDisease.count > 0)
    {
        [self layout];
    }
    else
    {
        [self loadData];
    }
    
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


#pragma mark - UI
static BOOL have =YES;
-(void)layout
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 108)];
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    
    
    
    UIButton* challengBtn = [UIButton new];
    challengBtn.y = 18;
    [challengBtn setBackgroundImage:[UIImage imageNamed:@"预防方案"] forState:0];
    challengBtn.width = 50;
    challengBtn.height = 50;
    challengBtn.centerX = (self.view.width-59*2)/2*0+59;
    
    [v addSubview:challengBtn];
    [[challengBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        TreatDiseaseController *b = [TreatDiseaseController new];
        b.XBParam = @"预防";
        b.intro = @"适合不同场景（上班/路上/家里）使用，用于预防颈/肩/手/腰因长期久坐，久站,使用电脑出现的肌肉疲劳酸胀感";
        b.title = @"预防";
        [self.navigationController pushViewController:b animated:YES];
        
    }];
    
    UILabel* label = [UILabel new];
    label.text =@"预防";
    label.font = [UIFont systemFontOfSize:WRDetailFont];
    [label sizeToFit];
    label.textColor = [UIColor darkTextColor];
    label.y =challengBtn.bottom+12;
    label.centerX =challengBtn.centerX;
    [v addSubview:label];
    
    
    UIButton* listBtn = [UIButton new];
    listBtn.y = 18;
    [listBtn setBackgroundImage:[UIImage imageNamed:@"方案库"] forState:0];
    listBtn.width = 50;
    listBtn.height = 50;
    listBtn.centerX = (self.view.width-59*2)/2*1+59;
    [v addSubview:listBtn];
    [[listBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        WRBodySelectorController*b = [WRBodySelectorController new];
        b.isadd = YES;
        [self.navigationController pushViewController:b animated:YES];
        
    }];
    UILabel* listBtnlabel = [UILabel new];
    listBtnlabel.text =@"方案库";
    listBtnlabel.font = [UIFont systemFontOfSize:WRDetailFont];
    [listBtnlabel sizeToFit];
    listBtnlabel.textColor = [UIColor darkTextColor];
    listBtnlabel.y =listBtn.bottom+12;
    listBtnlabel.centerX =listBtn.centerX;
    [v addSubview:listBtnlabel];
    
    
    
   
    //        [self.tableView.tableHeaderView addSubview:testlabel];
    
    
    UIButton* presonBtn = [UIButton new];
    presonBtn.y = 18;
    [presonBtn setBackgroundImage:[UIImage imageNamed:@"自建方案"] forState:0];
    presonBtn.width = 50;
    presonBtn.height = 50;
    presonBtn.centerX = (self.view.width-59*2)/2*2+59;
    [v addSubview:presonBtn];
    
    UILabel* presonlabel = [UILabel new];
    presonlabel.text =@"自建方案";
    presonlabel.font = [UIFont systemFontOfSize:WRDetailFont];
    [presonlabel sizeToFit];
    presonlabel.textColor = [UIColor darkTextColor];
    presonlabel.y =presonBtn.bottom+12;
    presonlabel.centerX =presonBtn.centerX;
    [v addSubview:presonlabel];
    [[presonBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        if ([WRUserInfo selfInfo].level<4) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat: @"您等级不满4级无法自建方案,您目前等级为%ld级",[WRUserInfo selfInfo].level] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:actionCancel];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        [self showCreateTreat];
    }];
    
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, v.height-5, ScreenW, 5)];
    line.backgroundColor = [UIColor wr_lineColor];
    [v addSubview:line];
    
    
    

    
    
    
    if (self.isLoadedData) {
        return;
    }
    self.isLoadedData = YES;
    
    NSMutableArray<NSString*> *codeSets = [NSMutableArray array];
    NSMutableDictionary<NSString*, NSMutableArray<WRRehabDisease*>*> *collections = [NSMutableDictionary dictionary];
    NSMutableArray *allDiseaseArray = [NSMutableArray array];
    [allDiseaseArray addObjectsFromArray:[ShareData data].treatDisease];
    [allDiseaseArray addObjectsFromArray:[ShareData data].proTreatDisease];
    NSMutableArray* classarry = [NSMutableArray array];
    
    for (WRTreatclass* class in [ShareData data].treatclassArry ) {
        if ([class.classifyType intValue]==1) {
            [classarry addObject:class];
        }
    }
    
    
    
  
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
    
    
    
    for(WRRehabDisease *obj in allDiseaseArray)
    {
        NSLog(@"order%d",obj.order);
        if (obj.state == DiseaseStateComming) {
            continue;
        }
        
        WRTreatclass* typeclas = nil;
        for (WRTreatclass* class in classarry ) {
            for (NSString* str in[obj.classifyId componentsSeparatedByString:@"|"] ) {
                
                if ([str isEqualToString:class.uuid]) {
                    typeclas = class;
                }
                
            }
        }
        if (!typeclas)
        {
            continue;
        }
        
        if (![codeSets containsObject:typeclas.classifyName]) {
            [codeSets addObject:typeclas.classifyName];
        }
        
        
        
        NSMutableArray *array = collections[typeclas.classifyName];
        if (!array)
        {
            array = [NSMutableArray array];
            collections[typeclas.classifyName] = array;
        }
        
        
        
        [array addObject:obj];
    }
    
    
    
    
    
    for (WRTreatclass* typeclas in classarry ) {
        
        [codeSets setObject:typeclas.classifyName atIndexedSubscript:typeclas.sort-1];
    }
    
    
    UIView *container = self.scrollView;
    
    __weak __typeof(self) weakSelf = self;
    
    CGRect frame = container.bounds;
    CGFloat offset = 15, x = offset, y = 108, cx, cy;
  //  UILabel *label;
    UIView *lineView;
    UIFont *titleFont = [UIFont wr_lightFont];
    const NSUInteger rowCount = 3;
    CGFloat itemHeight = 0;
    UIColor *sectionColor = [UIColor wr_lightGray];
    const CGFloat sectionHeight = 1;
    NSString *placeHolderImageName = @"well_default_4_3";
    
    for(NSString *code in codeSets)
    {
        x = 15;
        
        
        NSMutableArray<WRRehabDisease*> *array = collections[code];
        UIScrollView* view = [UIScrollView new];
        view.width = ScreenW;
        view.height = 198;
        view.y = y;
        view.x = 0;
        [container addSubview:view];
        
        
        
        NSString *codeDesc = code;
        label = [[UILabel alloc] init];
        label.text = codeDesc;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:12 ];
        label.textAlignment = NSTextAlignmentLeft;
        [label sizeToFit];
        label.frame = CGRectMake(x, y+22, container.width - 2*x, label.height);
        [container addSubview:label];
        
        UIImageView* IM = [UIImageView new];
        [IM setImage:[UIImage imageNamed:@"下一个视频"]];
        IM.width = 7;
        IM.height = 12;
        IM.y = y+23;
        IM.right = ScreenW-12;
        [container addSubview:IM];
        
        UILabel* count = [UILabel new];
        
        count.text = [NSString stringWithFormat:@"%ld个方案",array.count];
        count.font = [UIFont systemFontOfSize:12];
        count.textColor = [UIColor wr_detailTextColor];
        [count sizeToFit];
        count.right = IM.left-5;
        count.y = y+22;
        [container addSubview:count];
        
        IM = [UIImageView new];
        [IM setImage:[UIImage imageNamed:@"方案图标"]];
        IM.width = 11;
        IM.height = 12;
        IM.y = y+23;
        IM.right =ScreenW-80;
        [container addSubview:IM];
        
        
        
        y += label.height + offset/2+32;
        label.userInteractionEnabled = YES;
        [label bk_whenTapped:^{
            TreatDiseaseController* tvc = [TreatDiseaseController new];
            if ([label.text isEqualToString:@"定制方案"]) {
                tvc.intro = @"根据自身症状，个性化定制的运动康复方案，适用于缓解颈肩腰疼痛，方案可升阶";
            }
            if ([label.text isEqualToString:@"运动损伤康复复方案"]) {
                tvc.intro = @"适用于膝关节疼痛等运动损伤康复，有助于恢复正常生活状态，重返运动场";
            }
            if ([label.text isEqualToString:@"体态调整方案"]) {
                tvc.intro = @"适用于不良体态（如高低肩/扁平足等）调整，有助于改善不良体态引起的不美观，疼痛等";
            }
            if ([label.text isEqualToString:@"快速缓解方案"]) {
                tvc.intro = @"适用于快速缓解颈肩腰部疼痛，腰突引起的坐骨神经痛等症状，建议配合定制方案使用";
            }
            if ([label.text isEqualToString:@"预防方案"]) {
                tvc.intro = @"适合不同场景（上班/路上/家里）使用，用于预防颈/肩/手/腰因长期久坐，久站,使用电脑出现的肌肉疲劳酸胀感";
            }
            tvc.title = code;
            [self.navigationController pushViewController:tvc animated:YES];
            
            
        }];
        
        cx = (frame.size.width - 2*offset);
        CGFloat imageWidth = 237;
        
        CGFloat y0 = y;
        
        if (array.count > 0)
        {
            NSInteger j = 0;
            UIImage *holderImage = [UIImage imageNamed:placeHolderImageName];
            
            
            for(NSInteger index = 0; index < array.count; index++)
            {
                
                WRRehabDisease *disease = array[index];
                BOOL isPro = [disease isPro];
                
                GridThumbView *item = [[GridThumbView alloc] initWithFrame:CGRectMake(x, 44+10, imageWidth, 137)
                                                                     style: GridThumbViewStyleDefault placeHolderImage:holderImage];
                
//                item.imageView.layer.masksToBounds = YES;
//                item.imageView.layer.cornerRadius = 5.f;
                
//                item.titleLabel.textColor = isPro ? [UIColor whiteColor] : [UIColor lightGrayColor];
              
//                if (!isPro && itemHeight == 0)
//                {
//                    [item sizeToFit];
//                    itemHeight = item.height;
//                }
            
                if (isPro)
                {
                    
                    item.pro = YES;
                    item.detailLabel.text = [NSString stringWithFormat:@"根据您%@的症状智能定制适合您的康复方案",disease.diseaseName];;
                    [item.imageView setImageWithUrlString:disease.bannerImageUrl holder:placeHolderImageName];
                    item.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    item.count.text = [NSString stringWithFormat:@"%ld人已参加",disease.count];
                }
                else
                {
                    [item.imageView setImageWithUrlString:disease.bannerImageUrl holder:placeHolderImageName];
                    item.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    item.count.text = [NSString stringWithFormat:@"%ld人已参加",disease.clicks];
                }
                item.titleLabel.text =  disease.diseaseName;
                CGFloat value = (CGFloat)(disease.difficulty%5)/5;
                item.starview.scorePercent = value;
                
                
                
               // item.starview.backgroundColor = [UIColor blackColor];
                [item setNeedsLayout];
                [item layoutIfNeeded];
                [item bk_whenTapped:^{
                    if([weakSelf checkUserLogState:nil]) {
//                        NSLog(@"nrekgnerre");
                        [weakSelf actionOnDisease:disease];
                    }
                }];
                
                [view addSubview:item];
                x+=imageWidth+15;
            }
            view.contentSize = CGSizeMake(x, 198);
            y =  view.bottom;
            
        }
        
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, y+64);
}

-(void)actionOnDisease:(WRRehabDisease*)disease
{
    if ([disease isPro]) {
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
        [self pushTreatRehabWithDisease:disease isTreat:YES];
        [UMengUtils careForRehabDiseaseSelect:disease.diseaseName isPro:[@(0) stringValue]];
    }
}

#pragma mark - 


#pragma mark - LoadData
-(void)loadData
{
    [SVProgressHUD show];
    __weak __typeof(self) weakSelf = self;
    [self.viewModel fetchDataWithCompletion:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (error) {
            [Utility retryAlertWithViewController:weakSelf.navigationController title:NSLocalizedString(@"获取数据失败", nil) completion:^{
                [weakSelf loadData];
            }];
        } else {
            [weakSelf layout];
        }
    }];
}
@end
