//
//  WRTestResultViewController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/10.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRTestResultViewController.h"
#import "rehab-Bridging-Header.h"
#import "rehab-Swift.h"
#import "Masonry.h"
#import "WRTestIntroViewController.h"
#import "WRObject.h"
#import <YYKit/YYKit.h>
#import "WRSheetView.h"
#import "DLPickerView.h"
@interface WRTestResultViewController ()<ChartViewDelegate, IChartAxisValueFormatter>
{
    UIScrollView* _bg ;
}
@property (nonatomic) RadarChartView* myRadarView;
@property WRTestInfo * leftr;
@property WRTestInfo * rightr;
@property WRTestInfo * choose;
@property UIView* dataView;
@property UIView* desc;
@property UIView* chooseView;
@property UIButton* go;
@end

@implementation WRTestResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImage* image = [UIImage imageNamed:@"测试说明"];
    UIButton*  buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(0, 0, 20, 20);
    buttonRight.imageView.contentMode = UIViewContentModeScaleToFill;
    [buttonRight setBackgroundImage:image forState:0];
    [buttonRight addTarget:self action:@selector(onClickedRightBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:buttonRight];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self createBackBarButtonItem];
    
    
    // Do any additional setup after loading the view.
}

-(void)onClickedBackButton:(UIBarButtonItem *)sender
{
    if (self.isCompit) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    return;
}
-(void)viewWillAppear:(BOOL)animated
{
    if (!self.isCompit) {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageWithColor:[UIColor whiteColor]] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedBackButton:)];
        self.navigationItem.leftBarButtonItem = item;
    }
//    [_bg removeAllSubviews];
//    [_bg removeFromSuperview];
    if (!_isCompit) {
        self.title = @"测试结果";
    }
    else
    {
        self.title = @"结果对比";
    }
    if (!_bg) {
        _bg = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_bg];
    }
    
    _bg.backgroundColor = [UIColor whiteColor];
    
    
    
    
    
    
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView* im = [UIImageView new];
    im.x = 0;
    im.y = 170;
    im.width =self.view.width;
    im.height =159;
    im.contentMode = UIViewContentModeScaleAspectFit;
    [im setImage:[UIImage imageNamed:@"圈"]];
//     [self.view addSubview:im];
    
    
    if (!self.myRadarView) {
       self.myRadarView = [[RadarChartView alloc]initWithFrame:CGRectMake(0, 110-64-54, self.view.width, 280)];
        [_bg addSubview:self.myRadarView];
    }
    
    self.myRadarView.dragDecelerationEnabled =NO;
