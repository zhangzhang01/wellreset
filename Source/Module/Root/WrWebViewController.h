//
//  WrWebViewController.h
//  rehab
//
//  Created by yongen zhou on 2017/8/7.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface WrWebViewController : WRViewController
@property(nonatomic) NSString * url;
@property(nonatomic) BOOL  ifrefresh;
@property(nonatomic) NSString * callBack;
@end
