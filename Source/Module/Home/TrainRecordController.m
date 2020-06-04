//
//  TrainRecordController.m
//  rehab
//
//  Created by yongen zhou on 2017/3/1.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "TrainRecordController.h"
#import "rehab-Bridging-Header.h"
#import "rehab-Swift.h"
#import "Masonry.h"
#import "TrainViewModel.h"
#import "WRObject.h"
#import "WRDateformatter.h"
typedef enum : NSUInteger {
    trainDay,
    trainWeek,
    trainMonth,
    trainAll
} TrainType;

@interface TrainRecordController ()<ChartViewDelegate,UITableViewDelegate,IChartAxisValueFormatter>



@property (nonatomic, strong) BarChartView *barChartView;
@property (nonatomic, strong) BarChartData *data;
@property TrainViewModel* viewmodel;
@property WRTrainChartData* chooseChartData;
@property NSMutableArray* ChartDatas;
@property UITableView* DataTableView;
@property NSMutableDictionary* datadic;
@property NSMutableArray* dataarry;
@property UILabel* date;
@property UILabel* count;
@property UILabel* time;
@property UILabel* day;
@property UIView* dataView;
@property TrainType type;
@property NSInteger n;
@property UISegmentedControl* sege;
@property CGFloat scale;

@end
@implementation TrainRecordController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBackBarButtonItem];
    self.title= @"我的锻炼";
    self.viewmodel = [[TrainViewModel alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    [self fetchdata:trainDay date:[formatter stringFromDate:[NSDate new]]];
    [self addChart];
//    [self createTableView];
    [self layoutView];
    self.n =0;
    self.scale =1.0;
    
//    [self CreateDayChartView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    
    
    
}
- (UIView*)CreateDayChartView
{
    UIView* pandel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.x = WRUIDiffautOffset;
    titleLabel.y = WRUIDiffautOffset;
    titleLabel.text = @"锻炼记录";
    titleLabel.font = [UIFont systemFontOfSize:WRDetailFont];
    titleLabel.textColor = [UIColor darkTextColor];
    [titleLabel sizeToFit];
    [pandel addSubview:titleLabel];
    
    
    UILabel* contentLabel = [UILabel new];
    contentLabel.text = _chooseChartData.date;
    if (self.type == trainDay) {
        WRDateformatter* formatter = [WRDateformatter formatter];
        [formatter setDateFormat:@"YYYY-MM-dd"];
       NSDate* date = [formatter dateFromString:_chooseChartData.date];
        [formatter setDateFormat:@"YYYY年MM月dd日"];
        
        contentLabel.text = [formatter stringFromDate:date];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    
    
//    contentLabel.text =@"2017年09月20日";
    contentLabel.font = [UIFont wr_smallestFont];
    contentLabel.textColor = [UIColor darkTextColor];
    contentLabel.textAlignment = NSTextAlignmentRight;
    [contentLabel sizeToFit];
    contentLabel.right =  self.view.width - WRUIDiffautOffset;
    contentLabel.centerY = titleLabel.centerY;
    [pandel addSubview:contentLabel];
    self.date = contentLabel;
    
    UILabel* count = [UILabel new];
    count.text = [NSString stringWithFormat:@"%ld次",(long)_chooseChartData.trainCount];
//    count.text = @"10次";
    count.font = [UIFont wr_smallestFont];
    [count setWr_AttributedWithFontRange:NSMakeRange(0, count.text.length-1) Font:[UIFont systemFontOfSize:23] InitTitle:count.text];
    count.textColor = [UIColor darkTextColor];
    [count sizeToFit];
    count.centerX = self.view.width/4.0;
    count.y = titleLabel.bottom + WRUIBigOffset+WRUIOffset;
    [pandel addSubview:count];
    self.count = count;
    
    UILabel* time = [UILabel new];
    time.text = [NSString stringWithFormat:@"12分钟"];
    time.text = [NSString stringWithFormat:@"%ld分钟",(long)_chooseChartData.trainTime];
    time.font = [UIFont wr_smallestFont];
    [time setWr_AttributedWithFontRange:NSMakeRange(0, time.text.length-2) Font:[UIFont systemFontOfSize:23] InitTitle:time.text];
    time.textColor = [UIColor darkTextColor];
    [time sizeToFit];
    time.centerX = self.view.width/4.0*3;
    time.y = titleLabel.bottom + WRUIBigOffset+WRUIOffset;
    [pandel addSubview:time];
    self.time  = time;
    
    pandel.height = time.bottom;
    
    
    
    
    
    return pandel;
}
- (UIView*)CreateWeekChartView
{
    UIView* pandel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    
    UILabel* titleLabel = [UILabel new];
    titleLabel.x = WRUIDiffautOffset;
    titleLabel.y = WRUIDiffautOffset;
    titleLabel.text = @"锻炼记录";
    titleLabel.font = [UIFont systemFontOfSize:WRDetailFont];
    titleLabel.textColor = [UIColor darkTextColor];
    [titleLabel sizeToFit];
    [pandel addSubview:titleLabel];
    
    
    UILabel* contentLabel = [UILabel new];
    contentLabel.text = _chooseChartData.xVlue;
//    contentLabel.text =@"2017年09月20日";
    contentLabel.font = [UIFont wr_smallestFont];
    contentLabel.textColor = [UIColor darkTextColor];
    contentLabel.textAlignment = NSTextAlignmentRight;
    
    
    contentLabel.centerY = titleLabel.centerY;
     if(self.type == trainWeek)
    {
        NSArray * arr =[_chooseChartData.xVlue componentsSeparatedByString:@"/" ];
        if (arr.count==3) {
            NSArray* mid = [arr[1] componentsSeparatedByString:@"-"];
            contentLabel.text = [NSString stringWithFormat:@"%@月%@日-%@月%@日",arr[0],mid[0],mid[1],arr[2]];
        }
        
    }
    else if(self.type == trainMonth)
    {
        NSArray * arr =[_chooseChartData.date componentsSeparatedByString:@"-" ];
        if (arr.count==2) {
            contentLabel.text = [NSString stringWithFormat:@"%@年%@月",arr[0],arr[1]];
        }
        
    }
    
    [contentLabel sizeToFit];
    contentLabel.right =  self.view.width - WRUIDiffautOffset;
    [pandel addSubview:contentLabel];
    self.date = contentLabel;
    
    UILabel* count = [UILabel new];
    count.text = [NSString stringWithFormat:@"%ld次",_chooseChartData.trainCount];
//    count.text = @"10次";
    count.font = [UIFont wr_smallestFont];
    [count setWr_AttributedWithFontRange:NSMakeRange(0, count.text.length-1) Font:[UIFont systemFontOfSize:23] InitTitle:count.text];
    count.textColor = [UIColor darkTextColor];
    [count sizeToFit];
    count.centerX = self.view.width/4.0;
    count.y = titleLabel.bottom + WRUIBigOffset+WRUIOffset;
    [pandel addSubview:count];
    self.count = count;
    
    UILabel* day = [UILabel new];
    
    day.text = [NSString stringWithFormat:@"%ld天",[_chooseChartData.day integerValue]];
//    day.text = @"10天";
    day.font = [UIFont wr_smallestFont];
    [day setWr_AttributedWithFontRange:NSMakeRange(0, day.text.length-1) Font:[UIFont systemFontOfSize:23] InitTitle:day.text];
    day.textColor = [UIColor darkTextColor];
    [day sizeToFit];
    day.centerX = self.view.width/4.0*3;
    day.y = titleLabel.bottom + WRUIBigOffset+WRUIOffset;
    [pandel addSubview:day];
    self.day = day;
    
    
    UILabel* time = [UILabel new];
//    time.text = [NSString stringWithFormat:@"12分钟"];
    time.text = [NSString stringWithFormat:@"%ld分钟",_chooseChartData.trainTime];
    time.font = [UIFont wr_smallestFont];
    [time setWr_AttributedWithFontRange:NSMakeRange(0, time.text.length-2) Font:[UIFont systemFontOfSize:23] InitTitle:time.text];
    time.textColor = [UIColor darkTextColor];
    [time sizeToFit];
    time.centerX = self.view.width/4.0*2;
    time.y = titleLabel.bottom + WRUIBigOffset+WRUIOffset;
    [pandel addSubview:time];
    
    
    pandel.height = time.bottom;
    
    self.time = time;
    
    
    
    return pandel;
}






- (void)layoutView
{
    UISegmentedControl* dateSege = [[UISegmentedControl alloc]initWithFrame:CGRectMake(WRUIBigOffset,WRUIDiffautOffset , self.view.width-WRUIBigOffset*2, 32.5)];
    [dateSege insertSegmentWithTitle:@"日" atIndex:0 animated:NO];
    [dateSege insertSegmentWithTitle:@"周" atIndex:1 animated:NO];
    [dateSege insertSegmentWithTitle:@"月" atIndex:2 animated:NO];
    [dateSege insertSegmentWithTitle:@"总" atIndex:3 animated:NO];
    dateSege.tintColor = [UIColor wr_themeColor];
    [self.view addSubview:dateSege];
    self.sege = dateSege;
    UIView* chartdate =  [self CreateDayChartView];
    self.dataView = chartdate;
    self.type = trainDay;
    dateSege.selectedSegmentIndex =0;
    [[dateSege rac_newSelectedSegmentIndexChannelWithNilValue:@""]subscribeNext:^(id x) {
        
        // 返回的基本数据类型都被装包成NSNumber，可在此做一些判断操作
        NSLog(@"selectIndex-%@",x);
        [self.dataView removeFromSuperview];
        
        switch ([x integerValue]) {
            case 0:
            {
                UIView* chartdate =  [self CreateDayChartView];
                self.dataView = chartdate;
                self.barChartView.hidden =NO;
                chartdate.y = dateSege.bottom;
                [self.view addSubview:chartdate];
                self.type = trainDay;
                self.DataTableView.y= 341;
                self.DataTableView.height =self.view.height - 341;
                NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYY-MM-dd"];
                [self fetchdata:trainDay date:[formatter stringFromDate:[NSDate new]]];
                self.n =0;
                
            }
                break;
            case 1:
            {
                UIView* chartdate =  [self CreateWeekChartView];
                self.dataView = chartdate;
                self.barChartView.hidden =NO;
                chartdate.y = dateSege.bottom;
                [self.view addSubview:chartdate];
                self.type = trainWeek;
                self.DataTableView.y= 341;
                self.DataTableView.height =self.view.height - 341;
                NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYY-MM-dd"];
                [self fetchdata:trainWeek date:[formatter stringFromDate:[NSDate new]]];
                self.n =0;
                
            }
                break;
            case 2:
            {
                UIView* chartdate =  [self CreateWeekChartView];
                self.dataView = chartdate;
                self.barChartView.hidden =NO;
                chartdate.y = dateSege.bottom;
                [self.view addSubview:chartdate];
                self.type = trainMonth;
                self.DataTableView.y= 341;
                self.DataTableView.height =self.view.height - 341;
                NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYY-MM-dd"];
                [self fetchdata:trainMonth date:[formatter stringFromDate:[NSDate new]]];
                self.n =0;
               
            }
                break;
            case 3:
            {
                UIView* chartdate =  [self CreateWeekChartView];
                self.dataView = chartdate;
                self.barChartView.hidden =YES;
                chartdate.y = dateSege.bottom;
                [self.view addSubview:chartdate];
                self.DataTableView.y= 341-self.barChartView.height;
                self.DataTableView.height =self.view.height - 341+self.barChartView.height;
                self.type = trainAll;
                NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYY-MM-dd"];
                [self fetchdata:trainAll date:[formatter stringFromDate:[NSDate new]]];
                self.n =0;
            }
                break;
                
            default:
                break;
        }
    }];
    
    chartdate.y = dateSege.bottom;
    [self.view addSubview:chartdate];
    [self createTableView];
    
}


#pragma mark - chart
-(void)addChart
{
    self.barChartView = [[BarChartView alloc] init];
    self.barChartView.delegate = self;//设置代理
    [self.view addSubview:self.barChartView];
    [self.barChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width, 160));
        make.top.mas_offset(69+ 86.5);
    }];
    self.barChartView.y = 69+ 86.5;
    //基本样式
    self.barChartView.backgroundColor = [UIColor whiteColor];
    self.barChartView.noDataText = @"暂无数据";//没有数据时的文字提示
    self.barChartView.drawValueAboveBarEnabled = NO;//数值显示在柱形的上面还是下面
