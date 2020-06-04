//
//  BarChartsHeloper.m
//  sanbanhuiHelper
//
//  Created by WorkMac on 2017/4/4.
//  Copyright © 2017年 BeijingKaiFengData. All rights reserved.
//

#import "BarChartsHelper.h"

@interface BarChartsHelper()<ChartViewDelegate,IChartAxisValueFormatter>
{
    
}
@property (nonatomic, weak) BarChartView *ChartView2;
@property (nonatomic, weak) CombinedChartView *combarview;
@property (nonatomic, weak) LineChartView *lineView;
@property (nonatomic, retain) NSMutableArray *xVals3;
@property (nonatomic, retain) NSMutableArray *lineX3;
@property (nonatomic, retain) NSMutableArray *leftXia;
@end
@implementation BarChartsHelper
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpAllView3];
    }
    return self;
}
//单柱
- (void)setBarChart:(BarChartView *)barChartView xValues:(NSArray *)xValues yValues:(NSArray *)yValues barTitle:(NSString *)bar
{
    
    //X轴上面需要显示的数据
      NSMutableArray *xVals = [[NSMutableArray alloc] init];
      for (int i = 0; i < xValues.count; i++) {
      [xVals addObject:[NSString stringWithFormat:@"%d周", i+1]];
          self.xVals3 = xVals;
      }
    
    

    
        barChartView.noDataText = @"暂无数据";//没有数据时的文字提示
        barChartView.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
        barChartView.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
//        barChartView.userInteractionEnabled = NO;
        barChartView.scaleYEnabled = NO;//取消Y轴缩放
        barChartView.scaleXEnabled = NO;
        barChartView.doubleTapToZoomEnabled = NO;//取消双击缩放
        barChartView.dragEnabled = YES;//启用拖拽图表
        barChartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
        barChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    self.ChartView2 = barChartView;
        ChartXAxis *xAxis = barChartView.xAxis;
        xAxis.valueFormatter = self;
        xAxis.axisLineWidth = 1;//设置X轴线宽
        xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled = NO;//不绘制网格线
        //    xAxis.forceLabelsEnabled = YES;
        xAxis.labelTextColor = [UIColor blackColor];//label文字颜色
        xAxis.labelFont = [UIFont systemFontOfSize:9];
//        xAxis.labelCount = 7;
        ChartYAxis *leftAxis = barChartView.leftAxis;//获取左边Y轴
        leftAxis.forceLabelsEnabled = NO;//不强制绘制制定数量的label
        leftAxis.inverted = NO;//是否将Y轴进行上下翻转
        leftAxis.axisLineWidth = 0.5;//Y轴线宽
        leftAxis.forceLabelsEnabled = YES;
        leftAxis.axisLineColor = COLOR_grayColor;//Y轴颜色
        leftAxis.axisMinimum = 0;
        leftAxis.axisMaximum = 100;
        leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
        leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
        leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
        
        barChartView.rightAxis.enabled = NO;
        
//        ChartLimitLine *limitLine = [[ChartLimitLine alloc] initWithLimit:80 label:@"限制线"];
//        limitLine.lineWidth = 2;
//        limitLine.lineColor = [UIColor greenColor];
//        limitLine.lineDashLengths = @[@5.0f, @5.0f];//虚线样式
//        limitLine.labelPosition = ChartLimitLabelPositionTopRight;//位置
//        [leftAxis addLimitLine:limitLine];//添加到Y轴上
        leftAxis.drawLimitLinesBehindDataEnabled = YES;//设置限制线绘制在柱形图的后面
        
        barChartView.legend.enabled = NO;//不显示图例说明
        //    barChartView.descriptionText = @"";//不显示，就设为空字符串即可
        BarChartData *data = [self generateBarChartData:xValues title:bar barColor:COLOR(112, 198, 250, 1)];
        
        //为柱形图提供数据
        barChartView.data = data;
    if (xValues.count<7) {
             xAxis.labelCount =xValues.count;
       }else{
           xAxis.labelCount = 7;
       }
        [barChartView setVisibleXRangeMaximum:7];
        [barChartView animateWithYAxisDuration:1.0f];
    
    
    
    
    
}
- (BarChartData *)generateBarChartData:(NSArray *)yValues title:(NSString *)title barColor:(UIColor *)barColor
{
    ////////
     self.xVals3 = [[NSMutableArray alloc] init];
    
  self.leftXia = [[NSMutableArray alloc] init];
   NSInteger xVals_count = yValues.count;//X轴上要显示多少条数据
    //X轴上面需要显示的数据
    NSMutableArray *xVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {
        [xVals addObject:[NSString stringWithFormat:@"第%d周", i+1]];

        self.xVals3 = xVals;
    }
     NSArray *titleARR = [NSArray arrayWithObjects:@"-10",@"0",@"20",@"40",@"60",@"80",@"100", nil];
    self.leftXia =[titleARR mutableCopy];
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (int i = 0; i < xVals_count; i++) {

        double val = [yValues[i]doubleValue];
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:val];

        [yVals addObject:entry];
    }


    //对应Y轴上面需要显示的数据
