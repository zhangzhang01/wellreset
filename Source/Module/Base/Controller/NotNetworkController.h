//
//  NotNetworkController.h
//  rehab
//
//  Created by yongen zhou on 2017/4/5.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"
typedef void (^DidSelectedBack)();
@interface NotNetworkController : WRViewController
@property (nonatomic, copy) DidSelectedBack didSelectedBack;
@end