//    self.barChartView.drawHighlightArrowEnabled = NO;//点击柱形图是否显示箭头
    self.barChartView.drawBarShadowEnabled = NO;
//    self.barChartView._maxVisibleValueCount = 15;//是否绘制柱形的阴影背景
//    [self.barChartView zoom:2 scaleY:0 x:0 y:0];
    //交互设置
    
    
    self.barChartView.scaleYEnabled = YES;//取消Y轴缩放
    self.barChartView.scaleXEnabled = YES;//取消X轴缩放
    self.barChartView.doubleTapToZoomEnabled = NO;//取消双击缩放
    self.barChartView.dragEnabled = YES;//启用拖拽图表
    self.barChartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    self.barChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显

//    [self.barChartView zoomWithScaleX:2  scaleY:0 x:0 y:0];
    //X轴样式
    ChartXAxis *xAxis = self.barChartView.xAxis;
    xAxis.axisLineWidth = 0.5;//设置X轴线宽
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    xAxis.drawGridLinesEnabled = NO;//不绘制网格线
//    xAxis.labelFont = [UIFont wr_smallestFont];
    xAxis.valueFormatter = self;
    xAxis.granularityEnabled =YES;
    xAxis.granularity =1.0;
    xAxis.labelFont = [UIFont systemFontOfSize:9];
