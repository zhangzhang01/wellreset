//
//  RehabIndexController.m
//  rehab
//
//  Created by 何寻 on 6/16/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "GuideView.h"
#import "RehabIndexController.h"
#import "RehabIndexViewModel.h"
#import "TreatDiseaseSelectorController.h"
#import "ArticleDetailController.h"
#import "WRProTreatQuestionsIndexController.h"
#import "WRProTreatViewModel.h"
#import "WRRefreshHeader.h"
#import "WRTreat.h"
#import "WRView.h"


@interface RehabIndexController ()
{
    BOOL _loadDataFlag;
}
@property(nonatomic)NSMutableArray *guideControls;
@property(nonatomic)RehabIndexViewModel *viewModel;

@end

@implementation RehabIndexController

-(instancetype)init {
    if (self = [super init]) {
        __weak __typeof(self) weakSelf = self;
        
        WRRefreshHeader *header = [[WRRefreshHeader alloc] init];
        header.refreshingBlock = ^{
            [weakSelf onRefresh];
        };
        self.scrollView.mj_header = header;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:WRSplashOutNotification object:nil];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.frame = self.view.bounds;
}

#pragma mark - IBActions
-(IBAction)onRefresh {
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj != self.scrollView.mj_header) {
            [obj removeFromSuperview];
        }
    }];
    _loadDataFlag = NO;
    [self loadData];
}

#pragma mark - network
-(void)fetchData {
    if (_loadDataFlag) {
        return;
    }
    [self.scrollView.mj_header beginRefreshing];
    [self loadData];
}

-(void)loadData {
    if (!self.viewModel) {
        self.viewModel = [[RehabIndexViewModel alloc] init];
    }
    
    __weak __typeof(self) weakSelf = self;
    [self.viewModel fetchDataWithCompletion:^(NSError * _Nonnull error) {
        if (error) {
            [self.scrollView.mj_header endRefreshing];
        } else {
            [weakSelf didLoadedData];
        }
    }];
}

#pragma mark -
-(void)notificationHandler:(NSNotification*)notification {
    if ([notification.name isEqualToString:WRSplashOutNotification]) {
        [self.scrollView.mj_header beginRefreshing];
    }
}

-(void)didLoadedData {
    _loadDataFlag = YES;
    [self.scrollView.mj_header endRefreshing];
    [self.guideControls removeAllObjects];
    [self layout];
}

