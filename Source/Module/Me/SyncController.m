//
//  SyncController.m
//  rehab
//
//  Created by Matech on 3/2/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "SyncController.h"

#if !IPAD

#endif

#import "WRApp.h"
#import "WToast.h"
#import <YYKit/YYKit.h>
@interface SyncController ()
{
    NSDate *_startDate;
}
@property NSUInteger syncCount;

@end

@implementation SyncController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForMeWithType:@"sync" duration:duration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    
    _startDate = [NSDate date];
    [self defaultStyle];
    
    CAGradientLayer *layer = [[CAGradientLayer alloc] init];
    UIColor *endColor = [Utility ColorFromHexCode:@"209ee7"], *startColor = [Utility ColorFromHexCode:@"42d9e8"];
    layer.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(1.0, 1.0);
    layer.frame = self.view.bounds;
    
    UIImage *image = [UIImage imageNamed:@"well_health_icon"];
    CGRect frame = self.view.bounds;
    CGFloat offset = WRUIOffset,  x = offset, y = x, cx = frame.size.width - 2*x, cy = image.size.height + 2*offset;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, 0)];
    label.text = NSLocalizedString(@"HKDesc", nil);
    label.font = [UIFont wr_textFont];
    label.textColor = [UIColor lightGrayColor];
    label.numberOfLines = 0;
    [label sizeToFit];
    [self.view addSubview:label];
    y = CGRectGetMaxY(label.frame) + offset;
    
    UIControl *control = [[UIButton alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
    [control.layer addSublayer:layer];
    
    [control addTarget:self action:@selector(onClickedSync:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    [control wr_roundBorderWithColor:[UIColor whiteColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(offset, offset, imageView.frame.size.width, imageView.frame.size.height);
    [imageView wr_roundBorderWithColor:[UIColor whiteColor]];
    [control addSubview:imageView];
    x = CGRectGetMaxX(imageView.frame) + offset;
    
    cx = control.frame.size.width - x - offset;
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, cx, control.frame.size.height)];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.text = NSLocalizedString(@"同步iPhone健康数据", nil);
    [control addSubview:label];
    
    [WRNetworkService pwiki:@"同步数据"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (IBAction)onClickedSync:(id)sender {

}

-(void)postData:(NSArray*)data {
    NSString *json = [data jsonStringEncoded];
    if (json) {
        NSDictionary *params = @{@"data":json};
        NSString *url = [WRNetworkService getFormatURLString:urlUserSyncData];
        [SVProgressHUD showWithStatus:NSLocalizedString(@"正在上传数据到服务器", nil)];
        __weak __typeof(self) weakSelf = self;
        [WRBaseRequest post:url params:params result:^(id responseObject, NSError *error) {
            [SVProgressHUD dismiss];
            if (error) {
                [Utility retryAlertWithViewController:weakSelf title:NSLocalizedString(@"上传失败,请检查网络状况后重试", nil) completion:^{
                    [weakSelf postData:data];
                }];
            } else {
                weakSelf.syncCount--;
                if (weakSelf.syncCount == 0) {
                    //[Utility Alert:NSLocalizedString(@"同步数据成功", nil)];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"syncDate"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}

@end