//设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
    xAxis.labelTextColor = [UIColor brownColor];//label文字颜色
    
    //右边Y轴样式
    self.barChartView.rightAxis.enabled = NO;//不绘制右边边轴
    self.barChartView.leftAxis.enabled = NO;//不绘制左边轴
    
    ChartYAxis *yAxis = self.barChartView.leftAxis;
    yAxis.axisMinimum = 0;
    yAxis.drawZeroLineEnabled =YES;
    
    
    
    
    //图例说明样式
    self.barChartView.legend.enabled = NO;//不显示图例说明
    //    self.barChartView.legend.position = ChartLegendPositionBelowChartLeft;//位置
    
    //右下角的description文字样式
//    self.barChartView.description = @"";//不显示，就设为空字符串即可
//        self.barChartView.descriptionText = @"柱形图";
    
    self.data = [self setData];
    
    //为柱形图提供数据
    
    //设置动画效果，可以设置X轴和Y轴的动画效果
    [self.barChartView animateWithYAxisDuration:1.5];
}
- (BarChartData *)setData{
    
    NSInteger xVals_count = self.viewmodel.chartArry.count;//X轴上要显示多少条数据
    NSInteger i=0;
    for (WRTrainChartData* ch  in self.dataarry) {
        if (ch.trainTime>i) {
            i=ch.trainTime;
        }
    }

    int maxYVal = i;//Y轴的最大值
    
    //X轴上面需要显示的数据
    
    BarChartData *data;
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < xVals_count; i++) {
       
        WRTrainChartData* ch = self.dataarry[i];
        
        
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i yValues:@[[NSNumber numberWithInteger:ch.trainTime]] ];
        [yVals addObject:entry];
    }
    
    
    CGFloat old =  1/self.scale;
    if (self.scale>0) {
        [self.barChartView zoomWithScaleX:old scaleY:0 x:self.n y:0];
    }
    
    if (self.type == trainDay) {
        
        
        [self.barChartView zoomWithScaleX:xVals_count/7.0  scaleY:0 x:self.n y:0];
        self.scale =xVals_count/7.0;
    }
    else if(self.type == trainWeek)
    {
        
        [self.barChartView zoomWithScaleX:xVals_count/5.0  scaleY:0 x:self.n y:0];
        self.scale =xVals_count/5.0;
    }
    else if(self.type == trainMonth)
    {
        
        [self.barChartView zoomWithScaleX:xVals_count/5.0  scaleY:0 x:self.n y:0];
        self.scale =xVals_count/5.0;
    }
    if (self.scale<1) {
        self.scale =1;
    }

    
    if (self.chooseChartData) {
        for (WRTrainChartData* data in self.dataarry) {
            if ([data.date isEqualToString:self.chooseChartData.date]) {
                self.n  = [self.dataarry indexOfObject:data];
                
            }
        }
    }
    
    if (yVals.count>0) {
        
    
    //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
//    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithValues:yVals label:nil];
        BarChartDataSet *set1 = [[BarChartDataSet alloc]initWithEntries:yVals label:nil];
//柱形之间的间隙占整个柱形(柱形+间隙)的比例
    set1.drawValuesEnabled = NO;//是否在柱形图上面显示数值
    set1.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
    [set1 setColor:[UIColor groupTableViewBackgroundColor]];
    [set1 setHighlightColor:[UIColor wr_themeColor]];//设置柱形图颜色
    //将BarChartDataSet对象放入数组中
    
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    
    [dataSets addObject:set1];
    
    //创建BarChartData对象, 此对象就是barChartView需要最终数据对象
    data = [[BarChartData alloc] initWithDataSet:set1];
    [data setBarWidth:0.5];

    }
    return data;
    
    
}

