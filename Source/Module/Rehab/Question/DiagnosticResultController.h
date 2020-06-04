//
//  DiagnosticResultController.h
//  rehab
//
//  Created by yefangyang on 16/9/14.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"
#import "WRObject.h"

@interface DiagnosticResultController : WRViewController

-(instancetype)initWithDisease:(WRRehabDisease*)disease diagnosticDescription:(NSString*)description;

@property (nonatomic, copy) void (^sureButtonBlock)();

@end
