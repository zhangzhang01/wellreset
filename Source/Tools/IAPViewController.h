//
//  IAPViewController.h
//  rehab
//
//  Created by yefangyang on 2016/12/28.
//  Copyright © 2016年 WELL. All rights reserved.
//
#import <StoreKit/StoreKit.h>
#import <UIKit/UIKit.h>

@interface IAPViewController : UIViewController<SKPaymentTransactionObserver,SKProductsRequestDelegate>

@end