-(void)layout
{
    BOOL biPad = [WRUIConfig IsHDApp];
    
    CGRect frame = self.scrollView.bounds;
  
    NSString *placeHolderImageName = @"well_default_4_3";
    CGFloat offset = WRUIOffset;
    if (biPad)
    {
        offset *= 2;
    }
    CGFloat x = offset, y = x, cx, cy, lineSize = 1;
    NSInteger columns = 2;
    const NSUInteger maxCount = 4;
    UIColor *sectionColor = [UIColor colorWithHexString:@"d3e8fd"];
    UIColor *lineColor = [UIColor wr_lightBorderColor];
    const CGFloat sectionHeight = 10;
    
    UIView *header;
    NSString *title, *iconName;
    NSArray *array;
    UIView *panel = self.scrollView;
    
    title = NSLocalizedString(@"快速缓解不适", nil);
    array = self.viewModel.treatDiseaseArray;
    iconName = @"index_icon_treat";
    __weak __typeof(self) weakSelf = self;
    for (NSUInteger index = 0; index < 1; index++)
    {
        NSUInteger count = (biPad?4:2);
        cx = (frame.size.width - 2*offset);
        CGFloat imageWidth = (cx - (count - 1)*offset)/count;
        
        CGFloat itemHeight = 0;
        x = offset;
        cx = frame.size.width - 2*x;
        
        header = [RCAppUtils createSectionHeaderWithTitle:title icon:iconName tintColor:(index > 0) ? [UIColor wr_themeColor] : [UIColor orangeColor] width:cx more:(index == 0) moreAction:^{
            if ([weakSelf checkUserLogState:nil]) {
                [weakSelf showDiseaseSelector];
            }
        }];
        cy = header.frame.size.height;
        header.frame = CGRectMake(x, y, cx, cy);
        [panel addSubview:header];
        y = header.bottom + offset;
        
        CGFloat y0 = y;
        NSArray *itemsArray = array;
        NSUInteger j = 0;
        
        NSUInteger indexCount = 0;
        for(id object in itemsArray)
        {
            if (indexCount >= maxCount) {
                break;
            }
            indexCount++;
            
            NSString *title, *imageUrl, *detail;
            BOOL enable = YES;
            if (index == 0)
            {
                WRRehabDisease *disease = object;
                title = disease.diseaseName;
                detail = disease.diseaseDetail;
                imageUrl = disease.imageUrl;
                enable = (disease.state != DiseaseStateComming);
            }
            else
            {
                WRRehabDisease *disease = object;
                title = disease.diseaseName;
                imageUrl = disease.imageUrl;
                detail = disease.diseaseDetail;
                enable = (disease.state != DiseaseStateComming);
            }
            
            GridThumbView *item = [[GridThumbView alloc] initWithFrame:CGRectMake(x, y, imageWidth, itemHeight)
                                                                 style:GridThumbViewStyleDefault
                                                      placeHolderImage:[UIImage imageNamed:placeHolderImageName]];
            item.enable = enable;
            [item.imageView setImageWithUrlString:imageUrl holder:placeHolderImageName];
            item.titleLabel.text = title;
            item.detailLabel.text = detail;
            item.tag = j;
            if (itemHeight == 0)
            {
                [item sizeToFit];
                itemHeight = item.height;
            }
            if (enable)
            {
                [item bk_whenTapped:^{
                    if([weakSelf checkUserLogState:nil]) {
                        NSInteger position = item.tag;
                        if(index == 0)
                        {
                            WRRehabDisease *treatDisease = weakSelf.viewModel.treatDiseaseArray[position];
                            [weakSelf showTreatmentWithDisease:treatDisease];
                        }
                        else
                        {
                            WRRehabDisease *disease = weakSelf.viewModel.proTreatDiseaseArray[position];
                            [self fetchQuestionWithDisease:disease];
                        }
                    }
                    
                }];
            }
            
            [panel addSubview:item];
            j++;
            
            if (j%count == 0)
            {
                x = offset;
                y += item.bounds.size.height + offset;
            }
            else
            {
                x += item.bounds.size.width + offset;
            }
            y0 = item.bottom + offset;
        }
        
        y = y0;
        
        if (index == 0)
        {
            x = 0, cx = frame.size.width, cy = sectionHeight;
            UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
            sectionView.backgroundColor = sectionColor;
            [panel addSubview:sectionView];
            y = sectionView.bottom + offset;
        }
        
        [self.guideControls addObject:panel];
        
        if (index == 0) {
            title = NSLocalizedString(@"定制康复方案", nil);
            array = self.viewModel.proTreatDiseaseArray;
            iconName = @"index_icon_pro_treat";
            
            x = offset;
            cx = frame.size.width - 2*x;
            header = [RCAppUtils createSectionHeaderWithTitle:title icon:iconName tintColor:[UIColor wr_themeColor] width:cx more:NO];
            cy = header.frame.size.height;
            header.frame = CGRectMake(x, y, cx, cy);
            [panel addSubview:header];
            y = header.bottom + offset;
            
            cx = (header.size.width - lineSize - offset)/columns;
            cy = cx/2;
            for(NSInteger index = 0; index < MIN(maxCount, array.count); index++)
            {
                WRRehabDisease *disease = array[index];
                GridThumbView *itemControl = [[GridThumbView alloc] initWithFrame:CGRectMake(x, y, cx, cy)
                                                                            style:GridThumbViewStyle1
                                                                 placeHolderImage:[UIImage imageNamed:@"well_default"]];
                itemControl.titleLabel.text = disease.diseaseName;
                itemControl.detailLabel.text = [NSString stringWithFormat:@"%@ %@", [@(disease.count) stringValue], NSLocalizedString(@"人已定制", nil)];
                itemControl.imageView.layer.masksToBounds = YES;
                itemControl.imageView.layer.cornerRadius = itemControl.imageView.width/2;
                itemControl.enable = (disease.state != DiseaseStateComming);
                if (itemControl.enable == NO) {
                    itemControl.detailLabel.hidden = YES;
                }
                [itemControl.imageView setImageWithUrlString:disease.imageUrl holder:@"well_default"];
                if (itemControl.enable) {
                    [itemControl bk_whenTapped:^{
                        if([weakSelf checkUserLogState:nil]) {
                            [self fetchQuestionWithDisease:disease];
                        }
                    }];
                }
                [panel addSubview:itemControl];
                
                if ((index + 1)%columns == 0) {
                    x = offset;
                    y += cy;
                    
                    if (index == (columns - 1)) {
                        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(2*x, y, frame.size.width - 2*2*x, lineSize)];
                        lineView.backgroundColor = lineColor;
                        [panel addSubview:lineView];
                        y = lineView.bottom;
                    }
                    
                } else {
                    x += cx ;
                    if ((index%columns != (columns - 1))) {
                        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, (index == 0) ? (y + offset) : y, lineSize, cy)];
                        lineView.backgroundColor = lineColor;
                        [panel addSubview:lineView];
                    }
                    x += offset;
                }
            }
            
            x = 0, cx = frame.size.width, cy = sectionHeight;
            UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
            sectionView.backgroundColor = sectionColor;
            [panel addSubview:sectionView];
            y = sectionView.bottom + offset;
        }
    }

    //[self showGuideView];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, y);
}