//    NSMutableArray *yValsTwo = [[NSMutableArray alloc] init];
//    for (int i = 0; i < xVals_count; i++) {
//
//        double val = 29+2*i;
//        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:val];
//
//        [yValsTwo addObject:entry];
//    }
    //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
    BarChartDataSet *set1 = [[BarChartDataSet alloc] initWithEntries:yVals label:nil];
    set1.barBorderWidth =0;//边学宽
    set1.drawValuesEnabled = YES;//是否在柱形图上面显示数值
    set1.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
    [set1 setColors:@[COLOR(112, 198, 250, 1)]];//设置柱形图颜色
    //    [set1 setColors:ChartColorTemplates.material];

    //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
   
//    BarChartDataSet *set2 = [[BarChartDataSet alloc]initWithEntries:yValsTwo label:nil];
//    set2.barBorderWidth =0;//边学宽
//    set2.drawValuesEnabled = YES;//是否在柱形图上面显示数值
//    set2.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
//    [set2 setColors:@[[UIColor colorWithHexString:@"#f5c383"]]];
    //将BarChartDataSet对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
//    [dataSets addObject:set2];
    //创建BarChartData对象, 此对象就是barChartView需要最终数据对象
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    //设置宽度   柱形之间的间隙占整个柱形(柱形+间隙)的比例
    [data setBarWidth:0.4];
    [data groupBarsFromX: -0.5 groupSpace: 0.2 barSpace: 0];

    [data setValueFont:[UIFont systemFontOfSize:9]];//文字字体
    [data setValueTextColor:kBlue];//文字颜色
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式  小数点形式
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

        [formatter setPositiveFormat:@"#0.0"];
    ChartDefaultValueFormatter  *forma =
    [[ChartDefaultValueFormatter alloc] initWithFormatter:formatter]
    ;
    [data setValueFormatter:forma];
    
    return data;
}
//x标题
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    //    NSLog(@"%@",)
    if (axis == self.ChartView2.xAxis) {
       return  self.xVals3[(int)value];
    }if (axis == self.combarview.leftAxis) {
        NSArray *titleArr = [NSArray arrayWithObjects:@"-10",@"0",@"20",@"40",@"60",@"80",@"100", nil];
        return  [NSString stringWithFormat:@"10"];
    }else{
        
        return @"";
    }
    
}
//单柱和折线组合
- (void)setBarChart:(CombinedChartView *)combineChart lineValues:(NSArray *)lineValues xValues:(NSArray *)xValues yValues:(NSArray *)yValues lineTitle:(NSString *)lineTitle barTitle:(NSString *)barTitle
{
//    combineChart.descriptionText = @"";
         combineChart.pinchZoomEnabled = NO;
        combineChart.marker = [[ChartMarkerView alloc] init];
        combineChart.drawOrder = @[@0,@0,@2];//设置绘制顺序CombinedChartDrawOrderBar,CombinedChartDrawOrderLine
        combineChart.doubleTapToZoomEnabled = NO;//取消双击放大
        combineChart.scaleYEnabled = NO;
        combineChart.scaleXEnabled = NO;
        combineChart.dragEnabled = YES;//启用拖拽图表
        combineChart.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
        combineChart.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        combineChart.drawValueAboveBarEnabled = YES;
        combineChart.highlightPerTapEnabled = NO;//取消单击高亮显示
        combineChart.highlightPerDragEnabled = NO;
        combineChart.drawGridBackgroundEnabled = YES;
        combineChart.gridBackgroundColor = [UIColor whiteColor];
        combineChart.drawBordersEnabled = NO;
//        combineChart.userInteractionEnabled = YES;
        combineChart.rightAxis.enabled = NO;
    self.combarview = combineChart;
        /* 设置 X 轴显示的值的属性 */
        ChartXAxis *xAxis = combineChart.xAxis;
        xAxis.labelPosition = XAxisLabelPositionBottom; // 显示位置
        xAxis.drawGridLinesEnabled = NO; // 网格绘制
        xAxis.axisLineColor = [UIColor lightGrayColor]; // X 轴颜色
        xAxis.axisLineWidth = 0.5f; // X 轴线宽
        xAxis.labelFont = [UIFont systemFontOfSize:10]; // 字号
        xAxis.labelTextColor = [UIColor lightGrayColor]; // 颜色
        xAxis.labelRotationAngle = 0; // 文字倾斜角度
    
    
    
    
   
        /* 设置左侧 Y 轴显示的值的属性 */
        ChartYAxis *leftAxis = combineChart.leftAxis;
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart; // 显示位置
        leftAxis.drawGridLinesEnabled = YES; // 网格绘制
        leftAxis.gridColor = [UIColor lightGrayColor]; // 网格颜色
        leftAxis.gridLineWidth = 0.5f; // 网格线宽
        leftAxis.drawAxisLineEnabled = YES; // 是否显示轴线
        leftAxis.labelFont = [UIFont systemFontOfSize:10]; // 字号
        leftAxis.labelTextColor = [UIColor lightGrayColor]; // 颜色
        leftAxis.axisMinimum = -10; // 最小值
        leftAxis.axisMaximum = 100; // 最大值（不设置会根据数据自动设置）
        leftAxis.axisLineColor = COLOR_grayColor;//Y轴颜色
        leftAxis.axisLineWidth = 0.5;
        leftAxis.gridAntialiasEnabled = NO;//开启抗锯齿;
        leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
        leftAxis.drawZeroLineEnabled = NO;
        leftAxis.zeroLineWidth = 0.5;
//        leftAxis.valueFormatter = self;
       leftAxis.forceLabelsEnabled = YES;
        [leftAxis setLabelCount:8 force:NO]; // Y 轴段数（会自动分成对应段数）
//         leftAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc]init];
        leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
    
    
    
    
//          let formatter = NumberFormatter()  //自定义格式
//          formatter.positiveSuffix = "%"  //数字后缀
//          chartView.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)
    
        //设置图例
        ChartLegend *legend = combineChart.legend;
        legend.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
        legend.verticalAlignment = ChartLegendVerticalAlignmentBottom;
        legend.orientation = ChartLegendOrientationHorizontal;
        legend.drawInside = YES;
        legend.direction = ChartLegendDirectionLeftToRight;
        legend.form = ChartLegendFormSquare;
        legend.formSize = 10;
        legend.font = [UIFont systemFontOfSize:10];
        legend.textColor = kBlue;
        legend.xOffset = -15;
        
        CombinedChartData *data = [[CombinedChartData alloc] init];
        data.barData = [self generateBarChartData:xValues title:barTitle barColor:kBlue];
        data.lineData = [self generateLineData:lineValues lineTitle:lineTitle lineColor:[UIColor redColor]];
        
        
        combineChart.data = data;
    if (xValues.count<7) {
          xAxis.labelCount =xValues.count;
    }else{
        xAxis.labelCount = 7;
    }
          
         [combineChart setVisibleXRangeMaximum:7];
        xAxis.axisMinimum = data.xMin - 0.7f;
        xAxis.axisMaximum = data.xMax + 0.7f;
        xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:self.xVals3];
