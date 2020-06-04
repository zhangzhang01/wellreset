//
//  OrderDetailController.h
//  rehab
//
//  Created by yongen zhou on 2017/6/30.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface OrderDetailController : WRTableViewController
@property NSString* orderId;
@property (nonatomic)WRImOrder * Listorder;
@end