#pragma mark - 
-(void)showTreatmentWithDisease:(WRRehabDisease*)disease
{
    [self presentTreatRehabWithDisease:disease isTreat:YES];
}

-(void)fetchQuestionWithDisease:(WRRehabDisease*)disease
{
    [[self.class root] presentProTreatRehabWithDisease:disease stage:0];
}

-(void)showDiseaseSelector
{
    TreatDiseaseSelectorController *viewController = [[TreatDiseaseSelectorController alloc] init];
    WRNavigationController *nav = [[WRNavigationController alloc] initWithRootViewController:viewController];
    [[self.class root] presentViewController:nav animated:YES completion:nil];
}

static NSString *kGuideVersionKey = @"treatIndexGuide";
-(NSMutableArray *)guideControls {
    if (!_guideControls) {
        _guideControls = [NSMutableArray array];
    }
    return _guideControls;
}

-(void)showGuideView {
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kGuideVersionKey];
    if (lastVersion && lastVersion.floatValue > 0.0) {
        
    } else {
        NSArray* guideTitles = [NSMutableArray arrayWithObjects:NSLocalizedString(@"有不适？简单的运动就能缓解疼痛哦", nil),
                                NSLocalizedString(@"想要您的专属康复运动？回答问题就能定制哦", nil), nil];
        [[NSUserDefaults standardUserDefaults] setObject:@"1.0" forKey:kGuideVersionKey];
        GuideView *guide = [GuideView new];
        NSMutableArray *array = [NSMutableArray array];
        [self.guideControls enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect frame = [Utility resizeRect:obj.frame cx:180 height:60];
            frame = CGRectOffset(frame, 0, 54);
            [array addObject:[NSValue valueWithCGRect:frame]];
        }];
        UIView *view = [[UIApplication sharedApplication].delegate window].rootViewController.view;
        [guide showInView:view maskFrames:array labels:guideTitles];
    }
}
@end