//        leftAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:self.leftXia];
        combineChart.extraBottomOffset = 30;
        combineChart.extraTopOffset = 30;
        [combineChart animateWithYAxisDuration:1.0];
}

//双柱和折线组合
- (void)setCombineBarChart:(CombinedChartView *)combineChart xValues:(NSArray *)xValues lineValues:(NSArray *)lineValues bar1Values:(NSArray *)bar1Values bar2Values:(NSArray *)bar2Values lineTitle:(NSString *)lineTitle bar1Title:(NSString *)bar1Title bar2Title:(NSString *)bar2Title
{
//    combineChart.descriptionText = @"";
    combineChart.pinchZoomEnabled = NO;
    combineChart.marker = [[ChartMarkerView alloc] init];
    combineChart.drawOrder = @[@0,@0,@2];//CombinedChartDrawOrderBar,CombinedChartDrawOrderLine
    combineChart.doubleTapToZoomEnabled = NO;//取消双击放大
    combineChart.scaleYEnabled = NO;
    combineChart.dragEnabled = YES;//启用拖拽图表
    combineChart.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
    combineChart.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
    combineChart.drawValueAboveBarEnabled = YES;
    combineChart.highlightPerTapEnabled = NO;//取消单击高亮显示
    combineChart.highlightPerDragEnabled = NO;
    combineChart.drawGridBackgroundEnabled = YES;
    combineChart.gridBackgroundColor = [UIColor whiteColor];
    combineChart.drawBordersEnabled = NO;//添加边框
    combineChart.userInteractionEnabled = NO;
    
    ChartXAxis *xAxis = combineChart.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.drawGridLinesEnabled = NO;
    xAxis.labelFont = [UIFont systemFontOfSize:10];
    xAxis.labelCount = xValues.count;
    xAxis.labelRotationAngle = -40;
    xAxis.yOffset = 10;
    xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xValues];
    xAxis.drawAxisLineEnabled = YES;
    //左侧Y轴设置
    ChartYAxis *leftAxis = combineChart.leftAxis;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.axisMinimum = 0.0f;
    leftAxis.drawGridLinesEnabled = YES;
    