//    self.myRadarView.description = @"";
    self.myRadarView.drawMarkers =NO;
    self.myRadarView.webLineWidth =0.5;
    self.myRadarView.innerWebLineWidth= 0.5;
    self.myRadarView.webColor = [UIColor colorWithHexString:@"e5e5e5"];
    self.myRadarView.innerWebColor = [UIColor colorWithHexString:@"959595"];
    self.myRadarView.webAlpha = 0.8;
    self.myRadarView.drawWeb = YES;
    self.myRadarView.rotationEnabled = NO;
    self.myRadarView.rotationAngle = 280;
    self.myRadarView.legend.enabled = YES;
    self.myRadarView.legend.drawInside = YES;
    self.myRadarView.delegate = self;
    self.myRadarView.backgroundColor = [UIColor clearColor];
    [self.myRadarView animateWithYAxisDuration:1.5];
    
    
    [self setdata];
    
   
    
}
- (void)setdata {
    ChartXAxis *xAxis = self.myRadarView.xAxis;
    xAxis.labelFont = [UIFont systemFontOfSize:13];
    xAxis.labelTextColor = [UIColor colorWithHexString:@"959595"];
    xAxis.drawLabelsEnabled=YES;
    xAxis.xOffset = 100;
    xAxis.yOffset = 100;
    
    xAxis.valueFormatter = self;
    
    ChartYAxis *yAxis = self.myRadarView.yAxis;
    yAxis.axisMinimum = 0.0;//最小值
    yAxis.axisMaximum = 100.0;//最大值
    yAxis.drawLabelsEnabled = NO;//是否显示 label
    yAxis.labelCount = 5;// label 个数
    yAxis.labelFont = [UIFont systemFontOfSize:20];// label 字体
    yAxis.labelTextColor = [UIColor lightGrayColor];// label 颜色
    //颜色
    if (!_choose) {
        self.choose = self.UserHealthStage;
        self.leftr = self.choose;
    }
    
    
    NSMutableArray* arry = [NSMutableArray array];
    //    NSMutableArray* xarry = [NSMutableArray array];
    double maxYVal = 100;
    for (int i=0; i<5; i++) {
        
        double mult = maxYVal + 1;
        double val = [[self.leftr.wwt componentsSeparatedByString:@"," ][i] intValue];
        RadarChartDataEntry* en1 = [[RadarChartDataEntry alloc]initWithValue:val data:@"测试1"];
        //        [en1 setX:];
        
        
        [arry addObject:en1];
        
    }
    
    
//    RadarChartDataSet* set =[[RadarChartDataSet alloc]initWithValues:arry label:self.leftr.createTime];
    RadarChartDataSet *set = [[RadarChartDataSet alloc]initWithEntries:arry label:self.leftr.createTime];
    set.drawFilledEnabled=NO;
    set.drawHighlightCircleEnabled =NO;
    set.highlightCircleFillColor = self.view.backgroundColor;
    set.fillColor = [UIColor redColor];
    set.colors = @[[UIColor wr_themeColor]];
    
    set.lineWidth = 2.0;
    set.drawValuesEnabled =NO;
    set.drawIconsEnabled = YES;
    set.highlightEnabled = YES;
    //    set.formLineDashPhase =2;
    set.formLineDashLengths = @[@2.0f, @3.0f];
    set.highlightLineDashPhase = YES;
    
    RadarChartDataSet* set2;
    arry = [NSMutableArray array];
    if (self.lastarry.count>0&&self.isCompit) {
        if (!self.rightr) {
            WRTestInfo* other = self.lastarry[0];
            self.rightr =other;
        }
        
        for (int i=0; i<5; i++) {
            
            double mult = maxYVal + 1;
            
            double val = [[self.rightr.wwt componentsSeparatedByString:@"," ][i] intValue];
            RadarChartDataEntry* en1 = [[RadarChartDataEntry alloc]initWithValue:val data:@"测试1"];
            //        [en1 setX:];
            
            
            [arry addObject:en1];
            
        }
        
        set2 = [[RadarChartDataSet alloc]initWithEntries:arry label:self.leftr.createTime];
        set2.drawFilledEnabled=NO;
        set2.colors = @[[UIColor colorWithHexString:@"e9e9e9"]];
        
        set2.drawHighlightCircleEnabled =NO;
        set2.highlightCircleFillColor = self.view.backgroundColor;
        set2.fillColor = [UIColor wr_lineColor];
        set2.lineWidth = 2.0;
        set2.formLineDashLengths= @[@2,@2];
        set2.formLineDashPhase =2;
        set2.drawValuesEnabled = NO;
        set2.drawIconsEnabled = YES;
    }
    //
    if (self.choose == self.rightr) {
        set2.colors = @[[UIColor wr_themeColor]];
        set.colors = @[[UIColor colorWithHexString:@"e9e9e9"]];
    }
    else
    {
        set2.colors = @[[UIColor colorWithHexString:@"e9e9e9"]];
        set.colors = @[[UIColor wr_themeColor]];
    }
    
    
    RadarChartData* date = [[RadarChartData alloc]initWithDataSets:@[set ]];
    if (set2 ) {
        date = [[RadarChartData alloc]initWithDataSets:@[set,set2 ]];
    }
    date.highlightEnabled =NO;
    self.myRadarView.data =date;
    
    if (self.dataView) {
        [self.dataView removeFromSuperview];
    }
    UIView* result =  [self createResultViewWith:@[]];
    if (_isCompit) {
        if (!self.chooseView) {
            UIView* sel =  [self createSeletDateView];
            sel.y = 310-64+25;
            [_bg addSubview:sel];
            self.chooseView = sel;
            
        }
        result.y = self.chooseView.bottom;
        [_bg bringSubviewToFront:self.chooseView];
    }
    else
    {
        result.y =  310-64+25;
    }
    [_bg addSubview:result];
    self.dataView = result;
    
    CGFloat y = result.bottom;
    if (self.desc) {
        [self.desc removeFromSuperview];
    }
    UIView* contene = [self createContentView:@""];
    contene.y = y;
    
    y+=contene.height;
    [_bg addSubview:contene];
    self.desc = contene;
    
    _bg.contentSize = CGSizeMake(self.view.width, y+119+64);
    
    [self.go removeFromSuperview];
    UIButton* go = [UIButton new];
    go.x = 25;
    go.y = YYScreenSize().height - 85 -64;
    go.width = 325;
    go.height = 50;
    go.backgroundColor = [UIColor wr_rehabBlueColor];
    [go setTitle:@"进入方案" forState:0];
    [go setTitleColor:[UIColor whiteColor] forState:0];
    go.titleLabel.font = [UIFont systemFontOfSize:18];
    [go wr_roundBorderWithColor:[UIColor colorWithHexString:@"82e3ff"]];
    self.go = go;
    if (!self.isCompit) {
        [self.view addSubview:go];
    }
    
    [[go rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self showNOquestionProTreatRehab:_rehab stage:0];
    }];

    

    // Dispose of any resources that can be recreated.
}
- (UIView*)createSeletDateView
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 310-64+25, self.view.width, 74)];
    CGFloat w = 17+13+112;
    UIButton* addl = [UIButton new];
    addl.width=addl.height = 17;
    addl.left = self.view.width*1.0/4 - w*1.0/2;
    addl.centerY  = pannel.height*1.0/2;
    [addl setBackgroundImage:[UIImage imageNamed:@"对比"] forState:0];
    [pannel addSubview:addl];
    
    UIButton* choosel = [UIButton new];
    choosel.width = 112;
    choosel.height = 30;
    choosel.x = addl.right+13;
    choosel.centerY = pannel.height*1.0/2;
    [choosel setTitle:[self.leftr.createTime substringToIndex:10] forState:0];
    [choosel setTitleColor:[UIColor colorWithHexString:@"707070"] forState:0];
    [choosel setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    choosel.titleLabel.font = [UIFont systemFontOfSize:13];
    choosel.layer.cornerRadius =WRCornerRadius;
    choosel.layer.masksToBounds = YES;
    choosel.layer.borderWidth = 1;
    choosel.layer.borderColor = [UIColor colorWithHexString:@"707070"].CGColor;
    [pannel addSubview:choosel];
    
    UIButton* addr = [UIButton new];
    addr.width=addr.height = 17;
    addr.right = self.view.width*3.0/4 + w*1.0/2;
    addr.centerY  = pannel.height*1.0/2;
    [addr setBackgroundImage:[UIImage imageNamed:@"对比"] forState:0];
    [pannel addSubview:addr];
    
    
    UIButton* chooser = [UIButton new];
    chooser.width = 112;
    chooser.height = 30;
    chooser.right = addr.left -13;
    chooser.centerY = pannel.height*1.0/2;
    if (self.rightr) {
      [chooser setTitle:[self.rightr.createTime substringToIndex:10] forState:0];
    }
    else
    {
      [chooser setTitle:@"未添加数据" forState:0];
    }
    [chooser setTitleColor:[UIColor colorWithHexString:@"707070"] forState:0];
    [chooser setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    chooser.titleLabel.font = [UIFont systemFontOfSize:13];
    chooser.layer.cornerRadius =WRCornerRadius;
    chooser.layer.masksToBounds = YES;
    chooser.layer.borderWidth = 1;
    chooser.layer.borderColor = [UIColor colorWithHexString:@"707070"].CGColor;
    [pannel addSubview:chooser];

    
    choosel.selected =YES;
    chooser.selected =NO;
    chooser.layer.borderColor = [UIColor colorWithHexString:@"707070"].CGColor;
    chooser.backgroundColor = [UIColor whiteColor];
    choosel.backgroundColor = [UIColor wr_themeColor];
    choosel.layer.borderColor = [UIColor wr_themeColor].CGColor;
    
    UIImageView* centre = [UIImageView new];
    centre .width = 10;
    centre.height = 18;
    centre.centerY = pannel.height*1.0/2;
    centre.centerX = pannel.width *1.0/2;
    [centre setImage:[UIImage imageNamed:@"-"]];
    [pannel addSubview:centre];
    
    
//    [_bg addSubview:pannel];
    
    //action
    [addl  bk_whenTapped:^{
        if (self.lastarry .count>0) {
            NSMutableArray* canChoose = [NSMutableArray array];
            [canChoose addObject:self.UserHealthStage];
            for (WRTestInfo* info in self.lastarry) {
                [canChoose addObject:info];
            }
            if (self.leftr) {
                [canChoose removeObject:self.leftr];
            }
            if (self.rightr) {
                [canChoose removeObject:self.rightr];
            }
            
            NSMutableArray* times = [NSMutableArray array];
            for (WRTestInfo * info in  canChoose) {
                [times addObject:info.createTime];
            }
            if (times.count>0) {
                DLPickerView* pick = [[DLPickerView alloc]initWithDataSource:times withSelectedItem:nil withSelectedBlock:^(id  _Nonnull item) {
                    NSInteger index = [times indexOfObject:item];
                    self.leftr = canChoose[index];
                    [choosel setTitle:[item substringToIndex:10] forState:0];
                    
                    choosel.selected =YES;
                    chooser.selected =NO;
                    self.choose = self.leftr;
                    
                    chooser.layer.borderColor = [UIColor colorWithHexString:@"707070"].CGColor;
                    chooser.backgroundColor = [UIColor whiteColor];
                    choosel.backgroundColor = [UIColor wr_themeColor];
                    choosel.layer.borderColor = [UIColor wr_themeColor].CGColor;
                    [self setdata];
                }];
                [pick show];
            }
            
        }
        else
        {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"暂时还没有更多的测试数据，下一次测试将在升阶时进行。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *repeatAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                
            }];
            [controller addAction:repeatAction];
            [self presentViewController:controller animated:YES completion:nil];
        }

        
        
        
        
        
    }];
    
    
    [addr  bk_whenTapped:^{
        if (self.lastarry .count>0) {
            NSMutableArray* canChoose = [NSMutableArray array];
            [canChoose addObject:self.UserHealthStage];
            for (WRTestInfo* info in self.lastarry) {
                [canChoose addObject:info];
            }
            if (self.leftr) {
                [canChoose removeObject:self.leftr];
            }
            if (self.rightr) {
                [canChoose removeObject:self.rightr];
            }
            
            NSMutableArray* times = [NSMutableArray array];
            for (WRTestInfo * info in  canChoose) {
                [times addObject:info.createTime];
            }
            if (times.count>0) {
                DLPickerView* pick = [[DLPickerView alloc]initWithDataSource:times withSelectedItem:nil withSelectedBlock:^(id  _Nonnull item) {
                    NSInteger index = [times indexOfObject:item];
                    self.rightr = canChoose[index];
                    [chooser setTitle:[item substringToIndex:10] forState:0];
                    
                    chooser.selected =YES;
                    choosel.selected =NO;
                    self.choose = self.rightr;
                    choosel.layer.borderColor = [UIColor colorWithHexString:@"707070"].CGColor;
                    choosel.backgroundColor = [UIColor whiteColor];
                    chooser.backgroundColor = [UIColor wr_themeColor];
                    chooser.layer.borderColor = [UIColor wr_themeColor].CGColor;
                    [self setdata];
                    
                }];
                [pick show];
                
            }
        }
        else
        {
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"抱歉" message:@"暂时还没有更多的测试数据，下一次测试将在升阶时进行。" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *repeatAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
                
            }];
            [controller addAction:repeatAction];
            [self presentViewController:controller animated:YES completion:nil];
            
        }
        
    }];

    [choosel bk_whenTapped:^{
        if (self.leftr) {
            choosel.selected =YES;
            chooser.selected =NO;
            self.choose = self.leftr;
            
            chooser.layer.borderColor = [UIColor colorWithHexString:@"707070"].CGColor;
            chooser.backgroundColor = [UIColor whiteColor];
            choosel.backgroundColor = [UIColor wr_themeColor];
            choosel.layer.borderColor = [UIColor wr_themeColor].CGColor;
            [self setdata];
        }
        
    }];
    
    [chooser bk_whenTapped:^{
        if (self.rightr) {
            chooser.selected =YES;
            choosel.selected =NO;
            self.choose = self.rightr;
            choosel.layer.borderColor = [UIColor colorWithHexString:@"707070"].CGColor;
            choosel.backgroundColor = [UIColor whiteColor];
            chooser.backgroundColor = [UIColor wr_themeColor];
            chooser.layer.borderColor = [UIColor wr_themeColor].CGColor;
            [self setdata];
        }
        
    }];
    return pannel;
    
}
- (UIView*)createResultViewWith:(NSArray*)arr
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 87)];
    pannel.backgroundColor = [[UIColor whiteColor ]colorWithAlphaComponent:0.05];
    
    NSString* v1 = [self.leftr.wwt componentsSeparatedByString:@","][0];
    NSString* v2 = [self.leftr.wwt componentsSeparatedByString:@","][1];
    NSString* v3 = [self.leftr.wwt componentsSeparatedByString:@","][2];
    NSString* v4 = [self.leftr.wwt componentsSeparatedByString:@","][3];
    NSString* v5 = [self.leftr.wwt componentsSeparatedByString:@","][4];
    
    arr = @[[NSString stringWithFormat: @"%@/100",v1],[NSString stringWithFormat: @"%@/100",v2],[NSString stringWithFormat: @"%@/100",v3],[NSString stringWithFormat: @"%@/100",v4],[NSString stringWithFormat: @"%@/100",v5]];
    NSArray* titleArr = @[@"健康度",@"功能度",@"灵活度",@"持久度",@"力量度"];
    if (!_isCompit) {
        for (int i=0; i<5; i++) {
            UILabel* count = [UILabel new];
            
            count.text = arr[i];
            
            count.font = [UIFont  systemFontOfSize:10];
            count.textColor = [UIColor wr_themeColor];
            [count sizeToFit];
            count.centerX = self.view.width/5*i+self.view.width/10.0;
            count.y = WRUIBigOffset;
            [pannel addSubview:count];
            [count setWr_AttributedWithFontRange:NSMakeRange(0, count.text.length-3) Font:[UIFont systemFontOfSize:20] InitTitle:count.text];
            [count sizeToFit];
            count.centerX = self.view.width/5*i+self.view.width/10.0;
            
            UILabel* title = [UILabel new];
            title.text = titleArr[i];
            title.font = [UIFont wr_smallestFont];
            [title sizeToFit];
            title.textColor = [UIColor wr_titleTextColor];
            title.y = count.bottom+WRUIBigOffset;
            title.centerX = count.centerX;
            
            [pannel addSubview:title];
            
            
            
            
        }

    }
    else
    {
        
        NSArray* ar1 = @[v1,v2,v3,v4,v5];
        NSString* b1,*b2,*b3,*b4,*b5;
        if (self.rightr) {
            b1 = [self.rightr.wwt componentsSeparatedByString:@","][0];
            b2 = [self.rightr.wwt componentsSeparatedByString:@","][1];
            b3 = [self.rightr.wwt componentsSeparatedByString:@","][2];
            b4 = [self.rightr.wwt componentsSeparatedByString:@","][3];
            b5 = [self.rightr.wwt componentsSeparatedByString:@","][4];
        }
        else
        {
            b1 = b2 = b3 = b4 = b5 =@"--";
            }
        
        
        
        NSArray* ar2 = @[b1,b2,b3,b4,b5];
        for (int i=0; i<5; i++) {
            UILabel* count = [UILabel new];
            
            count.text = ar1[i];
            
            count.font = [UIFont  systemFontOfSize:15];
            count.textColor = [UIColor wr_themeColor];
            [count sizeToFit];
            count.centerX = self.view.width/5*i+self.view.width/10.0;
            count.y = 17;
            [pannel addSubview:count];
            [count sizeToFit];
            count.centerX = self.view.width/5*i+self.view.width/10.0;
            
            UIView* line = [UIView new];
            line.y = count.bottom+5;
            line.backgroundColor = [UIColor colorWithHexString:@"707070"];
            line.width = 21;
            line.height =1;
            line.centerX = count.centerX;
            [pannel addSubview:line];
          
            
            UILabel* count2 = [UILabel new];
            
            count2.text = ar2[i];
            
            count2.font = [UIFont  systemFontOfSize:15];
            count2.textColor = [UIColor wr_titleTextColor];
            [count2 sizeToFit];
            count2.centerX = self.view.width/5*i+self.view.width/10.0;
            count2.y = line.bottom+5;
            [pannel addSubview:count2];
            [count2 sizeToFit];
            
            if (self.choose == self.rightr) {
             count2.textColor = [UIColor wr_themeColor];
                count.textColor = [UIColor wr_titleTextColor];
            }else
            {
                count.textColor = [UIColor wr_themeColor];
                count2.textColor = [UIColor wr_titleTextColor];
            }
            
            UILabel* title = [UILabel new];
            title.text = titleArr[i];
            title.font = [UIFont wr_smallestFont];
            [title sizeToFit];
            title.textColor = [UIColor wr_titleTextColor];
            title.y = count2.bottom+WRUIBigOffset;
            title.centerX = count.centerX;
            
            [pannel addSubview:title];
            
            
            
            
        }
    }
    
    
    
    
    return pannel;
    
}
- (UIView*) createContentView:(NSString*)content
{
    UIView* pannel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    
    UILabel* title = [UILabel new];
    title.text= @"症状描述：";
    title.font = [UIFont systemFontOfSize:WRTitleFont];
    title.textColor = [UIColor wr_titleTextColor];
    [title sizeToFit ];
    title.y = 28;
    title.x = 23;
    [pannel addSubview:title];
    content = self.choose.desc;
    UILabel* contentL = [UILabel new];
    contentL.text = content;
    contentL.font = [UIFont systemFontOfSize:WRDetailFont];
    contentL.textColor = [UIColor colorWithHexString:@"B5B5B5"];
    contentL.numberOfLines = 0;
    contentL.x = 23;
    contentL.y = title.bottom+ 25;
    contentL.width = self.view.width -46;
    [contentL sizeToFit];
    [pannel addSubview:contentL];
    CGSize size = [contentL.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(contentL.width, MAXFLOAT)];
    pannel.height = title.bottom + 25+ size.height;
    
    

    
    
    
    
    
    
    
    return pannel;



}
- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    int i = value;
    switch (i) {
        case 0:
            return @"健康度";
            break;
        case 1:
            return @"功能度";
            break;
        case 2:
            return @"灵活度";
            break;
        case 3:
            return @"持久度";
            break;
        case 4:
            return @"力量度";
            break;
        default:
            return @"";
            break;
    }
}
- (IBAction)onClickedRightBarButtonItem:(UIButton *)sender
{
    [self.navigationController pushViewController:[WRTestIntroViewController new] animated:YES];
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
