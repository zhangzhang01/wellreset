//
//  PayCenter.m
//  rehab
//
//  Created by Matech on 2017/1/6.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "PayCenter.h"
#import <StoreKit/StoreKit.h>
#import <Security/Security.h>
#import "CheckPayOrder.h"
#import "IAPViewModel.h"

@interface PayCenter()<SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property(nonatomic) SKProductsRequest *request;
@property(nonatomic, copy) NSString *currentProductId;
@property (nonatomic, strong) NSDictionary *payDic;
@property (nonatomic, copy) NSString *sn, *productId, *receipt;

@end

@implementation PayCenter

+ (instancetype)defaultCenter {
    static dispatch_once_t onceToken;
    static id object = nil;
    dispatch_once(&onceToken, ^{
        object = [[PayCenter alloc] init];
    });
    return object;
}

-(instancetype)init
{
    if (self = [super init]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//        [self removeTrans];
    }
    return self;
}

-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark - SKProductsRequestDelegate
//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *product = response.products;
    if([product count] == 0)
    {
        NSLog(@"product empty");
        return;
    }
    
    
    for (SKProduct *pro in product) {
        NSLog(@"%@", [pro description]);
        NSLog(@"%@", [pro localizedTitle]);
        NSLog(@"%@", [pro localizedDescription]);
        NSLog(@"%@", [pro price]);
        NSLog(@"%@", [pro productIdentifier]);
        if([pro.productIdentifier isEqualToString:self.currentProductId])
        {
            SKPayment *payment = [SKPayment paymentWithProduct:pro];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            break;
        }
    }
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"iap error %@", error.localizedDescription);
}

- (void)requestDidFinish:(SKRequest *)request
{
    NSLog(@"requestDidFinish");
}

#pragma mark - apple pay
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction
{
//    [self removeTrans];
    for(SKPaymentTransaction *tran in transaction)
    {
        switch (tran.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"交易完成");
                [self completeTransaction:tran];
                break;
                
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [self restoreTransaction:tran];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"交易失败 %@", tran.originalTransaction.error.localizedDescription);
                [self failTransaction:tran];
                break;
                
            default:
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
        }
    }
}


- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error NS_AVAILABLE_IOS(3_0){
    NSLog(@"restoreCompletedTransactionsFailedWithError");
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue NS_AVAILABLE_IOS(3_0){
    NSLog(@"paymentQueueRestoreCompletedTransactionsFinished");
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    do
    {
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:receipt options:NSJSONReadingMutableLeaves error:nil];
        if (!receipt) {
            break;
        }
        NSError *error;
        NSDictionary *requestContents = @{
                                          @"transid":transaction.transactionIdentifier,
                                          @"receipt":[receipt base64EncodedStringWithOptions:0],
                                          @"productId":self.currentProductId
                                          };
        NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                              options:0
                                                                error:&error];
        if(requestData == nil) {
            break;
        }
//        [CheckPayOrder addPayOrder:requestContents];
        
        NSString *receiptString=[receipt base64EncodedStringWithOptions:0];//转化为base64字符串
        self.sn = transaction.transactionIdentifier;
        self.productId = @"51b5b5e2-0987-4d95-a3ea-6d3e9012cbe0";
        self.receipt = receiptString;
//        [IAPViewModel testIAPWithsn:transaction.transactionIdentifier productId:@"51b5b5e2-0987-4d95-a3ea-6d3e9012cbe0" receipt:receiptString completion:^(NSError *error, id resultObject) {
//            if (error) {
//                
//            } else {
//                [CheckPayOrder removePayOrder:requestContents];
//            }
//        }];
        NSLog(@"交易成功");
        [SVProgressHUD dismiss];
        
        [IAPViewModel SureIAPWithurl:@"https://sandbox.itunes.apple.com/verifyReceipt" orderId:self.orderId receipt:receiptString completion:^(NSError *error, id Id) {
            if (!error) {
               
                [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                self.completionBlock();
            }
            
        }];
    /*
     

        NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
        NSLog(@"bodyString%@",bodyString);
        NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
        NSURL *url=[NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
        NSLog(@"url%@",url);
        NSMutableURLRequest *requestM=[NSMutableURLRequest requestWithURL:url];
        requestM.HTTPBody=bodyData;
        requestM.HTTPMethod=@"POST";
        //创建连接并发送同步请求
        error=nil;
        NSData *responseData=[NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
        if (error) {
            NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
            return;
        }
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@",dic);
        if([dic[@"status"] intValue]==0){
            NSLog(@"购买成功！");
            NSDictionary *dicReceipt= dic[@"receipt"];
            NSDictionary *dicInApp=[dicReceipt[@"in_app"] firstObject];
            NSString *productIdentifier= dicInApp[@"product_id"];//读取产品标识
            //如果是消耗品则记录购买数量，非消耗品则记录是否购买过
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            if ([productIdentifier isEqualToString:@"123"]) {
                int purchasedCount=[defaults integerForKey:productIdentifier];//已购买数量
                [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount+1) forKey:productIdentifier];
            }else{
                [defaults setBool:YES forKey:productIdentifier];
            }
            //在此处对购买记录进行存储，可以存储到开发商的服务器端
        }else{
            NSLog(@"购买失败，未通过验证！");
        }
        */
        
        return;
        
    }while(NO);
    NSLog(@"交易异常");
    [SVProgressHUD dismiss];

}

