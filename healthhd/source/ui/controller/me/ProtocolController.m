//
//  ProtocolController.m
//  rehab
//
//  Created by Matech on 3/3/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "ProtocolController.h"
#import "WRViewModel.h"

@interface ProtocolController ()
{
    NSDate *_startDate;
}
@end

@implementation ProtocolController
-(void)dealloc
{
    NSDate *now = [NSDate date];
    int duration = (int)[now timeIntervalSinceDate:_startDate];
    [UMengUtils careForMeWithType:@"protocol" duration:duration];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self createBackBarButtonItem];
    _startDate = [NSDate date];
    NSString *urlString = [WRNetworkService getFormatURLString:urlAgreementUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    [WRNetworkService pwiki:@"用户协议"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}



@end