-(void)updateData{
    //数据改变时，刷新数据
    self.data = [self setData];

    self.barChartView.data = self.data;
    if (self.n>0) {
        [self.barChartView highlightValueWithX:self.n dataSetIndex:0 stackIndex:0];
        [self.barChartView centerViewToAnimatedWithXValue:self.n yValue:1 axis:0||1 duration:0.5];
    }
    NSEnumerator * enumerator = [self.dataarry reverseObjectEnumerator];
    NSMutableArray *ValueEn = [NSMutableArray array];
    ValueEn = [enumerator allObjects];
    for (WRTrainChartData *entry in ValueEn ) {
        if (entry.trainTime>0&&self.n==0) {
            NSInteger n =[self.dataarry indexOfObject:entry];
            [self.barChartView highlightValueWithX:n dataSetIndex:0 stackIndex:0];
            [self.barChartView centerViewToAnimatedWithXValue:n yValue:1 axis:0||1 duration:0.5];
            self.n = n;
            WRTrainChartData* ch = self.dataarry[n];
             [self fetchdata:self.type date:ch.date];
            self.chooseChartData =ch;
            break;
        }
    }
    [self.barChartView notifyDataSetChanged];
    
}
//-(void)addData
//{
//    int xVals_count = self.viewmodel.dataArray.count;//X轴上要显示多少条数据
//    int i=0;
//    for (WRTrainChartData* ch  in self.dataarry) {
//        if (ch.trainTime>i) {
//            i=ch.trainTime;
//        }
//    }
//    double maxYVal = i;
//    if (self.barChartView.data._xMax==29) {
//        
//    
//        for (int i = 0; i < xVals_count; i++) {
//            double mult = maxYVal + 1;
//            double val = (double)(arc4random_uniform(mult));
//            BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i+30 yValues:@[[NSNumber numberWithDouble:val]] label:[NSString stringWithFormat:@"%d日", i+1]];
//            [self.barChartView.data addEntry:entry dataSetIndex:0];
//        }
//    }
//    
//    [self.barChartView notifyDataSetChanged];
//    [self.barChartView zoomWithScaleX:2 scaleY:1 x:30 y:1];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//点击选中柱形时回调
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight{
    NSLog(@"%f",entry.x);
    if (entry.y>0) {
        
        NSInteger n =entry.x;
        self.n = n;
        WRTrainChartData* ch = self.dataarry[n];
        [self fetchdata:self.type date:ch.date];
        self.chooseChartData =ch;
    }
    
}
//没有选中柱形图时回调，当选中一个柱形图后，在空白处双击，就可以取消选择，此时会回调此方法
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView{
    NSLog(@"---chartValueNothingSelected---");
}
//放大图表时回调
- (void)chartScaled:(ChartViewBase * _Nonnull)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
    NSLog(@"---chartScaled---scaleX:%g, scaleY:%g", scaleX, scaleY);
}
//拖拽图表时回调
- (void)chartTranslated:(ChartViewBase * _Nonnull)chartView dX:(CGFloat)dX dY:(CGFloat)dY{
    NSLog(@"---chartTranslated---dX:%g, dY:%g,%g", dX, dY,chartView.viewPortHandler.transX);
    
    if (chartView.viewPortHandler.transX==-355) {
//        [self addData];
    }
    
}
-(void)createTableView
{
    
    UIView* line = [[UIView alloc]initWithFrame:CGRectMake(0, 341-5, self.view.width, 5)];
    line.backgroundColor = [UIColor wr_lineColor];
    [self.view addSubview:line];
    
    
    self.DataTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 341, self.view.width, self.view.height - 341) style:UITableViewStylePlain];
    self.DataTableView.delegate = self;
    self.DataTableView.dataSource = self;

    [self.view addSubview:self.DataTableView];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return _datadic.allKeys.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* arr = _datadic.allKeys;
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString* str1 = [obj1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString* str2 = [obj2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if ([str1 longLongValue]>[str2 longLongValue])
        {
            return NSOrderedAscending;
        }else
        {
            return NSOrderedDescending;
        }
        
    }];
    NSArray* trainarr = _datadic[arr[section]];
    return  trainarr.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0,self.view.width, 36.0)];
    customView.backgroundColor = [UIColor whiteColor];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero] ;
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor wr_titleTextColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:WRDetailFont];
    headerLabel.frame = CGRectMake(16.0, 16.0,0, 0);
    
    NSArray* arr = _datadic.allKeys;
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString* str1 = [obj1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString* str2 = [obj2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if ([str1 longLongValue]>[str2 longLongValue])
        {
            return NSOrderedAscending;
        }else
        {
            return NSOrderedDescending;
        }
        
    }];
    headerLabel.text = arr[section];

    [headerLabel sizeToFit];
    
    [customView addSubview:headerLabel];
    
    return customView;
}





