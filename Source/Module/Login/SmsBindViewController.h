//
//  SmsBindViewController.h
//  rehab
//
//  Created by yongen zhou on 2017/6/1.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface SmsBindViewController : WRViewController
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, assign) NSInteger sumSeconds;
@end
