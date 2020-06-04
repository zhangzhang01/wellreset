//
//  ChooseMusicController.h
//  rehab
//
//  Created by yefangyang on 2016/10/25.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "WRBaseViewController.h"

@interface ChooseMusicController : WRViewController

@property (nonatomic, copy) void (^ChooseMusicBlock)();

- (instancetype)init;
@end
