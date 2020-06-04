//
//  RestController.h
//  rehab
//
//  Created by yongen zhou on 2017/8/15.
//  Copyright © 2017年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface RestController : WRViewController
@property (nonatomic, strong) NSString *nextStr;
@property (nonatomic, strong) NSString * nextIm;
@property (nonatomic, copy)void(^completionBlock)();
@property (nonatomic) BOOL Ifpause;
@end
