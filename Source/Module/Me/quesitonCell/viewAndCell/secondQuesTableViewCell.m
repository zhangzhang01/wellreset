//
//  secondQuesTableViewCell.m
//  rehab
//
//  Created by matech on 2019/11/18.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "secondQuesTableViewCell.h"

@implementation secondQuesTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}
-(void)setUpAllView
{
    
    self.mainView = [UIView zj_viewWithBackColor:[UIColor whiteColor] supView:self.contentView constraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(360);
        
    }];
    self.mainView.layer.cornerRadius = 20.0;
    self.mainView.layer.masksToBounds= YES;
    
    self.nameLabel = [UILabel zj_labelWithFontSize:15 textColor:COLORBLUE superView:self.mainView constraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainView).offset(10);
        make.left.equalTo(self.mainView).offset(10);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    self.nameLabel.text = @"生活影响程度";
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    _views = [[statusView alloc]initWithFrame:CGRectMake(0, 60, WIDTH(self.mainView), 40)];
    _views.str = @"0";
    [_views setDataWith:@"0"];
    [self.contentView addSubview:_views];
    
    [self createChartView];
    
    

    
    
    
    
}
//柱状图
- (void)createChartView
{

    
    BarChartView *barChartView = [[BarChartView alloc] init];
    self.ChartView2 = barChartView;
    //    self.barChartView.delegate = self;//设置代理 可以设置X轴和Y轴的格式
    self.ChartView2.frame = CGRectMake(30, 100, ScreenW-60, 250);
    [self addSubview:self.ChartView2];
    
    
    
   
}
-(void)setDataWithDataWithODIarr:(NSMutableArray *)odiArr withODIarr:(NSMutableArray *)odiArr2 withchangeArr:(NSMutableArray *)changeArr
{
    BarChartsHelper *helper = [[BarChartsHelper alloc] init];
    [helper setBarChart:self.ChartView2 xValues:odiArr yValues:odiArr barTitle:@""];
    
//[self setLineChartWithXData:@[@"1",@"2",@"3",@"4"] yData:@[@"14",@"36",@"46",@"10"]];
    
    
    
    
//    NSArray *lineValues = [NSArray arrayWithObjects:@"46",@"29",@"30",@"70", nil];
//        NSArray * xVals2 = [xData mutableCopy];
//        NSInteger xVals_count = xVals2.count;//X轴上要显示多少条数据
//        //X轴上面需要显示的数据
//        NSMutableArray *xVals = [[NSMutableArray alloc] init];
//        NSMutableArray *lineXvals = [[NSMutableArray alloc] init];
//        for (int i = 0; i < yData.count; i++) {
//
//            [xVals addObject:[NSString stringWithFormat:@"第%d周",  i+1]];
//            [lineXvals addObject:[NSString stringWithFormat:@"%d",  i+1]];
//            self.xVals3 = xVals;
//            self.lineX3 = [lineXvals mutableCopy];
//        }
////        NSArray * yValss = [NSArray arrayWithObjects:@"2",@"3.5",@"7",@"3.4", nil];
//        NSArray * yValss = [xData mutableCopy];
//        //对应Y轴上面需要显示的数据
//        NSMutableArray *yVals = [[NSMutableArray alloc] init];
//        for (int i = 0; i < xVals_count; i++) {
//
//            double val = [yValss[i]doubleValue];
//            BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:val];
//
//            [yVals addObject:entry];
//        }
//
//
//
//    NSArray * yVals2 = [yData mutableCopy];
//        //对应Y轴上面需要显示的数据
//        NSMutableArray *yValsTwo = [[NSMutableArray alloc] init];
//        for (int i = 0; i < xVals_count; i++) {
//
//            double val = [yVals2[i]doubleValue];
//            BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:val];
//
//            [yValsTwo addObject:entry];
//        }
//        //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
//        BarChartDataSet *set1 =[[BarChartDataSet alloc]initWithEntries:yVals label:nil];
//        set1.barBorderWidth =0;//边学宽
//        set1.drawValuesEnabled = YES;//是否在柱形图上面显示数值
//        set1.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
//        [set1 setColors:@[COLOR(112, 198, 250, 1)]];//设置柱形图颜色
//        //    [set1 setColors:ChartColorTemplates.material];
//
//        //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
//        BarChartDataSet *set2 = [[BarChartDataSet alloc]initWithEntries:yValsTwo label:nil];
//
//        set2.barBorderWidth =0;//边学宽
//        set2.drawValuesEnabled = YES;//是否在柱形图上面显示数值
//        set2.highlightEnabled = YES;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
//        [set2 setColors:@[COLOR(212, 238, 253, 1)]];
//        //将BarChartDataSet对象放入数组中
//        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//        [dataSets addObject:set1];
//        [dataSets addObject:set2];
//
//
//        //创建BarChartData对象, 此对象就是barChartView需要最终数据对象
//        BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
//        //设置宽度   柱形之间的间隙占整个柱形(柱形+间隙)的比例
//        [data setBarWidth:0.4];
//        [data groupBarsFromX: -0.5 groupSpace: 0.2 barSpace: 0];
//
//        [data setValueFont:[UIFont systemFontOfSize:9]];//文字字体
//        [data setValueTextColor:[UIColor colorWithHexString:@"#999999"]];//文字颜色
//        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//        //自定义数据显示格式  小数点形式
//        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//
//        //    [formatter setPositiveFormat:@"#0.0"];
//
//
//    //    NSMutableArray *entries = [NSMutableArray array];
//    //    for (int i = 0; i < lineValues.count; i++) {
//    //        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:[lineValues[i] floatValue]];
//    //        [entries addObject:entry];
//    //    }
//    //
//    //
//    //    LineChartDataSet *dataSet =[[LineChartDataSet alloc]initWithEntries:entries label:@"line"];
//    //    dataSet.colors = [UIColor redColor];
//    //    dataSet.lineWidth = 1.5f;
//    //    dataSet.circleColors = @[[UIColor colorWithRGB:0xffc12d]];
//    //    dataSet.circleHoleColor = [UIColor colorWithRGB:0xffc12d];
//    //    dataSet.circleRadius = 3.0;
//    //    dataSet.drawCirclesEnabled = YES;
//    //    dataSet.drawCircleHoleEnabled = YES;
//    //    dataSet.axisDependency = AxisDependencyRight;
//    //    dataSet.drawValuesEnabled = NO;//不绘制线的数据
//    //
//    //    LineChartData *lineData = [[LineChartData alloc] initWithDataSet:dataSet];
//    //    [lineData setValueFont:[UIFont systemFontOfSize:10]];
//    //
//
//
//        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
//        //自定义数据显示格式
//        [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//        [numFormatter setPositiveFormat:@"#0.00"];
//
//
//
//        ChartDefaultValueFormatter  *forma =
//        [[ChartDefaultValueFormatter alloc] initWithFormatter:formatter]
//        ;
//        [data setValueFormatter:forma];
//
//        _ChartView2.data = data;
//
//
//
//    if (self.lineX3.count > 0)
//           {
//             //对应Y轴上面需要显示的数据
//             NSMutableArray *yVals = [[NSMutableArray alloc] init];
//
//             for (int i = 0; i < xVals_count; i++)
//            {
//                ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:[self.lineX3[i] doubleValue] y:[yData[i] doubleValue]];
//                [yVals addObject:entry];
//
//                if (i == yData.count - 1)
//                {
//       //             self.contentLab.text = [NSString stringWithFormat:@"%g℃",entry.y];
//                }
//            }
//
//            // 设置折线的样式
//
//            LineChartDataSet *set1 = [[LineChartDataSet alloc]initWithEntries:yVals label:nil];
//            set1.lineWidth = 1.0f;       // 折线宽度
//            [set1 setColor:[UIColor redColor]];  // 折线颜色
//            set1.drawValuesEnabled = NO; // 是否在拐点处显示数据
//
//            // 折线拐点样式
//            set1.drawCirclesEnabled = YES;      // 是否绘制拐点
//            set1.drawFilledEnabled = NO;        // 是否填充颜色
//            [set1 setCircleColor:[UIColor redColor]];   // 拐点 圆的颜色
//            set1.circleRadius = 5.0f;
//            set1.highlightColor = [UIColor clearColor];
//
//            NSMutableArray *dataSets = [[NSMutableArray alloc] init];
//            [dataSets addObject:set1];
//
//            LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
//            [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.0f]]; // 文字字体
//            [data setValueTextColor:[UIColor clearColor]];                               // 文字颜色
//
//           _lineView.data = data;
//
//            [_lineView highlightValue: [[ChartHighlight alloc] initWithX:[self.lineX3[self.lineX3.count - 1] doubleValue] y:[yData[yData.count - 1] doubleValue] dataSetIndex:0 dataIndex:0]];
//           }
       
}
//x标题
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    //    NSLog(@"%@",)
    return  self.xVals3[(int)value];
}




