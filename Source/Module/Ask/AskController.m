//
//  AskController.m
//  rehab
//
//  Created by herson on 2016/11/21.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "AskController.h"

#import "AskExpertViewModel.h"

#import "SVProgressHUD.h"
#import "ReactiveCocoa.h"
#import "WToast.h"

@interface AskController ()
{
    NSDate *_startDate;
}
@property(nonatomic)UITextView* textView;
@end

@implementation AskController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForMeWithType:@"complain" duration:duration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    
    _startDate = [NSDate date];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = NSLocalizedString(@"提问", nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UINavigationBar *bar = self.navigationController.navigationBar;
//    UIImage *image = [[WRUIConfig defaultBarImage] imageByResizeToSize:CGSizeMake(bar.width, 64)];
//    [bar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    bar.barTintColor = [UIColor whiteColor];
//    bar.tintColor = bar.barTintColor;
//    [bar setShadowImage:[UIImage new]];
    
    if (!self.textView) {
        [self layout];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
-(IBAction)onClickedSubmitButton:(id)sender {
    [self request];
}

#pragma mark - layout
-(void)layout
{
    UIColor *borderColor = [UIColor wr_lightGray];
    UIColor *textColor = [UIColor grayColor];
    BOOL biPad = [WRUIConfig IsHDApp];
    CGFloat offset;
    if (biPad) {
        offset = 2 * WRUIOffset;
    } else {
        offset = WRUIOffset;
    }
    CGRect bounds = self.view.bounds;
    CGFloat x = offset, y = x;
    CGFloat cx = bounds.size.width - 2*x;
    CGFloat cy;
    
    UITextView *textView = [[UITextView alloc] init];
    textView.layer.borderColor = borderColor.CGColor;
    textView.layer.borderWidth = 1.0f;
    textView.layer.cornerRadius = 4.0f;
    textView.layer.masksToBounds = YES;
    textView.font = [UIFont wr_textFont];
    cy = 180;
    textView.frame = CGRectMake(x, y, cx, cy);
    [self.view addSubview:textView];
    self.textView = textView;
    y = textView.bottom + 3;
    
    UILabel *inputCountNotifyLabel = [[UILabel alloc] init];
    inputCountNotifyLabel.textAlignment = NSTextAlignmentRight;
    inputCountNotifyLabel.textColor = textColor;
    inputCountNotifyLabel.font = [WRUIConfig IsHDApp] ? [UIFont wr_tinyFont] : [UIFont wr_smallestFont];
    cy = [WRUIConfig defaultLabelHeight];
    inputCountNotifyLabel.frame = CGRectMake(x, y, cx, cy);
    [self.view addSubview:inputCountNotifyLabel];
//    y = inputCountNotifyLabel.bottom + offset;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"提交", nil) style:UIBarButtonItemStylePlain target:self action:@selector(onClickedSubmitButton:)];
    
    RAC(self.navigationItem.rightBarButtonItem, enabled) = [RACSignal combineLatest:@[self.textView.rac_textSignal]
                                                                             reduce:^(NSString *content) {
                                                                                 return @(content.length >= WRComplainTextMinLength && content.length <= WRComplainTextMaxLength);
                                                                             }];
    
    RAC(inputCountNotifyLabel, text) = [RACSignal combineLatest:@[self.textView.rac_textSignal]
                                                         reduce:^(NSString *content) {
                                                             if (content.length < WRComplainTextMinLength) {
                                                                 return [NSString stringWithFormat:NSLocalizedString(@"至少输入%d个字符", nil), WRComplainTextMinLength];
                                                                 
                                                             }
                                                             else if (content.length>WRComplainTextMaxLength)
                                                             {
                                                                 self.textView.text = [textView.text substringToIndex:WRComplainTextMaxLength];
                                                                 
                                                                 TTAlert(@"已经超过了最大输入最大字数了哦，请删除！");
                                                                 return [NSString stringWithFormat:NSLocalizedString(@"已经到了最大输入字符", nil),WRComplainTextMaxLength+1];
                                                             }else {
                                                                 return [NSString stringWithFormat:NSLocalizedString(@"还可以输入%d个字符", nil), WRComplainTextMaxLength - content.length];
                                                             }
                                                         }];
}

#pragma mark -
-(void)request
{
    if (![Utility IsEmptyString:self.textView.text]) {
        [self.view endEditing:YES];
        //        [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"正在提交", nil)];
        [SVProgressHUD show];
        __weak __typeof(self) weakSelf = self;
        NSString *text = self.textView.text;
        
        [AskExpertViewModel askExpert:text completion:^(NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
            if(error) {
                NSString *errorText = error.domain;
                if ([Utility IsEmptyString:errorText]) {
                    errorText = NSLocalizedString(@"提交失败", nil);
                }
                [Utility alertWithViewController:weakSelf.navigationController title:errorText];
            } else {
                [UMengUtils careForAskAdd];
                weakSelf.textView.text = @"";
                UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提交成功,专家将会在2-3天给您答复,请耐心等待", nil) message:nil preferredStyle:UIAlertControllerStyleAlert];
                [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"返回", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }]];
                [weakSelf presentViewController:controller animated:YES completion:nil];
            }
        }];
    }
}
@end