//    float yMin = [[bar2Values valueForKeyPath:@"@min.floatValue"] floatValue];
//    float yMax = [[bar1Values valueForKeyPath:@"@max.floatValue"] floatValue];
//    if (yMin<0) {
//        yMin = yMin*1.3;
//    }else
//        yMin = yMin*0.8;
//    
//    if (yMax>=0) {
//        yMax = yMax*1.3;
//    }else
//        yMax = 0;
//    leftAxis.axisMinimum = yMin;
//    leftAxis.axisMaximum = yMax;

    //右侧Y轴
    ChartYAxis *rightAxis = combineChart.rightAxis;
    rightAxis.labelPosition = YAxisLabelPositionOutsideChart;
    rightAxis.drawGridLinesEnabled = NO;
    float y1Min = [[lineValues valueForKeyPath:@"@min.floatValue"] floatValue];
    float y1Max = [[lineValues valueForKeyPath:@"@max.floatValue"] floatValue];
    if (y1Min<0) {
        y1Min = y1Min*1.3;
    }else
        y1Min = 0;
    
    if (y1Max>=0) {
        y1Max = y1Max*1.3;
    }else
        y1Max = 0;
    
    rightAxis.axisMinimum = y1Min;
    rightAxis.axisMaximum = y1Max;
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式
    [numFormatter setNumberStyle:NSNumberFormatterPercentStyle];
    [numFormatter setPositiveFormat:@"#%/100"];
    
    ChartDefaultAxisValueFormatter *formatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:numFormatter];
    rightAxis.valueFormatter = formatter;
    
    //设置图例
    ChartLegend *legend = combineChart.legend;
    legend.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    legend.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    legend.orientation = ChartLegendOrientationHorizontal;
    legend.drawInside = YES;
    legend.direction = ChartLegendDirectionLeftToRight;
    legend.form = ChartLegendFormSquare;
    legend.formSize = 10;
    legend.font = [UIFont systemFontOfSize:10];
    legend.textColor = [UIColor colorWithRGB:0x595959];
//    legend.xOffset = -15;
    
    CombinedChartData *data = [[CombinedChartData alloc] init];
    data.lineData = [self generateLineData:lineValues lineTitle:lineTitle lineColor:[UIColor colorWithRGB:0xffc12d]];
    data.barData = [self generateCombineBarData:bar1Values bar2Values:bar2Values title1:bar1Title title2:bar2Title];
    combineChart.data = data;
    
    
    
    xAxis.axisMinimum = data.xMin - 0.7f;
    xAxis.axisMaximum = data.xMax + 0.7f;
    combineChart.extraBottomOffset = 50;
    combineChart.extraTopOffset = 30;
    [combineChart animateWithYAxisDuration:1.0];
}
//生成线的数据
- (LineChartData *)generateLineData:(NSArray *)lineValues lineTitle:(NSString *)lineTitle lineColor:(UIColor *)color
{
    
    
    NSMutableArray *entries = [NSMutableArray array];
    for (int i = 0; i < lineValues.count; i++) {
        
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[lineValues[i] floatValue]];
        [entries addObject:entry];
    }
    
    LineChartDataSet *dataSet = [[LineChartDataSet alloc]initWithEntries:entries label:lineTitle];
    dataSet.colors = @[[UIColor redColor]]; // 线的颜色
    dataSet.lineWidth = 0.5f; // 线宽
    dataSet.circleRadius = 2.5f; // 圆点外圆半径
    dataSet.circleHoleRadius = 1.5f; // 圆点内圆半径
    dataSet.circleColors = @[[UIColor redColor]];
    dataSet.circleHoleColor = [UIColor redColor]; // 圆点内圆颜色
    dataSet.axisDependency = AxisDependencyLeft; // 根据右边数据显示
    dataSet.drawValuesEnabled = YES; // 是否显示数据
    dataSet.mode = LineChartModeLinear; // 折线图类型
    dataSet.valueTextColor = [UIColor redColor];
    dataSet.drawFilledEnabled = NO; // 是否显示折线图阴影
