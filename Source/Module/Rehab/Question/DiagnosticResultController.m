//
//  DiagnosticResultController.m
//  rehab
//
//  Created by yefangyang on 16/9/14.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "DiagnosticResultController.h"

@interface DiagnosticResultController ()
{
    WRRehabDisease *_disease;
}
@end

@implementation DiagnosticResultController

-(instancetype)initWithDisease:(WRRehabDisease *)disease diagnosticDescription:(NSString*)description
{
    if (self = [super init]) {
        _disease = disease;
        [self layout];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)layout
{
    CGRect frame = self.view.frame;
    CGFloat x, y, cx, cy, offset, viewWidth;
    offset = 2 *WRUIOffset;
    viewWidth = frame.size.width;
    
    UIImage *image = [UIImage imageNamed:@"well_logo"];
    cx = image.size.width;
    cy = image.size.height;
    x = (viewWidth - cx) / 2;
    y = 44;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(x, y, cx, cy);
    [self.view addSubview:imageView];
    y = imageView.bottom + 2 * offset;
    
    cx = viewWidth - 2 * offset;
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(offset, y, cx, 0)];
    labelTitle.numberOfLines = 0;
    labelTitle.text = [NSString stringWithFormat:NSLocalizedString(@"根据您提交的信息，您的%@很健康！\n如出现%@不适，可使用【预防】中的康复运动舒缓。", nil), _disease.diseaseName, _disease.diseaseName];
    labelTitle.font = [UIFont wr_lightFont];
    labelTitle.textColor = [UIColor blackColor];
    CGSize size = [labelTitle sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    labelTitle.frame = CGRectMake(offset, y, size.width, size.height);
    [labelTitle sizeToFit];
    [self.view addSubview:labelTitle];
    y = labelTitle.bottom + offset;
    
    UILabel *labelTag = [[UILabel alloc]initWithFrame:CGRectMake(offset, y, cx, 0)];
    labelTag.numberOfLines = 0;
    labelTag.text = NSLocalizedString(@"免责声明：", nil);
    labelTag.font = [UIFont wr_detailFont];
    labelTag.textColor = [UIColor lightGrayColor];
    size = [labelTag sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    labelTag.frame = CGRectMake(offset, y, size.width, size.height);
    [labelTag sizeToFit];
    [self.view addSubview:labelTag];
    y = labelTag.bottom + WRUIOffset;
    
    
    UILabel *labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(offset, y, cx, 0)];
    labelDetail.numberOfLines = 0;
    labelDetail.text = NSLocalizedString(@"1 该测试结果只提供参考，不作为临床诊断意见及治疗依据；\n2 如需获得完整诊断意见请前往正规医疗机构；\n3 您有权选择是否遵循测试结果及建议，属于个人自由；\n4 因遵循测试结果及建议可能带来风险由您个人承担；WELL健康不承担相关法律责任。", nil);
    labelDetail.font = [UIFont wr_detailFont];
    labelDetail.textColor = [UIColor lightGrayColor];
    size = [labelDetail sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
    labelDetail.frame = CGRectMake(offset, y, size.width, size.height);
    [labelDetail sizeToFit];
    [self.view addSubview:labelDetail];
    
    x = offset;
    cy = 44;
    y = frame.size.height - cy - offset;
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sureButton.frame = CGRectMake(x, y, cx, cy);
    [sureButton setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.backgroundColor = [UIColor wr_themeColor];
    sureButton.layer.cornerRadius = 5.0f;
    [sureButton addTarget:self action:@selector(onClickedSureButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];

}

- (IBAction)onClickedSureButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
