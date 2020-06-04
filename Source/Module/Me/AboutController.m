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
#import <YYKit/YYKit.h>
@interface AboutController ()
{
    NSDate *_startDate;
}
@property NSUInteger tapCount;
@end

@implementation AboutController
-(void)dealloc
{
    [UMengUtils careForMeWithType:@"about" duration:1];
}


-(instancetype)init {
    if (self = [super init]) {
        self.view.backgroundColor = [UIColor wr_lightWhite];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    
    [self layout];
    
    [WRNetworkService pwiki:@"联系我们"];
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
                            
                            NSLocalizedString(@"mhc", nil),
                            
                            NSLocalizedString(@"192.168.11.63", nil),
                            
                            ];
        NSArray *servers = @[
                             @"http://api.well-health.cn:9955/well-v502/api.action",
                             @"http://192.168.1.217:8888/well-v4/api.action",
                             
                             @"http://10.0.0.66/mtWell/api.action",
                             
                             @"http://192.168.11.63:8080/well-api/api.action",
                             
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

#pragma mark -
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

-(void)layout
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *strAppName = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
    //strAppName = [strAppName stringByAppendingString:@"®"];
    
    NSString *strShortVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *wechatNumber = [WRNetworkService getFormatURLString:urlWechat];
    NSString *wechatString = [NSString stringWithFormat:NSLocalizedString(@"Email：contact@well-health.cn\n微信公众号：%@", nil), wechatNumber];
    
    BOOL biPad = [WRUIConfig IsHDApp];
    CGFloat offset = WRUIOffset, x = offset, y = x , cx = self.view.width, cy;
    CGSize size;
    
    UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cx, 0)];
    UIImage* logo = PNG_IMAGE_NAMED(@"logo");
    logo = [logo imageByResizeToSize:CGSizeMake(logo.size.width/3, logo.size.height/3)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:logo];
    imageView.center = CGPointMake(cx/2, imageView.height/2);
    [panel addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [imageView addGestureRecognizer:tap];
    
    UILabel *label = [UILabel new];
    label.textColor = [UIColor lightGrayColor];
    label.text = [NSString stringWithFormat:@"version %@", strShortVersion];
    label.font = [UIFont wr_detailFont];
    [label sizeToFit];
    label.top = imageView.bottom + offset;
    label.centerX = imageView.centerX;
    [panel addSubview:label];
    y = label.bottom + offset;
    
    label = [UILabel new];
    label.textColor = [UIColor wr_themeColor];
    label.text = strAppName;
    label.font = [UIFont wr_titleFont];
    [label sizeToFit];
    label.centerX = imageView.centerX;
    label.top = y;
    [panel addSubview:label];
    y = label.bottom + offset;
    
    label = [UILabel new];
    label.textColor = [UIColor wr_themeColor];
    label.text = @"We Empower Living Lives";
    label.font = [UIFont wr_smallTitleFont];
    [label sizeToFit];
    label.centerX = imageView.centerX;
    label.top = y;
    [panel addSubview:label];
    y = label.bottom + offset/2;
    
    label = [UILabel new];
    label.textColor = [UIColor wr_rehabBlueColor];
    label.text = NSLocalizedString(@"为生命赋能", nil);
    label.font = [UIFont wr_tinyFont];
    [label sizeToFit];
    label.centerX = imageView.centerX;
    label.top = y;
    [panel addSubview:label];
    y = label.bottom + offset;
    
    UIView *logoPanel = panel;
    
    panel.height = y;
    panel.top = 20;
    [self.view addSubview:panel];
    
    
    NSString *text = NSLocalizedString(@"WELL健康致力发展“运动康复与远程医疗”，我们的合作伙伴包括英国南安普顿大学、英超南安普顿足球俱乐部、中山大学附属第一医院、世界卫生组织合作中心等国内外顶尖机构。", nil);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    x = offset;
    panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cx, 0)];
//    panel.backgroundColor = [UIColor whiteColor];
    label = [UILabel new];
    label.textColor = [UIColor lightGrayColor];
    label.attributedText = attributedString;
    label.font = [UIFont wr_smallFont];
    label.numberOfLines = 0;
    size = [label sizeThatFits:CGSizeMake(panel.width - 2*x, CGFLOAT_MAX)];
    label.frame = CGRectMake(x, x, size.width, size.height);
    [panel addSubview:label];
    y = label.bottom + x;
    panel.height = y;
    panel.top = logoPanel.bottom + 20;
    [self.view addSubview:panel];
    
    
    panel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cx, 0)];
    NSArray* contentArray = @[
                              wechatString,
                              NSLocalizedString(@"Copyright © 2017 All rights reserved.", nil)
                              ];
    x = WRUILittleOffset;
    cx = panel.width - 2*x;
    y = 0;
    
    for( NSUInteger i = 0; i < contentArray.count; i++)
    {
        NSString *strContent = [contentArray objectAtIndex:i];
        cy = (i == (contentArray.count - 1)) ? 50: 25;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y, cx, cy)];
        if (i == (contentArray.count - 2))
        {
            label.userInteractionEnabled = YES;
            [label bk_whenTapped:^{
                UIAlertController *alereC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"发送邮件", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                NSString *email = NSLocalizedString(@"contact@well-health.cn", nil);
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
                UIPopoverPresentationController *popover = alereC.popoverPresentationController;
                
                if (popover) {
                    
                    popover.sourceView = label;
                    popover.sourceRect = label.bounds;
                    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
                }
                
                
                
                [self presentViewController:alereC animated:YES completion:nil];
            }];
        }
        UIFont *font = nil;
        if (biPad) {
            font = (i == 0)?[UIFont wr_bigFont]:[UIFont wr_titleFont];
        } else {
            font = (i == 0)?[UIFont wr_textFont]:[UIFont wr_detailFont];
        }
        label.font = font;
        label.text = strContent;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        CGSize size = [label sizeThatFits:CGSizeMake(cx, CGFLOAT_MAX)];
        label.frame = CGRectMake(x, y, cx, size.height);
        [panel addSubview:label];
        y = label.bottom + offset;
    }
    panel.height = y;
    panel.bottom = self.view.height-64 ;
    [self.view addSubview:panel];
}
@end