//-(void)setDataWithDataWithODIarr:(NSMutableArray *)odiArr withODIarr:(NSMutableArray *)odiArr withchangeArr:(NSMutableArray *)changeArr
//{
//      //             [self setLineChartWithXData:@[@"1",@"2",@"3",@"4"] yData:@[@"14",@"36",@"46",@"10"]];
//    [self setDataWithlineValues:@[@"1",@"2",@"3",@"4"] xValues:odiArr yValues:odiArr lineTitle:@"" barTitle:@""];
//}
#pragma mark 图表被缩放
-(void)chartScaled:(ChartViewBase *)chartView scaleX:(CGFloat)scaleX scaleY:(CGFloat)scaleY{
//    NSLog(@"图表被缩放");
     CGAffineTransform srcMatrix = chartView.viewPortHandler.touchMatrix;
     [self.ChartView2.viewPortHandler refreshWithNewMatrix:srcMatrix chart:self.ChartView2 invalidate:YES];
//     [self.barChartView.viewPortHandler refreshWithNewMatrix:srcMatrix chart:self.barChartView invalidate:YES];
}
-(void)chartViewDidEndPanning:(ChartViewBase *)chartView {

     CGAffineTransform srcMatrix = chartView.viewPortHandler.touchMatrix;
     [self.ChartView2.viewPortHandler refreshWithNewMatrix:srcMatrix chart:self.ChartView2 invalidate:YES];
//     [self.barChartView.viewPortHandler refreshWithNewMatrix:srcMatrix chart:self.barChartView invalidate:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
