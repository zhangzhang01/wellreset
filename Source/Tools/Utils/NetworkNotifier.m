//
//  NetworkNotifier.m
//  rehab
//
//  Created by yefangyang on 2016/12/7.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "NetworkNotifier.h"
//#import <AFNetworking/AFNetworking.h>

@interface NetworkNotifier ()
@property (nonatomic, assign) BOOL isWWAN;
@property (nonatomic) BOOL iswifi;
@property (nonatomic, strong) UIViewController *controller;

@end

@implementation NetworkNotifier

-(void)dealloc {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithController:(UIViewController *)controller
{
    if (self = [super init]) {
        self.controller = controller;
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            // 当网络状态改变时调用
            switch (status) {
                case
                AFNetworkReachabilityStatusUnknown:
                    self.isWWAN = NO;
                    NSLog(@"未知网络");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    self.isWWAN = NO;
                    NSLog(@"没有网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    self.isWWAN = YES;
                    NSLog(@"手机自带网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    self.isWWAN = NO;
                    self.iswifi = YES;
                    NSLog(@"WIFI");
                    break;
            }
        }];
        
        //开始监控
        [manager startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusChange) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    }
    return self;
}





- (void)reachabilityStatusChange
{
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *key = @"alertReachability";
//    NSString *reachability = [ud objectForKey:key];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变时调用
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                self.isWWAN = NO;
                NSLog(@"未知网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                self.isWWAN = NO;
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                self.isWWAN = NO;
                NSLog(@"手机自带网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self.isWWAN = NO;
                NSLog(@"WIFI");
                break;
        }
    }];
    __weak __typeof(self)weakself = self;
    if (self.isWWAN) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"使用移动网络在线播放和下载视频可能会消耗大量数据流量", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"继续", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakself.isWWAN = NO;
            if (weakself.continueBlock) {
                weakself.continueBlock(0);
            }
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [weakself.controller.navigationController popViewControllerAnimated:YES];
            if (weakself.continueBlock) {
                weakself.continueBlock(1);
            }
        }]];
        if (IPAD_DEVICE) {
            alert.popoverPresentationController.sourceView = self.controller.view;
            alert.popoverPresentationController.sourceRect = self.controller.view.bounds;
        }
        [self.controller presentViewController:alert animated:YES completion:nil];

    }
    else if (self.iswifi)
    {
        weakself.continueBlock(0);
    }
}


@end
