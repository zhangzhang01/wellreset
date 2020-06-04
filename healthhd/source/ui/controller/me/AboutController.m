//
//  AboutController.m
//  rehab
//
//  Created by Matech on 3/3/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "AboutController.h"
#import "WToast.h"
#import "WRNetworkService.h"

@interface AboutController ()
{
    NSDate *_startDate;
}
@property NSUInteger tapCount;
@end

@implementation AboutController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForMeWithType:@"about" duration:duration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    
    _startDate = [NSDate date];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    BOOL biPad = [WRUIConfig IsHDApp];
    
    CGFloat x = 0, y = 0, cx = 0, cy = 0, offset = WRUIOffset;
    CGRect frame = self.view.bounds;
    y = offset + 20;
    UIImage* imgLogo = PNG_IMAGE_NAMED(@"well_logo");
    if(biPad)
    {
        y += 80;
    }
    cx = imgLogo.size.width;
    cy = imgLogo.size.height;
    x = (frame.size.width - cx)/2;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
    imageView.image = imgLogo;
    //imageView.layer.masksToBounds = YES;
    //imageView.layer.cornerRadius = cx/2;
    [self.view addSubview:imageView];
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [imageView addGestureRecognizer:tap];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppName = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
    strAppName = [strAppName stringByAppendingString:@"®"];
    
    NSString *strShortVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //NSString *strVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *wechatNumber = [WRNetworkService getFormatURLString:urlWechat];
    NSString *wechatString = [NSString stringWithFormat:NSLocalizedString(@"Email：info@well-health.cn\n微信公众号：%@", nil), wechatNumber];
    NSArray* contentArray = @[
                              [NSString stringWithFormat:NSLocalizedString(@"%@ %@", nil), strAppName, strShortVersion],
                              NSLocalizedString(@"广州英康唯尔互联网服务有限公司", nil),
                              NSLocalizedString(@"中英康复专家团队、权威三甲医院联合开发提供专业、有效、安全的运动康复处方", nil),
                              wechatString,
                              NSLocalizedString(@"Copyright © 2016 www.well-health.cn, All rights reserved.", nil)
                              ];
    x = WRUILittleOffset;
    cx = frame.size.width - 2*x;
    y = CGRectGetMaxY(imageView.frame) + offset;
    for( NSUInteger i = 0; i < contentArray.count; i++)
    {
        NSString *strContent = [contentArray objectAtIndex:i];
        cy = (i == (contentArray.count - 1)) ? 50: 25;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, cx, cy)];
        if (i == (contentArray.count - 2)) {
            label.userInteractionEnabled = YES;
            [label bk_whenTapped:^{
                UIAlertController *alereC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"发送邮件", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                NSString *email = NSLocalizedString(@"info@well-health.cn", nil);
                UIAlertAction *emailAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"发送邮件:%@",email] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSString *urlStr = [NSString stringWithFormat:@"mailto:?to=%@",email];
                    //转换成URL
                    NSURL *url = [NSURL URLWithString:urlStr];
                    //调用系统方法
                    [[UIApplication sharedApplication] openURL:url];
                }];
                [alereC addAction:emailAction];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
                [alereC addAction:cancelAction];
                [self presentViewController:alereC animated:YES completion:nil];
            }];
        }
        UIFont *font = nil;
        if (biPad) {
            font = (i == 0)?[UIFont wr_bigFont]:[UIFont wr_titleFont];
        } else {
            font = (i == 0)?[UIFont wr_titleFont]:[UIFont wr_textFont];
        }
#if 0
        if (i == 0) {
            strContent = [strContent stringByAppendingFormat:@"(%@)", strVersion];
        }
#endif
        if (i == 0) {
            font = [UIFont boldSystemFontOfSize:font.pointSize];
        }
        label.font = font;
        label.text = strContent;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        //        [label sizeToFit];
        CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        if(i == (contentArray.count - 1)) {
            y = frame.size.height - size.height - offset - 64;
            
        }
        label.frame = CGRectMake(x, y, cx, size.height);
        [self.view addSubview:label];
        y = CGRectGetMaxY(label.frame) + offset;
    }
    
    [WRNetworkService pwiki:@"联系我们"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
-(void)tap:(UITapGestureRecognizer*)gesture {
    self.tapCount++;
    if (self.tapCount == 6) {
        
        NSString *server = [WRNetworkService getDomain];
        NSString *text = [NSString stringWithFormat:@"%@:%@\n%@", NSLocalizedString(@"当前服务器", nil), server, NSLocalizedString(@"选择服务器,然后重新打开app", nil)];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"服务器切换", nil)
                                                                            message:text
                                                                     preferredStyle:UIAlertControllerStyleAlert];
        
        NSArray *titles = @[
                            NSLocalizedString(@"正式服务器", nil),
                            NSLocalizedString(@"192.168.1.217", nil),
                            NSLocalizedString(@"192.168.1.217 V3", nil),
                            NSLocalizedString(@"mhc", nil),
                            NSLocalizedString(@"112.74.96.24", nil),
                            NSLocalizedString(@"120.25.255.77", nil)
                            ];
        NSArray *servers = @[
                             @"http://api.well-health.cn:8888/well-v3/api.action",
                             @"http://192.168.1.217:8888/well/api/index.action",
                             @"http://192.168.1.217:8888/well-v3/api.action",
                             @"http://10.0.0.66/mtWell/api.action",
                             @"http://112.74.96.24:8888/well-v3/api.action",
                             @"http://120.25.255.77:8888/well-v3/api.action"
                             ];
        
        void (^ __nullable block)(UIAlertAction *action);
        __weak __typeof(self) weakSelf = self;
        block = ^(UIAlertAction *action) {
            NSString *title = action.title;
            NSUInteger index = [titles indexOfObject:title];
            if (index < titles.count) {
                NSString *server = servers[index];
                [[NSUserDefaults standardUserDefaults] setObject:server forKey:@"server"];
                [weakSelf reloadServer];
            }
        };
        for(NSString *title in titles) {
            [controller addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:block]];
        }
        [controller addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:controller animated:YES completion:nil];
        self.tapCount = 0;
    }
    else
    {
        __weak __typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.tapCount = 0;
        });
    }
}

-(void)reloadServer
{
    [[WRNetworkService defaultService] fetchInterfaceWithCompletion:^(NSError *error) {
        if (error) {
            [SVProgressHUD showErrorWithStatus:@"change server error"];
        } else {
            [WToast showWithText:[[NSUserDefaults standardUserDefaults] objectForKey:@"server"]];
        }
    }];
}
@end
