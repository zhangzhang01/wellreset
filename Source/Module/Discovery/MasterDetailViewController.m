//
//  MasterDetailViewController.m
//  rehab
//
//  Created by yefangyang on 2016/10/10.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "MasterDetailViewController.h"
#import "CardView.h"
#import <YYKit/YYKit.h>
@interface MasterDetailViewController (){
        NSDate *_startDate;
}
@property (nonatomic, strong) WRExpert *master;

@end

@implementation MasterDetailViewController

-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForExpertDetail:_master.name duration:duration];
}

- (instancetype)initWithExpertInfo:(WRExpert *)master
{
    if (self = [super init]) {
        _master = master;
        _startDate = [NSDate date];
        self.navigationItem.title = NSLocalizedString(@"专家介绍", nil);
        
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.frame = self.view.bounds;
        [self.view addSubview:scrollView];
        
        CGFloat x, y, cx, cy, offset;
        offset = WRUIOffset;
        x = offset;
        y = offset;
        cx = (self.view.width - 3 * offset)/2;
        cx = MIN(cx, 217);
        
        UIImage *holder = [UIImage imageNamed:@"well_default_expert"];
        cy = holder.size.height * cx / holder.size.width;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        [imageView wr_setShadow];
        [imageView setImageWithUrlString:_master.picture holderImage:holder];
        [scrollView addSubview:imageView];
        
        x = imageView.right + offset;
        cx = self.view.width - offset - x;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        label.text = _master.name;
        label.font = [[UIFont wr_titleFont] fontWithBold];
        label.textColor = [UIColor blackColor];
        CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        label.frame = [Utility resizeRect:label.frame cx:-1 height:size.height];
        [scrollView addSubview:label];
        
        y = label.bottom + offset;
        UILabel *labelJob = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        labelJob.text = _master.jobTitle;
        labelJob.numberOfLines = 0;
        labelJob.font = [UIFont wr_tinyFont];
        labelJob.textColor = [UIColor darkGrayColor];
        size = [labelJob sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        labelJob.frame = [Utility resizeRect:labelJob.frame cx:-1 height:size.height];
        [scrollView addSubview:labelJob];
        
//        y = labelJob.bottom + offset;
//        UILabel *labelFieldTitle = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
//        labelFieldTitle.text = NSLocalizedString(@"领域", nil);
//        labelFieldTitle.font = [UIFont wr_smallFont];
//        labelFieldTitle.textColor = [UIColor wr_lightThemeColor];
//        [labelFieldTitle sizeToFit];
//        labelFieldTitle.frame = [Utility resizeRect:labelFieldTitle.frame cx:-1 height:labelFieldTitle.height];
//        [scrollView addSubview:labelFieldTitle];
        
        y = labelJob.bottom + offset;
        UILabel *labelField = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        labelField.numberOfLines = 0;
        labelField.text = _master.field;
        labelField.font = [UIFont wr_smallFont];
        labelField.textColor = [UIColor grayColor];
        size = [labelField sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        labelField.frame = [Utility resizeRect:labelField.frame cx:-1 height:size.height];
        [scrollView addSubview:labelField];
        
        y = labelField.bottom + offset;
        y = MAX(y, imageView.bottom - imageView.height/5);
        cx = self.view.width - 4 * offset;
        x = 2 * offset;
        cy = self.view .height - y;
        CardView *introduceView = [[CardView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        introduceView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8];
        [scrollView addSubview:introduceView];
        
        y = offset;
        x = offset;
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        labelName.numberOfLines = 0;
        labelName.text = NSLocalizedString(@"简介", nil);
        labelName.font = [UIFont wr_titleFont];
        labelName.textColor = [UIColor grayColor];
        size = [labelName sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        labelName.frame = [Utility resizeRect:labelName.frame cx:-1 height:size.height];
        [introduceView addSubview:labelName];
        
        y = labelName.bottom + offset;
        cx -= 2 * offset;
        UILabel *labelIntroduce = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
        labelIntroduce.numberOfLines = 0;
        labelIntroduce.text = _master.detail;
        labelIntroduce.font = [UIFont wr_smallFont];
        labelIntroduce.textColor = [UIColor grayColor];
        [labelIntroduce sizeToFit];
        labelIntroduce.frame = [Utility resizeRect:labelIntroduce.frame cx:-1 height:labelIntroduce.height];
        [introduceView addSubview:labelIntroduce];
        introduceView.frame = [Utility resizeRect:introduceView.frame cx:-1 height:labelIntroduce.bottom + offset];

        scrollView.contentSize = CGSizeMake(scrollView.width, introduceView.bottom + labelField.bottom);
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [WRNetworkService pwiki:@"专家介绍"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
