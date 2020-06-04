//
//  LevelUpgradeController.m
//  rehab
//
//  Created by 何寻 on 2016/12/3.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "LevelUpgradeController.h"
#import <YYKit/YYKit.h>
@interface LevelUpgradeController ()

@end

@implementation LevelUpgradeController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
    
    self.title = NSLocalizedString(@"升级规则", nil);
    [self layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [WRNetworkService pwiki:@"升级规则"];
}


#pragma mark -
-(void)layout
{
    [self.scrollView removeAllSubviews];
    
    UIView *container = self.scrollView;
    
    CGFloat offset = WRUIOffset, x = 0, y = x + 20;
    
//    NSArray *detailArray = @[
//                             NSLocalizedString(@"每天使用app可以积分，连续使用越久积分越多；", nil),
//                             NSLocalizedString(@"康复方案开始锻炼，连续锻炼升级越快；", nil),
//                             NSLocalizedString(@"挑战自我可以积分；", nil),
//                             NSLocalizedString(@"阅读文章可以积分；", nil),
//                             NSLocalizedString(@"每天使用app可以积分，连续使用越久积分越多；", nil),
//                             NSLocalizedString(@"康复方案开始锻炼，连续锻炼升级越快；", nil),
//                             NSLocalizedString(@"挑战自我可以积分；", nil),
//                             NSLocalizedString(@"阅读文章可以积分；", nil),
//                             NSLocalizedString(@"每天使用app可以积分，连续使用越久积分越多；", nil),
//                             NSLocalizedString(@"康复方案开始锻炼，连续锻炼升级越快；", nil),
//                             NSLocalizedString(@"挑战自我可以积分；", nil),
//                             NSLocalizedString(@"阅读文章可以积分；", nil),
//                             NSLocalizedString(@"每天使用app可以积分，连续使用越久积分越多；", nil),
//                             NSLocalizedString(@"康复方案开始锻炼，连续锻炼升级越快；", nil),
//                             NSLocalizedString(@"挑战自我可以积分；", nil),
//                             NSLocalizedString(@"阅读文章可以积分；", nil),
//                             NSLocalizedString(@"每天使用app可以积分，连续使用越久积分越多；", nil),
//                             NSLocalizedString(@"康复方案开始锻炼，连续锻炼升级越快；", nil),
//                             NSLocalizedString(@"挑战自我可以积分；", nil),
//                             NSLocalizedString(@"阅读文章可以积分；", nil),            NSLocalizedString(@"每天使用app可以积分，连续使用越久积分越多；", nil),
//                             NSLocalizedString(@"康复方案开始锻炼，连续锻炼升级越快；", nil),
//                             NSLocalizedString(@"挑战自我可以积分；", nil),
//                             NSLocalizedString(@"阅读文章可以积分；", nil),
//                             NSLocalizedString(@"每天使用app可以积分，连续使用越久积分越多；", nil),
//                             NSLocalizedString(@"康复方案开始锻炼，连续锻炼升级越快；", nil),
//                             NSLocalizedString(@"挑战自我可以积分；", nil),
//                             NSLocalizedString(@"阅读文章可以积分；", nil),
//                             ];
    NSArray *detailArray = self.dataArray;

    
    UIView *panel = [self createNotesPanelWithTitle:NSLocalizedString(@"可以通过以下方式升级", nil) notes:detailArray maxWidth:container.frame.size.width];
    panel.top = y;
    [container addSubview:panel];
    y = panel.bottom + offset;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, y);
}

#pragma mark -
-(UIView*)createPointView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
    view.backgroundColor = [UIColor darkGrayColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.width/2;
    return view;
}

-(UIView*)createNotesPanelWithTitle:(NSString*)title notes:(NSArray<NSString*>*)notes maxWidth:(CGFloat)maxWidth
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, 0)];
    UILabel *label;
    
    CGFloat offset = WRUIOffset, x = offset, y = 0, cx = container.width - 2*x, cy;
    CGSize size;
    CGFloat pointYOffset = 3, pointXOffset = 5;
    
    BOOL iPad = [WRUIConfig IsHDApp];
    
    UIFont *subTitleFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_smallFont];
    UIFont *textFont = iPad ? [UIFont wr_titleFont] : [UIFont wr_smallFont];
    UIColor *subTitleColor = [UIColor blackColor];
    UIColor *textColor = [UIColor darkGrayColor];
    UIColor *lineColor = [UIColor lightGrayColor];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
    label.textColor = subTitleColor;
    label.text = title;
    label.font = subTitleFont;
    [label sizeToFit];
    label.frame = [Utility moveRect:label.frame x:x y:y];
    [container addSubview:label];
    y = label.bottom + offset;
    
    for(NSString *text in notes)
    {
        UIView *point = [self createPointView];
        [container addSubview:point];
        point.left = offset;
        point.top = y + pointYOffset;
        
        x = point.right + pointXOffset;
        label = [[UILabel alloc] init];
        label.textColor = textColor;
        label.text = text;
        label.font = textFont;
        label.numberOfLines = 0;
        size = [label sizeThatFits:CGSizeMake(container.width - x - offset, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y, size.width, size.height);
        [container addSubview:label];
        y = label.bottom + offset;
    }
    x = offset;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, container.width - 2*x, 1)];
    lineView.backgroundColor = lineColor;
    [container addSubview:lineView];
    y = lineView.bottom;
    container.height = y;
    
    return container;
}
@end