-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [self.DataTableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIImageView* dayim = [UIImageView new];
        dayim.image  = [UIImage imageNamed:@"方案代表图标"];
        [dayim sizeToFit];
        dayim.y = 18;
        dayim.x  = 25;
        dayim.height= 16;
        dayim.width= 16;
        [cell.contentView addSubview:dayim];
        
        UILabel* title = [UILabel new];
        title.tag= 101;
        title.x = 12+dayim.right;
        title.y = 9;
        title.height= 13;
        title.font = [UIFont systemFontOfSize:WRDetailFont];
        title.textColor = [UIColor wr_titleTextColor];
        [cell.contentView addSubview:title];
        
        UILabel* time = [UILabel new];
        time.tag = 102;
        time.x = 12+dayim.right;
        time.y = 5+title.bottom;
        time.height= 13;
        time.font = [UIFont systemFontOfSize:WRDetailFont];
        time.textColor = [UIColor wr_titleTextColor];
        [cell.contentView addSubview:time];
        
//        UIImageView* timeim = [UIImageView new];
//        timeim.image  = [UIImage imageNamed:@"时间"];
//        [timeim sizeToFit];
//        timeim.centerY = time.centerY;
//        timeim.x  = time.right+10;
//        [cell.contentView addSubview:timeim];
        
        UILabel* count = [UILabel new];
        count.tag = 103;
        count.right = self.view.width - 15;
        count.y = 11;
        count.font = [UIFont systemFontOfSize:WRDetailFont];
        count.textColor = [UIColor wr_titleTextColor];
        [cell.contentView addSubview:count];


    }
    NSArray* arr = _datadic.allKeys;
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString* str1 = [obj1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSString* str2 = [obj2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        if ([str1 longLongValue]>[str2 longLongValue])
        {
            return NSOrderedAscending;
        }else
        {
            return NSOrderedDescending;
        }
        
    }];
    NSArray* trainarr = _datadic[arr[indexPath. section]];
    WRTrainData* data = trainarr[indexPath.row];
    UILabel* title = [cell.contentView viewWithTag:101];
    title.text = data.diseaseName;
    [title sizeToFit];
    
    UILabel* time = [cell.contentView viewWithTag:102];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    [formatter setTimeZone:sourceTimeZone];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"时长 HH:mm:ss"];
    long interview = [data.totalTime longLongValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interview];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    time.text = confromTimespStr;
    [time sizeToFit];
    
     UILabel* count = [cell.contentView viewWithTag:103];
    
    count.text = [NSString stringWithFormat:@"进度 %ld／%ld",data.currentStep,data.totalStep];
    if (data.currentStep == 0) {
        count.text = @"";
    }
    [count sizeToFit];
    count.right = self.view.width - 15;
    
    return cell;
}
- (void)fetchdata:(TrainType)type date:(NSString*)date;
{
    
    
    switch (type) {
        case trainDay:
        {
            [self.viewmodel fetchTrainListWithDay:date completion:^(NSError * _Nonnull error) {
                self.datadic = self.viewmodel.DataDic;
                self.dataarry = self.viewmodel.chartArry;
                [self.DataTableView  reloadData];
                [self updateData];
                [self loaddate:date];
            }];
        }
            break;
        case trainWeek:
        {
            [self.viewmodel fetchTrainListWithWeek:date completion:^(NSError * _Nonnull error) {
                self.datadic = self.viewmodel.DataDic;
                self.dataarry = self.viewmodel.chartArry;
                [self.DataTableView  reloadData];
                [self updateData];
                [self loaddate:date];
            }];
        }
            break;
        case trainMonth:
        {
            [self.viewmodel fetchTrainListWithMonth:date completion:^(NSError * _Nonnull error) {
                self.datadic = self.viewmodel.DataDic;
                self.dataarry = self.viewmodel.chartArry;
                [self.DataTableView  reloadData];
                [self updateData];
                [self loaddate:date];
            }];
        }
            break;
        case trainAll:
        {
            [self.viewmodel fetchTrainListcompletion:^(NSError * _Nonnull error)
                
            {
                self.datadic = self.viewmodel.DataDic;
                self.dataarry = self.viewmodel.chartArry;
                [self.DataTableView  reloadData];
                self.chooseChartData = self.dataarry[0];
                [self loaddate:date];
            }];
        }
            break;
            
            
        default:
            break;
    }
    
}
-(void)loaddate:(NSString*)date
{
//    self.date.text = date;
    WRTrainChartData* ch;
    
    if (self.dataarry.count>0&&self.n<self.dataarry.count) {
       ch  = self.dataarry[self.n];
    }
    self.chooseChartData =ch;
    [self.dataView removeFromSuperview];
    if (self.type == trainDay) {
    UIView* chartdate =[self CreateDayChartView];
        chartdate.y = self.sege.bottom;
        self.dataView=chartdate;
        [self.view addSubview:chartdate];
    }
    else
    {
       UIView* chartdate = [self CreateWeekChartView];
        chartdate.y = self.sege.bottom;
        self.dataView=chartdate;
        [self.view addSubview:chartdate];
    }
    
}
- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    int i = value;
    WRTrainChartData* ch = self.dataarry[(int)value % self.dataarry.count];
