//
//  IAPManager.m
//  rehab
//
//  Created by yefangyang on 2016/12/28.
//  Copyright © 2016年 WELL. All rights reserved.
//
#define IAPArray @"IAPArray"

@import StoreKit;

#import "IAPManager.h"
#import "SVProgressHUD.h"
#import "IAPViewModel.h"

@interface IAPManager ()<SKProductsRequestDelegate>
@property (nonatomic, strong) SKProduct *product;
@property (nonatomic, copy) NSString *isCash;

@end

@implementation IAPManager
+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[IAPManager alloc] init];
    });
    return sharedInstance;
}



-(void)test
{
    [self payBtnPressed:@"well.rehab.health02"];
}

//单利的入口,传进来一个后台得到的商品ID(在苹果网站注册的)
- (void)payBtnPressed:(NSString *)product_id {//这传进来个商品id,lzc
    if ([SKPaymentQueue canMakePayments])//是否允许应用内付费
    {
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:product_id]];
        request.delegate = self;
        [request start];
    }else
        NSLog(@"用户不允许内购");//提示框
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"用户不允许内购", nil)];
}

// 查询成功后的回调
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //这里菊花消失
    NSLog(@"菊花消失");
    NSArray *products = response.products;
    if (products.count != 0) {
        self.product = products[0];
        SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:self.product];//lzc 改
        payment.applicationUsername = @(1000000).stringValue;//充值用户的id,也就是uid.
        [[SKPaymentQueue defaultQueue] addPayment:payment];//发起购买
//        当然还有监听,这个东西写在程序入口比较好,至于为何下次讲
    }
    if (products.count == 0){
        NSLog(@"无法获取商品");
    }
}
//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    //菊花消失
    NSLog(@"请求苹果服务器失败%@",[error localizedDescription]);
}

//监听购买结果,每个状态下都要结束订单,否则就坑爹了
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {//当用户购买的操作有结果时，就会触发下面的回调函数，
    //菊花消失
    NSLog(@"来监听购买结果吧");
    for (SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased://交易成功
                
                [self completeTransaction:transaction];//验证
                //如果用户在这中间退出,咋办??不知道的看下一篇,坑坑坑都是坑
                NSLog(@"结束订单了");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];//验证成功与否,咱们都注销交易,否则会出现虚假凭证信息一直验证不通过..每次进程序都得输入苹果账号的情况
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];//交易失败方法
                break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品
                NSLog(@"已经购买过");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];//消耗型不支持恢复,所以我就不写了
                
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"已经在商品列表中");//菊花
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"最终状态未确定 ");
                break;
            default:
                break;
        }
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
    } else {
        NSLog(@"用户取消交易");
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    if (self.isCash != nil) { //self.cash这玩意我是点击商品后传进来的,所以通过它判断是不是漏单的,有他的话就走正常流程
        NSLog(@"购买成功验证订单");
        NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] appStoreReceiptURL] path]];
        NSString *a = [data base64EncodedStringWithOptions:0];
        NSLog(@"base64JSONString =---%@---",a);//得到凭证
        
        NSDictionary * dic = @{@"uid":a,
                               @"receipt":[WRUserInfo selfInfo].userId,
                               //还有后台要的其他东西,起码凭证和用户id是必须的吧
                               };
        NSLog(@"验证信息%@",dic);
        //存起来
        [self addDicToPayAry:dic];//先把这个信息存起到本地,这是你埋坑的第一步,有空再解释
        [self testForServer:dic];//和后台去二次验证,这个很必要
    }
    else
    {
        NSLog(@"漏单流程从本地取凭证去验证");
        [self checkUnTestReceipt];//从本地取凭证验证去,下篇分解
    }//不是点击cell 进来的,也就是说上次订单没结束,日狗去吧
}

- (void)checkUnTestReceipt
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSArray *payAry = [ud objectForKey:IAPArray];
    if (!payAry || payAry.count == 0) {
        return;
    }
    for (NSDictionary *dic in payAry) {
        [self untestReceiptByTime:dic];//把本地(漏单)的dic(验证信息)都去验证了
    }
}

- (void)untestReceiptByTime:(NSDictionary *)dic//第一次访问服务器失败了又一次请求,多了个定时的请求
{
 __weak __typeof(self)weakself = self;
//    [IAPViewModel testIAPWithDic:dic completion:^(NSError *error, id resultObject) {
//        if (error) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(360 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            [weakself untestReceiptByTime:dic];
//            });
//        } else {
//            [weakself removeDicFromPayAry:dic];
//        }
//    }];
    
//    [[YLBNetWorkManager sharedInstance]postJsonData:dic url:  e successBlock:^(id responseBody) {
//        
//        [weakSelf removeDicFromPayAry:dic];//移除,不懂得看一
//        
//    } failureBlock:^(NSString *error) {
//        NSLog(@"%@和自己服务器失败22",error);
//        [self untestReceiptByTime:dic];//最好一段时间后再验证,用GCD
//    }];
}

- (void)addDicToPayAry:(NSDictionary *)dic
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[ud objectForKey:IAPArray]];
    if (![mutableArray containsObject:dic]) {
        [mutableArray addObject:dic];
        NSArray *array = [NSArray arrayWithArray:mutableArray];
        [ud setObject:array forKey:IAPArray];
    }
}

- (void)removeDicFromPayAry:(NSDictionary *)dic
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[ud objectForKey:IAPArray]];
    if ([mutableArray containsObject:dic]) {
        [mutableArray removeObject:dic];
        NSArray *array = [NSArray arrayWithArray:mutableArray];
        [ud setObject:array forKey:IAPArray];
    }
}


- (void)testForServer:(NSDictionary *)dic
{
    __weak __typeof(self)weakself = self;
    NSDictionary *aipDic = [NSDictionary dictionary];
//    [IAPViewModel testIAPWithDic:aipDic completion:^(NSError *error, id resultObject) {
//        if (error) {
//            NSLog(@"%@和自己服务器交互失败11",error);
//            [weakself checkUnTestReceipt];//和自己后台没联系上,所以要检查本地有没有存过的凭证,有的话继续验证.下篇详聊
//
//        } else {
//        NSLog(@"支付成功%@",resultObject);
//            if ([resultObject[@"code"]isEqualToNumber:@(200)]) {
//                NSLog(@"1验证成功完成交易OKOKOKOK");
//                /*
//                if (weakself.paySuccessBlock){
//                    weakself.paySuccessBlock();//告诉外边UI做处理
//                }
//                [weakself removeDicFromPayAry:dic];从本地移除凭证等信息dic
//                 */
//            }
////            验证凭证失败
//            if (1) {
//                NSLog(@"1验证receipt-data失败");
//                [weakself removeDicFromPayAry:dic];//移除本地凭证
//            }
//            
//            if (1) {
//                [weakself removeDicFromPayAry:dic];
//                NSLog(@"1你去找客服吧我们服务器有毛病");
//            }
//                    NSLog(@"我结束订单了-----");
//        }
//    }];
}

@end
