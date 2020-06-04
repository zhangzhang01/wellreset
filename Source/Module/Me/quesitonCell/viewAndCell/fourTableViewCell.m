//
//  fourTableViewCell.m
//  rehab
//
//  Created by matech on 2019/12/16.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "fourTableViewCell.h"

@implementation fourTableViewCell

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
    self.nameLabel.text = @"症状好转程度";
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    _views = [[statusView alloc]initWithFrame:CGRectMake(0, 60, WIDTH(self.mainView), 40)];
    _views.str = @"1";
    [_views setDataWith:@"1"];
    [self.contentView addSubview:_views];
    
    [self createlineAndChartView];
    
    

    
    
    
    
}
//柱状图和折线图
- (void)createlineAndChartView
{
    CombinedChartView *combine = [[CombinedChartView alloc] init];
    self.combineChartView1 = combine;
    self.combineChartView1.frame =  CGRectMake(30, 100, ScreenW-60, 250);
    [self addSubview:combine];
    
    
}
-(void)setDataWithDataWithJOAarr:(NSMutableArray *)joaArr withODIarr:(NSMutableArray *)odiArr withchangeArr:(NSMutableArray *)changeArr
{
    BarChartsHelper *helper = [[BarChartsHelper alloc] init];
       [helper setBarChart:self.combineChartView1 lineValues:changeArr xValues:joaArr yValues:changeArr lineTitle:@"" barTitle:@""];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
