//
//  fourTableViewCell.h
//  rehab
//
//  Created by matech on 2019/12/16.
//  Copyright © 2019 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarChartsHelper.h"
#import "statusView.h"
NS_ASSUME_NONNULL_BEGIN

@interface fourTableViewCell : UITableViewCell<ChartViewDelegate,IChartAxisValueFormatter>
@property(nonatomic,retain)UIView *mainView;
@property(nonatomic,retain)BarChartsHelper *helperView;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)statusView *views;
@property (nonatomic, retain) BarChartView *ChartView2;
@property (nonatomic, retain) LineChartView *lineView;
@property (nonatomic, retain) NSMutableArray *xVals3;
@property (nonatomic, retain) NSMutableArray *lineX3;
@property (nonatomic, weak) CombinedChartView *combineChartView1;


-(void)setDataWithDataWithJOAarr:(NSMutableArray *)joaArr withODIarr:(NSMutableArray *)odiArr withchangeArr:(NSMutableArray *)changeArr;
@end

NS_ASSUME_NONNULL_END
