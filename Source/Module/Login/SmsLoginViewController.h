//
//  SmsLoginViewController.h
//  rehab
//
//  Created by yongen zhou on 2017/3/4.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface SmsLoginViewController : WRViewController
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, assign) NSInteger sumSeconds;
@end
