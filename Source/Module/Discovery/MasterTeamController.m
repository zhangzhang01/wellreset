//
//  MasterTeamController.m
//  rehab
//
//  Created by yefangyang on 2016/10/10.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "MasterTeamController.h"
#import "MasterDetailViewController.h"
#import "ExpertViewModel.h"
#import "WRRefreshHeader.h"
#import "CardView.h"
#import <YYKit/YYKit.h>

@interface MasterTeamController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIImageView *leftArrowImageView, *rightArrowImageView;
@property (nonatomic, strong) UIScrollView *pageScrollView, *headScrollView;
@property (nonatomic, strong) ExpertViewModel *viewModel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic) NSUInteger currentExpertIndex;
@property (nonatomic, strong) WRExpert *master;
@property (nonatomic, strong) UIView *underline;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) UIImageView *selectedImageView;

@end

@implementation MasterTeamController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wr_lightGray];
    self.navigationItem.title = NSLocalizedString(@"专家介绍", nil);
    self.imageArray = [NSMutableArray array];
    CGFloat headH = 64;
    CGRect bounds = [Utility resizeRect:self.view.bounds cx:-1 height:(self.view.height - 64)];
    CGFloat y = 0;
    CGFloat cx = bounds.size.width;
    CGFloat cy = bounds.size.height - headH;
    
    UIScrollView *headScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, cx, headH)];
    headScrollView.backgroundColor = [UIColor whiteColor];
    headScrollView.pagingEnabled = NO;
    headScrollView.scrollEnabled = YES;
    headScrollView.delegate = self;
    headScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:headScrollView];
    _headScrollView = headScrollView;
    
    CGFloat x = 0;
    
    
    y = _headScrollView.bottom;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, cx, cy)];
    scrollView.pagingEnabled = NO;
    scrollView.scrollEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    _pageScrollView = scrollView;
    
    CGFloat offset = 15;
    y = -offset;
    x = scrollView.left - offset;
    cx = scrollView.width + 2*offset;
    cy = bounds.size.height - 2*y;
    
    [WRNetworkService pwiki:@"专家团队"];
    [self fetchExpertData];
}

#pragma mark - getter & setter
- (ExpertViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[ExpertViewModel alloc] init];
    }
    return _viewModel;
}

-(void)setCurrentExpertIndex:(NSUInteger)currentExpertIndex
{
    _currentExpertIndex = currentExpertIndex;
    
    self.leftArrowImageView.hidden = (currentExpertIndex == 0);
    self.rightArrowImageView.hidden = (currentExpertIndex == (self.viewModel.expertArray.count));
    
    [self.pageScrollView setContentOffset:CGPointMake(currentExpertIndex*self.pageScrollView.width, 0) animated:YES];
}

#pragma mark -
- (void)fetchExpertData
{
    __weak __typeof(self)weakself = self;
    [self.viewModel fetchExpertsWithCompletion:^(NSError *error) {
        [weakself.pageScrollView.mj_header endRefreshing];
        if (error) {
            [Utility retryAlertWithViewController:weakself.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
                [weakself fetchExpertData];
            }];
        } else {
            [weakself layout];
        }
    }];
    
    //    [self.viewModel fetchExpertListWithCompletion:^(NSError *error) {
    //        if (error) {
    //            [Utility retryAlertWithViewController:weakself.navigationController title:NSLocalizedString(@"获取必要信息失败", nil) completion:^{
    //                [weakself fetchExpertData];
    //                   }];
    //        } else {
    //            [weakself layout];
    //        }
    //             }];
}

- (void)layout
{
//    [self.pageScrollView removeAllSubviews];
    
    if (self.viewModel.expertArray.count == 0) {
        return;
    }
    
    [self setupHeadView];
    
    [self layoutWithMasterIndex:0];
    
}

//头像滚动
- (void)setupHeadView
{
    __weak __typeof(self) weakSelf = self;
    CGFloat imageWidth = 44;
    CGFloat x = WRUIOffset, y = WRUIOffset;
    UIImage *image = [UIImage imageNamed:@"well_default_expert"];
    for (int i = 0; i < self.viewModel.expertArray.count; i++) {
        WRExpert *expert = self.viewModel.expertArray[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageWidth, imageWidth)];
        imageView.layer.cornerRadius = imageWidth/2;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [self.imageArray addObject:imageView];
        [self.headScrollView addSubview:imageView];
        [imageView setImageWithUrlString:expert.headImage holderImage:image];
        x += imageWidth + 2 * WRUIOffset;
        [imageView bk_whenTapped:^{
            [weakSelf layoutWithMasterIndex:imageView.tag];
            //             移动下划线
            [UIView animateWithDuration:0.35 animations:^{
                self.underline.centerX = imageView.centerX;
            }];
        }];
    }
    self.headScrollView.contentSize = CGSizeMake(x, self.headScrollView.height);
    
    CGFloat lineH = 2;
    UIImageView *imageV = self.imageArray[0];
    UIView *underline = [[UIView alloc] initWithFrame:CGRectMake((imageWidth + WRUIOffset)/2 - imageWidth/4, self.headScrollView.height - lineH, imageWidth/2, lineH)];
    underline.centerX = imageV.centerX;
    [self.headScrollView addSubview:underline];
    underline.backgroundColor = [UIColor wr_themeColor];
    self.underline = underline;
}