//    NSArray *shadowColors = @[(id)[[UIColor orangeColor] colorWithAlphaComponent:0].CGColor, (id)[[UIColor orangeColor] colorWithAlphaComponent:0.7].CGColor];
//    CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)shadowColors, nil);
//    dataSet.fill = [ChartFill fillWithLinearGradient:gradient angle:90.0f]; // 阴影渐变效果
//    dataSet.fillAlpha = 1.0f; // 阴影透明度
    LineChartData *lineData = [[LineChartData alloc] initWithDataSet:dataSet];
    
    return lineData;
    
    
//    NSMutableArray *entries = [NSMutableArray array];
//    for (int i = 0; i < lineValues.count; i++) {
//        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[lineValues[i] floatValue]];
//        [entries addObject:entry];
//    }
//
////    LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithValues:entries label:lineTitle];
//    LineChartDataSet *dataSet =[[LineChartDataSet alloc]initWithEntries:entries label:lineTitle];
//    dataSet.colors = @[[UIColor redColor]];
//    dataSet.lineWidth = 1.5f;
//    dataSet.circleColors = @[[UIColor redColor]];
//    dataSet.circleHoleColor = [UIColor redColor];
//    dataSet.circleRadius = 3.0;
//    dataSet.drawCirclesEnabled = YES;
//    dataSet.drawCircleHoleEnabled = YES;
//    dataSet.axisDependency = AxisDependencyRight;
//    dataSet.drawValuesEnabled = YES;//不绘制线的数据
//    dataSet.valueTextColor = [UIColor redColor];
//
//    LineChartData *lineData = [[LineChartData alloc] initWithDataSet:dataSet];
//    [lineData setValueFont:[UIFont systemFontOfSize:10]];
//    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
//    //自定义数据显示格式
//    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    [numFormatter setPositiveFormat:@"#0.00"];
//    ChartDefaultValueFormatter *formatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:numFormatter];
//    [lineData setValueFormatter:formatter];
//    return lineData;
}
//生成复杂的组合柱图的数据
- (BarChartData *)generateCombineBarData:(NSArray *)bar1Values bar2Values:(NSArray *)bar2Values title1:(NSString *)bar1Title title2:(NSString *)bar2Title
{
    NSMutableArray *bar1Entries = [NSMutableArray array];
    NSMutableArray *bar2Entries = [NSMutableArray array];
    for (int i=0; i<bar1Values.count; i++) {
        BarChartDataEntry *barEntry = [[BarChartDataEntry alloc] initWithX:i y:[bar1Values[i] floatValue]];
        [bar1Entries addObject:barEntry];
    }
    for (int i=0; i<bar2Values.count; i++) {
        BarChartDataEntry *barEntry = [[BarChartDataEntry alloc] initWithX:i y:[bar2Values[i] floatValue]];
        [bar2Entries addObject:barEntry];
    }
    
    BarChartDataSet *dataSet1 = [[BarChartDataSet alloc]  initWithEntries:bar1Entries label:bar1Title];
    
    dataSet1.colors = @[[UIColor colorWithRGB:0xc0b8f2]];
    dataSet1.axisDependency = AxisDependencyLeft;
    dataSet1.drawValuesEnabled = YES;
    
    BarChartDataSet *dataSet2 = [[BarChartDataSet alloc]  initWithEntries:bar2Entries label:bar2Title];
    dataSet2.colors = @[[UIColor colorWithRGB:0xa09be7]];
    dataSet2.axisDependency = AxisDependencyLeft;
    dataSet2.drawValuesEnabled = NO;
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:@[dataSet1,dataSet2]];
    [data setValueFont:[UIFont systemFontOfSize:10]];
    [data setValueTextColor:[UIColor colorWithRGB:0x838383]];
    data.barWidth = 0.4f;
    
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numFormatter setPositiveFormat:@"#0.00"];
    ChartDefaultValueFormatter *formatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:numFormatter];
    [data setValueFormatter:formatter];
    return data;
}
-(void)setUpAllView3{
    self.backgroundColor = [UIColor redColor];
           self.xVals3 = [[NSMutableArray alloc] init];
    
           BarChartView *barChartView = [[BarChartView alloc] init];
           barChartView.delegate = self;
            self.ChartView2 = barChartView;
            barChartView.frame = CGRectMake(30, 0, ScreenW-60, 250);
           [self addSubview:barChartView];


                
               
                barChartView.backgroundColor = [UIColor clearColor];
                barChartView.legend.enabled = NO;//不显示图例说明
                barChartView.noDataText = @"暂无数据";//没有数据时的文字提示
                barChartView.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
                barChartView.drawBarShadowEnabled = NO;//是否绘制柱形的阴影背景
                barChartView.scaleYEnabled = NO;//取消Y轴缩放
                barChartView.scaleXEnabled = YES;
                barChartView.rightAxis.enabled = NO;
                barChartView.doubleTapToZoomEnabled = NO;//取消双击缩放
                barChartView.dragEnabled = YES;//启用拖拽图表
                barChartView.dragDecelerationEnabled = YES;//拖拽后是否有惯性效果
                barChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
                
                ChartXAxis *xAxis = barChartView.xAxis;
                xAxis.valueFormatter = self;
                xAxis.axisLineWidth = 1;//设置X轴线宽
                xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
                xAxis.drawGridLinesEnabled = NO;//不绘制网格线
                //    xAxis.forceLabelsEnabled = YES;
                xAxis.labelCount = 7;
                xAxis.labelTextColor = [UIColor blackColor];//label文字颜色
                xAxis.labelFont = [UIFont systemFontOfSize:9];

                ChartYAxis *leftAxis = barChartView.leftAxis;//获取左边Y轴
                leftAxis.forceLabelsEnabled = NO;//不强制绘制制定数量的label
                leftAxis.inverted = NO;//是否将Y轴进行上下翻转
                leftAxis.axisLineWidth = 1;//Y轴线宽
                leftAxis.forceLabelsEnabled = YES;
                leftAxis.axisLineColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//Y轴颜色
                leftAxis.axisMinimum = 0;
                leftAxis.axisMaximum = 100;
                leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
                leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
                leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
                
                
                
      
                leftAxis.drawLimitLinesBehindDataEnabled = YES;//设置限制线绘制在柱形图的后面
                
                
                //    barChartView.descriptionText = @"";//不显示，就设为空字符串即可
            
            
            //设置折线

               LineChartView *lineChartView = [[LineChartView alloc] init];
               lineChartView.frame = CGRectMake(30, 0, ScreenW-60, 250);
               self.lineView = lineChartView;
               [self addSubview:lineChartView];
               

               lineChartView.backgroundColor =  [UIColor clearColor];
               lineChartView.chartDescription.enabled = YES;
               lineChartView.delegate = self;
               
               lineChartView.scaleYEnabled = YES;         // 取消Y轴缩放
               lineChartView.scaleXEnabled = NO;          // 取消X轴缩放
               lineChartView.doubleTapToZoomEnabled = NO; // 取消双击缩放
               lineChartView.dragEnabled = NO;            // 关闭拖拽图标
               lineChartView.legend.enabled = NO;         // 关闭图例显示
               [lineChartView setExtraOffsetsWithLeft:30 top:20 right:24 bottom:0];
               
               // 绘制
               lineChartView.rightAxis.enabled = NO;          // 绘制右边轴
               lineChartView.leftAxis.enabled = NO;           // 绘制左边轴
               
               // Y轴设置
               ChartYAxis *leftAxis2 = lineChartView.leftAxis;
               [leftAxis2 setXOffset:15.0f];
               leftAxis2.forceLabelsEnabled = YES;  // 强制绘制指定数量的label
               leftAxis2.labelCount = 4;
               leftAxis2.gridColor = [UIColor clearColor]; // 网格线颜色
               leftAxis2.gridAntialiasEnabled = YES;       // 开启抗锯齿
               leftAxis2.inverted = NO;                    // 是否将Y轴进行上下翻转
               
               // X轴设置
               ChartXAxis *xAxis2 = lineChartView.xAxis;
               xAxis2.labelPosition = XAxisLabelPositionBottom; // 设置x轴数据在底部
               xAxis2.axisLineColor = [UIColor clearColor];     // X轴颜色
               xAxis2.granularityEnabled = YES;                 // 设置重复的值不显示
               xAxis2.gridColor = [UIColor clearColor];
               
               xAxis2.labelTextColor =  [UIColor clearColor];    // 文字颜色
        //       NSNumberFormatter *xAxisFormatter = [[NSNumberFormatter alloc] init];
        //       xAxisFormatter.positiveSuffix = @":00";
        //       xAxisFormatter.positivePrefix = @"|";
        //       xAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:xAxisFormatter];
               
               // 能够显示的数据数量
               lineChartView.maxVisibleCount = 100;
               
               // 展现动画
               [lineChartView animateWithYAxisDuration:1.0f];
            
            
               
               // 设置选中时气泡
        //       ChartMarkerView *marker = [[ChartMarkerView alloc] initWithColor:UIColorFromHEXA(0x00bcac,1.0) font:[UIFont systemFontOfSize:12.0]  textColor:UIColor.whiteColor insets:UIEdgeInsetsMake(3, 3, 16.0, 3) xAxisValueFormatter:_lineChartView.xAxis.valueFormatter];
        //       marker.chartView = _lineChartView;
        //       marker.minimumSize = CGSizeMake(30.0f, 15.0f);
        //       _lineChartView.marker = marker;
            
           
             [barChartView animateWithYAxisDuration:1.0f];
            
            
            
            
//               [self setdata];
    //            //为柱形图提供数据

               
    
}

