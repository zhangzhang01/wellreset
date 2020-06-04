//
//  secondQuesTableViewCell.h
//  rehab
//
//  Created by matech on 2019/11/18.
//  Copyright © 2019 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BarChartsHelper.h"
#import "statusView.h"
NS_ASSUME_NONNULL_BEGIN

@interface secondQuesTableViewCell : UITableViewCell<ChartViewDelegate,IChartAxisValueFormatter>
@property(nonatomic,retain)UIView *mainView;
@property(nonatomic,retain)BarChartsHelper *helperView;
@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)statusView *views;
@property (nonatomic, retain) BarChartView *ChartView2;
@property (nonatomic, retain) LineChartView *lineView;
@property (nonatomic, retain) NSMutableArray *xVals3;
@property (nonatomic, retain) NSMutableArray *lineX3;
@property (nonatomic, weak) CombinedChartView *combineChartView1;
-(void)setDataWithDataWithODIarr:(NSMutableArray *)odiArr withODIarr:(NSMutableArray *)odiArr2 withchangeArr:(NSMutableArray *)changeArr;


@end

NS_ASSUME_NONNULL_END