- (void)layoutWithMasterIndex:(NSInteger)masterIndex
{
    __weak __typeof(self)weakself = self;
    WRExpert *master = self.viewModel.expertArray[masterIndex];
    _master = master;
    
    UIImageView *imgView = self.imageArray[masterIndex];
    [UIView animateWithDuration:0.35 animations:^{
        weakself.selectedImageView.transform = CGAffineTransformMakeScale(0.91, 0.91);
        weakself.selectedImageView = imgView;
        weakself.selectedImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }];
    UIScrollView *scrollView = _pageScrollView;
    [scrollView removeAllSubviews];
    CGFloat x, y, cx, cy, offset;
    offset = WRUIOffset;
    x = 0;
    y = 0;
    cx = (self.view.width - 3 * offset)/2;
    cx = MIN(cx, 217);
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(x, y, self.view.width, offset)];
    grayView.backgroundColor = [UIColor wr_lightGray];
    [scrollView addSubview:grayView];
    x = offset;
    y = 2 * offset;
    
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

//- (UIView *)createMasterViewWithFrame:(CGRect)frame expertInfo:(WRExpert*)expertInfo upModel:(BOOL)upModel
//{
//    BOOL biPad = [WRUIConfig IsHDApp];
//    UIImage *image = [UIImage imageNamed:@"well_default_expert"];
//    CGFloat imageWidth, inset;
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    inset = 6;
//    if (biPad) {
//        inset = 20;
//    }
//    imageWidth = view.width - 2 * inset + 4;
//    CGFloat cy = image.size.height*imageWidth/image.size.width;
//    CGFloat y = (view.height - cy)/2;
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(inset - 3, y, imageWidth, cy)];
//    imageView.contentMode = UIViewContentModeScaleToFill;
//    [view addSubview:imageView];
//    [imageView setImageWithUrlString:expertInfo.picture holderImage:image];
//
//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.text = expertInfo.name;
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.font = [[UIFont wr_titleFont] fontWithBold];
//    titleLabel.textColor = [UIColor blackColor];
//    [titleLabel sizeToFit];
//    [view addSubview:titleLabel];
//
//    CGFloat offset = WRUIOffset;
//    CGFloat cx = view.width - 2*offset;
//    UILabel *detailLabel = [[UILabel alloc] init];
//    detailLabel.text = expertInfo.jobTitle;
//    detailLabel.font = [UIFont wr_smallFont];
//    detailLabel.numberOfLines = 0;
//    detailLabel.textColor = [UIColor darkGrayColor];
//    detailLabel.textAlignment = NSTextAlignmentCenter;
//    CGSize size = [detailLabel sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
//    detailLabel.size = size;
//    [view addSubview:detailLabel];
//
//    CGFloat yOffset = 3;
//    if (upModel) {
//        detailLabel.frame = CGRectMake(offset, imageView.top - yOffset - detailLabel.height, view.width - 2*offset, detailLabel.height);
//        titleLabel.frame = CGRectMake(detailLabel.left, detailLabel.top - yOffset - titleLabel.height, view.width - 2*offset, titleLabel.height);
//    }
//    else
//    {
//        titleLabel.frame = CGRectMake(offset, imageView.bottom + yOffset, view.width - 2*offset, titleLabel.height);
//        detailLabel.frame = CGRectMake(titleLabel.left, titleLabel.bottom + yOffset, view.width - 2*offset, detailLabel.height);
//    }
//    return view;
//}




//- (UIView *)createLastViewWithFrame:(CGRect)frame
//{
//    BOOL biPad = [WRUIConfig IsHDApp];
//    UIImage *image = [UIImage imageNamed:@"well_default_expert"];
//    CGFloat inset, imageWidth;
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    inset = 6;
//    if (biPad) {
//        inset = 20;
//    }
//    imageWidth = view.width - 2 * inset + 4;
//    CGFloat cy = image.size.height*imageWidth/image.size.width;
//    CGFloat y = (view.height - cy)/2;
//    CGFloat x = WRUIOffset;
//    CGFloat cx = view.width - 2*x;
//
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
//    bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
//    [view addSubview:bgView];
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
//    label.text = NSLocalizedString(@"WELL健康：", nil);
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [[UIFont wr_titleFont] fontWithBold];
//    label.textColor = [UIColor blackColor];
//    [label sizeToFit];
//    label.frame = [Utility moveRect:label.frame x:(view.width - label.width)/2 y:-1];
//    [view addSubview:label];
//
//    UIFont *font;
//    font = [UIFont wr_textFont];
//    if (biPad) {
//        font = [UIFont wr_smallTitleFont];
//    }
//    y = label.bottom + x;
//    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
//    label.font = font;
//    label.textColor = [UIColor grayColor];
//    label.numberOfLines = 0;
//    label.textAlignment = NSTextAlignmentCenter;
//    NSString *text = NSLocalizedString(@"权威康复团队\n中英康复专家团队\n丰富临床理论验证\n有效进阶疗法\n专家精心设计方案\n进阶疗程保证效果\n针对性的方案\n根据症状量身定制\n人工智能精准方案\n便捷康复途径\n海量视频规范动作\n灵活选择便捷方案", nil);
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
//    NSDictionary *dict = @{
//                           NSFontAttributeName:[font fontWithBold],
//                           NSForegroundColorAttributeName:[UIColor blackColor]
//                           };
//    NSRange range = NSMakeRange(0, 6);
//    [attributedString addAttributes:dict range:range];
//    range = NSMakeRange(25, 6);
//    [attributedString addAttributes:dict range:range];
//    range = NSMakeRange(50, 6);
//    [attributedString addAttributes:dict range:range];
//    range = NSMakeRange(75, 6);
//    [attributedString addAttributes:dict range:range];
//    label.attributedText = attributedString;
//    CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
//    label.height = size.height;
//    [view addSubview:label];
//    
//    return view;
//}


@end
