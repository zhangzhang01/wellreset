//
//  PayController.m
//  rehab
//
//  Created by yongen zhou on 2017/6/12.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRPayController.h"
//#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
@interface WRPayController ()

@end

@implementation WRPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 200, 50)];
    [self.view addSubview:btn];
     NSString *appScheme = @"WELL-health";
    NSString* LOC = @"app_id=2017010404837065&biz_content=%7B%22body%22%3A%22%E6%89%93%E8%B5%8Fwell%E5%81%A5%E5%BA%B7%22%2C%22subject%22%3A%22%E6%89%93%E8%B5%8F%22%2C%22out_trade_no%22%3A%22201706121535597704%22%2C%22timeout_express%22%3A%2290m%22%2C%22total_amount%22%3A%221.00%22%2C%22seller_id%22%3A%22kourtney%40well-health.cn%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&charset=utf-8&format=JSON&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fmhc20150413.xicp.net%3A14702%2FmtWell%2Forder%2FupdateOrderByAlipay.action&sign_type=RSA&timestamp=2017-06-12+15%3A35%3A59&version=1.0&sign=g%2B2ChlRdoOtQSGXblV14%2BkdCEptaBAjmOa88ub7YSW%2BMWuzzxWRjUWMNT%2B%2Fe0fCHf5ns4E5Pr%2BeZvNyN5zYvzPZIP7Mqht%2FMjWF3Pv3voCLlQySwaIxtmbmfdoKj9GIXZPrvDMqiR21nsdYYiBKVLZrsoWpFS87CQoiSn5cvJfM%3D";
    [btn bk_whenTapped:^{
//        [[AlipaySDK defaultService] payOrder:LOC fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);
//            
//            
//            NSString*resultStatus=resultDic[@"resultStatus"];
//            
//            
//            
//            
//        }];
    }];
    
    
    UIButton* btn2 = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, 200, 50)];
    [self.view addSubview:btn2];
    [btn2 bk_whenTapped:^{
        NSString* appid=@"wx00ea0a14fe2e31fd";
        NSString* partnerId = @"1428147102";
        NSString* prepayId= @"wx201706130944291e6357c0f50247963505";
        NSString* package = @"Sign=WXPay";
        NSString* nonceStr= @"XX0SYNKSBHLMAHGU0O";
        
        
        PayReq *request = [[PayReq alloc]init];
        request.openID=appid;
        request.partnerId =partnerId;
        request.prepayId= prepayId;
        request.package = package;
        request.nonceStr= nonceStr;
        request.timeStamp = [@"1497318267" intValue];
        request.sign= @"2B8077902BCFA6155F5ACD679DBA44AA";
        [WXApi sendReq:request];
    }];
    // Do any additional setup after loading the view.
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