//    NSString*contentLabel ;
    
     if(self.type == trainWeek)
    {
        NSArray * arr =[ch.xVlue componentsSeparatedByString:@"-" ];
        if (arr.count==4) {
            ch.xVlue = [NSString stringWithFormat:@"%@/%@-%@/%@",arr[0],arr[1],arr[2],arr[3]];
        }
        
    }
    else if(self.type == trainMonth)
    {
        NSArray * arr =[ch.date componentsSeparatedByString:@"-" ];
        if (arr.count==2) {
            ch.xVlue = [NSString stringWithFormat:@"%@/%@",arr[0],arr[1]];
        }
        
    }
    else if (self.type == trainDay)
    {
        [ch.xVlue stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        
    }
    
    
    return [NSString stringWithFormat:@"%@",ch.xVlue];
    
    
    
}
//-(IBAction)onClickedShareButton:(id)sender {
//    NSString *title = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"专业运动治疗", nil), self.disease.diseaseName];
//    NSString *url = [NSString stringWithFormat:@"%@/program/program.html?userId=%@&id=%@",[ShareData data].shareIP,[WRUserInfo selfInfo].userId,self.rehab.indexId];
//    NSString *detail = NSLocalizedString(@"快来试试专业的运动处方,疼痛缓解治疗您的病痛", nil);
//    [UMengUtils shareWebWithTitle:title detail:detail url:url image:[UIImage imageNamed:@"well_logo"] viewController:self];
//    [UMengUtils careForRehabShare:self.rehab.disease.diseaseName];
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