-(void)setDataWithlineValues:(NSArray *)lineValues xValues:(NSArray *)xData yValues:(NSArray *)yData lineTitle:(NSString *)lineTitle barTitle:(NSString *)barTitle
{
    
    
//[self setLineChartWithXData:@[@"1",@"2",@"3",@"4"] yData:@[@"14",@"36",@"46",@"10"]];
    
    
    
    
//    NSArray *lineValues = [NSArray arrayWithObjects:@"46",@"29",@"30",@"70", nil];
        NSArray * xVals2 = [xData mutableCopy];
        NSInteger xVals_count = xVals2.count;//X轴上要显示多少条数据
        //X轴上面需要显示的数据
        NSMutableArray *xVals = [[NSMutableArray alloc] init];
        NSMutableArray *lineXvals = [[NSMutableArray alloc] init];
        for (int i = 0; i < yData.count; i++) {
           
            [xVals addObject:[NSString stringWithFormat:@"第%d周",  i+1]];
            [lineXvals addObject:[NSString stringWithFormat:@"%d",  i+1]];
            self.xVals3 = xVals;
            self.lineX3 = [lineXvals mutableCopy];
        }
//        NSArray * yValss = [NSArray arrayWithObjects:@"2",@"3.5",@"7",@"3.4", nil];
        NSArray * yValss = [xData mutableCopy];
        //对应Y轴上面需要显示的数据
        NSMutableArray *yVals = [[NSMutableArray alloc] init];
        for (int i = 0; i < xVals_count; i++) {

            double val = [yValss[i]doubleValue];
            BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:val];

            [yVals addObject:entry];
        }

    
    
    NSArray * yVals2 = [yData mutableCopy];
        //对应Y轴上面需要显示的数据
        NSMutableArray *yValsTwo = [[NSMutableArray alloc] init];
        for (int i = 0; i < xVals_count; i++) {

            double val = [yVals2[i]doubleValue];
            BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:val];

            [yValsTwo addObject:entry];
        }
        //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
        BarChartDataSet *set1 =[[BarChartDataSet alloc]initWithEntries:yVals label:nil];
        set1.barBorderWidth =0;//边学宽
        set1.drawValuesEnabled = YES;//是否在柱形图上面显示数值
        set1.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
        [set1 setColors:@[COLOR(112, 198, 250, 1)]];//设置柱形图颜色
        //    [set1 setColors:ChartColorTemplates.material];

        //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
        BarChartDataSet *set2 = [[BarChartDataSet alloc]initWithEntries:yValsTwo label:nil];
        
        set2.barBorderWidth =0;//边学宽
        set2.drawValuesEnabled = YES;//是否在柱形图上面显示数值
        set2.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
        [set2 setColors:@[COLOR(212, 238, 253, 1)]];
        //将BarChartDataSet对象放入数组中
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        [dataSets addObject:set2];
        
        
        //创建BarChartData对象, 此对象就是barChartView需要最终数据对象
        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
        //设置宽度   柱形之间的间隙占整个柱形(柱形+间隙)的比例
        [data setBarWidth:0.4];
        [data groupBarsFromX: -0.5 groupSpace: 0.2 barSpace: 0];

        [data setValueFont:[UIFont systemFontOfSize:9]];//文字字体
        [data setValueTextColor:[UIColor colorWithHexString:@"#999999"]];//文字颜色
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        //自定义数据显示格式  小数点形式
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

        //    [formatter setPositiveFormat:@"#0.0"];
        
        
    //    NSMutableArray *entries = [NSMutableArray array];
    //    for (int i = 0; i < lineValues.count; i++) {
    //        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[lineValues[i] floatValue]];
    //        [entries addObject:entry];
    //    }
    //
    //
    //    LineChartDataSet *dataSet =[[LineChartDataSet alloc]initWithEntries:entries label:@"line"];
    //    dataSet.colors = [UIColor redColor];
    //    dataSet.lineWidth = 1.5f;
    //    dataSet.circleColors = @[[UIColor colorWithRGB:0xffc12d]];
    //    dataSet.circleHoleColor = [UIColor colorWithRGB:0xffc12d];
    //    dataSet.circleRadius = 3.0;
    //    dataSet.drawCirclesEnabled = YES;
    //    dataSet.drawCircleHoleEnabled = YES;
    //    dataSet.axisDependency = AxisDependencyRight;
    //    dataSet.drawValuesEnabled = NO;//不绘制线的数据
    //
    //    LineChartData *lineData = [[LineChartData alloc] initWithDataSet:dataSet];
    //    [lineData setValueFont:[UIFont systemFontOfSize:10]];
    //
        
        
        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
        //自定义数据显示格式
        [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [numFormatter setPositiveFormat:@"#0.00"];
        
        
        
        ChartDefaultValueFormatter  *forma =
        [[ChartDefaultValueFormatter alloc] initWithFormatter:formatter]
        ;
        [data setValueFormatter:forma];
    
        _ChartView2.data = data;
        
 
    
    if (self.lineX3.count > 0)
           {
             //对应Y轴上面需要显示的数据
             NSMutableArray *yVals = [[NSMutableArray alloc] init];
          
             for (int i = 0; i < xVals_count; i++)
            {
                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:[self.lineX3[i] doubleValue] y:[yData[i] doubleValue]];
                [yVals addObject:entry];
              
                if (i == yData.count - 1)
                {
       //             self.contentLab.text = [NSString stringWithFormat:@"%g℃",entry.y];
                }
            }
          
            // 设置折线的样式

            LineChartDataSet *set1 = [[LineChartDataSet alloc]initWithEntries:yVals label:nil];
            set1.lineWidth = 1.0f;       // 折线宽度
            [set1 setColor:[UIColor redColor]];  // 折线颜色
            set1.drawValuesEnabled = NO; // 是否在拐点处显示数据
          
            // 折线拐点样式
            set1.drawCirclesEnabled = YES;      // 是否绘制拐点
            set1.drawFilledEnabled = NO;        // 是否填充颜色
            [set1 setCircleColor:[UIColor redColor]];   // 拐点 圆的颜色
            set1.circleRadius = 5.0f;
            set1.highlightColor = [UIColor clearColor];
          
            NSMutableArray *dataSets = [[NSMutableArray alloc] init];
            [dataSets addObject:set1];
          
            LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
            [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f]]; // 文字字体
            [data setValueTextColor:[UIColor clearColor]];                               // 文字颜色
          
           _lineView.data = data;

            [_lineView highlightValue: [[ChartHighlight alloc] initWithX:[self.lineX3[self.lineX3.count - 1] doubleValue] y:[yData[yData.count - 1] doubleValue] dataSetIndex:0 dataIndex:0]];
           }
       
}


@end