//- (void)testForServer:(NSDictionary *)dic
//{
//    __weak __typeof(self)weakself = self;
//    NSDictionary *aipDic = [NSDictionary dictionary];
//    [IAPViewModel testIAPWithDic:aipDic completion:^(NSError *error, id resultObject) {
//        if (error) {
//            NSLog(@"%@和自己服务器交互失败11",error);
////            [weakself checkUnTestReceipt];//和自己后台没联系上,所以要检查本地有没有存过的凭证,有的话继续验证.下篇详聊
//            
//        } else {
//            NSLog(@"支付成功%@",resultObject);
//            if ([resultObject[@"code"]isEqualToNumber:@(200)]) {
//                NSLog(@"1验证成功完成交易OKOKOKOK");
//                /*
//                 if (weakself.paySuccessBlock){
//                 weakself.paySuccessBlock();//告诉外边UI做处理
//                 }
//                 [weakself removeDicFromPayAry:dic];从本地移除凭证等信息dic
//                 */
//            }
//            //            验证凭证失败
//            if (1) {
//                NSLog(@"验证receipt-data失败");
//                [CheckPayOrder removePayOrder:dic];
//            }
//            
//            if (1) {
//                [CheckPayOrder removePayOrder:dic];
//                NSLog(@"1你去找客服吧我们服务器有毛病");
//            }
//            NSLog(@"我结束订单了-----");
//        }
//    }];
//}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"交易恢复处理");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

//交易结束
- (void)failTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"交易失败");
    [SVProgressHUD dismiss];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)validateReceiptForTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"validateReceiptForTransaction");
}

#pragma mark -
-(void)payForProductWithIdentify:(NSString*)identify
{
    self.currentProductId = identify;
    NSSet *nsset = [NSSet setWithArray:@[identify]];
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    self.request.delegate = self;
    self.payDic = [NSDictionary dictionary];
    [self.request start];
    [SVProgressHUD show];
}

-(void)test
{
    [self payForProductWithIdentify:@"well.rehab.health02"];
}

- (void)retrycomplete
{
    [IAPViewModel testIAPWithsn:self.sn productId:@"51b5b5e2-0987-4d95-a3ea-6d3e9012cbe0" receipt:self.receipt completion:^(NSError *error, id resultObject) {
        if (error) {
            
        } else {
//            [CheckPayOrder removePayOrder:requestContents];
        }
    }];
    
}






@end
